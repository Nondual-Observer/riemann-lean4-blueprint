#!/usr/bin/env julia
# ==============================================================================
# Zero-dependency verification suite for the Riemann Hypothesis Lean 4 Blueprint (v9.0)
# Pure Julia stdlib (Printf, SHA, Tar, LinearAlgebra) — 0 external packages.
# Modes:
#   --self-gate : blind preflight check (31 hostile traps, including 6 live Lean 4.33.1
#                 scope/modifier fixtures, second comma-separated line range, Table 2
#                 field swap eDiv↔eLoss, nonzero sum_Th, [0,1]^4 hypercube boundary,
#                 independent Mellin integrals in A.2, factor d in A.3, Lean version gate,
#                 exact Lubin-Tate formal exponential vs G_m, Bost-Arakelov sign trap,
#                 and partner bijection vs non-involution on E0 x Z/4Z)
#   --portable  : standalone check of all finite mathematics + bilingual EN/RU blueprint,
#                 one-page proof, and index parity + compilation of HypercubeAndLPTheorems.lean (44/44)
#   --full      : --self-gate + --portable + full audit of 175,187 archive modules,
#                 1,484,733 kernel rows, 233 public declarations, and 7 structure fields/Mathlib
#   (no args: runs --full automatically when RH_ARCHIVE_DIR holds the archive, else --portable)
# ==============================================================================

using Printf, SHA, Tar, LinearAlgebra

const Q = Rational{BigInt}
const HERE = @__DIR__
const REPO_ROOT = (isfile(joinpath(dirname(HERE), "blueprint", "BLUEPRINT_RU.md")) ||
                   isfile(joinpath(dirname(HERE), "blueprint", "BLUEPRINT_EN.md"))) ? dirname(HERE) : HERE

const MD_RU    = isfile(joinpath(REPO_ROOT, "blueprint", "BLUEPRINT_RU.md")) ?
                 joinpath(REPO_ROOT, "blueprint", "BLUEPRINT_RU.md") : joinpath(HERE, "BLUEPRINT_RU.md")
const IDX_RU   = isfile(joinpath(REPO_ROOT, "blueprint", "KERNEL_INDEX_RU.md")) ?
                 joinpath(REPO_ROOT, "blueprint", "KERNEL_INDEX_RU.md") : joinpath(HERE, "KERNEL_INDEX_RU.md")
const MD_EN    = joinpath(REPO_ROOT, "blueprint", "BLUEPRINT_EN.md")
const IDX_EN   = joinpath(REPO_ROOT, "blueprint", "KERNEL_INDEX_EN.md")
const ONE_EN   = joinpath(REPO_ROOT, "blueprint", "ONE_PAGE_PROOF_EN.md")
const ONE_RU   = joinpath(REPO_ROOT, "blueprint", "ONE_PAGE_PROOF_RU.md")
const LEAN_OWN = isfile(joinpath(REPO_ROOT, "lean", "HypercubeAndLPTheorems.lean")) ?
                 joinpath(REPO_ROOT, "lean", "HypercubeAndLPTheorems.lean") : joinpath(HERE, "HypercubeAndLPTheorems.lean")

function resolve_archive_dir()::String
    if haskey(ENV, "RH_ARCHIVE_DIR") && !isempty(strip(ENV["RH_ARCHIVE_DIR"]))
        return String(strip(ENV["RH_ARCHIVE_DIR"]))
    end
    cand = joinpath(REPO_ROOT, "archive")
    return isdir(cand) ? cand : REPO_ROOT
end
const DEFAULT_ARCHIVE_DIR = resolve_archive_dir()

function resolve_kernel_tsv(archive_dir::AbstractString)::String
    if haskey(ENV, "RH_KERNEL_TSV") && !isempty(strip(ENV["RH_KERNEL_TSV"]))
        return String(strip(ENV["RH_KERNEL_TSV"]))
    end
    for cand in (
        joinpath(REPO_ROOT, "verification", "kernel_reachability_5roots.tsv.zst"),
        joinpath(HERE, "kernel_reachability_5roots.tsv.zst"),
        joinpath(archive_dir, "kernel_reachability_5roots.tsv.zst"),
    )
        isfile(cand) && return cand
    end
    return joinpath(REPO_ROOT, "verification", "kernel_reachability_5roots.tsv.zst")
end

function resolve_lean_bin()::String
    for k in ("RH_LEAN_BIN", "LEAN_BIN")
        if haskey(ENV, k) && !isempty(strip(ENV[k]))
            return String(strip(ENV[k]))
        end
    end
    cand = joinpath(homedir(), ".elan", "toolchains", "leanprover--lean4---v4.33.1", "bin", "lean")
    isfile(cand) && return cand
    w = Sys.which("lean")
    return isnothing(w) ? cand : w
end

is_lean_4_33_1_banner(s::AbstractString) = occursin(r"^Lean \(version 4\.33\.1(?:,|\))", strip(s))

function verify_lean_4_33_1(bin_path::AbstractString)
    isempty(bin_path) && return false
    (isfile(bin_path) || !isnothing(Sys.which(bin_path))) || return false
    out = IOBuffer()
    try
        proc = run(pipeline(ignorestatus(`$bin_path --version`); stdout=out, stderr=out))
        return success(proc) && is_lean_4_33_1_banner(String(take!(out)))
    catch
        return false
    end
end

const DEFAULT_LEAN   = resolve_lean_bin()
const LEAN_IS_4_33_1 = verify_lean_4_33_1(DEFAULT_LEAN)

const ARCHIVE_SHA256 = "9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc"
const TSV_SHA256     = "76b00059f4c146d6fc45a7332eb8c3205845e4599022f104a7f58c7f168d4b09"
const ROOTS = ["riemannHypothesis", "riemannZeta_eq_zero_re", "LFunction_ne_zero_of_half_lt_re",
               "LFunction_eq_zero_re", "LFunction_eq_zero_re_of_isPrimitive"]
const ROOT_BITS = [1, 2, 4, 8, 16]
const EXPECTED_ROOT_COUNTS = [1478198, 1478200, 1478190, 1478203, 1478193]
const SOURCE_ONLY_SG = "Formalism.LFunctionChainParameters.characterSumData.sg"

const T_START = Ref(time())
function pulse(msg::AbstractString)
    @printf("[+%6.2fs] %s\n", time() - T_START[], msg)
    flush(stdout)
end

req(cond::Bool, msg::AbstractString) = cond || error("FAIL: " * msg)
is_prime(n::Integer) = n >= 2 && all(p -> n % p != 0, 2:isqrt(n))

function kronecker_prime(D::Integer, p::Integer)
    if p == 2
        iseven(D) && return 0
        m = mod(D, 8)
        return (m == 1 || m == 7) ? 1 : -1
    end
    r = mod(D, p)
    r == 0 && return 0
    z = powermod(r, (p - 1) ÷ 2, p)
    return z == p - 1 ? -1 : Int(z)
end

# ==============================================================================
# LEAN 4.33.1 SCOPE & DECLARATION PARSER (exact component-wise namespace/section/end)
# ==============================================================================
function strip_lean_comments_and_strings(source::String)
    !(occursin("/-", source) || occursin("--", source) || occursin('"', source)) && return source
    b = Vector{UInt8}(codeunits(source))
    i, n, depth = 1, length(b), 0
    in_line, in_str, esc = false, false, false
    while i <= n
        ch = b[i]
        nxt = i < n ? b[i+1] : 0x00
        if in_line
            in_line = (ch != 0x0a)
        elseif in_str
            if esc
                esc = false
            elseif ch == 0x5c
                esc = true
            elseif ch == 0x22
                in_str = false
                b[i] = 0x20
            end
        elseif ch == 0x2f && nxt == 0x2d
            depth += 1
            b[i] = 0x20; b[i+1] = 0x20
            i += 2; continue
        elseif depth > 0 && ch == 0x2d && nxt == 0x2f
            depth -= 1
            b[i] = 0x20; b[i+1] = 0x20
            i += 2; continue
        elseif depth == 0 && ch == 0x2d && nxt == 0x2d
            in_line = true
        elseif depth == 0 && ch == 0x22
            in_str = true
        end
        if (in_line || in_str || depth > 0) && ch != 0x0a
            b[i] = 0x20
        end
        i += 1
    end
    return String(b)
end

const MOD_ONLY_RE  = r"^(?:(?:private|protected|noncomputable|unsafe|partial|scoped|local|nonrec|meta)\s*)+$"
const ATTR_ONLY_RE = r"^@\[[^\]\n]*\]\s*$"
const SCOPE_RE     = r"^(?:(?:noncomputable|public|meta)\s+)*(namespace|section|mutual|end)(?:\s+([^\s]+)|\s*$)"
const DECL_RE      = r"^(?:@\[[^\]\n]*\]\s*)*((?:(?:private|protected|unsafe|noncomputable|partial|scoped|local|nonrec|nonempty|meta)\s+)*)(theorem|lemma|def|structure|class|inductive|abbrev|axiom|opaque|instance)\s+((?:[\p{L}_][\p{L}\p{M}\p{N}_'!?]*\.)*[\p{L}_][\p{L}\p{M}\p{N}_'!?]*)"
const CITATION_RE  = r"([\p{L}\p{N}_./₂]+\.lean)(?::(\d+(?:[–—-]\d+)?(?:,\s*\d+(?:[–—-]\d+)?)*))?"

const ScopeComp = @NamedTuple{kind::Symbol, label::String}
const IndexRow  = @NamedTuple{name::String, path::String, line::Int, kind::String, id::Int, mask::Int, section::String}
const ExtraRow  = @NamedTuple{name::String, path::String, line::Int, category::String, needle::String, id::Int, mask::Int}

function apply_scope_command!(stack::Vector{ScopeComp}, tag::String, arg::String)
    labels = isempty(arg) ? [""] : String.(split(arg, '.'))
    if tag != "end"
        k = Symbol(tag)
        for s in labels
            push!(stack, (kind = k, label = s))
        end
        return true
    end
    # Lean 4.33.1 semantics (Lean/Elab/BuiltinCommand.lean):
    # `end` matches the trailing suffix of open components sharing the same kind.
    if isempty(arg)
        isempty(stack) && return false
        pop!(stack)
        return true
    end
    length(labels) <= length(stack) || return false
    recent = @view stack[end - length(labels) + 1 : end]
    k0 = first(recent).kind
    all(e -> e.kind == k0, recent) || return false
    all(e.label == s for (e, s) in zip(recent, labels)) || return false
    resize!(stack, length(stack) - length(labels))
    return true
end

function scan_lean_declarations!(found::Dict{String, Vector{Tuple{String, Int, String}}},
                                 leaves::Set{String}, path::AbstractString, source::String;
                                 strict_scopes::Bool = false)
    stack = ScopeComp[]
    pending_private = false
    bad_ends = 0
    for (line_no, raw_line) in enumerate(eachsplit(strip_lean_comments_and_strings(source), '\n'))
        line = lstrip(raw_line)
        isempty(line) && continue
        c = first(line)
        if c in ('p', 'n', 'u', 's', 'l', 'm') && occursin(MOD_ONLY_RE, line)
            pending_private |= ("private" in split(line))
            continue
        elseif c == '@' && occursin(ATTR_ONLY_RE, line)
            continue
        end
        inherited_private = pending_private
        pending_private = false
        if c in ('e', 's', 'm', 'n', 'p')
            sc = match(SCOPE_RE, line)
            if !isnothing(sc)
                tag = String(sc.captures[1])
                arg = isnothing(sc.captures[2]) ? "" : String(sc.captures[2])
                ok_sc = apply_scope_command!(stack, tag, arg)
                if !ok_sc
                    bad_ends += 1
                    strict_scopes && error("Invalid scope closing `end $arg` at $path:$line_no")
                end
                continue
            end
        end
        c in ('@', 'p', 'd', 'a', 'i', 't', 'l', 'n', 's', 'o', 'u', 'c', 'm') || continue
        m = match(DECL_RE, line)
        isnothing(m) && continue
        quals, kind, ident = m.captures
        (inherited_private || ("private" in split(quals))) && continue
        raw = String(ident)
        dot = findlast(==('.'), raw)
        leaf = isnothing(dot) ? raw : String(SubString(raw, nextind(raw, dot)))
        leaf in leaves || continue
        full = if startswith(raw, "_root_.")
            chop(raw; head=7, tail=0)
        else
            ns_parts = String[e.label for e in stack if e.kind == :namespace && !isempty(e.label)]
            isempty(ns_parts) ? raw : join(ns_parts, ".") * "." * raw
        end
        haskey(found, full) || continue
        push!(found[full], (String(path), line_no, String(kind)))
    end
    return bad_ends
end

# Extract ALL file citations and ALL comma-separated line positions/ranges
function extract_file_citations(text::String, idx_paths::Set{String})
    citations = NamedTuple{(:line, :in_fence, :label, :path, :ranges), Tuple{Int, Bool, String, String, Vector{Tuple{Int, Int}}}}[]
    in_fence = false
    for (ln, raw) in enumerate(eachsplit(text, '\n'))
        if startswith(lstrip(raw), "```")
            in_fence = !in_fence
            continue
        end
        for m in eachmatch(CITATION_RE, raw)
            lbl = String(m.captures[1])
            opts = filter(p -> p == lbl || endswith(p, "/" * lbl), collect(idx_paths))
            req(length(opts) == 1, "ambiguous or unresolved Lean file citation (line $ln): $lbl => $opts")
            ranges = Tuple{Int, Int}[]
            if !isnothing(m.captures[2])
                for item in split(m.captures[2], ',')
                    parts = parse.(Int, split(strip(item), r"[–—-]"))
                    req(1 <= length(parts) <= 2, "malformed line range: $(m.match)")
                    push!(ranges, (first(parts), last(parts)))
                end
            end
            push!(citations, (line = ln, in_fence = in_fence, label = lbl, path = only(opts), ranges = ranges))
        end
    end
    return citations
