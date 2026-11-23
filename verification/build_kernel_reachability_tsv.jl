#!/usr/bin/env julia
# ==============================================================================
# Standalone zero-dependency builder of `kernel_reachability_5roots.tsv.zst`
# from L. Alpöge / A. Sutherland's `lean4export 3.1.0` stream (`solution.ndjson`).
# Pure Julia stdlib (`SHA`, `Printf`) + system `zstd` — 0 external Julia packages.
#
# Usage:
#   1. Self-test on a synthetic 5-root kernel export:
#      JULIA_LOAD_PATH=@stdlib julia --startup-file=no -t1 verification/build_kernel_reachability_tsv.jl --self-test
#   2. Rebuild `verification/kernel_reachability_5roots.tsv.zst` from `solution.ndjson` (or `.ndjson.zst`):
#      JULIA_LOAD_PATH=@stdlib julia --startup-file=no -t1 verification/build_kernel_reachability_tsv.jl /path/to/solution.ndjson[.zst] [out.tsv.zst]
# ==============================================================================

using SHA, Printf

const EXPECTED_NDJSON_SHA256 = "5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e"
const ROOTS = ["riemannHypothesis", "riemannZeta_eq_zero_re", "LFunction_ne_zero_of_half_lt_re",
               "LFunction_eq_zero_re", "LFunction_eq_zero_re_of_isPrimitive"]
const SYMBOL = UInt32(1) << 31
const BLOCKBITS = 18
const BS = 1 << BLOCKBITS

mutable struct Blocks{T}
    pages::Vector{Vector{T}}
    len::Int
end
Blocks{T}() where T = Blocks{T}(Vector{Vector{T}}(), 0)

@inline function put!(b::Blocks{T}, x::T) where T
    off = b.len & (BS - 1)
    off == 0 && push!(b.pages, Vector{T}(undef, BS))
    @inbounds b.pages[end][off + 1] = x
    b.len += 1
    return UInt32(b.len)
end

@inline function at(b::Blocks, i::Integer)
    u = Int(i) - 1
    @inbounds return b.pages[(u >> BLOCKBITS) + 1][(u & (BS - 1)) + 1]
end

@inline function joinref!(j, a::UInt32, b::UInt32)
    (b == 0 || a == b) && return a
    a == 0 && return b
    return put!(j, (a, b))
end

# Minimal RFC-8259 JSON parser in pure stdlib (for name/declaration lines)
function skip_ws(s::Vector{UInt8}, i::Int, n::Int)
    @inbounds while i <= n && (s[i] == 0x20 || s[i] == 0x09 || s[i] == 0x0d || s[i] == 0x0a)
        i += 1
    end
    return i
end

function parse_json_str(s::Vector{UInt8}, i::Int, n::Int)
    s[i] == 0x22 || error("expected '\"'")
    i += 1
    buf = IOBuffer()
    while i <= n
        c = s[i]
        if c == 0x22
            return String(take!(buf)), i + 1
        elseif c == 0x5c
            i += 1
            e = s[i]
            if e == 0x22; write(buf, '"')
            elseif e == 0x5c; write(buf, '\\')
            elseif e == 0x2f; write(buf, '/')
            elseif e == 0x62; write(buf, '\b')
            elseif e == 0x66; write(buf, '\f')
            elseif e == 0x6e; write(buf, '\n')
            elseif e == 0x72; write(buf, '\r')
            elseif e == 0x74; write(buf, '\t')
            elseif e == 0x75
                hex = String(s[i+1:i+4])
                cp = parse(UInt32, hex; base=16)
                i += 4
                if 0xD800 <= cp <= 0xDBFF && i + 6 <= n && s[i+1] == 0x5c && s[i+2] == 0x75
                    lo = parse(UInt32, String(s[i+3:i+6]); base=16)
                    cp = 0x10000 + ((cp - 0xD800) << 10) + (lo - 0xDC00)
                    i += 6
                end
                write(buf, Char(cp))
            else
                write(buf, Char(e))
            end
            i += 1
        else
            j = i
            while i <= n && s[i] != 0x22 && s[i] != 0x5c
                i += 1
            end
            write(buf, view(s, j:i-1))
        end
    end
    error("unterminated JSON string")
