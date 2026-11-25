# The Riemann Hypothesis in Lean 4

[![Verify Blueprint & Lean 4](https://github.com/Nondual-Observer/riemann-lean4-blueprint/actions/workflows/verify.yml/badge.svg)](https://github.com/Nondual-Observer/riemann-lean4-blueprint/actions/workflows/verify.yml)
[![Hexagon math.NT](https://img.shields.io/badge/Hexagon-2611.01031-2ea44f.svg)](https://hexagonmath.org/abs/2611.01031v1)
[![Blueprint DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24459320.svg)](https://doi.org/10.5281/zenodo.24459320)
[![Software DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24459582.svg)](https://doi.org/10.5281/zenodo.24459582)
[![Lean 4.33.1](https://img.shields.io/badge/Lean-4.33.1%20(0%20imports%2C%200%20sorry)-blue.svg)](lean/HypercubeAndLPTheorems.lean)
[![Julia 1.12+](https://img.shields.io/badge/Julia-1.12%2B%20stdlib%20(0%20deps)-9558B2.svg)](verification/verify_blueprint.jl)
[![Code License: Apache-2.0](https://img.shields.io/badge/Code-Apache--2.0-yellow.svg)](LICENSE)
[![Docs License: CC BY 4.0](https://img.shields.io/badge/Docs-CC%20BY%204.0-lightgrey.svg)](LICENSE-DOCS.md)

**[Read in Russian](README_RU.md)** · [Hexagon preprint (`2611.01031v1`)](https://hexagonmath.org/abs/2611.01031v1) · [Hexagon PDF (`25` pp.)](https://hexagonmath.org/pdf/2611.01031v1) · [One-page PDF (`ONE_PAGE_PROOF_EN.pdf`)](blueprint/ONE_PAGE_PROOF_EN.pdf) · [Outline (`ONE_PAGE_PROOF_EN.md`)](blueprint/ONE_PAGE_PROOF_EN.md) · [Article (`BLUEPRINT_EN.md`)](blueprint/BLUEPRINT_EN.md) · [Article PDF (`BLUEPRINT_EN.pdf`)](blueprint/BLUEPRINT_EN.pdf) · [Kernel index (`KERNEL_INDEX_EN.md`)](blueprint/KERNEL_INDEX_EN.md) · [`Lean 4` module (`44` theorems)](lean/HypercubeAndLPTheorems.lean) · [`Julia` verifier](verification/verify_blueprint.jl) · [Eight expositions](verification/COMPARISON_8_REPOS_EN.md) · [Audit history](verification/AUDIT_HISTORY_EN.md) · [Referee instructions](prompts/AI_REFEREE_PROMPT_EN.md)

---

## Overview and Scope Attribution

On 20 November 2026 Levent Alpöge released a formal proof, written with Claude, of the Riemann hypothesis and its analogue for all Dirichlet $L$-functions. The `Lean 4` archive contains `175,187` files and `17,374,215` lines. The author reports that a generated rendering exceeded `250,000` pages. [Author's note](https://alpo.ge/remark.pdf) · [Lean and Mathlib statement](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/)

Andrew Sutherland records checks on the compiled `.olean` modules with `leanchecker` and `lean4lean`. The `61.57 GB` export (`solution.ndjson`) was accepted by `nanoda` and `con-leche`. The `--compare` checks match the five statements of `Main.lean` to the challenge. Their axiom lists contain only `propext`, `Classical.choice` and `Quot.sound`. [Verification at MIT](https://math.mit.edu/~drew/grh/)

This edition follows the argument from a window bound on prime powers to the critical-line statements for zeros. Each part identifies the archive declarations used in that passage.

1. **Formal proof.** Levent Alpöge and Claude (2026) supplied the original `175,187`-file archive.
2. **Exposition, companion formalization, and verification suite.** Igor M. Zhuk, edition 9.0, prepared in collaboration with AI systems (Gemini and OpenAI Codex).
   - Read the five steps on [one page (`blueprint/ONE_PAGE_PROOF_EN.md`)](blueprint/ONE_PAGE_PROOF_EN.md) or in the [print version (`blueprint/ONE_PAGE_PROOF_EN.pdf`)](blueprint/ONE_PAGE_PROOF_EN.pdf). Parts I–V of the [article (`blueprint/BLUEPRINT_EN.md`)](blueprint/BLUEPRINT_EN.md) give the estimates, explicit scales, and order of quantifiers, with source notes pointing to the corresponding `Lean 4` declarations. [Article PDF, `11` pages (`blueprint/BLUEPRINT_EN.pdf`)](blueprint/BLUEPRINT_EN.pdf)
   - The [kernel index (`blueprint/KERNEL_INDEX_EN.md`)](blueprint/KERNEL_INDEX_EN.md) has `240` entries: `233` public declarations across `104` modules and `7` structure fields or Mathlib theorems. Each entry records `export_id` and its five-bit dependency mask in the `Expr.const` graph of `1,484,733` declarations, distinguishing homonyms by full namespace.
   - The [`Lean 4.33.1` companion module (`lean/HypercubeAndLPTheorems.lean`)](lean/HypercubeAndLPTheorems.lean) compiles with `0` imports and `0 sorry`. Its `44` public theorems formalize the $[0, 1]^4$ projector classification, the $2/3$ barrier and $(m - t)^2(m + 2t)$ cost gap, the four-wall exponent LP, height-2 vs. height-1 Lubin–Tate rates, the common-weight slope sum, the bijection `partner`, and seven concrete witness families over `Rat` and `Int`.
   - The zero-dependency standard-library `Julia` verifier ([`verification/verify_blueprint.jl`](verification/verify_blueprint.jl)) and reachability builder ([`verification/build_kernel_reachability_tsv.jl`](verification/build_kernel_reachability_tsv.jl)) run `31` adversarial preflight checks (`--self-gate`), verify finite mathematics, bilingual citations, and live `Lean 4.33.1` axioms (`--portable`), and scan all `175,187` source modules against the `1,484,733`-row kernel table when the archive is present (`--full`).

---

## Compression Scale and Reference Metrics

| Representation Layer | Scale | Verification Scope |
|---|---|---|
| Uncompressed kernel export `solution.ndjson` (MIT protocol) | `61.57 GB` (`1,065,214,335` expressions, `1,484,733` declarations) | `1,478,222` reachable declarations from `5` roots in `Main.lean`, `3` standard axioms |
| Five-root reachability table [`kernel_reachability_5roots.tsv.zst`](verification/kernel_reachability_5roots.tsv.zst) | `15.17 MiB` (`1,484,733` rows `mask · id · name`) | Bundled in repository (`SHA-256: 76b00059...`); reproducible via [`build_kernel_reachability_tsv.jl`](verification/build_kernel_reachability_tsv.jl) |
| Raw `Lean 4` source archive (`original.part01..14`) | `239.28 MB` (`175,187` files, `17,374,215` lines) | Scanned end-to-end in `--full` mode (`SHA-256: 9631b4f0...`) |
| Proof spine in [`KERNEL_INDEX_EN.md`](blueprint/KERNEL_INDEX_EN.md) | `104` modules (`233` public declarations + `7` fields/Mathlib = **`240`** entries) | Exact path, line, kind, `export_id`, 5-bit root mask, EN/RU citation and line-range parity |
| One-page proof [`ONE_PAGE_PROOF_EN.md`](blueprint/ONE_PAGE_PROOF_EN.md) | `1` printed page (`ONE_PAGE_PROOF_EN.pdf`) | All five stages, Lubin–Tate height-2 rate, 4-clause Bost–Arakelov squeeze, Four-Wall LP law |
| Mathematical blueprint [`BLUEPRINT_EN.md`](blueprint/BLUEPRINT_EN.md) | `11` printed pages (`BLUEPRINT_EN.pdf`) | Overview, Main Theorem, Parts I–VI, Appendices A.1–A.3, overload glossary B, two vector figures |
| Standalone module [`HypercubeAndLPTheorems.lean`](lean/HypercubeAndLPTheorems.lean) | `0` imports, `0` external libraries, `0 sorry` | `44/44` public theorems + `#print axioms` audit and `7` witness families over `Rat` / `Int` |

---

## Five-Stage Classical Proof Architecture (Parts I–V)

The analytic argument reduces the Riemann hypothesis to a one-sided upper bound $G_{\mathcal F}(x) \le x^{1/2 + O(\varepsilon)}$ on arbitrarily distant multiplicative windows $[Z, Z^{3/2}]$, with no sign restriction between windows:

![Architecture of the Formal Proof](assets/fig1_architecture_en.svg)

**Note on Figure 1.** In $(\mathrm{Div})$, the first term on the right is $S_{\rm div}$. The quantity $\mathrm{Data.Main}$ enters after the counting and height terms are combined in Part IV. The ladder has $m$ signatures and $m-1$ lifts.

![Breaking the 2/3 Barrier and Four-Wall LP Phase Diagram](assets/fig2_balance_lp_en.svg)

**Figure 2(a).** The red line gives the exponent $2a$ of $\sum_{j=1}^{m}j=m(m+1)/2\sim m^2/2$.

1. **Exclude zeros on a window (Part I).** Fix a finite admissible family $\mathcal F = \{(a_i, \chi_i)\}$ with $a_i > 0$ containing the target character $\psi$ (omitting imprimitive principal characters). The Mellin transform $\Phi(s)$ of $G_{\mathcal F}(y)$ is regular at $s = 1$; positive weights prevent residue cancellation and give a positive residue at any real zero $\rho \in (0, 1)$. Under $u = \log y$, the gamma density $\frac{\sigma^{k+1}}{k!} u^k e^{-\sigma u}\,du$ concentrates $D_k(z) = (-1)^k\Phi^{(k)}(z)/k!$ on $[U, (1+\delta)U]$ near $k/\sigma$. A bound $G_{\mathcal F}(y) \le C y^\theta$ across arbitrarily distant windows $[Z, Z^{3/2}]$ ($\delta = 1/2$) rules out poles in $\Re s > \theta$, using $\Re D_k(\sigma)$ in the real branch and comparing $|D_k(\sigma + iv)|$ with $\Re D_k(\sigma)$ at a nearest isolated pole in the shifted branch.
2. **Select the target characters (Part II).** On each window $[Z, Z^{3/2}]$, a single prime pair $(q, d)$ ($q \equiv 3 \bmod 8$, $d \equiv 7 \bmod 16$) serves every $x \in [Z, Z^{3/2}]$. Over a real floor of degree $n = c\,2^e \asymp x^{2+8\varepsilon}$ ($1 \le c \le \operatorname{ord}(\psi)$), the CM field $E$ has degree $[E:\mathbb Q] = 4n$ and group $G = E_0 \times H$ with $E_0 = (\mathbb Z/2\mathbb Z)^2$ and $|H| = n$. The bijection $\mathrm{partner}(t, g) = \mathrm{cconj} + g + \mathrm{topPl}(t)$ from $G \setminus \Phi$ onto $\Phi$ (with inverse $\mathrm{partner}(-t, \cdot)$, not an involution when $2t \ne 0$) gives the complex identity $\mathrm{ASK} - \mathrm{MAIN} = \mathrm{De}$, where $\mathrm{ASK}$ carries multiplicity-two ramps at odd powers of inert primes outside $\{2, q, d\}$ together with a separate $\log d$ sum at $d$. Averaging over $A_0 \le H$ isolates the annihilator $\Psi_A$, and bounding $\Psi_A \setminus K_p$ reduces $G_{\mathcal F}(x) \le x^{1/2 + (e_D + e_L + 7)\varepsilon}$ on $[Z, Z^{3/2}]$ to bounding $\mathrm{gap}_A(u_0) = \sum (\mathrm{ASK} - \Re\,\mathrm{MAIN})$.
3. **Obtain odd powers at height $2$ (Part III).** The unitary ladder traverses $m \asymp x^{1/2-\varepsilon/16}$ signatures $(k + j - 1, m - j)$ ($1 \le j \le m$, $k \asymp x^{9/2+10\varepsilon}$) via $m - 1$ lifts, ending at definite signature $(r, 0)$ with $r = k + m - 1$. At a good prime $\ell \ge 5$ inert in $\mathbb Q(\sqrt{-d})$, supersingular CM reduction has formal-group height $2$: the inverse of $\mathrm{ltLog}(X) = \sum_{j \ge 0} X^{\ell^{2j}}/\ell^j$ has $\ell$-adic denominator rate $\le 1/(\ell^2 - 1)$ against Legendre's factorial rate $1/(\ell - 1)$, giving net jet divisibility rate $\gamma_\ell = \frac{1}{\ell - 1} - \frac{1}{\ell^2 - 1} = \frac{\ell}{\ell^2 - 1} = \sum_{e\,\mathrm{odd}} \ell^{-e}$ (whereas ordinary split primes have height $1$ and net rate $0$). Truncation $\alpha - \min(\alpha, c) = \max(\alpha - c, 0)$ produces the ramps in $\mathrm{ASK}$.
4. **Compare slopes and optimize exponents (Part IV).** Averaging $(\mathrm{Gain})$ and $(\mathrm{Div})$ at fixed $u_0$ with the same positive rank weights cancels the mean height, while $(\mathrm{Slope})$ eliminates the quotient slope and $(\mathrm{Loss})$ retains the local loss $\mathrm{LoP}$; at $(r, 0)$ both $\pm\mathrm{Fo}(u_0)$ and $\pm\mu(P_{u_0})$ cancel. Lower-bounding $\log T(u_0, u)$ by word counting and evaluating $\log\Omega_{\mathrm{val}} = \gamma + \log(2\pi/\mathrm{rd}(E)) - \Re(L'/L)(1, \chi_{-d})$ via Chowla–Selberg periods convert $S_{\rm div}$ into $\mathrm{Data.Main}(u_0) = \sum_{t, j} \Re\,\mathrm{MAIN}$. Because the $m$ blocks $F.\mathrm{L}_{j,t}$ share a common budget $O(f m b x^\varepsilon)$ ($f = 2n$) rather than compounding prefix losses $\sum_{j=1}^m j \asymp m^2$, the sequential barrier $\min_m(x/m + m^2) = 3(x/2)^{2/3}$ drops to $x/m + m$, and the four-wall LP over $m = x^a, k = x^\kappa, n = x^\nu$ at $(p, q, \nu) = (5, 4, 2)$ has the unique optimum $(a, \kappa) = (1/2, 9/2)$, giving $G_{\mathcal F}(x) \le x^{1/2 + (e_D + e_L + 7)\varepsilon}$.
5. **Descend to the five theorems of `Main.lean` (Part V).** Letting $\theta \downarrow 1/2$ and $\varepsilon \downarrow 0$ for the fixed family $\mathcal F \ni \psi$ proves $L(s, \chi) \ne 0$ throughout $\Re s > 1/2$ (when $\chi \ne 1$ or $s \ne 1$). Passing to the primitive character across finite Euler factors in $0 < \Re s < 1$ and reflecting via $s \leftrightarrow 1 - s$ exclude $0 < \Re s < 1/2$, forcing $\Re s = 1/2$ across the open critical strip.

### Raw-Archive Pitfalls Resolved in the Index
- **Short-name and filename collisions:** `26` distinct live `adm2` declarations across namespaces, two distinct `ltLog` series (height 2 in `CMGoodModels/Statement.lean:35` vs. height 1 elsewhere), two `SizeData₂` structures, three `MAIN` / `Data.Main` declarations, `BNBounds` (arbitrary finite abelian $H$) vs. `BNBoundsU`, proposition `PairEx` vs. proof `QH.pairEx`, `86` files named `Statement.lean`, `15` named `StatementG.lean`, four named `RamificationTwoAndConjugationAtQAndD.lean`, two named `ChCore.lean`, and source-only `sg` absent from the compiled kernel export.
- **Local symbol overloading:** in `PowFourLeRpowNineHalves.lean:134`, `m := 2 * P.r + 2` denotes the local Bessel grid dimension inside `wBp_of`, not the signature count `R.m` of `Params.lean`.
- **Bit transposition across carriers:** the additive carrier `E0 × H` (`PartnersToFactorsAt.lean`) and multiplicative carrier `Frame.GG` (`DataHost.lean`) are linked by the group isomorphism `toE` (`RecH.lean:10`, `ToEBij.lean:37`), which swaps the first two bits (`(a₁, a₂) ↦ ((-1)^{a₂}, (-1)^{a₁})`).

---

## Secondary Research Arcs (Part VI and Appendix A.3)

The classical exposition is completely self-contained in **Parts I–V**. Two independent companion arcs are strictly separated and carry explicit epistemic tags:

1. **Structural Comparisons via Distinction Observable Theory (`DOT`, Part VI) and the $[0, 1]^4$ Hypercube Rigidity Theorem:**
   - Functional-equation reflection $s \leftrightarrow 1 - s$ is blind to symmetric off-line zero quartets $\frac{1}{2} \pm \sigma \pm i\gamma$ in the exact same structural sense in which Boolean complementation $q \mapsto 1 - q$ on $[0, 1]^4$ is blind to weight pairs $(1, 3)$; isolating the midline requires an independent **positivity cone**.
   - Section VI.1 proves analytically and formally in [`lean/HypercubeAndLPTheorems.lean`](lean/HypercubeAndLPTheorems.lean) the **continuous hypercube $[0, 1]^4$ projector theorem**: by the Walsh–Bloch trace identity
     $$\operatorname{tr}\bigl(E(q) - E(q)^2\bigr) = 4\bigl(t - t^2 - \|\mathbf e\|_2^2\bigr) = \sum_{i=1}^4 q_i(1 - q_i),$$
     the image of the entire continuous hypercube $[0, 1]^4$ contains **no additional orthogonal projectors**. There are strictly **`8`** in total ($0$, $I_4$, and strictly **`6`** projectors of real rank $2$, forming the vertices of the regular $\ell_1$-octahedron $O_6$ inscribed inside the Bloch sphere $\|\mathbf e\|_2 = 1/2$), whereas a continuous $S^2$ of projectors appears only across the full Clifford interval $0 \le E \le I_4$ outside $[0, 1]^4$.
   - Canonical open repository of Distinction Observable Theory (`DOT`): [`Nondual-Observer/DOTheory`](https://github.com/Nondual-Observer/DOTheory).
2. **Open Rank-$2$ Determinant Target over $\mathbb Q(\sqrt{-7})$ (Appendix A.3):**
   - The simultaneous critical-line statements for $\zeta(s)$ and $L(s, \chi_{-7})$ are equivalent to a window estimate for the integer $2 \times 2$ ideal-norm determinant $N I_{M_j}(j)$. The computation in `Julia` covers determinants of up to `7,079` bits. A direct proof of the rank-$2$ estimate without the rank-$\asymp x^{9/2}$ theta tower remains open.

---

## Quick Start and Reproducible Verification

Requirements: `Lean 4.33.1` (via `elan`, pinned by [`lean-toolchain`](lean-toolchain)) and standard `Julia 1.12+` (**zero external packages**). For `--full` mode, standard system utilities `cat`, `gzip`, and `zstd` are required together with a directory `RH_ARCHIVE_DIR` holding the 14 archive volumes named `original.part01` … `original.part14` (or a single `original.tar.gz` matching `SHA-256 = 9631b4f0...`; the five-root reachability table [`verification/kernel_reachability_5roots.tsv.zst`](verification/kernel_reachability_5roots.tsv.zst) is bundled in the repository and can be rebuilt from scratch from `solution.ndjson` via [`verification/build_kernel_reachability_tsv.jl`](verification/build_kernel_reachability_tsv.jl)).

```bash
# 1. Verify SHA-256 cryptographic checksums of all repository files:
shasum -a 256 -c SHA256SUMS.txt

# 2. Compile the standalone Lean 4.33.1 module directly (0 imports, 0 sorry, 44/44 #print axioms):
lean lean/HypercubeAndLPTheorems.lean

# 3. Run the 31-trap adversarial preflight self-gate (including live Lean 4.33.1):
OPENBLAS_NUM_THREADS=1 JULIA_NUM_THREADS=1 JULIA_LOAD_PATH=@stdlib \
  julia --startup-file=no -t1 verification/verify_blueprint.jl --self-gate

# 4. Run portable verification of finite mathematics, bilingual coverage, and Lean 4 axioms (no archive needed):
OPENBLAS_NUM_THREADS=1 JULIA_NUM_THREADS=1 JULIA_LOAD_PATH=@stdlib \
  julia --startup-file=no -t1 verification/verify_blueprint.jl --portable

# 5. Full scan of all 175,187 Lean 4 modules and 1,484,733 kernel declarations (with original.part01..14):
OPENBLAS_NUM_THREADS=1 JULIA_NUM_THREADS=1 JULIA_LOAD_PATH=@stdlib \
  RH_ARCHIVE_DIR=/path/to/archive julia --startup-file=no -t1 verification/verify_blueprint.jl --full
```

---

## Repository Structure

```text
├── .github/workflows/verify.yml                 # Automated CI (Lean 4.33.1 + Julia stdlib + SHA-256)
├── README.md                                    # Primary overview, proof architecture, and quick start (EN)
├── README_RU.md                                 # Russian overview (RU)
├── CITATION.cff                                 # Citation metadata (CFF 1.2.0)
├── LICENSE                                      # Apache License 2.0 (for Lean 4 and Julia code)
├── LICENSE-DOCS.md                              # CC BY 4.0 (for blueprint text and index tables)
├── lean-toolchain                               # Pins compiler leanprover/lean4:v4.33.1
├── assets/
│   ├── octahedron_borromean_emblem.png          # Square profile avatar asset (not embedded in papers)
│   ├── social_preview_1280x640.png              # 2:1 Open Graph / X / Discord link-preview card
│   ├── fig1_architecture_{en,ru}.{svg,pdf}      # Vector proof-architecture flowchart
│   └── fig2_balance_lp_{en,ru}.{svg,pdf}        # Vector 2/3-vs-1/2 & Four-Wall LP phase diagram
├── blueprint/
│   ├── ONE_PAGE_PROOF_EN.md                     # Standalone 1-page classical proof account (EN)
│   ├── ONE_PAGE_PROOF_EN.pdf                    # Strictly 1-page printable PDF (EN)
│   ├── ONE_PAGE_PROOF_RU.md                     # Standalone 1-page classical proof account (RU)
│   ├── ONE_PAGE_PROOF_RU.pdf                    # Strictly 1-page printable PDF (RU)
│   ├── BLUEPRINT_EN.md                          # Full mathematical blueprint (Parts I–VI, Appendices A–B, EN)
│   ├── BLUEPRINT_EN.pdf                         # Printable typeset PDF generated from BLUEPRINT_EN.md (11 pp.)
│   ├── BLUEPRINT_RU.md                          # Full mathematical blueprint (Parts I–VI, Appendices A–B, RU)
│   ├── BLUEPRINT_RU.pdf                         # Printable typeset PDF generated from BLUEPRINT_RU.md (12 pp.)
│   ├── KERNEL_INDEX_EN.md                       # 240-entry Lean 4 kernel index and collision ledger (EN)
│   └── KERNEL_INDEX_RU.md                       # 240-entry Lean 4 kernel index and collision ledger (RU)
├── lean/
│   └── HypercubeAndLPTheorems.lean              # Standalone Lean 4.33.1 module (0 imports, 0 sorry, 44 theorems)
├── scripts/
│   ├── build_figures.py                         # Deterministic SVG/PDF vector figure generator
│   ├── build_pdfs.py                            # PDF builder (Pandoc, Tectonic and pdfinfo or pypdf)
│   ├── blueprint_pdf.lua                        # Pandoc Lua filter for Lean 4 line breaks and theorem boxes
│   └── blueprint_header.tex                     # Academic XeLaTeX/Tectonic preamble (CMU Serif + DejaVu Mono)
├── verification/
│   ├── verify_blueprint.jl                      # Unified zero-dependency stdlib Julia verification suite
│   ├── build_kernel_reachability_tsv.jl         # Standalone builder of the 5-root TSV from solution.ndjson
│   ├── kernel_reachability_5roots.tsv.zst       # 1,484,733-row 5-root kernel reachability table (SHA-256: 76b00059...)
│   ├── COMPARISON_8_REPOS_EN.md                 # Comparative audit of 8 public exposition repositories (EN)
│   ├── COMPARISON_8_REPOS_RU.md                 # Comparative audit of 8 public exposition repositories (RU)
│   ├── AUDIT_HISTORY_EN.md                      # Full verification log and 44-theorem Lean 4 ledger (EN)
│   └── AUDIT_HISTORY_RU.md                      # Full verification log and 44-theorem Lean 4 ledger (RU)
├── prompts/
│   ├── AI_REFEREE_PROMPT_EN.md                  # Ready-to-copy adversarial AI referee prompt (EN)
│   └── AI_REFEREE_PROMPT_RU.md                  # Ready-to-copy adversarial AI referee prompt (RU)
└── SHA256SUMS.txt                               # Cryptographic manifest of all repository files
```

---

## Primary Sources and References

1. **L. Alpöge** (with Claude), Author's note accompanying the source archive, Nov 20, 2026: https://alpo.ge/remark.pdf (source archive `SHA-256`: `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc`).
2. **A. V. Sutherland** (MIT), *Verification files for the Lean proof of the Riemann Hypothesis*, Nov 2026: https://math.mit.edu/~drew/grh/ (uncompressed `solution.ndjson` `SHA-256`: `5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e`).
3. **Lean and Mathlib Community**, *Lean verification of the Riemann Hypothesis*, Nov 2026: https://leanprover-community.github.io/blog/posts/riemann-hypothesis/.
4. **E. Landau**, *Über einen Satz von Tschebyschef*, Math. Ann. **61** (1905), 527–550.
5. **S. Chowla, A. Selberg**, *On Epstein's zeta-function*, J. Reine Angew. Math. **227** (1967), 86–110.
6. **S. S. Kudla, J. J. Millson**, *Intersection numbers of cycles on locally symmetric spaces and Fourier coefficients of holomorphic modular forms in several complex variables*, Publ. Math. IHÉS **71** (1990), 121–172; **R. E. Borcherds**, *Automorphic forms with singularities on Grassmannians*, Invent. Math. **132** (1998), 491–562.
7. **L. Grenié, G. Molteni**, *Explicit versions of the prime ideal theorem for Dedekind zeta functions under GRH*, Math. Comp. **85** (2016), 889–906 (`arXiv:1312.4463`); **L. Faber, H. Kadiri**, *New bounds for $\psi(x)$*, Math. Comp. **84** (2015), 1339–1357 ([arXiv:1310.6374](https://arxiv.org/abs/1310.6374), with the 2018 corrigendum).
8. **P. Massot**, *leanblueprint*; **A. Kontorovich, T. Tao et al.**, *PrimeNumberTheoremAnd* (`Lean 4` blueprint project).
9. **Igor M. Zhuk**, *DOT: Distinction Observable Theory*: https://github.com/Nondual-Observer/DOTheory.

---

## Citation and Authorship

- **Author of the mathematical blueprint, kernel index, standalone `Lean 4` module, and verification suite:** Igor M. Zhuk · [ORCID `0009-0003-1670-8388`](https://orcid.org/0009-0003-1670-8388) · [GitHub `@Nondual-Observer`](https://github.com/Nondual-Observer).
- **AI Collaboration:** Whereas the `175,187`-module formal archive was created by Levent Alpöge with Claude (November 20, 2026), this mathematical exposition, the `240`-entry kernel index, the `44`-theorem `Lean 4.33.1` module, and the `Julia` verification suite were prepared in collaboration with AI systems (Gemini and OpenAI Codex), with all cited declarations, formal proofs, and finite calculations verified mechanically.
- **Hexagon Preprint (`math.NT`, `math.AG`, `cs.LO`, 25-page classical LaTeX blueprint):** [`hexagon:2611.01031v1`](https://hexagonmath.org/abs/2611.01031v1) ([PDF](https://hexagonmath.org/pdf/2611.01031v1)).
- **Zenodo Preprint (Blueprint Edition `9.0`, 4 PDFs):** Concept DOI [`10.5281/zenodo.24459320`](https://doi.org/10.5281/zenodo.24459320) (latest `v9.0.1`: [`10.5281/zenodo.24459946`](https://doi.org/10.5281/zenodo.24459946)).
- **Zenodo Software Release (`v1.0.0`):** [DOI `10.5281/zenodo.24459582`](https://doi.org/10.5281/zenodo.24459582).
- The software release is `1.0.0`. The blueprint edition is `9.0`. Citation metadata is provided in [`CITATION.cff`](CITATION.cff). Code is licensed under [`Apache-2.0`](LICENSE); documentation and blueprint tables are licensed under [`CC BY 4.0`](LICENSE-DOCS.md).