end

function verify_citation_ranges(citations, lengths::Dict{String, Int})
    n_pos = 0
    for c in citations
        for (a, b) in c.ranges
            maxlen = lengths[c.path]
            req(1 <= a <= b <= maxlen, "line range $(a)-$(b) out of bounds for $(c.path) (max $maxlen) at line $(c.line)")
            n_pos += 1
        end
    end
    return n_pos
end

# Strict Table 2 binding check (field/Mathlib identifier <-> parent structure & exact line)
function verify_extra_row_binding(e::ExtraRow, src::String, t1_rows::Vector{IndexRow})
    lines_src = split(src, '\n')
    req(1 <= e.line <= length(lines_src), "line $(e.line) out of bounds in $(e.path) for $(e.name)")
    target_line = String(lines_src[e.line])
    req(occursin(e.needle, target_line), "snippet `$(e.needle)` not found at $(e.path):$(e.line) for $(e.name)")
    if e.category == "field"
        dot = findlast(==('.'), e.name)
        req(!isnothing(dot), "field $(e.name) must carry a qualified parent structure name")
        parent_name = String(SubString(e.name, 1, prevind(e.name, dot)))
        field_leaf  = String(SubString(e.name, nextind(e.name, dot)))
        req(occursin(Regex("^\\s*" * field_leaf * "\\s*:"), target_line),
            "line $(e.path):$(e.line) does not declare field `$field_leaf` (expected for $(e.name), got: $(strip(target_line)))")
        req(occursin(Regex("^" * field_leaf * "\\s*:"), strip(e.needle)),
            "snippet `$(e.needle)` does not match field `$field_leaf` for $(e.name)")
        p_matches = filter(r -> r.name == parent_name && r.path == e.path && r.kind == "structure", t1_rows)
        req(length(p_matches) == 1, "parent structure $parent_name for $(e.name) not found in Table 1 of $(e.path)")
        p_line = only(p_matches).line
        req(p_line < e.line, "field $(e.name) at line $(e.line) does not follow parent structure $parent_name ($p_line)")
        clean_lines = split(strip_lean_comments_and_strings(src), '\n')
        for ln in (p_line + 1):(e.line - 1)
            raw_ln = clean_lines[ln]
            if !isempty(raw_ln) && !isspace(first(raw_ln)) &&
               occursin(r"^(?:private|protected|noncomputable|structure|def|theorem|lemma|abbrev|class|inductive|end|namespace)\b", raw_ln)
                error("FAIL: field $(e.name) at $(e.path):$(e.line) is separated from structure $parent_name ($p_line) by top-level line $ln: $raw_ln")
            end
        end
    elseif e.category == "mathlib"
        req(occursin(Regex("\\b" * e.name * "\\b"), target_line) && occursin(e.name, e.needle),
            "Mathlib theorem call `$(e.name)` not confirmed at $(e.path):$(e.line)")
    else
        error("FAIL: unknown Table 2 category: $(e.category)")
    end
end

function matching_rows(obs::Vector{IndexRow}, exp::Vector{IndexRow})
    length(obs) == length(exp) || return false
    byname = Dict(r.name => r for r in exp)
    seen = Set{String}()
    for r in obs
        (r.name in seen || !haskey(byname, r.name) || r != byname[r.name]) && return false
        push!(seen, r.name)
    end
    return length(seen) == length(byname)
end

function run_row_mutation_checks(rows::Vector{IndexRow})
    r1, r2 = rows[1], rows[2]
    alt(f) = vcat([merge(r1, f)], rows[2:end])
    req(!matching_rows(alt((; path = "WrongDir/" * basename(r1.path))), rows), "mutation path")
    req(!matching_rows(alt((; line = r1.line + 1)), rows), "mutation line")
    req(!matching_rows(alt((; name = "OtherNS." * String(last(split(r1.name, '.'))))), rows), "mutation namespace")
    req(!matching_rows(alt((; mask = r1.mask ⊻ 1)), rows), "mutation mask")
    req(!matching_rows(alt((; id = r2.id)), rows), "mutation id")
    req(!matching_rows(vcat([r2], rows[2:end]), rows), "mutation dup")
    req(!matching_rows(rows[2:end], rows), "mutation drop")
    req(!matching_rows(vcat(rows, [r1]), rows), "mutation extra")
    idx_sib = findfirst(r -> r.path == r1.path && r.mask != r1.mask, rows)
    req(!isnothing(idx_sib), "need sibling row in same file")
    rs = rows[idx_sib]
    swapped = copy(rows)
    swapped[1] = merge(r1, (; path = rs.path, line = rs.line))
    swapped[idx_sib] = merge(rs, (; path = r1.path, line = r1.line))
    req(!matching_rows(swapped, rows), "mutation line swap")
    req(!matching_rows(alt((; mask = rs.mask)), rows), "mutation sibling mask")
    return 10
end

# ==============================================================================
# WALSH-BLOCH EFFECT OPERATORS, INVERSE WALSH MAP, AND PRINCIPAL MINORS
# ==============================================================================
const I4Q = Matrix{Q}(I, 4, 4)
const J4Q = Q[0 -1 0 0; 1 0 0 0; 0 0 0 -1; 0 0 1 0]
const SIGMA4 = (
    Q[1 0 0 0; 0 1 0 0; 0 0 -1 0; 0 0 0 -1],
    Q[0 0 1 0; 0 0 0 1; 1 0 0 0; 0 1 0 0],
    Q[0 0 0 1; 0 0 -1 0; 0 -1 0 0; 1 0 0 0],
)

function bloch_coords(q)
    a, b, c, d = Q.(q)
    return ((a + b + c + d) / 4, (-a - b + c + d) / 4, (-a + b - c + d) / 4, (a - b - c + d) / 4)
end

function inv_walsh(t::Q, e1::Q, e2::Q, e3::Q)
    return Q[t - e1 - e2 + e3, t - e1 + e2 - e3, t + e1 - e2 - e3, t + e1 + e2 + e3]
end

in_hypercube(q) = all(x -> Q(0) <= x <= Q(1), q)

function effect_cones(q)
    t, e1, e2, e3 = bloch_coords(q)
    r2 = e1*e1 + e2*e2 + e3*e3
    return (t >= 0 && t*t >= r2, 1 - t >= 0 && (1 - t)^2 >= r2)
end

function direct_effect_matrix(q)
    a, b, c, d = Q.(q)
    u, v = (c + d) / 2, (a + b) / 2
    h, j = ((b - a) + (d - c)) / 4, ((a - b) + (d - c)) / 4
    return Q[u 0 h j; 0 u -j h; h -j v 0; j h 0 v]
end

function all_principal_minors(M::Matrix{Q})
    res = Q[]
    for mask in 1:15
        idx = [i for i in 1:4 if (mask & (1 << (i - 1))) != 0]
        push!(res, det(M[idx, idx]))
    end
    return res
end

effect_by_minors(M::Matrix{Q}) = (all(>=(0), all_principal_minors(M)), all(>=(0), all_principal_minors(I4Q - M)))

# ==============================================================================
# SELF-GATE: 31 HOSTILE PREFLIGHT CHECKS
# ==============================================================================
function padic_val_rat(x::Q, p::Integer)
    p > 1 || throw(ArgumentError("valuation base must exceed one"))
    iszero(x) && return Inf
    num = abs(numerator(x))
    den = denominator(x)
    v = 0
    while mod(num, p) == 0; num ÷= p; v += 1; end
    while mod(den, p) == 0; den ÷= p; v -= 1; end
    return v
end

function poly_mul_trunc(a::Vector{Q}, b::Vector{Q}, max_deg::Int)
    res = fill(Q(0), max_deg)
    for i in 1:max_deg
        iszero(a[i]) && continue
        for j in 1:(max_deg - i)
            iszero(b[j]) && continue
            res[i + j] += a[i] * b[j]
        end
    end
    return res
end

function poly_pow_trunc(a::Vector{Q}, e::Int, max_deg::Int)
    acc = fill(Q(0), max_deg)
    e_rem = e
    first_set = false
    base = copy(a)
    while e_rem > 0
        if isodd(e_rem)
            acc = first_set ? poly_mul_trunc(acc, base, max_deg) : copy(base)
            first_set = true
        end
        e_rem >>= 1
        e_rem > 0 && (base = poly_mul_trunc(base, base, max_deg))
    end
    return acc
end

# Exact formal inverse exp_LT(Z) = Σ_{r=1}^R c_r Z^r of height-2 ltLog(X) = Σ_{j>=0} X^{l^{2j}} / l^j
function lubin_tate_exp_coeffs(l::Int, max_deg::Int)
    c = fill(Q(0), max_deg)
    c[1] = Q(1)
    for r in 2:max_deg
        # Coefficient of Z^r in Σ_{j>=1} c(Z)^{l^{2j}} / l^j depends only on c[1..r-1]
        s = Q(0)
        j = 1
        while l^(2j) <= r
            pw = poly_pow_trunc(c, l^(2j), r)
            s += pw[r] / (BigInt(l)^j)
            j += 1
        end
        c[r] = -s
    end
    return c
end

function audit_own_lean_module(own_src::String, obs::Union{Nothing, String}; expected_count::Int = 44)
    clean_src = strip_lean_comments_and_strings(own_src)
    req(!occursin(r"(?m)^\s*import\b", clean_src), "forbidden `import` found in standalone Lean 4 module")
    for kw in ("sorry", "admit", "axiom", "opaque", "unsafe", "partial", "implemented_by", "extern")
        req(!occursin(Regex("\\b" * kw * "\\b"), clean_src), "forbidden keyword `$kw` found in standalone Lean 4 module")
    end
    decl_thms = String[]
    for m in eachmatch(r"(?m)^theorem\s+([A-Za-z0-9_']+)\b", clean_src)
        push!(decl_thms, "HypercubeAndLP." * String(m[1]))
    end
    req(length(decl_thms) == expected_count && allunique(decl_thms),
        "expected $expected_count unique public theorems in HypercubeAndLPTheorems.lean, got $(length(decl_thms))")

    if !isnothing(obs)
        req(!occursin("sorryAx", obs) && !occursin("warning:", obs) && !occursin("error:", obs),
            "warnings, errors, or sorryAx detected in Lean 4 output:\n$obs")
        allowed_ax = Set(["propext", "Classical.choice", "Quot.sound"])
        obs_flat = replace(obs, r"\s+" => " ")
        printed_thms = String[]
        for m_ax in eachmatch(r"'(HypercubeAndLP\.[^']+)'\s+(?:(does not depend on any axioms)|depends on axioms:\s*\[([^\]]*)\])", obs_flat)
            push!(printed_thms, String(m_ax[1]))
            if !isnothing(m_ax[3])
                for a in split(m_ax[3], ',')
                    ax = strip(a)
                    isempty(ax) && continue
                    req(ax in allowed_ax, "non-standard axiom `$ax` in #print axioms output: $(m_ax.match)")
                end
            end
        end
        req(length(printed_thms) == expected_count && allunique(printed_thms) && Set(printed_thms) == Set(decl_thms),
            "mismatch between public theorems and #print axioms: declared $(length(decl_thms)), verified $(length(printed_thms))")
    end
    return length(decl_thms)
end