end

function parse_json_val(s::Vector{UInt8}, i::Int, n::Int)
    i = skip_ws(s, i, n)
    c = s[i]
    if c == 0x7b
        d = Dict{String, Any}()
        i = skip_ws(s, i + 1, n)
        if s[i] == 0x7d; return d, i + 1; end
        while true
            i = skip_ws(s, i, n)
            k, i = parse_json_str(s, i, n)
            i = skip_ws(s, i, n)
            s[i] == 0x3a || error("expected ':'")
            v, i = parse_json_val(s, i + 1, n)
            d[k] = v
            i = skip_ws(s, i, n)
            if s[i] == 0x7d; return d, i + 1; end
            s[i] == 0x2c || error("expected ','")
            i += 1
        end
    elseif c == 0x5b
        arr = Any[]
        i = skip_ws(s, i + 1, n)
        if s[i] == 0x5d; return arr, i + 1; end
        while true
            v, i = parse_json_val(s, i, n)
            push!(arr, v)
            i = skip_ws(s, i, n)
            if s[i] == 0x5d; return arr, i + 1; end
            s[i] == 0x2c || error("expected ','")
            i += 1
        end
    elseif c == 0x22
        return parse_json_str(s, i, n)
    elseif c == 0x74; return true, i + 4
    elseif c == 0x66; return false, i + 5
    elseif c == 0x6e; return nothing, i + 4
    else
        j = i
        while i <= n && (0x30 <= s[i] <= 0x39 || s[i] == 0x2d)
            i += 1
        end
        return parse(Int, String(s[j:i-1])), i
    end
end

parse_json_slice(b::Vector{UInt8}, l::Int, r::Int) = parse_json_val(b, l, r)[1]

@inline function number(b, i)
    v = 0
    @inbounds while 0x30 <= b[i] <= 0x39
        v = 10 * v + Int(b[i] - 0x30); i += 1
    end
    return v
end

@inline function seekbyte(b, i, last, v)
    @inbounds while i <= last && b[i] != v; i += 1; end
    return i
end

@inline function fieldnum(b, start, last, key)
    j = start; stop = last - length(key) + 1
    @inbounds while j <= stop
        if b[j] == 0x22
            k = 2
            while k <= length(key) && b[j + k - 1] == key[k]; k += 1; end
            k > length(key) && return number(b, j + length(key))
        end
        j += 1
    end
    error("missing field " * String(copy(key)))
end

const fld = s -> collect(codeunits("\"" * s * "\":"))
const IE = fld("ie"); const FN = fld("fn"); const ARG = fld("arg"); const TY = fld("type")
const BODY = fld("body"); const VAL = fld("value"); const NM = fld("name"); const EXP = fld("struct")
const LAM = fld("lam"); const LET = fld("letE")

@inline function containskey(b, l, r, s)
    n = length(s)
    @inbounds for i = l:r-n+1
        if b[i] == s[1]
            j = 2
            while j <= n && b[i + j - 1] == s[j]; j += 1; end
            j > n && return true
        end
    end
    return false
end

@inline function expr!(b, l, r, key, ie, reps, joins)
    getref(k) = at(reps, 1 + fieldnum(b, l, r, k))
    zeroid = UInt32(0)
    v = if key == UInt8('a')
        joinref!(joins, getref(FN), getref(ARG))
    elseif key == UInt8('c')
        SYMBOL | UInt32(fieldnum(b, l, r, NM))
    elseif key == UInt8('f') || (key == UInt8('l') && containskey(b, l, r, LAM))
        joinref!(joins, getref(TY), getref(BODY))
    elseif key == UInt8('l') && containskey(b, l, r, LET)
        joinref!(joins, joinref!(joins, getref(TY), getref(VAL)), getref(BODY))
    elseif key == UInt8('p')
        getref(EXP)
    elseif key in (UInt8('b'), UInt8('s'), UInt8('n'), UInt8('l'))
        zeroid
    else
        error("unknown expr: " * String(b[l:r]))
    end
    ie == reps.len || error("out-of-order ie")
    put!(reps, v)
end

