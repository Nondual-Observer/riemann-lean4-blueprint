# Multi-Round Verification Record for the Blueprint, Kernel Index, and Standalone `Lean 4.33.1` Module

**Release Date:** November 23, 2026 · **Blueprint Edition:** `v9.0`  
**Author of Blueprint, Index, and Companion Code:** Igor M. Zhuk (`ORCID: 0009-0003-1670-8388`)

---

## 1. Primary Reference Artifacts and Verification Boundary

1. **Primary Formal Archive (L. Alpöge and Claude, November 20, 2026):**
   - `175,187` `Lean 4` source modules (`17,374,215` lines, `239.28 MB`, concatenated `original.part01..14` `SHA-256`: `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc`).
   - Compiled kernel export `solution.ndjson` (A. V. Sutherland's MIT protocol, https://math.mit.edu/~drew/grh/): `61,570,595,788` bytes (`SHA-256`: `5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e`), `1,484,733` declarations, of which **`1,478,222`** are reachable in the `Expr.const` graph from the five root theorems in `Main.lean` using only the three standard axioms `propext`, `Classical.choice`, `Quot.sound` (`1,478,198` declarations for classical `riemannHypothesis`).
2. **Scope of This Repository's Suite:**
   - [`verification/verify_blueprint.jl`](verify_blueprint.jl) does not replace external `Lean 4` kernel checkers (`leanchecker`, `lean4lean`, `nanoda`, `con-leche`) on the `61.57 GB` export.
   - In `--full` mode, it verifies `lean --version` (`4.33.1`), unpacks and scans all `175,187` archive modules using a component-wise `Lean 4.33.1` `namespace` / `section` / `end` analyzer, cross-checks all `240` entries of [`KERNEL_INDEX_EN.md`](../blueprint/KERNEL_INDEX_EN.md) and [`KERNEL_INDEX_RU.md`](../blueprint/KERNEL_INDEX_RU.md) against both the raw source lines and [`kernel_reachability_5roots.tsv.zst`](kernel_reachability_5roots.tsv.zst) (`1,484,733` rows, reproducible via [`build_kernel_reachability_tsv.jl`](build_kernel_reachability_tsv.jl)), verifies all file citations and individual line positions/ranges across both the full blueprints and standalone one-page proofs in both language editions, certifies all finite mathematical nodes on two independent bases, and compiles [`lean/HypercubeAndLPTheorems.lean`](../lean/HypercubeAndLPTheorems.lean).

---

## 2. Evolution Across 20 Cross-Audit Rounds (`v1.0 → v9.0`)

| Stage | Advance and Resolved Classes of Pitfalls |
|---|---|
| `v1.0 – v3.0` | Initial decompilation from `Main.lean` down to local Gauss jets and Chowla–Selberg periods; formulation of the 4-wall LP exponent law; construction of the rank-$2$ ideal-norm target over $\mathbb Q(\sqrt{-7})$ (Appendix A.3). |
| `v4.0` | Full `Expr.const` traversal of `solution.ndjson` (`1,484,733` declarations); replacement of `import`/substring checks by true kernel reachability; inclusion of the fourth Bessel wall $m^4 \le f$ in LP and exact finite factor $(1 - 1/x)$ for threshold $X'/3$. |
| `v5.0 – v6.0` | Atomic index schema `(full_name, unique_file, line, export_id, 5-bit_mask)`; disambiguation of twin `SizeData₂` structures, three distinct `MAIN`/`Main` definitions, and `BNBounds` vs `BNBoundsU`; replacement of ternary grids and leading minors by all `30` principal minors; addition of the overload glossary (Appendix B). |
| `v7.0` | Identification of local `m := 2r + 2` inside `wBp_of` (`PowFourLeRpowNineHalves.lean:134`) and the bit-swapping isomorphism `toE` (`RecH.lean:10`, `ToEBij.lean:37`) between additive `E0 × H` and multiplicative `Frame.GG`. |
| `v8.0` | Proof of the **continuous hypercube $[0, 1]^4$ projector theorem** in `DOT` ($\operatorname{tr}(E - E^2) = \sum q_i(1-q_i) \implies$ exactly `8` projectors and `6` of rank `2` across $[0, 1]^4$); two-table `198 + 6 = 204` kernel index; verification of all comma-separated secondary line ranges; non-zero `sum_Th` witness (`7/4` and `7/8`), Romberg quadrature in A.2 (`~1.12·10⁻²⁷`), and component-wise `Lean 4.33.1` scope stack. |
| `v8.1` | Explicit separation of subtracted center $C_{\chi_0}(y) = C_1(y) - y b_N$ and centered remainder $R_{\chi_0}(y) - C_{\chi_0}(y) = R_{\chi_0}(y) - C_1(y) + y b_N$; strict field-name-to-structure binding in Table 2; full `2,003` integer + `6,002` fractional window grid in A.3; all `6/6` live `Lean 4.33.1` syntax fixtures; conversion of all `34` display math blocks to `$$ ... $$` for native GitHub rendering; inclusion of `kernel_reachability_5roots.tsv.zst` and `build_kernel_reachability_tsv.jl`; expansion of [`lean/HypercubeAndLPTheorems.lean`](../lean/HypercubeAndLPTheorems.lean) to `34/34` public theorems (`0` imports, `0 sorry`). |
| `v9.0` | Classical journal prose overhaul (`0` mid-sentence code soup, discrete `*[Lean: ...]*` traces, Anti-AI-Slop scientific editorial pass across Rules 1–6, median sentence length tightened from `41` to `16` words); standalone 1-page proofs (`ONE_PAGE_PROOF_{EN,RU}.{md,pdf}`); vector SVG/PDF architecture and LP/barrier figures; explicit derivations of block-local `DefFam.L` charging vs. the $2/3$ barrier with exact gap identity $(m - t)^2(m + 2t)$, height-2 Lubin–Tate odd-prime-power rate $\ell/(\ell^2-1)$ with degree-`81` Lagrange inversion check and `ltLog` / `adm2` collision notes, 4-clause Bost–Arakelov slope squeeze over an abstract positive normalized mean `SlopeMean` with exact `Count5` / `EComp5` / `Data.DIV` separation and strict `(Loss)` witness $(4, 3, 1)$, exact `GlobalTheory.GLq.Green` cuspidal-character parametrization, non-global-maximum Landau dichotomy wording, and correction of `partner(t, g)` from "involution" to bijection with inverse `partner(-t, ·)` (`partner_not_involution_Z4`); expansion to **`233 + 7 = 240` kernel entries** (`104` modules), **`44/44` `Lean 4.33.1` theorems**, **`31/31` hostile traps**, full TeX transcript log check in `scripts/build_pdfs.py`, and 8-repository comparative audit ([`COMPARISON_8_REPOS_EN.md`](COMPARISON_8_REPOS_EN.md)). |

---

## 3. Ledger of All 44 Public Theorems in `lean/HypercubeAndLPTheorems.lean`

[`lean/HypercubeAndLPTheorems.lean`](../lean/HypercubeAndLPTheorems.lean) compiles directly under `Lean 4.33.1` with zero `Lake` config, zero `Mathlib` imports, and zero `import` lines. It formalizes the algebraic, matrix-operator, polyhedral, and lattice cores of the blueprint's finite statements (group-ring subgroup convolution and Abel summation in A.1 are derived analytically in the blueprint prose, while Gaussian-elimination matrix ranks and the positive half of the `81`-vector witness are additionally checked in `Julia`):

| # | Theorem (`HypercubeAndLP.*`) | Exact Formal Statement | Kernel Axioms |
|---:|---|---|---|
| 1 | `J4_sq` | $J_4^2 = -I_4$ over an arbitrary field $K$ | `propext, Classical.choice, Quot.sound` |
| 2 | `clifford_relations` | Commutation of $\Sigma_i$ with $J_4$ and $\Sigma_i\Sigma_j + \Sigma_j\Sigma_i = 2\delta_{ij} I_4$ | `propext, Classical.choice, Quot.sound` |
| 3 | `trace_bloch_sub_sq` | Bloch trace $\operatorname{tr}(B - B^2) = 4(t - t^2 - e_1^2 - e_2^2 - e_3^2)$ | `propext, Classical.choice, Quot.sound` |
| 4 | `invWalsh_left_inv` | Left inverse property of the Walsh–Bloch map | `propext, Classical.choice, Quot.sound` |
| 5 | `invWalsh_right_inv` | Right inverse property of the Walsh–Bloch map | `propext, Classical.choice, Quot.sound` |
| 6 | `directMat_eq_effectOp` | Entrywise equality of direct $(u, v, h, j)$ matrix and $E(q) = t I_4 + \sum e_i \Sigma_i$ | `propext, Classical.choice, Quot.sound` |
| 7 | `trace_E_sub_E_sq` | Identity $\operatorname{tr}(E(q) - E(q)^2) = 4(t - t^2 - \|\mathbf e\|_2^2) = \sum_{i=1}^4 q_i(1-q_i)$ | `propext, Classical.choice, Quot.sound` |
| 8 | `hypercube_projector_is_boolean` | **Hypercube rigidity:** $q \in [0, 1]^4 \land E(q)^2 = E(q) \implies q \in \{0, 1\}^4$ | `propext, Classical.choice, Quot.sound` |
| 9 | `midslice_octahedron_touches_sphere_at_six_vertices` | On $t = 1/2$: intersection of $\ell_1$-octahedron with $\|\mathbf e\|_2 = 1/2$ is the `6` axial vertices | `propext, Classical.choice, Quot.sound` |
| 10 | `outside_projector_counterexample` | External projector $P = \frac{1}{2}I_4 + \frac{3}{10}\Sigma_1 + \frac{2}{5}\Sigma_2$: $P^2=P$, preimage $(-1/5, 3/5, 2/5, 6/5) \notin [0,1]^4$ | `propext, Classical.choice, Quot.sound` |
| 11 | `weakened_positivity_counterexamples` | Negative witnesses $-3/64$ and $-1/64$ for ternary grid and leading minors | `propext, Classical.choice, Quot.sound` |
| 12 | `hypercube_boolean_projector_counts` | Enumeration on $\{0,1\}^4$: `16` vertices and distribution `(1, 0, 6, 0, 1)` for `boolIsProjector` | **none (`0`)** |
| 13 | `four_wall_lower_bounds` | Four Lagrange dual lower bounds of the 4-wall LP law over ordered field $K$ | `propext, Classical.choice, Quot.sound` |
| 14 | `four_wall_achievable` | Achievability of $\theta^*(p, q, \nu)$ at $a = 1 - \theta$ | `propext, Classical.choice, Quot.sound` |
| 15 | `four_wall_unique_at_5_4_2` | Uniqueness of $(a, \kappa) = (1/2, 9/2)$ and four wall values at $(p, q, \nu) = (5, 4, 2)$ | `propext, Classical.choice, Quot.sound` |
| 16 | `four_wall_half_threshold` | Equivalence of the three $\nu$ thresholds with $\theta \le 1/2$ | `propext, Classical.choice, Quot.sound` |
| 17 | `bitSwap_left_inv` | Left inverse property of the bit-swapping map | **none (`0`)** |
| 18 | `bitSwap_right_inv` | Right inverse property of the bit-swapping map | **none (`0`)** |
| 19 | `bitSwap_hom` | Homomorphism property of `E0 × H ≃ Frame.GG` for any operation on $H$ | **none (`0`)** |
| 20 | `bitSwap_inPhi_iff_Psi` | Compatibility `InPhi(g) ↔ Psi(bitSwap(g))` | `propext` |
| 21 | `bitSwap_places` | Images of all four distinguished tags `topPl`, `thickPl`, `cconj`, `sgc0` | **none (`0`)** |
| 22 | `unnormalized_sum_idempotent_iff` | Arithmetic core $k^2 = k \iff k = 1$ for $k > 0$ | `propext, Classical.choice, Quot.sound` |
| 23 | `scaled_projector_square` | Matrix identity $(c P)^2 = c(c P)$ for any $4\times 4$ projector $P^2 = P$ over $K$ | `propext, Classical.choice, Quot.sound` |
| 24 | `scaled_projector_idem_iff` | Matrix criterion $(c P)^2 = c P \iff c = 1$ when $P^2 = P$, $P_{ij} \ne 0$, and $c \ne 0$ | `propext, Classical.choice, Quot.sound` |
| 25 | `bit_matrix_iff` | Equivalence of `boolIsProjector` and matrix idempotence $E^2 = E$ on all `16` vertices over `Rat` | `propext, Classical.choice, Quot.sound` |
| 26 | `octahedron_dual_iso_Q3` | Face-adjacency isomorphism between $O_6$ and $Q_3$ + `2` shortest paths | `propext` |
| 27 | `faceToQ3_bijective` | Surjectivity and injectivity of `faceToQ3` on `Fin 8` | `propext, Quot.sound` |
| 28 | `powerSum_eq` | Equality between direct sum $\sum_{i=0}^{h-1}(2^i - 1)$ and `dyadicRampDiff h` | `propext` |
| 29 | `dyadicRampDiff_closed` | Closed inductive identity `dyadicRampDiff h + h + 1 = 2^h` for all $h \in \mathbb N$ | `propext, Quot.sound` |
| 30 | `principal_centering_sign_identity` | Algebraic sign separation $C_{\chi_0} = C_1 - y b_N$ | `propext, Classical.choice, Quot.sound` |
| 31 | `a1_ceiling_optimality` | Pointwise integer bound $S \le \lceil W \rceil$ from $S < W + 1$ and $W \le \lceil W \rceil$ | `propext, Classical.choice, Quot.sound` |
| 32 | `a3_omega_closure_iff` | Divisibility equivalence for $\omega$-closure over $\mathbb Z[(1+\sqrt{-7})/2]$ | `propext, Classical.choice, Quot.sound` |
| 33 | `a3_lattice_9_0_3_counterexample` | Necessity of factor $d$: $9 \mid 18$ while $(9\cdot 3) \nmid 18$ | `propext, Classical.choice, Quot.sound` |
| 34 | `compounding_barrier_two_thirds` | Prefix-compounding $2/3$ barrier: $\max(1-a, 2a) \ge 2/3$, with equality iff $a = 1/3$ | `propext, Classical.choice, Quot.sound` |
| 35 | `lubin_tate_height2_rate` | Height-1 zero rate vs. height-2 Lubin–Tate rate $1/(l-1) - 1/(l^2-1) = l/(l^2-1) > 0$ for $l > 1$ | `propext, Classical.choice, Quot.sound` |
| 36 | `lubin_tate_odd_power_sum` | Inductive geometric identity $(l/(l^2-1))(1 - l^{-2N}) = \sum_{j=0}^{N-1} l^{-(2j+1)}$ | `propext, Classical.choice, Quot.sound` |
| 37 | `lubin_tate_jet_valuation_bound` | Legendre vs. height-2 jet bound $(r-s)/(l-1) - r/(l^2-1) \ge (l/(l^2-1))r - d_1$ | `propext, Classical.choice, Quot.sound` |
| 38 | `ramp_gain_split` | Archimedean ramp conversion $\alpha - \min(\alpha, c) = \max(\alpha - c, 0)$ | `propext, Classical.choice, Quot.sound` |
| 39 | `arakelov_slope_chain_telescope` | Four-clause `(Loss)+(Gain)+(Slope)+(Div)` Bost–Arakelov slope telescope averaged by a common positive normalized mean `SlopeMean I K` | `propext, Classical.choice, Quot.sound` |
| 40 | `exact_envelope_gap_identities` | Exact cost gaps $t^2 + m^2 - 2tm = (m-t)^2 \ge 0$ and $2t^3 + m^3 - 3t^2 m = (m-t)^2(m+2t) \ge 0$ | `propext, Classical.choice, Quot.sound` |
| 41 | `partner_shift_bijection` | Bijection `partnerMap f : G \ Φ → Φ` with inverse `partnerMap fInv` and square shift `f ∘ f` | `propext` |
| 42 | `partner_not_involution_Z4` | Universal refutation on `E0 × Fin 4` (`t = 1`): `partner(1, partner(1, g)) ≠ g` for all `16` elements | `propext` |
| 43 | `loss_bounds_strict_witness` | Strict `(Loss)` witness `(4, 3, 1)`: `4 - 3 ≤ 1` while `¬(4 ≤ 3)` | `propext, Classical.choice, Quot.sound` |
| 44 | `non_vacuity_rat_witnesses` | Seven families of concrete rational and integer satisfiability witnesses over `Rat` and `Int` | `propext, Classical.choice, Quot.sound` |

## Release review of edition 9.0

The archived definition of `ZeroBox` places the zero-free region to the right of 399/400, up to the specified height. The one-page outline now retains the factor $f=2n$ in the block budget. Appendix A.2 bounds the inner integral together with its Mellin weight. The release verifier compares the ordered source references of both editions and requires the exact Lean compiler version.