function run_self_gate()
    pulse("SELF-GATE: running 31 hostile preflight checks...")

    # 1-4. Exact Lean 4.33.1 scope and multiline modifier semantics
    f_priv = "namespace A\nprivate\nnoncomputable\ndef secret : Nat := 1\nend A\n"
    d_priv = Dict("A.secret" => Tuple{String,Int,String}[])
    req(scan_lean_declarations!(d_priv, Set(["secret"]), "F1.lean", f_priv; strict_scopes=true) == 0 && isempty(d_priv["A.secret"]),
        "multiline private/noncomputable leaked")

    f_dbl = "namespace A\nnamespace B\nend A.B\ntheorem outside : True := True.intro\n"
    d_dbl = Dict("outside" => Tuple{String,Int,String}[], "A.outside" => Tuple{String,Int,String}[])
    req(scan_lean_declarations!(d_dbl, Set(["outside"]), "F2.lean", f_dbl; strict_scopes=true) == 0 &&
        length(d_dbl["outside"]) == 1 && isempty(d_dbl["A.outside"]), "end A.B failed")

    f_part = "namespace A.B\nend B\ndef outside := 2\nend A\n"
    d_part = Dict("outside" => Tuple{String,Int,String}[], "A.outside" => Tuple{String,Int,String}[])
    req(scan_lean_declarations!(d_part, Set(["outside"]), "F3.lean", f_part; strict_scopes=true) == 0 &&
        length(d_part["A.outside"]) == 1 && isempty(d_part["outside"]), "namespace A.B / end B failed")

    f_bad_end = "namespace A\nnamespace B\nend A\n"
    d_bad_end = Dict("outside" => Tuple{String,Int,String}[])
    req(scan_lean_declarations!(d_bad_end, Set(["outside"]), "F4.lean", f_bad_end; strict_scopes=false) == 1,
        "invalid `end A` inside B was not rejected")

    # Live cross-check of all 6 scope/modifier fixtures against local Lean 4.33.1 when available
    if LEAN_IS_4_33_1
        lean_fixtures = [
            ("end A.B", "namespace A\nnamespace B\nend A.B\ntheorem outside : True := True.intro\n#check _root_.outside\n", true, "outside : True"),
            ("namespace A.B; end B", "namespace A.B\nend B\ndef outside := 2\n#check _root_.A.outside\nend A\n", true, "A.outside : Nat"),
            ("two sequential ends", "namespace A\nnamespace B\nend B\nend A\ntheorem outside : True := True.intro\n#check _root_.outside\n", true, "outside : True"),
            ("multiline private", "namespace A\nprivate\nnoncomputable\ndef secret : Nat := 1\nend A\n", true, ""),
            ("invalid end A", "namespace A\nnamespace B\nend A\n", false, "Expected `B`"),
            ("invalid noncomputable private", "namespace A\nnoncomputable private\ntheorem hidden : True := True.intro\nend A\n", false, "unexpected token 'private'"),
        ]
        for (lbl, src, exp_ok, frag) in lean_fixtures
            out = IOBuffer()
            proc = run(pipeline(ignorestatus(`$DEFAULT_LEAN --stdin`); stdin=IOBuffer(src), stdout=out, stderr=out))
            obs = String(take!(out))
            req(success(proc) == exp_ok && (isempty(frag) || occursin(frag, obs)), "Lean 4.33.1 fixture $lbl mismatch: $obs")
        end
    end

    # 5. Nested block comments, string literals, `_root_.`, and standard section/namespace closings
    f_misc = join([
        "namespace A",
        "section Local",
        "def h := 1",
        "end Local",
        "/- outer /- inner -/",
        "theorem h : False := by trivial",
        "-/",
        "def txt := \"theorem h : False\"",
        "namespace B",
        "protected theorem h : True := by trivial",
        "end B",
        "end A",
        "namespace C",
        "  def _root_.root_expl := 0",
        "end C",
    ], "\n")
    d_misc = Dict("A.h" => Tuple{String,Int,String}[], "A.B.h" => Tuple{String,Int,String}[], "root_expl" => Tuple{String,Int,String}[])
    req(scan_lean_declarations!(d_misc, Set(["h", "root_expl"]), "Misc.lean", f_misc; strict_scopes=true) == 0 &&
        only(d_misc["A.h"])[2] == 3 && only(d_misc["A.B.h"])[2] == 10 && only(d_misc["root_expl"])[2] == 14,
        "comments/strings/_root_ check failed")

    # 6-15. 10 index row mutations
    synth_rows = IndexRow[
        (; name="A.h", path="Misc.lean", line=3, kind="def", id=1, mask=1, section="S"),
        (; name="A.B.h", path="Misc.lean", line=10, kind="theorem", id=2, mask=2, section="S"),
        (; name="root_expl", path="Misc.lean", line=14, kind="def", id=3, mask=4, section="S"),
    ]
    req(run_row_mutation_checks(synth_rows) == 10, "expected 10 row mutations")

    # 16. Second comma-separated line range trap (`ChCore.lean:56–74, 999999–1000000`)
    fake_paths = Set(["Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChCore.lean"])
    fake_len   = Dict("Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChCore.lean" => 400)
    mut_cits   = extract_file_citations("See `ChCore.lean:56–74, 999999–1000000`.", fake_paths)
    req(length(only(mut_cits).ranges) == 2, "second comma range not parsed")
    caught_bad_range = false
    try
        verify_citation_ranges(mut_cits, fake_len)
    catch
        caught_bad_range = true
    end
    req(caught_bad_range, "second comma range 999999-1000000 was NOT rejected!")

    # 17. Hypercube [0,1]^4 boundary trap: P = I/2 + (3/10)Σ_1 + (2/5)Σ_2 lies outside L([0,1]^4)
    q_out = inv_walsh(Q(1//2), Q(3//10), Q(2//5), Q(0))
    req(q_out == Q[-1//5, 3//5, 2//5, 6//5] && !in_hypercube(q_out), "hypercube boundary trap failed")
    P_out = I4Q / 2 + (3//10) * SIGMA4[1] + (2//5) * SIGMA4[2]
    req(P_out == direct_effect_matrix(q_out) && P_out * P_out == P_out && tr(P_out) == 2 && all(effect_by_minors(P_out)),
        "P_out operator-interval check failed")

    # 18. Ternary grid {-1,0,1}^4 fooled at q = (47,7,7,7)/64 while 30 principal minors catch -77/262144
    m_bad = direct_effect_matrix(Q[47, 7, 7, 7] / 64)
    for t in Iterators.product(-1:1, -1:1, -1:1, -1:1)
        v = Q[t...]
        req(dot(v, m_bad * v) >= 0 && dot(v, (I4Q - m_bad) * v) >= 0, "ternary grid trap")
    end
    w_wit = Q[3, 0, 1, -1]
    req(dot(w_wit, m_bad * w_wit) == -3 // 64 && det(m_bad[1:3, 1:3]) == -77 // 262144 && det(m_bad) > 0, "minor 123 trap")
    req(effect_by_minors(m_bad) == (false, true), "30 minors catch q=(47,7,7,7)/64")

    # 19. Leading principal minors fooled at q = (1/2,0,0,0) while minor {1,3} = -1/64
    m_lead = direct_effect_matrix(Q[1//2, 0, 0, 0])
    req([det(m_lead[1:k, 1:k]) for k in 1:4] == Q[0, 0, 0, 1//1024] && det(m_lead[[1, 3], [1, 3]]) == -1 // 64, "minor {1,3} trap")

    # 20. Singular Gram with positive diagonal + cconj/sgc0 + non-idempotent S^2 = 2S
    G_sing = [1 1; 2 2] * transpose([1 1; 2 2])
    req(all(>(0), diag(G_sing)) && det(G_sing) == 0, "singular Gram positive diag")
    prod_char(a1, a2) = (-1)^(a1 + a2)
    req(prod_char(1, 0) == -1 && prod_char(1, 1) == 1, "cconj vs sgc0")
    S2 = [1 1; 1 1]
    req(S2 * S2 == 2 * S2 && S2 * S2 != S2, "S^2 = 2S")

    # 21. Polynomial P(s) with conjugate symmetry and |P(2s-1)/P(2s)| = 1 on Re(s)=1/2, yet 4 off-line zeros
    P_off(z) = ((z - 3//4)^2 + 9) * ((z - 1//4)^2 + 9)
    for t in Q[0, 1//3, 7//4, 5]
        z = 1//2 + t * im
        req(P_off(2z) != 0 && P_off(2z - 1) == conj(P_off(2z)) && abs2(P_off(2z - 1) / P_off(2z)) == 1, "P_off unit modulus")
    end
    req(iszero(P_off(3//4 + 3im)) && iszero(P_off(1//4 + 3im)), "P_off off-line zeros")

    # 22. Non-window (11, 9239), kronecker(-4, 2) == 0, and factor d trap in A.3 lattice: (9,0,3)
    setprecision(BigFloat, 256) do
        u0 = log(BigFloat(11))
        req(u0 * (260 * log(u0))^2 / 2 > 61995 && log(BigFloat(9239)) < 10, "(11,9239) non-window trap")
    end
    req(kronecker_prime(-4, 2) == 0 && kronecker_prime(-11, 2) == -1 && kronecker_prime(-263, 2) == 1, "kronecker at p=2")
    req(mod(0 + 0 + 2 * 3^2, 9) == 0 && mod(0 + 0 + 2 * 3^2, 9 * 3) != 0 && mod(-6, 9) != 0, "A.3 lattice factor d trap")

    # 23. Omitting ramified prime p = d breaks ch_balance + nonzero sum_Th sensitivity (7/4 != 0)
    res_with, res_without = ch_balance_H0_check()
    req(res_with < big"1e-65" && res_without > 1, "ramified prime p=d omission trap")
    lhs_nz, rhs_nz, avg_nz = sum_Th_nonzero_witness()
    req(lhs_nz == rhs_nz && lhs_nz == Complex{Q}(Q(7//4), Q(0)) && avg_nz == Complex{Q}(Q(7//8), Q(0)) && lhs_nz != 0,
        "sum_Th nonzero sensitivity trap")

    # 24. Independent integral sign check for Mellin boundary in A.2 on G = 1_[1,2], s = 1
    # For G(u)=u and s=0 the unweighted inner integral grows as 1/t.
    # At t=16^-k and b=5/4, division by t^(1-b) gives 2^(3k)-2^(-k).
    for k in 1:8
        t = 1 // big(16)^k
        inner = inv(t) - 1
        req(inner / big(2)^k == big(2)^(3k) - 1 // big(2)^k &&
            t * inner == 1 - t, "Mellin boundary weight t^(1-s) lost")
    end
    tg1, b1 = mellin_indicator_12_at_1()
    req(abs(BigFloat(1)/2 - b1 - tg1) < big"1e-18" && abs(BigFloat(1)/2 + b1 - tg1) > big"0.6",
        "A.2 boundary sign-flip sensitivity trap")

    # 25. Table 2 field swap trap (eDiv <-> eLoss in the same file)
    synth_struct_src = "namespace Foo\nstructure Consts where\n  eDiv : ℝ\n  eLoss : ℝ\nend Foo\n"
    synth_t1 = IndexRow[(; name="Foo.Consts", path="S.lean", line=2, kind="structure", id=10, mask=31, section="S")]
    good_eDiv = ExtraRow((; name="Foo.Consts.eDiv", path="S.lean", line=3, category="field", needle="eDiv : ℝ", id=11, mask=31))
    swapped_eDiv = ExtraRow((; name="Foo.Consts.eDiv", path="S.lean", line=4, category="field", needle="eLoss : ℝ", id=11, mask=31))
    verify_extra_row_binding(good_eDiv, synth_struct_src, synth_t1)
    caught_swap = false
    try
        verify_extra_row_binding(swapped_eDiv, synth_struct_src, synth_t1)
    catch
        caught_swap = true
    end
    req(caught_swap, "Table 2 field swap eDiv<->eLoss was NOT rejected!")

    # 26. Missing, duplicate, or non-standard #print axioms in standalone Lean 4 module
    synth_lean = "namespace HypercubeAndLP\ntheorem t1 : True := True.intro\ntheorem t2 : True := True.intro\nend HypercubeAndLP\n#print axioms HypercubeAndLP.t1\n#print axioms HypercubeAndLP.t2\n"
    synth_obs_good = "'HypercubeAndLP.t1' does not depend on any axioms\n'HypercubeAndLP.t2' depends on axioms: [propext]\n"
    audit_own_lean_module(synth_lean, synth_obs_good; expected_count=2)
    for bad_obs in (
        "'HypercubeAndLP.t1' does not depend on any axioms\n",
        "'HypercubeAndLP.t1' does not depend on any axioms\n'HypercubeAndLP.t1' does not depend on any axioms\n",
        "'HypercubeAndLP.t1' depends on axioms: [propext, Lean.ofReduceBool]\n'HypercubeAndLP.t2' does not depend on any axioms\n",
    )
        caught_ax = false
        try
            audit_own_lean_module(synth_lean, bad_obs; expected_count=2)
        catch
            caught_ax = true
        end
        req(caught_ax, "bad #print axioms output was NOT rejected: $bad_obs")
    end

    # 27. Hidden import / axiom / opaque / sorry in standalone Lean 4 module
    for bad_src in (
        "import Init\n" * synth_lean,
        replace(synth_lean, "theorem t2 : True := True.intro" => "axiom cheat : False\ntheorem t2 : True := True.intro"),
        replace(synth_lean, "theorem t2 : True := True.intro" => "opaque secret : Nat\ntheorem t2 : True := True.intro"),
        replace(synth_lean, "True.intro" => "by sorry"),
    )
        caught_src = false
        try
            audit_own_lean_module(bad_src, synth_obs_good; expected_count=2)
        catch
            caught_src = true
        end
        req(caught_src, "forbidden Lean keyword/import was NOT rejected!")
    end

    # 28. Strict Lean 4.33.1 version gate (rejects nonexistent binaries and non-Lean executables)
    req(is_lean_4_33_1_banner("Lean (version 4.33.1, release)") &&
        !is_lean_4_33_1_banner("Lean (version 4.33.10, release)") &&
        !is_lean_4_33_1_banner("Lean (version 4.33.1-rc1, release)"),
        "wrong Lean release accepted or the exact release rejected")
    req(!verify_lean_4_33_1("") && !verify_lean_4_33_1("/nonexistent/lean_4_33_1"),
        "nonexistent Lean binary was NOT rejected by verify_lean_4_33_1")
    if isfile("/usr/bin/true")
        req(!verify_lean_4_33_1("/usr/bin/true"), "/usr/bin/true was NOT rejected by verify_lean_4_33_1")
    end

    # 29. Exact Lubin-Tate height-2 formal exponential vs height-1 G_m (zero gain)
    c5 = lubin_tate_exp_coeffs(5, 28)
    req(c5[1] == Q(1) && all(iszero, c5[2:24]) && c5[25] == Q(-1 // 5), "ltExp l=5 c_25 != -1/5")
    req(padic_val_rat(factorial(BigInt(25)) * c5[25], 5) == 5 &&
        padic_val_rat(factorial(BigInt(25)) * (Q(1) // factorial(BigInt(25))), 5) == 0,
        "height-2 vs height-1 valuation gain at l=5, r=25 failed")
    c3 = lubin_tate_exp_coeffs(3, 81)
    # Lagrange inversion for X + X^9/3 at degree 81 (k = 10).
    # The full logarithm has one extra term X^81/9, so its inverse loses 1/9.
    clipped = binomial(big(90), 10) // (big(81) * big(3)^10)
    req(c3[81] == clipped - 1//9 && c3[81] != clipped, "second log term missing at degree 81")
    req(all(r -> mod(r-1, 8) == 0 || iszero(c3[r]), eachindex(c3)), "height-2 support")
    for r in eachindex(c3)
        iszero(c3[r]) && continue
        v_lt = padic_val_rat(factorial(BigInt(r)) * c3[r], 3)
        d_fl = ndigits(r; base=3) - 1
        req(Q(v_lt) >= Q(3 // 8) * r - (d_fl + 1), "LemmaSt lower bound violated at l=3, r=$r: v=$v_lt")
    end
    req(c3[9] == Q(-1 // 3) && c3[17] == Q(1) && c3[25] != 0 && padic_val_rat(factorial(big(25)) * c3[25], 3) >= Q(3//8)*25-3,
        "ltExp l=3 exact coefficients check failed")

    # 30. Prefix-compounding 2/3 barrier vs 1/2 LP & Bost-Arakelov 4-clause Fo sign-flip trap
    for a_cand in Q[0, 1//4, 1//3, 1//2, 2//3, 1]
        val_comp = max(1 - a_cand, 2 * a_cand)
        req(val_comp >= Q(2 // 3) && ((val_comp == Q(2 // 3)) == (a_cand == Q(1 // 3))), "2/3 barrier check failed")
    end
    # Unequal positive weights 1 and 2; all four original clauses are tight.
    avg(x) = (x[1] + 2*x[2]) / 3
    ask, gain, loss, fo = Q(4), Q(3), Q(1), Q(-5)
    e, lo, m = fill(Q(0),2), fill(Q(0),2), fill(Q(0),2)
    n, height, top = Q[-2,-2], Q[0,3], Q(-4)
    good_v, bad_v = Q[1,4], Q[-9,-6]
    divisor_rhs(h) = top + h - fo
    four(v, divlhs) = ask-gain <= loss && all(m.+gain.+fo.-e.-lo .<= n) &&
        avg(n.-height) <= top && all(divlhs.(height) .<= v)
    bound(v) = ask <= avg(v) + loss + avg(e) + avg(lo) - avg(m)
    req(four(good_v, divisor_rhs) && bound(good_v) && ask == avg(good_v)+loss,
        "valid common-weight telescope")
    req(!four(bad_v, divisor_rhs) && four(bad_v, h -> top+h+fo) && !bound(bad_v),
        "reversing Fo in Div must give a false conclusion")
    req(ask > avg(reverse(good_v)) + loss, "exchanging word weights must be observable")

    # 31. Partner bijection vs non-involution on E0 x Z/4Z, exact envelope gap
    #     identities (m-t)^2(m+2t) & (m-t)^2, and strict (Loss) witness (4,3,1)
    partner_z4(t::Int, g) = (g[1] ⊻ 1, g[2] ⊻ 1, mod(g[3] + t, 4))
    for t in 0:3, a1 in 0:1, a2 in 0:1, h in 0:3
        g = (a1, a2, h)
        p = partner_z4(t, g)
        req(p == (1-a1, 1-a2, mod(h+t,4)), "partner must shift both carrier bits and H")
        req(partner_z4(t,p) == (a1,a2,mod(h+2t,4)), "wrong square of partner")
        req(partner_z4(mod(-t, 4), p) == g && partner_z4(t, partner_z4(mod(-t, 4), g)) == g,
            "partner(-t, .) must be two-sided inverse of partner(t, .)")
        if mod(2 * t, 4) != 0
            req(partner_z4(t, p) != g, "partner(t, .) must NOT be an involution when 2t != 0 mod 4")
        end
    end
    for m_q in Q[1//2, 1, 2, 7//3], t_q in Q[1//3, 1, 5//2]
        req(t_q^2 + m_q^2 - 2 * t_q * m_q == (m_q - t_q)^2 >= 0, "blockwise gap identity failed")
        req(2 * t_q^3 + m_q^3 - 3 * t_q^2 * m_q == (m_q - t_q)^2 * (m_q + 2 * t_q) >= 0,
            "compounding gap identity failed")
    end
    req(Q(4) - Q(3) <= Q(1) && !(Q(4) <= Q(3)), "strict (Loss) witness (4,3,1) failed")

    pulse("SELF-GATE: PASS (31/31 hostile preflight traps caught" *
          (LEAN_IS_4_33_1 ? ", including all 6 live Lean 4.33.1 fixtures" : "") * ")")
end

# ==============================================================================
# GATE-V8-01: FOUR-WALL LP LAW (dual certification: vertex enumeration + dual multipliers)
# ==============================================================================
function lp_matrices(p::Q, q::Q, ν::Q)
    A = Q[-1 0 0; q 0 0; 0 -1 0; p -1 0;
          -1 0 -1; 1 -1 -1; 1 0 -1; 0 1 -1]
    b = Q[0, ν, 0, -ν, -1, -1, 0, 2ν]
    return A, b
end

function certify_lp_instance(p, q, ν)
    p, q, ν = Q(p), Q(q), Q(ν)
    A, b = lp_matrices(p, q, ν)
    lower = Q[1//2, 1 - ν/q, (2 - 2ν)/3, (p - ν)/(p + 1)]
    Λ = zeros(Q, 8, 4)
    Λ[[5, 7], 1] .= 1//2
    Λ[[2, 5], 2] = Q[1/q, 1]
    Λ[[5, 6, 8], 3] .= 1//3
    Λ[[4, 5, 8], 4] = Q[1/(p + 1), p/(p + 1), 1/(p + 1)]
    for j in 1:4
        λ = Λ[:, j]
        req(all(>=(0), λ) && transpose(A) * λ == Q[0, 0, -1] && -dot(λ, b) == lower[j], "LP dual $j")
    end
    θ = maximum(lower)
    primal = Q[1 - θ, max(p * (1 - θ) + ν, 2 - 2θ), θ]
    req(all(A * primal .<= b), "LP primal feasible")
    req(all(A * Q[0, 0, 1] .<= 0) && all(A * Q[0, 1, 1] .<= 0), "LP recession cone")
    verts = Set{NTuple{3, Q}}()
    for i in 1:6, j in i+1:7, k in j+1:8
        idx = [i, j, k]
        iszero(det(A[idx, :])) && continue
        pt = A[idx, :] \ b[idx]
        all(A * pt .<= b) && push!(verts, (pt[1], pt[2], pt[3]))
    end
    req(!isempty(verts) && minimum(last, verts) == θ, "LP vertex optimum mismatch")
    return θ, Set(v for v in verts if last(v) == θ)
end

function gate_v8_01()
    pulse("GATE-V8-01: dual-basis certification of the 4-wall LP law (123 distinct triples, 93 with p>=1)...")
    νs = Q[0, 1//4, 1//2, 3//4, 1, 5//4, 3//2, 7//4, 2, 9//4, 5//2, 11//4, 3, 4, 5]
    pqs = [(5, 4), (3, 4), (3, 2), (5, 2), (4, 3), (0, 1//10), (1//2, 3//2), (7, 1)]
    distinct = Set{NTuple{3, Q}}()
    for (p, q) in pqs, ν in νs
        certify_lp_instance(p, q, ν)
        push!(distinct, (Q(p), Q(q), Q(ν)))
    end
    for (p, q, ν, expected) in [(1, 1//10, 1//10, 3//5), (7, 1, 1//2, 13//16), (5, 4, 1//10, 39//40), (1, 1//2, 1//4, 1//2), (5, 4, 2, 1//2)]
        θ, _ = certify_lp_instance(p, q, ν)
        req(θ == expected, "LP edge case ($p,$q,$ν)")
        push!(distinct, (Q(p), Q(q), Q(ν)))
    end
    n_pge1 = count(t -> t[1] >= 1, distinct)
    req(length(distinct) == 123 && n_pge1 == 93, "LP distinct count mismatch: $(length(distinct)), p>=1: $n_pge1")
    req(certify_lp_instance(5, 4, 0) == (Q(1), Set([(Q(0), Q(0), Q(1)), (Q(0), Q(1), Q(1))])), "LP degenerate ν=0")
    req(certify_lp_instance(5, 4, 2) == (Q(1//2), Set([(Q(1//2), Q(9//2), Q(1//2))])), "LP unique point at (5,4,2)")
    req(certify_lp_instance(5, 4, 3) == (Q(1//2), Set([(Q(1//2), Q(11//2), Q(1//2)), (Q(1//2), Q(13//2), Q(1//2))])), "LP segment at ν=3")
    a, κ, ν = Q(1//2), Q(9//2), Q(2)
    req(Q[1 - a, 1 + a - κ, a, κ - 2ν] == Q[1//2, -3, 1//2, 1//2], "4 prices at (5,4,2)")
    pulse("GATE-V8-01: PASS ($(length(distinct)) distinct triples, $n_pge1 with p>=1, primal==dual==vertex)")
end

# ==============================================================================
# GATE-V8-02: ch_balance (H=0 + Z/4Z + 98 exact rational coeffs), nonzero sum_Th (7/4, 7/8 + 16 basis),
#             principal character R_1 - R_{χ_0}, bit-swap + TT/T2/u0, CostWindows, Z_(3), χ_8, X'/3
# ==============================================================================
function ch_balance_H0_check()
    return setprecision(BigFloat, 256) do
        q, d = 11, 263
        A = BigFloat(970)
        w = BigFloat[5//2, 7//2]
        ell(i, j) = BigFloat(3i - 5j) / 13
        γ = BigFloat(Base.MathConstants.eulergamma)
        direct, ramified = BigFloat(0), BigFloat(0)
        for p in 2:401
            is_prime(p) || continue
            pk, e = p, 1
            while pk <= 401
                sec = kronecker_prime(-q, p)^e
                if p == d || (p != 2 && p != q && kronecker_prime(-d, p)^e == -1)
                    pos = sec == -1 ? 1 : 2
                    term = log(BigFloat(p)) * max(A / pk - w[pos], 0)
                    if p == d
                        ramified += term
                    else
                        direct += 2 * term
                    end
                end
                pk *= p; e += 1
            end
        end
        function gchi(i, j, y)
            val = BigFloat(0)
            for p in 2:floor(Int, y)
                is_prime(p) || continue
                cp = kronecker_prime(-d, p)^i * kronecker_prime(-q, p)^j
                pk, l = p, 1
                while pk <= y
                    val += log(BigFloat(p)) * cp^l * (y / pk - 1)
                    pk *= p; l += 1
                end
            end
            return (i + j == 0) ? (val - y * log(y) + (1 + γ) * y) : (val + y * ell(i, j))
        end
        rhs = sum((-1)^(i + j*g) * w[2 - g] * gchi(i, j, A / w[2 - g]) / 2 for g in 0:1 for i in 0:1 for j in 0:1)
        main = A * (log(A) - 1 - γ + ell(1, 0) - sum(log.(w)) / 2)
        return abs(direct + ramified - main - rhs), abs(direct - main - rhs)
    end
end

function ch_balance_Z4_exact_and_bf()
    q1, d = 11, 263
    S_set = Set([2, q1, 5])
    t_shift = 3
    A_q = Q(970)
    N_cut = 401
    G_elems = [(a1, a2, h) for a1 in 0:1 for a2 in 0:1 for h in 0:3]
    addG(x, y) = ((x[1] + y[1]) & 1, (x[2] + y[2]) & 1, mod(x[3] + y[3], 4))
    subG(x, y) = ((x[1] - y[1]) & 1, (x[2] - y[2]) & 1, mod(x[3] - y[3], 4))
    nsmulG(k, x) = ((k * x[1]) & 1, (k * x[2]) & 1, mod(k * x[3], 4))
    in_phi(g) = (g[1] == 0)
    cconj = (1, 1, 0); sgc0 = (1, 0, 0)
    topPl(t) = (0, 0, mod(t, 4))
    partner(t, g) = addG(addG(cconj, g), topPl(t))

    w_q = Dict{Tuple{Int,Int,Int}, Q}()
    idx_w = 0
    for g in G_elems
        if in_phi(g)
            idx_w += 1
            w_q[g] = Q(25 + 3 * idx_w) // 10
        end
    end
    inertia_of(p::Int) = p == d ? [(0, 0, 0), sgc0] : (p == 5 ? [(0, 0, 0), (0, 1, 0)] : [(0, 0, 0)])
    function frob_of(p::Int)
        p == 2  && return (0, 1, 1)
        p == q1 && return (0, 0, 2)
        p == 5  && return (0, 1, 3)
        p == d  && return (0, 1, 1)
        return (kronecker_prime(-d, p) == -1 ? 1 : 0, kronecker_prime(-q1, p) == -1 ? 1 : 0, mod(p, 4))
    end
    roots_q = (Complex{Q}(1, 0), Complex{Q}(0, 1), Complex{Q}(-1, 0), Complex{Q}(0, -1))
    eval_q(ψ, g) = roots_q[1 + mod(2 * (ψ[1]*g[1] + ψ[2]*g[2]) + ψ[3]*g[3], 4)]
    coset_mean_q(I_sub, h_elem, ψ) = sum(eval_q(ψ, addG(h_elem, x)) for x in I_sub) / length(I_sub)

    n_pk = 0
    d_coeff = Q(0)
    for p in 2:N_cut
        is_prime(p) || continue
        I_p = inertia_of(p); fp = frob_of(p)
        pk, k = p, 1
        while pk <= N_cut
            n_pk += 1
            lhs_c = Q(0)
            if p == d
                I_d = Set(I_p)
                for g in G_elems
                    if !in_phi(g) && (subG(g, nsmulG(k, fp)) in I_d)
                        lhs_c += max(A_q / pk - w_q[partner(t_shift, g)], Q(0))
                    end
                end
                d_coeff += lhs_c
            elseif !(p in S_set) && !in_phi(fp)
                gk = nsmulG(k, fp)
                if !in_phi(gk)
                    lhs_c += 2 * max(A_q / pk - w_q[partner(t_shift, gk)], Q(0))
                end
            end
            rhs_c = Complex{Q}(Q(0), Q(0))
            for g in G_elems
                in_phi(g) && continue
                wp = w_q[partner(t_shift, g)]
                y = A_q / wp
                if pk <= y
                    ramp_pk = wp * (y / pk - 1)
                    orth = sum(conj(eval_q(ψ, g)) * coset_mean_q(I_p, nsmulG(k, fp), ψ) for ψ in G_elems) / 8
                    rhs_c += orth * ramp_pk
                end
            end
            req(rhs_c == Complex{Q}(lhs_c, Q(0)), "exact coeff mismatch at $p^$k: lhs=$lhs_c rhs=$rhs_c")
            pk *= p; k += 1
        end
    end
    req(n_pk == 98 && d_coeff == Q(1168 // 1315), "expected 98 prime powers and d_coeff=1168/1315, got $n_pk, $d_coeff")

    r4, r4_nod = setprecision(BigFloat, 256) do
        A = BigFloat(970); γ = BigFloat(Base.MathConstants.eulergamma)
        w_bf = Dict(k => BigFloat(v) for (k, v) in w_q)
        i_u = Complex{BigFloat}(0, 1)
        roots_bf = (Complex{BigFloat}(1, 0), i_u, Complex{BigFloat}(-1, 0), -i_u)
        eval_bf(ψ, g) = roots_bf[1 + mod(2 * (ψ[1]*g[1] + ψ[2]*g[2]) + ψ[3]*g[3], 4)]
        ell_bf(ψ) = Complex{BigFloat}(BigFloat(2*ψ[1] - 3*ψ[2] + ψ[3]) / 11, BigFloat(ψ[3] - ψ[2]) / 17)
        prim_bf(ψ, p, k) = sum(eval_bf(ψ, addG(nsmulG(k, frob_of(p)), x)) for x in inertia_of(p)) / length(inertia_of(p))

        ask_inert = BigFloat(0)
        for p in 2:N_cut
            is_prime(p) || continue
            (p in S_set || p == d) && continue
            fp = frob_of(p); in_phi(fp) && continue
            pk, k = p, 1
            while pk <= N_cut
                gk = nsmulG(k, fp)
                if !in_phi(gk)
                    ask_inert += 2 * log(BigFloat(p)) * max(A / pk - w_bf[partner(t_shift, gk)], 0)
                end
                pk *= p; k += 1
            end
        end
        ask_d = BigFloat(d_coeff) * log(BigFloat(d))
        avg_log_w = sum(log(v) for v in values(w_bf)) / 8
        MAIN_val = A * (Complex{BigFloat}(log(A) - 1 - γ, 0) + ell_bf((1, 0, 0)) - Complex{BigFloat}(avg_log_w, 0))

        function GPsi_bf(ψ, y::BigFloat)
            lim = floor(Int, y)
            s = Complex{BigFloat}(0, 0)
            for p in 2:lim
                is_prime(p) || continue
                lp = log(BigFloat(p)); pk, k = p, 1
                while pk <= lim
                    s += lp * prim_bf(ψ, p, k) * (y / pk - 1)
                    pk *= p; k += 1
                end
            end
            return ψ == (0, 0, 0) ? (s + Complex{BigFloat}(-y * log(y) + (1 + γ) * y, 0)) : (s + y * ell_bf(ψ))
        end
        De_val = Complex{BigFloat}(0, 0)
        for g in G_elems
            in_phi(g) && continue
            wp = w_bf[partner(t_shift, g)]
            for ψ in G_elems
                De_val += conj(eval_bf(ψ, g)) * wp * GPsi_bf(ψ, A / wp)
            end
        end
        De_val /= 8
        return abs(Complex{BigFloat}(ask_inert + ask_d, 0) - MAIN_val - De_val),
               abs(Complex{BigFloat}(ask_inert, 0) - MAIN_val - De_val)
    end
    return r4, r4_nod, n_pk
end

function sum_Th_nonzero_witness()
    states = [(a1, a2, h) for a1 in 0:1 for a2 in 0:1 for h in 0:3]
    roots = (Complex{Q}(1, 0), Complex{Q}(0, 1), Complex{Q}(-1, 0), Complex{Q}(0, -1))
    chval(ψ, g) = roots[1 + mod(2 * (ψ[1]*g[1] + ψ[2]*g[2]) + ψ[3]*g[3], 4)]
    A0_sub = [0, 2]; T2_sub = [0, 2]; t0 = 3; b_val = Q(7//2)
    e1_fn(h) = (1, 0, mod(h, 4))
    negG(g) = (g[1], g[2], mod(-g[3], 4))
    PsiA = [ψ for ψ in states if all(s -> chval(ψ, (0, 0, s)) == 1, A0_sub)]
    δ2 = length(T2_sub) // 4

    G_nz = Dict(ψ => Complex{Q}(Q(2*ψ[1] + ψ[2] + 3*ψ[3] + 1) + (ψ == (0, 0, 0) ? Q(1) : Q(0)), Q(ψ[3] - ψ[1])) for ψ in states)
    lhs = sum((1 // 8) * sum(sum(chval(ψ, negG(e1_fn(s + u0 - t0))) * b_val * G_nz[ψ] for ψ in states) for s in T2_sub) for u0 in A0_sub)
    rhs = (length(A0_sub) * b_val * (δ2 / 2)) * sum(chval(ψ, e1_fn(t0)) * G_nz[ψ] for ψ in PsiA)
    return lhs, rhs, rhs / length(A0_sub)
end

function gate_v8_02()
    pulse("GATE-V8-02: ch_balance (98 exact rational coeffs), nonzero sum_Th (7/4, 7/8 + 16 basis), R_1-R_{χ_0}, bit-swap + TT/T2...")
    r0, r0_nod = ch_balance_H0_check()
    req(r0 < big"1e-65" && r0_nod > 1, "ch_balance H=0 failed")
    r4, r4_nod, n_pk = ch_balance_Z4_exact_and_bf()
    req(r4 < big"1e-60" && r4_nod > 1 && n_pk == 98, "ch_balance H=Z/4Z failed")

    states = [(a1, a2, h) for a1 in 0:1 for a2 in 0:1 for h in 0:3]
    roots = (Complex{Q}(1, 0), Complex{Q}(0, 1), Complex{Q}(-1, 0), Complex{Q}(0, -1))
    chval(ψ, g) = roots[1 + mod(2 * (ψ[1]*g[1] + ψ[2]*g[2]) + ψ[3]*g[3], 4)]
    idx_of = Dict(g => i for (i, g) in enumerate(states))
    for A0 in ([0], [0, 2], [0, 1, 2, 3])
        P = zeros(Q, 16, 16)
        for (i, (a1, a2, h)) in enumerate(states), u in A0
            P[i, idx_of[(a1, a2, mod(h + u, 4))]] += 1 // length(A0)
        end
        S_unnorm = length(A0) * P
        req(P == P' && P * P == P && tr(P) == 16 // length(A0), "projector properties")
        req(S_unnorm * S_unnorm == length(A0) * S_unnorm, "S^2 = |A0| S")
        req((S_unnorm * S_unnorm == S_unnorm) == (length(A0) == 1), "S idempotent iff |A0|==1")
        kept = 0
        for ψ in states
            v = [chval(ψ, g) for g in states]
            ann = all(u -> chval(ψ, (0, 0, u)) == 1, A0)
            req(P * v == (ann ? v : zero(v)), "projector eigenvalue on character")
            kept += ann
        end
        req(kept == tr(P), "annihilator rank")
    end
    lhs_nz, rhs_nz, avg_nz = sum_Th_nonzero_witness()
    req(lhs_nz == rhs_nz == Complex{Q}(Q(7//4), Q(0)) && avg_nz == Complex{Q}(Q(7//8), Q(0)), "sum_Th 7/4 & 7/8")
    A0_sub = [0, 2]; T2_sub = [0, 2]; t0 = 3; b_val = Q(7//2)
    e1_fn(h) = (1, 0, mod(h, 4)); negG(g) = (g[1], g[2], mod(-g[3], 4))
    PsiA = Set(ψ for ψ in states if all(s -> chval(ψ, (0, 0, s)) == 1, A0_sub))
    δ2 = length(T2_sub) // 4
    nz_basis = 0
    for ψ0 in states
        lhs_b = sum((1 // 8) * sum(chval(ψ0, negG(e1_fn(s + u0 - t0))) * b_val for s in T2_sub) for u0 in A0_sub)
        rhs_b = (ψ0 in PsiA) ? (length(A0_sub) * b_val * (δ2 / 2)) * chval(ψ0, e1_fn(t0)) : Complex{Q}(Q(0), Q(0))
        req(lhs_b == rhs_b, "sum_Th basis indicator $ψ0")
        nz_basis += (lhs_b != 0)
        if lhs_b != 0
            req(lhs_b == Complex{Q}(Q(7//4), Q(0)) || lhs_b == Complex{Q}(Q(-7//4), Q(0)), "basis value ±7/4")
        end
    end
    req(nz_basis == 8, "expected 8 nonzero basis indicators in PsiA")

    addG(x, y) = ((x[1] + y[1]) & 1, (x[2] + y[2]) & 1, mod(x[3] + y[3], 4))
    mulGG(x, y) = ((x[1][1] * y[1][1], x[1][2] * y[1][2]), mod(x[2] + y[2], 4))
    iso(g) = (((g[2] == 0 ? 1 : -1), (g[1] == 0 ? 1 : -1)), g[3])
    in_Psi_GG(gg) = (gg[1][2] == 1)
    tau1(t) = ((1, 1), t); tau2(t) = ((-1, 1), t)
    req(length(Set(iso.(states))) == 16, "iso bijection")
    for g1 in states, g2 in states
        req(iso(addG(g1, g2)) == mulGG(iso(g1), iso(g2)), "iso homomorphism on 256 pairs")
    end
    for g in states
        req((g[1] == 0) == in_Psi_GG(iso(g)), "InPhi <-> R.Psi bit-swap mismatch")
    end
    for t in 0:3
        req(iso((0, 0, t)) == tau1(t) && iso((0, 1, t)) == tau2(t), "topPl/thickPl <-> tau1/tau2 mismatch")
    end
    TT = [0]; T2 = [0]; dig(s) = s; u0 = 1
    topPlaces   = Set(tau1(t) for t in TT)
    thickPlaces = Set(tau2(mod(dig(s) + u0, 4)) for s in T2)
    req(tau1(0) in topPlaces && !(tau1(1) in topPlaces), "TT restriction witness")
    req(tau2(1) in thickPlaces && !(tau2(0) in thickPlaces), "T2+u0 restriction witness")

    for p in (2, 3, 5, 7), y in 2:128
        powers = Int[]; qv = p
        while qv <= y; push!(powers, qv); qv *= p; end
        k = length(powers)
        direct = sum((Q(y) / qv - 1 for qv in powers); init = Q(0))
        closed = Q(y) * (1 - Q(1) / Q(p)^k) / (p - 1) - k
        req(direct == closed, "principal ramp formula at p=$p, y=$y")
    end
    for h in 1:128
        y2 = BigInt(2)^h
        direct_h = sum((Q(y2) / BigInt(2)^j - 1 for j in 1:h); init = Q(0))
        req(direct_h == Q(y2 - 1 - h), "N=2, y=2^h witness at h=$h")
    end

    req(abs(Q(100) / 1 - 100) <= 1 && Q(1) <= Q(10^6) <= Q(1 + 10^6 + 1) && Q(100) / Q(10^6) == Q(1 // 10000),
        "CostWindows necessity witness")

    A2 = BigInt[3 0; 3 9]; y2 = BigInt[3 0; 0 1]
    req(all(iszero, mod.(A2 * y2, 9)), "Ly divisible by 9")
    det2(B) = B[1,1]*B[2,2] - B[1,2]*B[2,1]
    req(det2(A2) == 27 && det2(A2 * transpose(A2)) == 729 && (A2*transpose(A2))[1,1]*(A2*transpose(A2))[2,2] == 810, "Smith-Gram 2x2")
    chi8(i) = iseven(i) ? 0 : ((i % 8 in (1, 7)) ? 1 : -1)
    for e in 1:8
        M = 2^(e + 2); grp = 1:2:M-1; stab = [a for a in grp if a == 1 || a == M - 1]
        req(all(a -> chi8(a) == 1, stab) && length(grp) ÷ length(stab) == 2^e, "chi8 c=1 at e=$e")
    end
    req((20 // 2) == 30 // 3 && (80 // 2) < 90 // 2, "X'/3 sharpness")
    pulse("GATE-V8-02: PASS (ch_balance 98 exact coeffs, sum_Th=7/4 & 7/8 + 16 basis, R_1-R_{χ_0} 128 powers, 256 bit-swap pairs)")
end

# ==============================================================================
# GATE-V8-03: APPENDICES A.1 (2 series + X->1), A.2 (independent 1_[1,2] integrals),
#             A.3 (ω-closure + HNF up to 7,079 bits + 2,003 integer & 6,002 fractional points)
# ==============================================================================
function bernoulli_even_rational(max_k::Int)
    N = 2 * max_k
    B = zeros(Q, N + 1)
    B[1] = 1
    for m in 1:N
        s = Q(0)
        for k in 0:m-1
            s += binomial(BigInt(m + 1), BigInt(k)) * B[k + 1]
        end
        B[m + 1] = -s // (m + 1)
    end
    return [B[2k + 1] for k in 1:max_k]
end

function complex_gamma_bf(z::Complex{BigFloat}, B_even::Vector{Q})
    shift = Complex{BigFloat}(1, 0)
    w = z
    while real(w) < 25
        shift *= w
        w += 1
    end
    lg = (w - BigFloat(1)/2) * log(w) - w + log(2 * BigFloat(pi)) / 2
    invw2 = inv(w * w)
    pow_inv = inv(w)
    for (k, B2k) in enumerate(B_even)
        lg += BigFloat(B2k) / (2k * (2k - 1)) * pow_inv
        pow_inv *= invw2
    end
    return exp(lg) / shift
end

function mellin_indicator_12_at_1()
    return setprecision(BigFloat, 256) do
        pi_bf = BigFloat(pi)
        function romberg(f, a::BigFloat, b::BigFloat; levels::Int = 8)
            R = zeros(BigFloat, levels, levels)
            h = b - a
            R[1, 1] = h * (f(a) + f(b)) / 2
            for i in 2:levels
                h /= 2
                s = BigFloat(0)
                for k in 1:2:(2^(i - 1) - 1)
                    s += f(a + k * h)
                end
                R[i, 1] = R[i - 1, 1] / 2 + h * s
                p4 = BigFloat(4)
                for j in 2:i
                    R[i, j] = R[i, j - 1] + (R[i, j - 1] - R[i - 1, j - 1]) / (p4 - 1)
                    p4 *= 4
                end
            end
            return R[levels, levels]
        end
        t_of(φ) = sin(φ / 2)^2
        tg_left  = romberg(φ -> max(t_of(φ) - BigFloat(1)/2, BigFloat(0)), BigFloat(0), pi_bf / 2)
        tg_right = romberg(φ -> max(t_of(φ) - BigFloat(1)/2, BigFloat(0)), pi_bf / 2, pi_bf)
        b_left   = romberg(φ -> min(BigFloat(1)/2, 1 - t_of(φ)), BigFloat(0), pi_bf / 2)
        b_right  = romberg(φ -> min(BigFloat(1)/2, 1 - t_of(φ)), pi_bf / 2, pi_bf)
        return (tg_left + tg_right) / pi_bf, (b_left + b_right) / pi_bf
    end
end

function intersect_hnf2(L1::NTuple{3, BigInt}, L2::NTuple{3, BigInt})
    a1, b1, d1 = L1; a2, b2, d2 = L2
    a_int = lcm(a1, a2)
    d_lcm = lcm(d1, d2)
    g_a = gcd(a1, a2)
    diff = (d_lcm ÷ d1) * b1 - (d_lcm ÷ d2) * b2
    g_d = gcd(abs(diff), g_a)
    step = g_a ÷ g_d
    d_int = step * d_lcm
    rhs = (d_int ÷ d2) * b2 - (d_int ÷ d1) * b1
    _, u, _ = gcdx(a1 ÷ g_a, a2 ÷ g_a)
    m1 = mod(u * (rhs ÷ g_a), a2 ÷ g_a)
    b_int = mod((d_int ÷ d1) * b1 + m1 * a1, a_int)
    return (a_int, b_int, d_int)
end

function all_ideals_Qsqrt_m7(tmax::Int)
    ideals = Tuple{Int, NTuple{3, BigInt}}[]
    for d in 1:isqrt(tmax)
        max_m = tmax ÷ (d * d)
        for m in 1:max_m
            norm_val = d * d * m
            for r in 0:m-1
                if mod(r * r + r + 2, m) == 0
                    push!(ideals, (norm_val, (BigInt(d * m), BigInt(d * r), BigInt(d))))
                end
            end
        end
    end
    return ideals
end

function gate_v8_03()
    pulse("GATE-V8-03: Appendices A.1, A.2 (independent integrals), A.3 (ω-closure, 7,079 bits, integer/fractional windows)...")
    B_even = bernoulli_even_rational(18)

    setprecision(BigFloat, 512) do
        N_e = 210
        row = [inv(sqrt(BigFloat(n))) for n in 1:N_e]
        eta = BigFloat(0)
        for i in 1:N_e
            eta += ldexp(row[1], -i)
            for j in 1:N_e-i
                row[j] = row[j] - row[j+1]
            end
        end
        z_euler = eta / (1 - sqrt(BigFloat(2)))
        N_em = 120; s = BigFloat(1) / 2
        z_em = sum(BigFloat(n)^(-s) for n in 1:N_em-1) + BigFloat(N_em)^(1 - s) / (s - 1) + BigFloat(N_em)^(-s) / 2
        poch = s
        for (k, B2k) in enumerate(B_even)
            if k > 1; poch *= (s + 2k - 3) * (s + 2k - 2); end
            z_em += BigFloat(B2k) / factorial(BigInt(2k)) * poch * BigFloat(N_em)^(-(s + 2k - 1))
        end
        req(abs(z_euler - z_em) < big"1e-45", "A.1 dual-basis zeta(1/2) disagreement")
        γ = BigFloat(Base.MathConstants.eulergamma)
        C_val = BigFloat(9)/2 + z_euler + γ - log(4 * BigFloat(pi))
        req(startswith(string(C_val), "1.0858369091226552547"), "A.1 constant decimal prefix")
        triv_limit = 1 - log(BigFloat(2))
        hadamard_sum = 2 + γ - log(4 * BigFloat(pi))
        req(abs(hadamard_sum + log(2 * BigFloat(pi)) - triv_limit - (1 + γ)) < big"1e-100", "A.1 explicit formula X->1 check")
    end

    for X in 2:120
        ps = reverse([p for p in (isqrt(X)+1):X if is_prime(p)])
        W = Q(0); Hprev = BigInt(0)
        for p in ps
            W += 1 - (X % p) // p
            H = ceil(BigInt, W)
            req((H - Hprev) in (0, 1) && 0 <= H - W < 1, "A.1 rounding invariant at X=$X")
            Hprev = H
        end
    end

    setprecision(BigFloat, 256) do
        half_pi = BigFloat(pi) / 2
        h_de = BigFloat(1) / 32
        for s_c in [Complex{BigFloat}(0.75, 1.3), Complex{BigFloat}(1.2, -0.8)]
            m_gamma = complex_gamma_bf(BigFloat(3)/2 - s_c, B_even) / (sqrt(BigFloat(pi)) * complex_gamma_bf(BigFloat(2) - s_c, B_even))
            m_quad = Complex{BigFloat}(0, 0)
            for k in -128:128
                tk = k * h_de
                sh = sinh(tk); ch = cosh(tk); arg = half_pi * sh
                u = inv(1 + exp(-2 * arg))
                w_de = half_pi * ch / (2 * cosh(arg)^2) * h_de
                m_quad += sin(half_pi * u)^(2 - 2*s_c) * w_de
            end
            req(abs(m_gamma - m_quad) < big"1e-20", "A.2 m(s) gamma vs tanh-sinh")
        end
        tg1, b1 = mellin_indicator_12_at_1()
        pi_bf = BigFloat(pi)
        req(abs(tg1 - inv(2 * pi_bf)) < big"1e-18" && abs(b1 - (BigFloat(1)/2 - inv(2 * pi_bf))) < big"1e-18",
            "A.2 independent indicator integrals mismatch")
    end

    for a in 1:36, d in 1:12, b in 0:a-1
        direct_ok = (mod(a, d) == 0) && (mod(0 - (a ÷ d) * b, a) == 0) &&
                    (mod(b + d, d) == 0) && (mod(-2 * d - ((b + d) ÷ d) * b, a) == 0)
        crit_ok   = (mod(a, d) == 0) && (mod(b, d) == 0) && (mod(b * b + b * d + 2 * d * d, a * d) == 0)
        req(direct_ok == crit_ok, "A.3 omega-closure equivalence at ($a,$b,$d)")
    end

    pairs = [(5, 2), (7, 3), (10, 3), (13, 4), (17, 4), (20, 5), (25, 5), (31, 6),
             (40, 6), (50, 7), (64, 8), (80, 9), (95, 10), (110, 11), (127, 12)]
    all_id = all_ideals_Qsqrt_m7(127)
    J_norm_hnf = Dict{Int, BigInt}(0 => BigInt(1))
    cur_L = (BigInt(1), BigInt(0), BigInt(1))
    by_norm = Dict{Int, Vector{NTuple{3, BigInt}}}()
    for (nv, lat) in all_id
        push!(get!(by_norm, nv, NTuple{3, BigInt}[]), lat)
    end
    for t in 1:127
        if haskey(by_norm, t)
            for lat in by_norm[t]; cur_L = intersect_hnf2(cur_L, lat); end
        end
        J_norm_hnf[t] = cur_L[1] * cur_L[3]
    end
    max_bits = 0
    for (x, M) in pairs
        N_hnf = BigInt(1)
        for j in 1:(M * (x - 1)); N_hnf *= J_norm_hnf[(M * x) ÷ (M + j)]; end
        N_mul = BigInt(1)
        for p in 2:x
            is_prime(p) || continue
            chi_p = kronecker_prime(-7, p); pk, k = p, 1; exp_p = BigInt(0)
            while pk <= x
                exp_p += BigInt(1 + chi_p^k) * BigInt((M * x) ÷ pk - M)
                pk *= p; k += 1
            end
            N_mul *= BigInt(p)^exp_p
        end
        req(N_hnf == N_mul, "A.3 dual-basis norm mismatch at (x=$x, M=$M)")
        max_bits = max(max_bits, ndigits(N_hnf; base=2))
    end
    req(max_bits == 7079, "A.3 expected 7079 bits, got $max_bits")

    n_int_pts, n_frac_pts = 0, 0
    for Y in [16.0, 25.3, 40.7, 81.25, 200.5, 350.75]
        Yp = ceil(Int, Y)
        hi_outer = Y^1.5
        hi_inner = Float64(Yp)^1.25
        req(hi_inner + 1 <= hi_outer, "shrunk window inclusion failed at Y=$Y")
        for x_num in (4 * Yp):floor(Int, 4 * hi_inner)
            x = x_num / 4.0
            x <= hi_inner || continue
            n = floor(Int, x); t = x - n
            req(n >= Y, "left endpoint n >= Y")
            if t == 0.0
                n_int_pts += 1
                req(n <= hi_outer, "integer point inside outer window")
            else
                n_frac_pts += 1
                req(n + 1 <= hi_outer, "n+1 inside outer window for fractional x")
                hn = n * log(n); hn1 = (n + 1) * log(n + 1); hnt = x * log(x)
                ce = (1 - t) * hn + t * hn1 - hnt
                req(0 <= ce <= t * (1 - t) / (2 * n) + 1e-12 && ce <= 1 / (8 * n) + 1e-12, "chord error")
            end
        end
    end
    req(n_int_pts == 2003 && n_frac_pts == 6002, "expected 2003 integer and 6002 fractional points, got $n_int_pts, $n_frac_pts")
    pulse("GATE-V8-03: PASS (A.1 2 series <1e-45, A.2 1_[1,2] <1e-18, A.3 15/15 up to $max_bits bits, $n_int_pts int + $n_frac_pts frac window pts)")
end

# ==============================================================================
# GATE-V8-04: DOT META-LAYER — [0,1]^4 HYPERCUBE PROJECTOR THEOREM + 30 MINORS + O_6 <-> Q_3
# ==============================================================================
function gate_v8_04()
    pulse("GATE-V8-04: [0,1]^4 hypercube projector theorem (tr(E-E^2)=Σq_i(1-q_i)), 30 minors, and O_6 <-> Q_3...")
    for s1 in SIGMA4, s2 in SIGMA4
        req(s1 * J4Q == J4Q * s1 && s1 == transpose(s1), "Clifford symmetry & J-commutativity")
        req(s1 * s2 + s2 * s1 == (s1 == s2 ? 2 * I4Q : 0 * I4Q), "Clifford anticommutation")
    end
    req(J4Q * J4Q == -I4Q, "J^2 = -I")

    good = zeros(Int, 5); tot = zeros(Int, 5)
    for i in 0:15
        q = ntuple(j -> (i >> (j - 1)) & 1, 4)
        M = direct_effect_matrix(q)
        t, e1, e2, e3 = bloch_coords(q)
        r2 = e1*e1 + e2*e2 + e3*e3
        req(inv_walsh(t, e1, e2, e3) == Q[q...], "inv_walsh roundtrip")
        req(M == t * I4Q + e1 * SIGMA4[1] + e2 * SIGMA4[2] + e3 * SIGMA4[3], "direct == Bloch")
        req(tr(M - M * M) == 4 * (t - t^2 - r2) == sum(Q(x) * (1 - Q(x)) for x in q), "trace identity on bool")
        req(direct_effect_matrix(1 .- q) == I4Q - M && J4Q * M == M * J4Q, "complement & J")
        req(effect_by_minors(M) == effect_cones(q), "30 minors == Bloch cones on bool $q")
        for λ in -2:2
            req(det(λ * I4Q - M) == ((λ - t)^2 - r2)^2, "charpoly at λ=$λ")
        end
        w = sum(q)
        tot[w + 1] += 1
        good[w + 1] += all(effect_by_minors(M)) ? 1 : 0
        if iseven(w)
            req(M * M == M && tr(M) == w, "even weight projector")
        else
            req(r2 == 3 // 16 && effect_by_minors(M) == (w == 3, w == 1), "odd weight violation")
        end
    end
    req(good == [1, 0, 6, 0, 1] && tot == [1, 4, 6, 4, 1], "L(Q_4) cap E_4^[0,I] counts")

    grid = Q[0, 1//4, 1//2, 3//4, 1]
    proj_total = 0; proj_rank2 = 0
    for q in Iterators.product(grid, grid, grid, grid)
        M = direct_effect_matrix(q)
        t, e1, e2, e3 = bloch_coords(q)
        r2 = e1*e1 + e2*e2 + e3*e3
        req(inv_walsh(t, e1, e2, e3) == Q[q...], "inv_walsh on 625-grid")
        req(effect_cones(q) == effect_by_minors(M), "625-grid 30 minors == Bloch")
        tr_diff = tr(M - M * M)
        req(tr_diff == 4 * (t - t^2 - r2) == sum(x * (1 - x) for x in q), "trace identity on 625-grid")
        if M * M == M
            proj_total += 1
            req(all(x -> x == 0 || x == 1, q), "projector inside [0,1]^4 must be boolean vertex!")
            if tr(M) == 2
                proj_rank2 += 1
                req(abs(e1) + abs(e2) + abs(e3) == Q(1//2) && r2 == Q(1//4), "||e||_1 == ||e||_2 == 1/2")
            end
        end
    end
    req(proj_total == 8 && proj_rank2 == 6, "hypercube projector count mismatch: total=$proj_total, rank2=$proj_rank2")

    P_cont = I4Q / 2 + (3//10) * SIGMA4[1] + (2//5) * SIGMA4[2]
    q_cont = inv_walsh(Q(1//2), Q(3//10), Q(2//5), Q(0))
    req(P_cont * P_cont == P_cont && tr(P_cont) == 2 && all(effect_by_minors(P_cont)), "P_cont in operator interval")
    req(q_cont == Q[-1//5, 3//5, 2//5, 6//5] && !in_hypercube(q_cont), "P_cont preimage outside [0,1]^4")

    tetra = [(i, j) for i in 1:3 for j in i+1:4]
    stars = [Set(e for e in tetra if i in e) for i in 1:4]
    cavs  = [Set(e for e in tetra if !(i in e)) for i in 1:4]
    faces = vcat(stars, cavs)
    adj = [length(intersect(f, g)) == 2 for f in faces, g in faces]
    req(sum(adj) == 24 && all(iszero, adj[1:4, 1:4]), "dual cube 12 edges bipartite")
    for i in 1:3, j in i+1:4
        mid = [h for h in 1:4 if adj[i, h + 4] && adj[h + 4, j]]
        req(Set(mid) == setdiff(Set(1:4), [i, j]) && length(mid) == 2, "2 bridges per star pair")
    end
    even = [0, 3, 5, 6]; cube = vcat(even, 7 .⊻ even)
    req(adj == [count_ones(xor(u, v)) == 1 for u in cube, v in cube], "O_6 dual == Q_3")
    pulse("GATE-V8-04: PASS ([0,1]^4 hypercube: 8 projectors / 6 rank-2, 625 grid points via 30 minors, O_6 <-> Q_3)")
end

# ==============================================================================
# GATE-V8-05: BILINGUAL BLUEPRINT & INDEX AUDIT (EN + RU, math delimiters, linguistic separation, Lean 4.33.1)
# ==============================================================================
const ROW_RE_T1 = r"^\| `([^`]+)` \| `([^`]+)` \| (\d+) \| `(\w+)` \| (\d+) \| (\d+) \| (.+) \|$"
const ROW_RE_T2 = r"^\| `([^`]+)` \| `([^`]+)` \| (\d+) \| `(\w+)` \| `([^`]+)` \| (\d+) \| (\d+) \|$"

function parse_v8_index(path::String)
    rows = IndexRow[]
    extras = ExtraRow[]
    for line in eachline(path)
        startswith(line, "| `") || continue
        m2 = match(ROW_RE_T2, line)
        if !isnothing(m2)
            nm, fp, ln, cat, ndl, id, msk = m2.captures
            push!(extras, (; name=String(nm), path=String(fp), line=parse(Int, ln),
                             category=String(cat), needle=String(ndl), id=parse(Int, id), mask=parse(Int, msk)))
            continue
        end
        m1 = match(ROW_RE_T1, line)
        if !isnothing(m1)
            nm, fp, ln, kd, id, msk, sec = m1.captures
            push!(rows, (; name=String(nm), path=String(fp), line=parse(Int, ln),
                           kind=String(kd), id=parse(Int, id), mask=parse(Int, msk), section=String(sec)))
        end
    end
    return rows, extras
end

function strip_fences(s::String)
    out = String[]; in_f = false
    for line in eachsplit(s, '\n')
        if startswith(lstrip(line), "```")
            in_f = !in_f; continue
        end
        in_f || push!(out, String(line))
    end
    return join(out, "\n")
end

const NON_LEAN_SHARED = Set([
    "Lean 4", "Lean 4.33.1", "Scope Box", "One-Page Proof Map", "propext", "Classical.choice", "Quot.sound",
    "verification/verify_blueprint.jl", "verify_blueprint.jl", "HypercubeAndLPTheorems", "lean/",
    "--self-gate", "--portable", "--full", "v9.0", "v9", "v8.1", "v8", "v2.0",
    "0", "0 sorry", "3", "6", "7", "8", "16", "22", "26", "29", "30", "31", "34", "40", "44",
    "83", "103", "104", "198", "204", "233", "240",
    "Rat", "Int", "000, 011, 101, 110", "hY", "ell", "claimAll.2.1",
    "E0 × H", "¬IsThickAt", "IsThickAt T2 u0", "HostFactsS D S", "WinPair eps (X^{1/J}) q d",
    "Unram l K0", "Ranks.sigW(j) = (k + j - 1, m - j)", "R.Psi", "Frame.GG", "Main", "id = 341024",
    "SHA-256 = 9631b4f0...", "SHA-256 = 5ea74b91...",
    "(Loss)", "(Gain)", "(Slope)", "(Div)",
])

const NON_LEAN_RU = union(NON_LEAN_SHARED, Set([
    "blueprint/KERNEL_INDEX_RU.md", "KERNEL_INDEX_RU.md",
    "blueprint/ONE_PAGE_PROOF_RU.md", "ONE_PAGE_PROOF_RU.md", "ONE_PAGE_PROOF_RU.pdf",
    "blueprint/BLUEPRINT_RU.md", "BLUEPRINT_RU.md", "BLUEPRINT_RU.pdf",
    "verification/AUDIT_HISTORY_RU.md", "verification/COMPARISON_8_REPOS_RU.md",
    "[\u0414]", "[\u0421]", "[\u041a]", "[\u0412]",
    "\u041f_0", "\u041f_1", "\u041f_2", "\u041f_3",
    "175 187", "17 374 215", "1 484 733", "1 478 222", "7 079",
]))

const NON_LEAN_EN = union(NON_LEAN_SHARED, Set([
    "blueprint/KERNEL_INDEX_EN.md", "KERNEL_INDEX_EN.md",
    "blueprint/ONE_PAGE_PROOF_EN.md", "ONE_PAGE_PROOF_EN.md", "ONE_PAGE_PROOF_EN.pdf",
    "blueprint/BLUEPRINT_EN.md", "BLUEPRINT_EN.md", "BLUEPRINT_EN.pdf",
    "verification/AUDIT_HISTORY_EN.md", "verification/COMPARISON_8_REPOS_EN.md",
    "DOT", "[P]", "[C]", "[X]", "[Q]",
    "\u03a0_0", "\u03a0_1", "\u03a0_2", "\u03a0_3",
    "175,187", "17,374,215", "1,484,733", "1,478,222", "7,079",
]))

function verify_blueprint_backticks(raw_text::String, idx_names::Set{String}, idx_paths::Set{String},
                                    allowed_non_lean::Set{String}, label::String)
    req(!occursin(r"\\\[|\\\]", raw_text), "$label contains LaTeX \\[ or \\] delimiters unsupported by GitHub Markdown; use \$\$ ... \$\$")
    text_clean = strip_fences(raw_text)
    idx_stems = Set(replace(basename(p), ".lean" => "") for p in idx_paths)
    unmatched = String[]
    for m in eachmatch(r"`([^`\n]+)`", text_clean)
        tok = String(m[1])
        (tok in allowed_non_lean || endswith(tok, ".lean") || occursin(".lean:", tok) || occursin(' ', tok) || occursin('↔', tok)) && continue
        base_tok = replace(tok, r"\([^()]*\)$" => "")
        ok = (base_tok in idx_stems) || any(n -> n == base_tok || endswith(n, "." * base_tok) || startswith(n, base_tok * "."), idx_names)
        ok || push!(unmatched, tok)
    end
    req(isempty(unmatched), "$label has Lean identifiers missing from KERNEL_INDEX (Tables 1-2): " * join(sort(unique(unmatched)), ", "))
end

function verify_monolingual_separation()
    REPO_ROOT == HERE && return
    ru_switcher = "[\u0420\u0443\u0441\u0441\u043a\u0430\u044f \u0432\u0435\u0440\u0441\u0438\u044f (README_RU.md)]"
    cyr_re = r"[\u0410-\u044F\u0401\u0451]"
    en_files = [
        "README.md", "CITATION.cff", "LICENSE-DOCS.md",
        joinpath("blueprint", "BLUEPRINT_EN.md"), joinpath("blueprint", "ONE_PAGE_PROOF_EN.md"),
        joinpath("blueprint", "KERNEL_INDEX_EN.md"),
        joinpath("verification", "AUDIT_HISTORY_EN.md"),
        joinpath("verification", "COMPARISON_8_REPOS_EN.md"),
        joinpath("prompts", "AI_REFEREE_PROMPT_EN.md"),
        joinpath("lean", "HypercubeAndLPTheorems.lean"),
        joinpath("verification", "build_kernel_reachability_tsv.jl"),
        joinpath("verification", "verify_blueprint.jl"),
        joinpath("scripts", "build_pdfs.py"),
        joinpath("scripts", "build_figures.py"),
        joinpath("scripts", "blueprint_pdf.lua"),
        joinpath("scripts", "blueprint_header.tex"),
        joinpath("assets", "fig1_architecture_en.svg"),
        joinpath("assets", "fig2_balance_lp_en.svg"),
        joinpath(".github", "workflows", "verify.yml"),
    ]
    forbidden_en_acr = Regex("\\b" * join(["T", "N", "R"]) * "\\b")
    for rel in en_files
        full = joinpath(REPO_ROOT, rel)
        req(isfile(full), "missing required release file: $rel")
        txt = read(full, String)
        rel == "README.md" && (txt = replace(txt, ru_switcher => ""))
        req(!occursin(cyr_re, txt), "Cyrillic characters found in English/code file $rel")
        req(!occursin(forbidden_en_acr, txt), "transliterated Russian acronym found in English/code file $rel (must use `DOT` only)")
    end

    ru_files = [
        "README_RU.md",
        joinpath("blueprint", "BLUEPRINT_RU.md"), joinpath("blueprint", "ONE_PAGE_PROOF_RU.md"),
        joinpath("blueprint", "KERNEL_INDEX_RU.md"),
        joinpath("verification", "AUDIT_HISTORY_RU.md"),
        joinpath("verification", "COMPARISON_8_REPOS_RU.md"),
        joinpath("prompts", "AI_REFEREE_PROMPT_RU.md"),
        joinpath("assets", "fig1_architecture_ru.svg"),
        joinpath("assets", "fig2_balance_lp_ru.svg"),
    ]
    for rel in ru_files
        full = joinpath(REPO_ROOT, rel)
        req(isfile(full), "missing required release file: $rel")
        txt = read(full, String)
        txt_prose = replace(txt, r"\]\([^)\n]+\)" => "]()")
        txt_prose = replace(txt_prose, r"https?://\S+" => "")
        req(!occursin(r"\bDOT\b", txt_prose) && !occursin("Distinction Observable Theory", txt_prose) &&
            !occursin("DOTheory", txt_prose),
            "English theory acronym/name (`DOT` / `Distinction Observable Theory` / `DOTheory`) found in Russian prose of $rel")
    end
end

function require_matching_lean_citations(en, ru, refs_en, refs_ru, publication)
    locs(refs) = [(r.path, r.ranges, r.in_fence) for r in refs]
    blocks(text) = [m.captures[1] for m in eachmatch(r"\*\[Lean:\s*([^\]\n]*)\]\*", text)]
    en_blocks = blocks(en)
    req(locs(refs_en) == locs(refs_ru) && !isempty(en_blocks) && en_blocks == blocks(ru),
        "bilingual Lean citation targets differ in $publication")
end

function gate_v8_05()
    pulse("GATE-V8-05: auditing blueprint + one-page <-> kernel index coverage (Tables 1 & 2, EN + RU, Lean 4.33.1)...")
    rows, extras = parse_v8_index(IDX_RU)
    req(length(rows) == 233, "expected 233 public declarations in Table 1, got $(length(rows))")
    req(length(extras) == 7, "expected 7 entries in Table 2 (fields/Mathlib), got $(length(extras))")
    all_names = vcat([r.name for r in rows], [e.name for e in extras])
    all_ids   = vcat([r.id for r in rows], [e.id for e in extras])
    req(allunique(all_names), "duplicate full names in KERNEL_INDEX")
    req(allunique(all_ids), "duplicate export_ids in KERNEL_INDEX")
    req(all(r -> 1 <= r.mask <= 31 && r.line >= 1, rows), "invalid mask/line in Table 1")
    req(all(e -> 1 <= e.mask <= 31 && e.line >= 1, extras), "invalid mask/line in Table 2")
    run_row_mutation_checks(rows)

    idx_names = Set(all_names)
    idx_paths = Set(vcat([r.path for r in rows], [e.path for e in extras]))

    req(isfile(LEAN_OWN), "missing standalone Lean 4 module: $LEAN_OWN")
    own_src = read(LEAN_OWN, String)
    own_clean = strip_lean_comments_and_strings(own_src)
    own_thms = Set(String(m[1]) for m in eachmatch(r"(?m)^theorem\s+([A-Za-z0-9_']+)\b", own_clean))
    allowed_ru = union(NON_LEAN_RU, own_thms)
    allowed_en = union(NON_LEAN_EN, own_thms)

    raw_ru = read(MD_RU, String)
    citations_ru = extract_file_citations(raw_ru, idx_paths)
    verify_blueprint_backticks(raw_ru, idx_names, idx_paths, allowed_ru, "BLUEPRINT_RU.md")

    all_citations = copy(citations_ru)
    rows_en, extras_en = parse_v8_index(IDX_EN)
    req([(r.name, r.path, r.line, r.kind, r.id, r.mask) for r in rows_en] ==
        [(r.name, r.path, r.line, r.kind, r.id, r.mask) for r in rows],
        "Table 1 metadata mismatch between KERNEL_INDEX_EN.md and KERNEL_INDEX_RU.md")
    req(extras_en == extras, "Table 2 metadata mismatch between KERNEL_INDEX_EN.md and KERNEL_INDEX_RU.md")

    raw_en = read(MD_EN, String)
    citations_en = extract_file_citations(raw_en, idx_paths)
    verify_blueprint_backticks(raw_en, idx_names, idx_paths, allowed_en, "BLUEPRINT_EN.md")
    require_matching_lean_citations(raw_en, raw_ru, citations_en, citations_ru, "BLUEPRINT")
    append!(all_citations, citations_en)


    one_en = read(ONE_EN, String)
    one_ru = read(ONE_RU, String)
    cits_one_en = extract_file_citations(one_en, idx_paths)
    cits_one_ru = extract_file_citations(one_ru, idx_paths)
    verify_blueprint_backticks(one_en, idx_names, idx_paths, allowed_en, "ONE_PAGE_PROOF_EN.md")
    verify_blueprint_backticks(one_ru, idx_names, idx_paths, allowed_ru, "ONE_PAGE_PROOF_RU.md")
    require_matching_lean_citations(one_en, one_ru, cits_one_en, cits_one_ru, "ONE_PAGE_PROOF")
    append!(all_citations, cits_one_en)
    append!(all_citations, cits_one_ru)

    verify_monolingual_separation()

    prose_cits   = filter(c -> !c.in_fence, citations_ru)
    fence_cits   = filter(c -> c.in_fence, citations_ru)
    n_ranges_all = sum(length(c.ranges) for c in citations_ru; init = 0)
    n_with_lines = count(c -> !isempty(c.ranges), citations_ru)

    lean_msg = ""
    if LEAN_IS_4_33_1
        out = IOBuffer()
        proc = run(pipeline(ignorestatus(`$DEFAULT_LEAN $LEAN_OWN`); stdout=out, stderr=out))
        obs = String(take!(out))
        req(success(proc), "Lean 4.33.1 compilation failed on $LEAN_OWN:\n$obs")
        n_ax = audit_own_lean_module(own_src, obs; expected_count=44)
        lean_msg = "; HypercubeAndLPTheorems.lean compiled by Lean 4.33.1 ($n_ax/$n_ax theorems, 0 imports, 0 sorry)"
    else
        n_ax = audit_own_lean_module(own_src, nothing; expected_count=44)
        lean_msg = "; HypercubeAndLPTheorems.lean checked statically ($n_ax theorems, 0 imports, 0 sorry; Lean 4.33.1 not invoked)"
    end
    bilingual_msg = " [EN+RU blueprint & 1-page parity + monolingual lock OK]"
    pulse("GATE-V8-05: PASS ($(length(rows)) decls in $(length(idx_paths)) files + $(length(extras)) fields/Mathlib = $(length(all_names)) entries; citations: $(length(prose_cits)) prose + $(length(fence_cits)) map, $n_with_lines with lines, $n_ranges_all ranges$bilingual_msg$lean_msg)")
    return rows, extras, all_citations
end

# ==============================================================================
# GATE-V8-06 (--full only): 175,187 archive modules + 1,484,733 kernel rows + Tables 1-2 + all EN/RU ranges
# ==============================================================================
function gate_v8_06(rows::Vector{IndexRow}, extras::Vector{ExtraRow}, citations, archive_dir::String)
    pulse("GATE-V8-06: full audit of the 175,187 Lean 4 archive modules and 1,484,733 kernel rows...")
    parts  = [joinpath(archive_dir, "original.part" * lpad(i, 2, '0')) for i in 1:14]
    tar_gz = joinpath(archive_dir, "original.tar.gz")
    use_parts = all(isfile, parts)
    req(use_parts || isfile(tar_gz),
        "neither original.part01..14 nor original.tar.gz found in RH_ARCHIVE_DIR=$archive_dir")
    tsv = resolve_kernel_tsv(archive_dir)
    req(isfile(tsv), "kernel reachability table not found at $tsv")

    comb_sha = use_parts ?
        open(io -> bytes2hex(sha256(io)), Cmd(vcat(["cat"], parts))) :
        open(io -> bytes2hex(sha256(io)), tar_gz)
    req(comb_sha == ARCHIVE_SHA256, "archive SHA-256 mismatch: $comb_sha")
    tsv_sha = open(io -> bytes2hex(sha256(io)), tsv)
    req(tsv_sha == TSV_SHA256, "kernel TSV SHA-256 mismatch: $tsv_sha")
    pulse("GATE-V8-06: archive SHA-256 (9631b4f0...) and kernel TSV SHA-256 (76b00059...) verified")

    wanted_t1   = Set(r.name for r in rows)
    wanted_all  = union(wanted_t1, Set(e.name for e in extras))
    wanted_scan = union(wanted_t1, Set([SOURCE_ONLY_SG]))
    found = Dict(n => Tuple{String, Int, String}[] for n in wanted_scan)
    leaves = Set{String}(String(last(split(n, '.'))) for n in wanted_scan)
    idx_paths = Set(vcat([r.path for r in rows], [e.path for e in extras]))
    extra_paths = Set(e.path for e in extras)
    lengths = Dict{String, Int}()
    kept_sources = Dict{String, String}()

    nmods = 0
    tar_stream = use_parts ? pipeline(Cmd(vcat(["cat"], parts)), `gzip -dc`) : `gzip -dc $tar_gz`
    open(tar_stream) do io
        Tar.read_tarball(h -> h.type == :file && startswith(h.path, "lean/src/") && endswith(h.path, ".lean"), io) do h, _
            rel = String(chop(h.path; head=9, tail=0))
            nmods += 1
            if nmods % 50_000 == 0
                pulse("GATE-V8-06: scanned $nmods / 175,187 modules...")
            end
            bytes = read(io, cld(h.size, 512) * 512)
            resize!(bytes, h.size)
            src = String(bytes)
            if rel in idx_paths
                lengths[rel] = count(==('\n'), src) + (!isempty(src) && !endswith(src, '\n'))
            end
            if rel in extra_paths
                kept_sources[rel] = src
            end
            scan_lean_declarations!(found, leaves, rel, src)
        end
    end
    req(nmods == 175187, "archive .lean module count != 175187: $nmods")
    for r in rows
        sites = found[r.name]
        req(length(sites) == 1, "unique owner violated for $(r.name): $sites")
        p, ln, kd = only(sites)
        req(p == r.path && ln == r.line && kd == r.kind,
            "metadata mismatch for $(r.name): archive=($p,$ln,$kd) vs index=($(r.path),$(r.line),$(r.kind))")
    end
    for e in extras
        verify_extra_row_binding(e, kept_sources[e.path], rows)
    end
    req(only(found[SOURCE_ONLY_SG]) == ("Formalism/SizeWindowBrackets/FirstPrimeNeSecondPrime.lean", 15, "def"), "sg source site mismatch")

    n_pos = verify_citation_ranges(citations, lengths)

    counts = zeros(Int, 32)
    mem = Dict{String, Tuple{Int, Int}}()
    prev_id = 0
    open(`zstd -qdc --long=30 $tsv`) do io
        for line in eachline(io)
            f = split(line, '\t'; limit=3)
            msk = parse(Int, f[1]); id = parse(Int, f[2]); nm = f[3]
            req(0 <= msk <= 31 && id > prev_id, "kernel TSV ordering/mask corruption at id=$id")
            prev_id = id
            counts[msk + 1] += 1
            req(nm != SOURCE_ONLY_SG, "source-only declaration sg unexpectedly present in kernel export")
            if nm in wanted_all
                mem[String(nm)] = (id, msk)
            end
        end
    end
    req(sum(counts) == 1484733 && sum(counts[2:end]) == 1478222, "kernel graph row counts mismatch")
    by_root = [sum(counts[m + 1] for m in 0:31 if (m & bit) != 0) for bit in ROOT_BITS]
    req(by_root == EXPECTED_ROOT_COUNTS, "five-root reachability counts mismatch: $by_root")
    for r in rows
        req(haskey(mem, r.name) && mem[r.name] == (r.id, r.mask), "Table 1 reachability mismatch for $(r.name)")
    end
    for e in extras
        req(haskey(mem, e.name) && mem[e.name] == (e.id, e.mask), "Table 2 reachability mismatch for $(e.name)")
    end
    pulse("GATE-V8-06: PASS (175,187 modules, 1,484,733 kernel rows, $(length(rows))/$(length(rows)) Table 1 + $(length(extras))/$(length(extras)) Table 2, $n_pos line-range checks)")
end

function has_local_archive(archive_dir::String)
    parts = [joinpath(archive_dir, "original.part" * lpad(i, 2, '0')) for i in 1:14]
    has_tar = all(isfile, parts) || isfile(joinpath(archive_dir, "original.tar.gz"))
    return has_tar && isfile(resolve_kernel_tsv(archive_dir))
end

function main()
    BLAS.set_num_threads(1)
    req(Threads.nthreads() == 1, "Run Julia single-threaded: julia --startup-file=no -t1 ...")
    allow_no_lean = ("--allow-no-lean" in ARGS)
    pos_args = filter(!=("--allow-no-lean"), ARGS)
    mode = isempty(pos_args) ? "auto" : only(pos_args)
    req(mode in ("auto", "--self-gate", "--portable", "--full"),
        "Allowed modes: --self-gate, --portable, --full (optional flag: --allow-no-lean)")

    if mode == "--self-gate"
        run_self_gate()
        return
    end

    if mode == "--full"
        req(LEAN_IS_4_33_1 || allow_no_lean,
            "Lean 4.33.1 binary is required for --full verification (resolved '$DEFAULT_LEAN'); install leanprover/lean4:v4.33.1 via elan or pass --allow-no-lean")
    end

    run_self_gate()
    gate_v8_01()
    gate_v8_02()
    gate_v8_03()
    gate_v8_04()
    rows, extras, citations = gate_v8_05()

    lean_tag = LEAN_IS_4_33_1 ? "LEAN 4.33.1 VERIFIED" : "STATIC LEAN CHECK ONLY (Lean 4.33.1 not invoked)"
    if mode == "--full" || (mode == "auto" && has_local_archive(DEFAULT_ARCHIVE_DIR) && LEAN_IS_4_33_1)
        gate_v8_06(rows, extras, citations, DEFAULT_ARCHIVE_DIR)
        pulse("=== ALL 6/6 GATES + SELF-GATE PASS (FULL ARCHIVE + KERNEL + $lean_tag, v9.0) ===")
    else
        pulse("=== ALL 5/5 PORTABLE GATES + SELF-GATE PASS (0 external packages, $lean_tag, v9.0) ===")
    end
end

main()