function build_reachability(io::IO; expected_digest=nothing, out_tsv_zst=nothing)
    rep = Blocks{UInt32}(); joins = Blocks{Tuple{UInt32, UInt32}}()
    parents = Int32[0]; parts = String[""]; defs = Dict{Int, Vector{UInt32}}()
    seeds = Dict{String, Int}()

    function full_name(n)
        a = String[]
        while n != 0; push!(a, parts[n + 1]); n = parents[n + 1]; end
        return join(Iterators.reverse(a), ".")
    end

    function name!(o)
        idx = Int(o["in"]); idx == length(parents) || error("name index order")
        d = haskey(o, "str") ? o["str"] : o["num"]
        s = haskey(d, "str") ? String(d["str"]) : string(d["i"])
        pred = Int(d["pre"]); push!(parents, pred)
        quoted = haskey(d, "str") && (isempty(s) || occursin('.', s) || occursin('«', s) || occursin('»', s) ||
            any(iscntrl, s) || all(isdigit, s))
        comp = quoted ? "«" * escape_string(replace(s, '«' => "\\u00ab", '»' => "\\u00bb")) * "»" : s
        push!(parts, comp)
        if pred == 0 && s in ROOTS
            seeds[s] = idx
        end
    end

    function declare!(o)
        k = String(only(keys(o))); x = o[k]
        typ(v) = at(rep, 1 + Int(v))
        if k == "inductive"
            for grp in ("types", "ctors", "recs"), a in x[grp]
                defs[Int(a["name"])] = [typ(a["type"])]
            end
        elseif k in ("axiom", "def", "thm", "opaque", "quot", "theorem", "definition")
            refs = [typ(x["type"])]
            haskey(x, "value") && push!(refs, typ(x["value"]))
            defs[Int(x["name"])] = refs
        elseif k != "meta"
            error("unknown record kind: " * k)
        end
    end

    function processchunk!(b)
        i = 1; last_b = length(b)
        while i <= last_b
            r = seekbyte(b, i, last_b, 0x0a) - 1
            if r >= i
                c = @inbounds b[i + 2]
                isie = (c == 0x69 && b[i + 3] == 0x65)
                if isie || (c in (0x61, 0x62, 0x63, 0x66) && !(c == 0x61 && b[i + 3] != 0x70))
                    ind = isie ? number(b, i + 6) : fieldnum(b, i, r, IE)
                    key = isie ? b[seekbyte(b, i + 6, r, 0x2c) + 2] : c
                    expr!(b, i, r, key, ind, rep, joins)
                elseif c == 0x69 && b[i + 3] == 0x6e && b[i + 4] == 0x22
                    name!(parse_json_slice(b, i, r))
                elseif (c == 0x69 && b[i + 3] == 0x6c) || (c == 0x69 && b[i + 3] == 0x6d) || (c in (0x6d, 0x70, 0x73) && containskey(b, i, r, fld("il")))
                    nothing
                else
                    declare!(parse_json_slice(b, i, r))
                end
            end
            i = r + 2
        end
    end

    hash = SHA.SHA2_256_CTX(); total = 0
    while !eof(io)
        block = read(io, 8 << 20)
        if !isempty(block) && last(block) != 0x0a && !eof(io)
            append!(block, readuntil(io, 0x0a; keep=true))
        end
        prev = total
        SHA.update!(hash, block); total += length(block)
        processchunk!(block)
        if !isnothing(expected_digest) && (total >> 33) > (prev >> 33)
            @printf(stderr, "[build_kernel_tsv] parsed %d GiB...\n", total >> 30)
        end
    end
    sumhex = bytes2hex(SHA.digest!(hash))
    isnothing(expected_digest) || sumhex == expected_digest || error("solution.ndjson SHA-256 mismatch: $sumhex")
    length(seeds) == 5 || error("missing root theorems in export")

    njoins = joins.len; empty!(rep.pages); GC.gc()
    seen = zeros(UInt8, njoins); ns = zeros(UInt8, length(parents))
    for (i0, root) in enumerate(ROOTS)
        bit = UInt8(1) << (i0 - 1)
        stack = UInt32[UInt32(seeds[root]) | SYMBOL]
        while !isempty(stack)
            h = pop!(stack); h == 0 && continue
            if h >= SYMBOL
                n = Int(h & ~SYMBOL)
                (ns[n + 1] & bit) != 0 && continue
                ns[n + 1] |= bit
                for ref in defs[n]; push!(stack, ref); end
            else
                (seen[h] & bit) != 0 && continue
                seen[h] |= bit
                a, c = at(joins, h); push!(stack, a, c)
            end
        end
    end

    if !isnothing(out_tsv_zst)
        open(out_tsv_zst, "w") do dest
            open(pipeline(`zstd -q -T1 -c -3`; stdout=dest), "w") do wr
                for idx in sort!(collect(keys(defs)))
                    println(wr, Int(ns[idx + 1]), '\t', idx, '\t', full_name(idx))
                end
            end
        end
    end
    counts = [count(x -> (x & (UInt8(1) << (i - 1))) != 0, ns) for i in 1:5]
    return (; counts, declared=length(defs), union_reachable=count(!iszero, ns), sha256=sumhex)
end

function run_self_test()
    rows = String[]
    addname(i, p, n) = push!(rows, "{\"in\":$i,\"str\":{\"pre\":$p,\"str\":\"$n\"}}")
    for (i, n) in enumerate(vcat(["S", "T", "K", "Unused"], ROOTS, ["Scope", "K"]))
        addname(i, i == 11 ? 10 : 0, n)
    end
    append!(rows, [
        "{\"ie\":0,\"sort\":0}",
        "{\"const\":{\"name\":1,\"us\":[]},\"ie\":1}",
        "{\"const\":{\"name\":2,\"us\":[]},\"ie\":2}",
        "{\"const\":{\"name\":3,\"us\":[]},\"ie\":3}",
        "{\"app\":{\"arg\":2,\"fn\":1},\"ie\":4}",
        "{\"ie\":5,\"lam\":{\"binderInfo\":\"default\",\"body\":4,\"name\":4,\"type\":3}}",
        "{\"ie\":6,\"letE\":{\"body\":3,\"name\":4,\"nondep\":false,\"type\":1,\"value\":2}}",
        "{\"ie\":7,\"proj\":{\"idx\":0,\"name\":4,\"struct\":1}}",
        "{\"forallE\":{\"binderInfo\":\"default\",\"body\":1,\"name\":4,\"type\":2},\"ie\":8}",
        "{\"const\":{\"name\":11,\"us\":[]},\"ie\":9}",
    ])
    for i in (1, 2, 3, 4, 11)
        push!(rows, "{\"axiom\":{\"name\":$i,\"type\":0}}")
    end
    for (i, (typ, val)) in enumerate([(0, 5), (0, 6), (0, 7), (0, 8), (2, 9)])
        push!(rows, "{\"thm\":{\"name\":$(i+4),\"type\":$typ,\"value\":$val}}")
    end
    res = build_reachability(IOBuffer(join(rows, "\n") * "\n"))
    res.counts == [4, 4, 2, 3, 3] || error("unexpected counts: $(res.counts)")
    res.declared == 10 || error("unexpected declared: $(res.declared)")
    println("build_kernel_reachability_tsv.jl --self-test: PASS (counts=[4,4,2,3,3], 0 external packages)")
end

function main()
    if length(ARGS) == 1 && ARGS[1] == "--self-test"
        run_self_test()
        return
    end
    length(ARGS) in (1, 2) || error("Usage: build_kernel_reachability_tsv.jl --self-test | <solution.ndjson[.zst]> [out.tsv.zst]")
    in_path = ARGS[1]
    out_path = length(ARGS) == 2 ? ARGS[2] : joinpath(@__DIR__, "kernel_reachability_5roots.tsv.zst")
    res = if endswith(in_path, ".zst")
        open(io -> build_reachability(io; expected_digest=EXPECTED_NDJSON_SHA256, out_tsv_zst=out_path), `zstd -dc $in_path`)
    else
        open(io -> build_reachability(io; expected_digest=EXPECTED_NDJSON_SHA256, out_tsv_zst=out_path), in_path)
    end
    println("Built $out_path: declared=$(res.declared), union_reachable=$(res.union_reachable), counts=$(res.counts)")
end

main()
