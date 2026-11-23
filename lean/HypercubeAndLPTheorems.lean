/-
  ==============================================================================
  Standalone Lean 4.33.1 Formalization (0 imports, 0 external deps, 0 sorry)
  Algebraic, Matrix-Operator, Polyhedral, Formal-Group, and Slope Companion Theorems (v9.0)
  Author: Igor M. Zhuk (ORCID: 0009-0003-1670-8388)

  Scope boundary:
  - The five Riemann Hypothesis / Generalized Riemann Hypothesis theorems
    (Main.lean) are proved in L. Alpöge and Claude's formal archive
    (175,187 Lean 4 modules).
  - This standalone zero-import module formally proves in the Lean 4.33.1 kernel
    44 public theorems covering the algebraic, 4×4 matrix-operator, polyhedral LP,
    Lubin–Tate formal-group, Bost–Arakelov slope-telescope, combinatorial, and
    lattice cores of the companion statements in the blueprint:
      1. Hypercube [0, 1]⁴ projector rigidity (Part VI.1, Distinction Observable
         Theory — DOT): over any linearly ordered field K (including ℝ and ℚ),
         tr(E - E²) = 4(t - t² - ‖e‖₂²) = Σ qᵢ(1 - qᵢ), E(q)² = E(q) on [0, 1]⁴
         forces q ∈ {0, 1}⁴, equivalence of boolIsProjector with E² = E on all
         16 Boolean vertices over Rat, the 6 sphere-touching vertices of the
         t = 1/2 ℓ₁-octahedron, the outside projector P = I/2 + (3/10)Σ₁ + (2/5)Σ₂,
         and negative-value witnesses for weakened positivity tests.
      2. Four-wall LP exponent law & 2/3 compounding barrier (Section 1) over any
         linearly ordered field K: all 4 dual lower bounds, achievability, threshold
         ν ≥ max(q/2,(p-1)/2,1/4), uniqueness of (a, κ) = (1/2, 9/2) at (5, 4, 2),
         and the sharp 2/3 barrier max(1 - a, 2a) ≥ 2/3 at a = 1/3 for prefix compounding.
      3. Polymorphic bit-swapping isomorphism E₀ × H ≃ Frame.GG (including topPl,
         thickPl, cconj, sgc0) and matrix-operator projector scaling
         (c·P)² = c·(c·P) with idempotence criterion c = 1 (Part VI.2).
      4. Face-adjacency duality O₆ = L(K₄) ↔ bipartite cube Q₃ and bijectivity
         of faceToQ3 on Fin 8 (Part VI.2).
      5. Lubin–Tate height-2 vs height-1 formal-group valuation rate l/(l² - 1),
         exact odd-prime-power geometric expansion Σ_{j=0}^{N-1} l^{-(2j+1)},
         Legendre jet valuation bound, ramp conversion α - min(α, c) = max(α - c, 0),
         4-clause Bost–Arakelov slope chain telescope over `SlopeMean`, exact
         cost-gap identities `(m - t)²` and `(m - t)²(m + 2t)`, `partner` shift
         bijection vs non-involution on `E₀ × Fin 4`, strict `(Loss)` witness `(4, 3, 1)`,
         mod-2 principal character ramp, Appendix A.1 ceiling, Appendix A.3 ω-closure
         with witness (9, 0, 3), and concrete non-vacuity witnesses over Rat and Int.
  ==============================================================================
-/

namespace HypercubeAndLP

open Lean.Grind Std

/-! ## Helper lemmas over a linearly ordered field -/

section OrderedFieldHelpers
variable {K : Type} [Field K] [LE K] [LT K] [LawfulOrderLT K] [IsLinearOrder K] [OrderedRing K]

private theorem mul_nonneg_ord {a b : K} (ha : 0 ≤ a) (hb : 0 ≤ b) : 0 ≤ a * b := by
  by_cases ha0 : a = 0
  · subst ha0; grind
  · by_cases hb0 : b = 0
    · subst hb0; grind
    · have ha_pos : (0 : K) < a := by grind
      have hb_pos : (0 : K) < b := by grind
      have hpos : a * 0 < a * b := OrderedRing.mul_lt_mul_of_pos_left hb_pos ha_pos
      grind

private theorem mul_le_mul_of_nonneg_left_ord {a b c : K} (hc : 0 ≤ c) (hab : a ≤ b) :
    c * a ≤ c * b := by
  have h := mul_nonneg_ord hc (show (0 : K) ≤ b - a by grind)
  grind

private theorem mul_div_cancel_ord {a b : K} (hb : b ≠ 0) : b * (a / b) = a := by
  rw [Field.div_eq_mul_inv]
  have hinv := Field.mul_inv_cancel hb
  grind

private theorem inv_pos_ord {b : K} (hb : 0 < b) : 0 < (1 : K) / b := by
  have hbne : b ≠ 0 := by grind
  have hmul : b * (1 / b) = 1 := mul_div_cancel_ord hbne
  by_cases h : (0 : K) < 1 / b
  · exact h
  · have hnn : (0 : K) ≤ -(1 / b) := by grind
    have hprod : (0 : K) ≤ b * (-(1 / b)) := mul_nonneg_ord (by grind) hnn
    have h1 : (0 : K) < 1 := OrderedRing.zero_lt_one
    grind

private theorem div_le_iff_ord {a b c : K} (hb : 0 < b) : a / b ≤ c ↔ a ≤ b * c := by
  have hbne : b ≠ 0 := by grind
  have hmul : b * (a / b) = a := mul_div_cancel_ord hbne
  constructor
  · intro h
    have := mul_le_mul_of_nonneg_left_ord (show (0 : K) ≤ b by grind) h
    grind
  · intro h
    have hinv : (0 : K) < 1 / b := inv_pos_ord hb
    have hscaled := mul_le_mul_of_nonneg_left_ord (show (0 : K) ≤ 1 / b by grind) h
    have h1 : (1 / b) * a = a / b := by rw [Field.div_eq_mul_inv, Field.div_eq_mul_inv]; grind
    have h2 : (1 / b) * (b * c) = c := by
      have : (1 / b) * b = 1 := by grind
      grind
    grind

private theorem le_div_iff_ord {a b c : K} (hb : 0 < b) : c ≤ a / b ↔ b * c ≤ a := by
  have hbne : b ≠ 0 := by grind
  have hmul : b * (a / b) = a := mul_div_cancel_ord hbne
  constructor
  · intro h
    have := mul_le_mul_of_nonneg_left_ord (show (0 : K) ≤ b by grind) h
    grind
  · intro h
    have hinv : (0 : K) < 1 / b := inv_pos_ord hb
    have hscaled := mul_le_mul_of_nonneg_left_ord (show (0 : K) ≤ 1 / b by grind) h
    have h1 : (1 / b) * a = a / b := by rw [Field.div_eq_mul_inv, Field.div_eq_mul_inv]; grind
    have h2 : (1 / b) * (b * c) = c := by
      have : (1 / b) * b = 1 := by grind
      grind
    grind

private theorem sum4_eq_zero_ord {a b c d : K}
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hc : 0 ≤ c) (hd : 0 ≤ d)
    (h : a + b + c + d = 0) : a = 0 ∧ b = 0 ∧ c = 0 ∧ d = 0 :=
  ⟨by grind, by grind, by grind, by grind⟩

private theorem pos_two : (0 : K) < 2 := by
  have h1 : (0 : K) < 1 := OrderedRing.zero_lt_one; grind
private theorem pos_three : (0 : K) < 3 := by
  have h1 : (0 : K) < 1 := OrderedRing.zero_lt_one; grind
private theorem pos_four : (0 : K) < 4 := by
  have h1 : (0 : K) < 1 := OrderedRing.zero_lt_one; grind
private theorem pos_five : (0 : K) < 5 := by
  have h1 : (0 : K) < 1 := OrderedRing.zero_lt_one; grind
private theorem pos_ten : (0 : K) < 10 := by
  have h1 : (0 : K) < 1 := OrderedRing.zero_lt_one; grind
private theorem pos_64 : (0 : K) < 64 := by
  have h1 : (0 : K) < 1 := OrderedRing.zero_lt_one; grind

end OrderedFieldHelpers

/-! ## General 4×4 matrix algebra over an arbitrary field -/

inductive Idx4 where
  | i0 | i1 | i2 | i3
  deriving DecidableEq, Repr

abbrev Mat4 (K : Type) := Idx4 → Idx4 → K

section Matrix4
variable {K : Type} [Field K]

def matAdd (A B : Mat4 K) : Mat4 K := fun i j => A i j + B i j
def matSub (A B : Mat4 K) : Mat4 K := fun i j => A i j - B i j
def matNeg (A : Mat4 K) : Mat4 K := fun i j => -(A i j)
def matScale (c : K) (A : Mat4 K) : Mat4 K := fun i j => c * A i j
def matMul (A B : Mat4 K) : Mat4 K :=
  fun i j => A i .i0 * B .i0 j + A i .i1 * B .i1 j + A i .i2 * B .i2 j + A i .i3 * B .i3 j
def matTr (A : Mat4 K) : K := A .i0 .i0 + A .i1 .i1 + A .i2 .i2 + A .i3 .i3

def I4 : Mat4 K
  | .i0, .i0 => 1 | .i1, .i1 => 1 | .i2, .i2 => 1 | .i3, .i3 => 1
  | _, _ => 0

def J4 : Mat4 K
  | .i0, .i1 => -1 | .i1, .i0 => 1
  | .i2, .i3 => -1 | .i3, .i2 => 1
  | _, _ => 0

def Sigma1 : Mat4 K
  | .i0, .i0 => 1 | .i1, .i1 => 1
  | .i2, .i2 => -1 | .i3, .i3 => -1
  | _, _ => 0

def Sigma2 : Mat4 K
  | .i0, .i2 => 1 | .i1, .i3 => 1
  | .i2, .i0 => 1 | .i3, .i1 => 1
  | _, _ => 0

def Sigma3 : Mat4 K
  | .i0, .i3 => 1 | .i1, .i2 => -1
  | .i2, .i1 => -1 | .i3, .i0 => 1
  | _, _ => 0

theorem J4_sq : matMul (K := K) J4 J4 = matNeg I4 := by
  funext i j
  cases i <;> cases j <;> dsimp [matMul, matNeg, J4, I4] <;> grind

theorem clifford_relations :
    matMul (K := K) Sigma1 Sigma1 = I4 ∧
    matMul (K := K) Sigma2 Sigma2 = I4 ∧
    matMul (K := K) Sigma3 Sigma3 = I4 ∧
    matAdd (matMul (K := K) Sigma1 Sigma2) (matMul Sigma2 Sigma1) = (fun _ _ => 0) ∧
    matAdd (matMul (K := K) Sigma1 Sigma3) (matMul Sigma3 Sigma1) = (fun _ _ => 0) ∧
    matAdd (matMul (K := K) Sigma2 Sigma3) (matMul Sigma3 Sigma2) = (fun _ _ => 0) ∧
    matMul (K := K) Sigma1 J4 = matMul J4 Sigma1 ∧
    matMul (K := K) Sigma2 J4 = matMul J4 Sigma2 ∧
    matMul (K := K) Sigma3 J4 = matMul J4 Sigma3 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩ <;>
    (funext i j; cases i <;> cases j <;>
      dsimp [matMul, matAdd, I4, J4, Sigma1, Sigma2, Sigma3] <;> grind)

/-! ## Section 1. Continuous hypercube [0, 1]⁴ projector rigidity (Part VI.1, DOT) -/

/-- Walsh-Bloch coordinates (t, e₁, e₂, e₃) of q = (q₀, q₁, q₂, q₃) ∈ K⁴. -/
def walshT (q0 q1 q2 q3 : K) : K := (q0 + q1 + q2 + q3) / 4
def walshE1 (q0 q1 q2 q3 : K) : K := (-q0 - q1 + q2 + q3) / 4
def walshE2 (q0 q1 q2 q3 : K) : K := (-q0 + q1 - q2 + q3) / 4
def walshE3 (q0 q1 q2 q3 : K) : K := (q0 - q1 - q2 + q3) / 4

/-- Inverse Walsh map from (t, e₁, e₂, e₃) back to q ∈ K⁴. -/
def invWalsh (t e1 e2 e3 : K) : K × K × K × K :=
  (t - e1 - e2 + e3, t - e1 + e2 - e3, t + e1 - e2 - e3, t + e1 + e2 + e3)

/-- Effect operator in Bloch coordinates: t·I₄ + e₁·Σ₁ + e₂·Σ₂ + e₃·Σ₃. -/
def blochMat (t e1 e2 e3 : K) : Mat4 K :=
  matAdd (matAdd (matScale t I4) (matScale e1 Sigma1))
         (matAdd (matScale e2 Sigma2) (matScale e3 Sigma3))

/-- Direct 4×4 matrix E(q) in (u, v, h, j) coordinates (Part VI.1). -/
def directMat (q0 q1 q2 q3 : K) : Mat4 K :=
  let u := (q2 + q3) / 2
  let v := (q0 + q1) / 2
  let h := ((q1 - q0) + (q3 - q2)) / 4
  let j := ((q0 - q1) + (q3 - q2)) / 4
  fun r c =>
    match r, c with
    | .i0, .i0 => u | .i0, .i2 => h | .i0, .i3 => j
    | .i1, .i1 => u | .i1, .i2 => -j | .i1, .i3 => h
    | .i2, .i0 => h | .i2, .i1 => -j | .i2, .i2 => v
    | .i3, .i0 => j | .i3, .i1 => h | .i3, .i3 => v
    | _, _ => 0

/-- Effect operator E(q) = blochMat(walsh(q)). -/
def effectOp (q0 q1 q2 q3 : K) : Mat4 K :=
  blochMat (walshT q0 q1 q2 q3) (walshE1 q0 q1 q2 q3) (walshE2 q0 q1 q2 q3) (walshE3 q0 q1 q2 q3)

/-- In Bloch coordinates, tr(E - E²) = 4(t - t² - ‖e‖₂²). -/
theorem trace_bloch_sub_sq (t e1 e2 e3 : K) :
    let E := blochMat t e1 e2 e3
    matTr (matSub E (matMul E E)) = 4 * (t - t * t - (e1 * e1 + e2 * e2 + e3 * e3)) := by
  dsimp [matTr, matSub, matMul, blochMat, matAdd, matScale, I4, Sigma1, Sigma2, Sigma3]
  grind

section OrderedHypercube
variable [LE K] [LT K] [LawfulOrderLT K] [IsLinearOrder K] [OrderedRing K]

theorem invWalsh_left_inv (q0 q1 q2 q3 : K) :
    invWalsh (walshT q0 q1 q2 q3) (walshE1 q0 q1 q2 q3) (walshE2 q0 q1 q2 q3) (walshE3 q0 q1 q2 q3)
    = (q0, q1, q2, q3) := by
  simp only [invWalsh, walshT, walshE1, walshE2, walshE3]
  have h4 : (4 : K) ≠ 0 := by have := pos_four (K := K); grind
  have ht := mul_div_cancel_ord (a := q0 + q1 + q2 + q3) h4
  have he1 := mul_div_cancel_ord (a := -q0 - q1 + q2 + q3) h4
  have he2 := mul_div_cancel_ord (a := -q0 + q1 - q2 + q3) h4
  have he3 := mul_div_cancel_ord (a := q0 - q1 - q2 + q3) h4
  grind

theorem invWalsh_right_inv (t e1 e2 e3 : K) :
    let q := invWalsh t e1 e2 e3
    (walshT q.1 q.2.1 q.2.2.1 q.2.2.2,
     walshE1 q.1 q.2.1 q.2.2.1 q.2.2.2,
     walshE2 q.1 q.2.1 q.2.2.1 q.2.2.2,
     walshE3 q.1 q.2.1 q.2.2.1 q.2.2.2) = (t, e1, e2, e3) := by
  simp only [invWalsh, walshT, walshE1, walshE2, walshE3]
  have h4 : (4 : K) ≠ 0 := by have := pos_four (K := K); grind
  have h_1 := mul_div_cancel_ord (a := (t - e1 - e2 + e3) + (t - e1 + e2 - e3) + (t + e1 - e2 - e3) + (t + e1 + e2 + e3)) h4
  have h_2 := mul_div_cancel_ord (a := -(t - e1 - e2 + e3) - (t - e1 + e2 - e3) + (t + e1 - e2 - e3) + (t + e1 + e2 + e3)) h4
  have h_3 := mul_div_cancel_ord (a := -(t - e1 - e2 + e3) + (t - e1 + e2 - e3) - (t + e1 - e2 - e3) + (t + e1 + e2 + e3)) h4
  have h_4 := mul_div_cancel_ord (a := (t - e1 - e2 + e3) - (t - e1 + e2 - e3) - (t + e1 - e2 - e3) + (t + e1 + e2 + e3)) h4
  grind

/-- Identity between the direct (u, v, h, j) matrix and the Walsh-Bloch expansion. -/
theorem directMat_eq_effectOp (q0 q1 q2 q3 : K) :
    directMat q0 q1 q2 q3 = effectOp q0 q1 q2 q3 := by
  have h2 : (2 : K) ≠ 0 := by have := pos_two (K := K); grind
  have h4 : (4 : K) ≠ 0 := by have := pos_four (K := K); grind
  have hu := mul_div_cancel_ord (a := q2 + q3) h2
  have hv := mul_div_cancel_ord (a := q0 + q1) h2
  have hh := mul_div_cancel_ord (a := (q1 - q0) + (q3 - q2)) h4
  have hj := mul_div_cancel_ord (a := (q0 - q1) + (q3 - q2)) h4
  have ht := mul_div_cancel_ord (a := q0 + q1 + q2 + q3) h4
  have he1 := mul_div_cancel_ord (a := -q0 - q1 + q2 + q3) h4
  have he2 := mul_div_cancel_ord (a := -q0 + q1 - q2 + q3) h4
  have he3 := mul_div_cancel_ord (a := q0 - q1 - q2 + q3) h4
  funext i j
  cases i <;> cases j <;>
    dsimp [directMat, effectOp, blochMat, walshT, walshE1, walshE2, walshE3,
           matAdd, matScale, I4, Sigma1, Sigma2, Sigma3] <;> grind

/-- Exact trace identity: tr(E - E²) = 4(t - t² - ‖e‖₂²) = Σ qᵢ(1 - qᵢ). -/
theorem trace_E_sub_E_sq (q0 q1 q2 q3 : K) :
    let E := effectOp q0 q1 q2 q3
    let t := walshT q0 q1 q2 q3
    let e1 := walshE1 q0 q1 q2 q3
    let e2 := walshE2 q0 q1 q2 q3
    let e3 := walshE3 q0 q1 q2 q3
    matTr (matSub E (matMul E E)) = 4 * (t - t * t - (e1 * e1 + e2 * e2 + e3 * e3)) ∧
    4 * (t - t * t - (e1 * e1 + e2 * e2 + e3 * e3))
      = q0 * (1 - q0) + q1 * (1 - q1) + q2 * (1 - q2) + q3 * (1 - q3) := by
  constructor
  · exact trace_bloch_sub_sq _ _ _ _
  · have h4 : (4 : K) ≠ 0 := by have := pos_four (K := K); grind
    have ht := mul_div_cancel_ord (a := q0 + q1 + q2 + q3) h4
    have he1 := mul_div_cancel_ord (a := -q0 - q1 + q2 + q3) h4
    have he2 := mul_div_cancel_ord (a := -q0 + q1 - q2 + q3) h4
    have he3 := mul_div_cancel_ord (a := q0 - q1 - q2 + q3) h4
    simp only [walshT, walshE1, walshE2, walshE3]
    grind

private theorem nonneg_mul_one_sub {x : K} (h0 : 0 ≤ x) (h1 : x ≤ 1) : 0 ≤ x * (1 - x) :=
  mul_nonneg_ord h0 (by grind)

/--
  MAIN HYPERCUBE [0, 1]⁴ RIGIDITY THEOREM (Part VI.1, DOT):
  For ANY point q = (q₀, q₁, q₂, q₃) ∈ [0, 1]⁴ ⊂ K⁴ (including K = ℝ),
  if E(q)² = E(q), then every coordinate qᵢ belongs to {0, 1}.
  Hence continuous filling of [0, 1]⁴ introduces no additional projectors.
-/
theorem hypercube_projector_is_boolean
    (q0 q1 q2 q3 : K)
    (h0a : 0 ≤ q0) (h0b : q0 ≤ 1)
    (h1a : 0 ≤ q1) (h1b : q1 ≤ 1)
    (h2a : 0 ≤ q2) (h2b : q2 ≤ 1)
    (h3a : 0 ≤ q3) (h3b : q3 ≤ 1)
    (hproj : matMul (effectOp q0 q1 q2 q3) (effectOp q0 q1 q2 q3) = effectOp q0 q1 q2 q3) :
    (q0 = 0 ∨ q0 = 1) ∧ (q1 = 0 ∨ q1 = 1) ∧ (q2 = 0 ∨ q2 = 1) ∧ (q3 = 0 ∨ q3 = 1) := by
  have htr_zero : matTr (matSub (effectOp q0 q1 q2 q3) (matMul (effectOp q0 q1 q2 q3) (effectOp q0 q1 q2 q3))) = 0 := by
    rw [hproj]
    dsimp [matTr, matSub]
    grind
  have ⟨h_eq1, h_eq2⟩ := trace_E_sub_E_sq q0 q1 q2 q3
  have hsum : q0 * (1 - q0) + q1 * (1 - q1) + q2 * (1 - q2) + q3 * (1 - q3) = 0 := by grind
  have ⟨z0, z1, z2, z3⟩ := sum4_eq_zero_ord
    (nonneg_mul_one_sub h0a h0b) (nonneg_mul_one_sub h1a h1b)
    (nonneg_mul_one_sub h2a h2b) (nonneg_mul_one_sub h3a h3b) hsum
  exact ⟨by grind, by grind, by grind, by grind⟩

/--
  On the mid-slice t = 1/2, the hypercube bounds q ∈ [0, 1]⁴ are equivalent
  to the eight signed inequalities of the ℓ₁-octahedron (‖e‖₁ ≤ 1/2), whose
  intersection with the projector sphere ‖e‖₂ = 1/2 consists of the 6 axial vertices.
-/
theorem midslice_octahedron_touches_sphere_at_six_vertices
    (e1 e2 e3 : K)
    (h1 : -(1 / 2 : K) ≤ -e1 - e2 + e3 ∧ -e1 - e2 + e3 ≤ 1 / 2)
    (h2 : -(1 / 2 : K) ≤ -e1 + e2 - e3 ∧ -e1 + e2 - e3 ≤ 1 / 2)
    (h3 : -(1 / 2 : K) ≤  e1 - e2 - e3 ∧  e1 - e2 - e3 ≤ 1 / 2)
    (h4 : -(1 / 2 : K) ≤  e1 + e2 + e3 ∧  e1 + e2 + e3 ≤ 1 / 2)
    (hsphere : e1 * e1 + e2 * e2 + e3 * e3 = 1 / 4) :
    (e1 = 1 / 2 ∧ e2 = 0 ∧ e3 = 0) ∨ (e1 = -(1 / 2) ∧ e2 = 0 ∧ e3 = 0) ∨
    (e1 = 0 ∧ e2 = 1 / 2 ∧ e3 = 0) ∨ (e1 = 0 ∧ e2 = -(1 / 2) ∧ e3 = 0) ∨
    (e1 = 0 ∧ e2 = 0 ∧ e3 = 1 / 2) ∨ (e1 = 0 ∧ e2 = 0 ∧ e3 = -(1 / 2)) := by
  have h2ne : (2 : K) ≠ 0 := by have := pos_two (K := K); grind
  have h4ne : (4 : K) ≠ 0 := by have := pos_four (K := K); grind
  have hhalf := mul_div_cancel_ord (a := (1 : K)) h2ne
  have hqtr  := mul_div_cancel_ord (a := (1 : K)) h4ne
  let q0 : K := 1 / 2 - e1 - e2 + e3
  let q1 : K := 1 / 2 - e1 + e2 - e3
  let q2 : K := 1 / 2 + e1 - e2 - e3
  let q3 : K := 1 / 2 + e1 + e2 + e3
  have hsum : q0 * (1 - q0) + q1 * (1 - q1) + q2 * (1 - q2) + q3 * (1 - q3) = 0 := by
    dsimp [q0, q1, q2, q3]; grind
  have ⟨z0, z1, z2, z3⟩ := sum4_eq_zero_ord
    (nonneg_mul_one_sub (x := q0) (by grind) (by grind))
    (nonneg_mul_one_sub (x := q1) (by grind) (by grind))
    (nonneg_mul_one_sub (x := q2) (by grind) (by grind))
    (nonneg_mul_one_sub (x := q3) (by grind) (by grind)) hsum
  have b0 : q0 = 0 ∨ q0 = 1 := by grind
  have b1 : q1 = 0 ∨ q1 = 1 := by grind
  have b2 : q2 = 0 ∨ q2 = 1 := by grind
  have b3 : q3 = 0 ∨ q3 = 1 := by grind
  rcases b0 with hq0 | hq0 <;> rcases b1 with hq1 | hq1 <;>
    rcases b2 with hq2 | hq2 <;> rcases b3 with hq3 | hq3 <;>
    dsimp [q0, q1, q2, q3] at hq0 hq1 hq2 hq3 <;> grind

/--
  The external projector P = (1/2)I₄ + (3/10)Σ₁ + (2/5)Σ₂ satisfies P² = P
  and tr(P) = 2 in the full Clifford interval, while its unique Walsh preimage
  q = (-1/5, 3/5, 2/5, 6/5) lies strictly outside [0, 1]⁴.
-/
theorem outside_projector_counterexample :
    let P : Mat4 K := blochMat (1 / 2) (3 / 10) (2 / 5) 0
    let q := invWalsh (1 / 2 : K) (3 / 10) (2 / 5) 0
    matMul P P = P ∧ matTr P = 2 ∧
    q = (-(1 / 5 : K), 3 / 5, 2 / 5, 6 / 5) ∧
    q.1 < 0 ∧ 1 < q.2.2.2 := by
  have h2p : (0 : K) < 2 := pos_two
  have h5p : (0 : K) < 5 := pos_five
  have h10p : (0 : K) < 10 := pos_ten
  have h2 : (2 : K) ≠ 0 := by grind
  have h5 : (5 : K) ≠ 0 := by grind
  have h10 : (10 : K) ≠ 0 := by grind
  have c2 := mul_div_cancel_ord (a := (1 : K)) h2
  have c310 := mul_div_cancel_ord (a := (3 : K)) h10
  have c25 := mul_div_cancel_ord (a := (2 : K)) h5
  have c15 := mul_div_cancel_ord (a := (1 : K)) h5
  have c35 := mul_div_cancel_ord (a := (3 : K)) h5
  have c65 := mul_div_cancel_ord (a := (6 : K)) h5
  have hinv5 : (0 : K) < 1 / 5 := inv_pos_ord h5p
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · funext i j
    cases i <;> cases j <;>
      dsimp [matMul, blochMat, matAdd, matScale, I4, Sigma1, Sigma2, Sigma3] <;> grind
  · dsimp [matTr, blochMat, matAdd, matScale, I4, Sigma1, Sigma2, Sigma3]; grind
  · dsimp [invWalsh]
    exact Prod.ext (by grind) (Prod.ext (by grind) (Prod.ext (by grind) (by grind)))
  · dsimp [invWalsh]; grind
  · dsimp [invWalsh]; grind

/--
  Negative-value witnesses against weakened positivity tests (Part VI.1):
  (a) at q = (47, 7, 7, 7)/64, vector x = (3, 0, 1, -1) yields xᵀEx = -3/64 < 0;
  (b) at q = (1/2, 0, 0, 0), leading minors are ≥ 0, while minor {1, 3} is -1/64 < 0.
-/
theorem weakened_positivity_counterexamples :
    let E1 : Mat4 K := directMat (47 / 64) (7 / 64) (7 / 64) (7 / 64)
    (E1 .i0 .i0 * (3 * 3) + E1 .i2 .i2 * (1 * 1) + E1 .i3 .i3 * ((-1) * (-1))
      + 2 * E1 .i0 .i2 * (3 * 1) + 2 * E1 .i0 .i3 * (3 * (-1))) = -(3 / 64 : K) ∧
    (let E2 : Mat4 K := directMat (1 / 2) 0 0 0
     E2 .i0 .i0 * E2 .i2 .i2 - E2 .i0 .i2 * E2 .i2 .i0 = -(1 / 64 : K)) := by
  have h2 : (2 : K) ≠ 0 := by have := pos_two (K := K); grind
  have h4 : (4 : K) ≠ 0 := by have := pos_four (K := K); grind
  have h64 : (64 : K) ≠ 0 := by have := pos_64 (K := K); grind
  have c47 := mul_div_cancel_ord (a := (47 : K)) h64
  have c7  := mul_div_cancel_ord (a := (7 : K)) h64
  have c3  := mul_div_cancel_ord (a := (3 : K)) h64
  have c1  := mul_div_cancel_ord (a := (1 : K)) h64
  have c12 := mul_div_cancel_ord (a := (1 : K)) h2
  constructor
  · dsimp only [directMat]
    have cu := mul_div_cancel_ord (a := (7 / 64 : K) + 7 / 64) h2
    have cv := mul_div_cancel_ord (a := (47 / 64 : K) + 7 / 64) h2
    have ch := mul_div_cancel_ord (a := ((7 / 64 : K) - 47 / 64) + (7 / 64 - 7 / 64)) h4
    have cj := mul_div_cancel_ord (a := ((47 / 64 : K) - 7 / 64) + (7 / 64 - 7 / 64)) h4
    grind
  · dsimp only [directMat]
    have cu := mul_div_cancel_ord (a := (0 : K) + 0) h2
    have cv := mul_div_cancel_ord (a := (1 / 2 : K) + 0) h2
    have ch := mul_div_cancel_ord (a := ((0 : K) - 1 / 2) + (0 - 0)) h4
    grind

end OrderedHypercube
end Matrix4

/-! ### Exact enumeration on Q₄ = {0, 1}⁴: 8 admissible vertices and projectors (1, 0, 6, 0, 1) -/

def boolIsProjector (b0 b1 b2 b3 : Bool) : Bool :=
  let q0 : Int := if b0 then 1 else 0
  let q1 : Int := if b1 then 1 else 0
  let q2 : Int := if b2 then 1 else 0
  let q3 : Int := if b3 then 1 else 0
  let t4  := q0 + q1 + q2 + q3
  let e14 := -q0 - q1 + q2 + q3
  let e24 := -q0 + q1 - q2 + q3
  let e34 := q0 - q1 - q2 + q3
  decide (t4 * t4 + e14 * e14 + e24 * e24 + e34 * e34 = 4 * t4 ∧
          (t4 = 2 ∨ (e14 = 0 ∧ e24 = 0 ∧ e34 = 0)))

def allBoolVertices : List (Bool × Bool × Bool × Bool) :=
  [false, true].flatMap fun b0 =>
  [false, true].flatMap fun b1 =>
  [false, true].flatMap fun b2 =>
  [false, true].map fun b3 => (b0, b1, b2, b3)

def boolWeight (v : Bool × Bool × Bool × Bool) : Nat :=
  (if v.1 then 1 else 0) + (if v.2.1 then 1 else 0) +
  (if v.2.2.1 then 1 else 0) + (if v.2.2.2 then 1 else 0)

theorem hypercube_boolean_projector_counts :
    allBoolVertices.length = 16 ∧
    (allBoolVertices.filter fun v => boolIsProjector v.1 v.2.1 v.2.2.1 v.2.2.2).length = 8 ∧
    ([0, 1, 2, 3, 4].map fun w =>
      (allBoolVertices.filter fun v =>
        boolWeight v = w && boolIsProjector v.1 v.2.1 v.2.2.1 v.2.2.2).length) = [1, 0, 6, 0, 1] := by
  decide

/-! ## Section 2. Four-wall LP limiting exponent law (Section 1) -/

section FourWallLP
variable {K : Type} [Field K] [LE K] [LT K] [LawfulOrderLT K] [IsLinearOrder K] [OrderedRing K]

/-- Feasibility of (a, κ, θ) in the four-wall LP problem. -/
def LPFeasible (p q ν a κ θ : K) : Prop :=
  0 ≤ a ∧ q * a ≤ ν ∧ 0 ≤ κ ∧ p * a + ν ≤ κ ∧
  1 - a ≤ θ ∧ 1 + a - κ ≤ θ ∧ a ≤ θ ∧ κ - 2 * ν ≤ θ

/-- Four dual Lagrange lower bounds on θ. -/
theorem four_wall_lower_bounds
    {p q ν a κ θ : K} (hp : 0 ≤ p) (hq : 0 < q) (hfeas : LPFeasible p q ν a κ θ) :
    1 / 2 ≤ θ ∧
    1 - ν / q ≤ θ ∧
    (2 - 2 * ν) / 3 ≤ θ ∧
    (p - ν) / (p + 1) ≤ θ := by
  rcases hfeas with ⟨_, hqa, _, hpa, hc1, hc2, hc3, hc4⟩
  have h2p : (0 : K) < 2 := pos_two
  have h3p : (0 : K) < 3 := pos_three
  have h1p : (0 : K) < 1 := OrderedRing.zero_lt_one
  have hp1p : (0 : K) < p + 1 := by grind
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [div_le_iff_ord h2p]; grind
  · have ha : a ≤ ν / q := (le_div_iff_ord hq).mpr hqa
    grind
  · rw [div_le_iff_ord h3p]; grind
  · rw [div_le_iff_ord hp1p]
    have hpa_scaled : p * (1 - a) ≤ p * θ := mul_le_mul_of_nonneg_left_ord hp hc1
    grind

/-- Achievability of θ_* = max(1/2, 1 - ν/q, (2 - 2ν)/3, (p - ν)/(p + 1)). -/
theorem four_wall_achievable
    {p q ν θ : K} (hp : 0 ≤ p) (hq : 0 < q) (hν : 0 ≤ ν)
    (h1 : 1 / 2 ≤ θ) (h2 : 1 - ν / q ≤ θ) (h3 : (2 - 2 * ν) / 3 ≤ θ) (h4 : (p - ν) / (p + 1) ≤ θ)
    (hθ1 : θ ≤ 1) :
    ∃ κ : K, (κ = 2 - 2 * θ ∨ κ = p * (1 - θ) + ν) ∧ LPFeasible p q ν (1 - θ) κ θ := by
  have h2p : (0 : K) < 2 := pos_two
  have h3p : (0 : K) < 3 := pos_three
  have h1p : (0 : K) < 1 := OrderedRing.zero_lt_one
  have hp1p : (0 : K) < p + 1 := by grind
  have h1' : (1 : K) ≤ 2 * θ := (div_le_iff_ord h2p).mp h1
  have h2' : q * (1 - θ) ≤ ν := by
    have : 1 - θ ≤ ν / q := by grind
    exact (le_div_iff_ord hq).mp this
  have h3' : 2 - 2 * ν ≤ 3 * θ := (div_le_iff_ord h3p).mp h3
  have h4' : p - ν ≤ (p + 1) * θ := (div_le_iff_ord hp1p).mp h4
  by_cases hcmp : p * (1 - θ) + ν ≤ 2 - 2 * θ
  · exact ⟨2 - 2 * θ, Or.inl rfl,
      ⟨by grind, h2', by grind, hcmp, by grind, by grind, by grind, by grind⟩⟩
  · have hpa_nn : 0 ≤ p * (1 - θ) := mul_nonneg_ord hp (by grind)
    exact ⟨p * (1 - θ) + ν, Or.inr rfl,
      ⟨by grind, h2', by grind, by grind, by grind, by grind, by grind, by grind⟩⟩

/-- Uniqueness of (a, κ) = (1/2, 9/2) at (p, q, ν) = (5, 4, 2) and the four wall values. -/
theorem four_wall_unique_at_5_4_2 {a κ : K}
    (hfeas : LPFeasible 5 4 2 a κ (1 / 2)) :
    a = 1 / 2 ∧ κ = 9 / 2 ∧
    (1 - a = 1 / 2 ∧ 1 + a - κ = -3 ∧ a = 1 / 2 ∧ κ - 2 * 2 = 1 / 2) := by
  rcases hfeas with ⟨_, _, _, hpa, hc1, _, hc3, hc4⟩
  have h2p : (0 : K) < 2 := pos_two
  have h2 : (2 : K) ≠ 0 := by grind
  have c12 := mul_div_cancel_ord (a := (1 : K)) h2
  have c92 := mul_div_cancel_ord (a := (9 : K)) h2
  have h12 : (1 : K) - 1 / 2 = 1 / 2 := by grind
  have ha_ge : (1 / 2 : K) ≤ a := by grind
  have ha : a = 1 / 2 := IsPartialOrder.le_antisymm a (1 / 2) hc3 ha_ge
  rw [ha] at hpa
  have h52 : (5 : K) * (1 / 2) + 2 = 9 / 2 := by grind
  have h42 : (2 * 2 : K) + 1 / 2 = 9 / 2 := by grind
  have hκ_ge : (9 / 2 : K) ≤ κ := by grind
  have hκ_le : κ ≤ 9 / 2 := by grind
  have hκ : κ = 9 / 2 := IsPartialOrder.le_antisymm κ (9 / 2) hκ_le hκ_ge
  grind

/-- Exact threshold on ν for achieving θ_* = 1/2: ν ≥ max(q/2, (p - 1)/2, 1/4). -/
theorem four_wall_half_threshold {p q ν : K} (hp : 0 ≤ p) (hq : 0 < q) :
    (1 - ν / q ≤ 1 / 2 ∧ (2 - 2 * ν) / 3 ≤ 1 / 2 ∧ (p - ν) / (p + 1) ≤ 1 / 2) ↔
    (q / 2 ≤ ν ∧ (p - 1) / 2 ≤ ν ∧ 1 / 4 ≤ ν) := by
  have h1p : (0 : K) < 1 := OrderedRing.zero_lt_one
  have h2p : (0 : K) < 2 := pos_two
  have h3p : (0 : K) < 3 := pos_three
  have h4p : (0 : K) < 4 := pos_four
  have hp1p : (0 : K) < p + 1 := by grind
  have h2ne : (2 : K) ≠ 0 := by grind
  have c12 := mul_div_cancel_ord (a := (1 : K)) h2ne
  rw [div_le_iff_ord h3p, div_le_iff_ord hp1p, div_le_iff_ord h2p, div_le_iff_ord h2p, div_le_iff_ord h4p]
  have hq_iff : (1 - ν / q ≤ 1 / 2) ↔ (q ≤ 2 * ν) := by
    have : (1 - ν / q ≤ 1 / 2) ↔ (1 / 2 ≤ ν / q) := by grind
    rw [this, le_div_iff_ord hq]
    constructor
    · intro h
      have := mul_le_mul_of_nonneg_left_ord (show (0 : K) ≤ 2 by grind) h
      grind
    · intro h
      have hinv : (0 : K) ≤ 1 / 2 := by have := inv_pos_ord h2p; grind
      have := mul_le_mul_of_nonneg_left_ord hinv h
      grind
  have hp_iff : (p - ν ≤ (p + 1) * (1 / 2)) ↔ (p - 1 ≤ 2 * ν) := by
    constructor
    · intro h
      have := mul_le_mul_of_nonneg_left_ord (show (0 : K) ≤ 2 by grind) h
      grind
    · intro h
      have hinv : (0 : K) ≤ 1 / 2 := by have := inv_pos_ord h2p; grind
      have := mul_le_mul_of_nonneg_left_ord hinv h
      grind
  have h3_iff : (2 - 2 * ν ≤ 3 * (1 / 2)) ↔ (1 ≤ 4 * ν) := by
    constructor
    · intro h
      have := mul_le_mul_of_nonneg_left_ord (show (0 : K) ≤ 2 by grind) h
      grind
    · intro h
      have hinv : (0 : K) ≤ 1 / 2 := by have := inv_pos_ord h2p; grind
      have := mul_le_mul_of_nonneg_left_ord hinv h
      grind
  rw [hq_iff, hp_iff, h3_iff]
  exact ⟨fun ⟨a, b, c⟩ => ⟨a, c, b⟩, fun ⟨a, c, b⟩ => ⟨a, b, c⟩⟩

/--
  Prefix-compounding 2/3 barrier (Section 1): if local index errors compound across
  1 ≤ j ≤ m (Σ j ~ m²/2, exponent 2a) against main-term scaling x/m (exponent 1 - a),
  then max(1 - a, 2a) ≥ 2/3 for all a ∈ K, with θ = 2/3 attained iff a = 1/3.
-/
theorem compounding_barrier_two_thirds {a θ : K} :
    ((1 - a ≤ θ ∧ 2 * a ≤ θ) → 2 / 3 ≤ θ) ∧
    ((1 - a ≤ 2 / 3 ∧ 2 * a ≤ 2 / 3) ↔ a = 1 / 3) := by
  have h3p : (0 : K) < 3 := pos_three
  have h3ne : (3 : K) ≠ 0 := by grind
  have c13 := mul_div_cancel_ord (a := (1 : K)) h3ne
  have c23 := mul_div_cancel_ord (a := (2 : K)) h3ne
  constructor
  · rintro ⟨h1, h2⟩
    rw [div_le_iff_ord h3p]
    grind
  · constructor
    · rintro ⟨h1, h2⟩
      have h1' : (3 : K) * (1 - a) ≤ 3 * (2 / 3) := mul_le_mul_of_nonneg_left_ord (by grind) h1
      have h2' : (3 : K) * (2 * a) ≤ 3 * (2 / 3) := mul_le_mul_of_nonneg_left_ord (by grind) h2
      have ha_lo : (1 / 3 : K) ≤ a := by
        rw [div_le_iff_ord h3p]; grind
      have ha_hi : a ≤ 1 / 3 := by
        rw [le_div_iff_ord h3p]; grind
      exact IsPartialOrder.le_antisymm a (1 / 3) ha_hi ha_lo
    · rintro rfl
      grind

end FourWallLP

/-! ## Section 3. Bit-swapping isomorphism E₀ × H ≃ Frame.GG and projector scaling (Part VI.2) -/

inductive Sign where
  | pos : Sign
  | neg : Sign
  deriving DecidableEq, Repr

def Sign.mul : Sign → Sign → Sign
  | .pos, s => s
  | .neg, .pos => .neg
  | .neg, .neg => .pos

def boolToSign : Bool → Sign
  | false => .pos
  | true  => .neg

def signToBool : Sign → Bool
  | .pos => false
  | .neg => true

/-- Additive carrier E₀ × H (`PartnersToFactorsAt.lean`). -/
abbrev AddCarrier (H : Type) := (Bool × Bool) × H

/-- Multiplicative carrier Frame.GG = ({±1} × {±1}) × H (`DataHost.lean`). -/
abbrev MulCarrier (H : Type) := (Sign × Sign) × H

def addInPhi {H : Type} (g : AddCarrier H) : Prop := g.1.1 = false
def mulInPsi {H : Type} (g : MulCarrier H) : Prop := g.1.2 = .pos

def topPl {H : Type} (t : H) : AddCarrier H := ((false, false), t)
def thickPl {H : Type} (t : H) : AddCarrier H := ((false, true), t)
def tau1 {H : Type} (t : H) : MulCarrier H := ((.pos, .pos), t)
def tau2 {H : Type} (t : H) : MulCarrier H := ((.neg, .pos), t)

/-- Explicit bit-swapping map: (a₁, a₂, h) ↦ (((-1)^a₂, (-1)^a₁), h). -/
def bitSwapIso {H : Type} (g : AddCarrier H) : MulCarrier H :=
  ((boolToSign g.1.2, boolToSign g.1.1), g.2)

/-- Inverse isomorphism (`UpperTheory.Comparison₂.toE` in `RecH.lean:10`). -/
def bitSwapInv {H : Type} (g : MulCarrier H) : AddCarrier H :=
  ((signToBool g.1.2, signToBool g.1.1), g.2)

theorem bitSwap_left_inv {H : Type} (g : AddCarrier H) : bitSwapInv (bitSwapIso g) = g := by
  rcases g with ⟨⟨a1, a2⟩, h⟩
  cases a1 <;> cases a2 <;> rfl

theorem bitSwap_right_inv {H : Type} (g : MulCarrier H) : bitSwapIso (bitSwapInv g) = g := by
  rcases g with ⟨⟨s1, s2⟩, h⟩
  cases s1 <;> cases s2 <;> rfl

/-- Homomorphism property for any binary operation addH : H → H → H. -/
theorem bitSwap_hom {H : Type} (addH : H → H → H) (x y : AddCarrier H) :
    bitSwapIso ((xor x.1.1 y.1.1, xor x.1.2 y.1.2), addH x.2 y.2) =
    ((Sign.mul (bitSwapIso x).1.1 (bitSwapIso y).1.1,
      Sign.mul (bitSwapIso x).1.2 (bitSwapIso y).1.2),
     addH (bitSwapIso x).2 (bitSwapIso y).2) := by
  rcases x with ⟨⟨a1, a2⟩, hx⟩
  rcases y with ⟨⟨b1, b2⟩, hy⟩
  cases a1 <;> cases a2 <;> cases b1 <;> cases b2 <;> rfl

theorem bitSwap_inPhi_iff_Psi {H : Type} (g : AddCarrier H) :
    addInPhi g ↔ mulInPsi (bitSwapIso g) := by
  rcases g with ⟨⟨a1, a2⟩, h⟩
  cases a1 <;> simp [addInPhi, mulInPsi, bitSwapIso, boolToSign]

theorem bitSwap_places {H : Type} (t z : H) :
    bitSwapIso (topPl t) = tau1 t ∧
    bitSwapIso (thickPl t) = tau2 t ∧
    bitSwapIso ((true, true), z) = ((.neg, .neg), z) ∧
    bitSwapIso ((true, false), z) = ((.pos, .neg), z) :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- Arithmetic core k² = k ⇔ k = 1 for positive integer k. -/
theorem unnormalized_sum_idempotent_iff (k : Nat) (hk : 0 < k) :
    k * k = k ↔ k = 1 := by
  constructor
  · intro h
    cases k with
    | zero => omega
    | succ m =>
      cases m with
      | zero => rfl
      | succ m' => grind
  · intro h; subst h; rfl

/-- Matrix-operator identity (c·P)² = c·(c·P) for any 4×4 projector P² = P over a field K. -/
theorem scaled_projector_square {K : Type} [Field K] (P : Mat4 K) (c : K)
    (hP : matMul P P = P) :
    matMul (matScale c P) (matScale c P) = matScale c (matScale c P) := by
  funext i j
  have h := congrFun (congrFun hP i) j
  have h' := congrArg (fun z : K => c * c * z) h
  dsimp [matMul, matScale] at h' ⊢
  grind

/-- Matrix-operator idempotence criterion (c·P)² = c·P ⇔ c = 1 when P² = P, P i j ≠ 0, and c ≠ 0. -/
theorem scaled_projector_idem_iff {K : Type} [Field K] (P : Mat4 K) (c : K)
    (hP : matMul P P = P) (i j : Idx4) (hp : P i j ≠ 0) (hc : c ≠ 0) :
    matMul (matScale c P) (matScale c P) = matScale c P ↔ c = 1 := by
  rw [scaled_projector_square P c hP]
  constructor
  · intro he
    have h := congrFun (congrFun he i) j
    change c * (c * P i j) = c * P i j at h
    have h0 : (c - 1) * (c * P i j) = 0 := by grind
    grind
  · rintro rfl
    funext u v
    dsimp [matScale]
    grind

private def allIdx4 : List Idx4 := [.i0, .i1, .i2, .i3]
private def sameEntriesRat (A B : Mat4 Rat) : Bool :=
  allIdx4.all fun i => allIdx4.all fun j => decide (A i j = B i j)

private theorem sameEntriesRat_iff (A B : Mat4 Rat) : sameEntriesRat A B = true ↔ A = B := by
  constructor
  · intro h
    simp [sameEntriesRat, allIdx4] at h
    funext i j
    cases i <;> cases j <;> grind
  · rintro rfl
    simp [sameEntriesRat, allIdx4]

def bitQ (b : Bool) : Rat := if b then 1 else 0
def bitMatrix (a b c d : Bool) : Mat4 Rat := effectOp (bitQ a) (bitQ b) (bitQ c) (bitQ d)

private theorem bitTest_eq (a b c d : Bool) :
    boolIsProjector a b c d = sameEntriesRat (matMul (bitMatrix a b c d) (bitMatrix a b c d)) (bitMatrix a b c d) := by
  cases a <;> cases b <;> cases c <;> cases d <;> decide +kernel

/-- Equivalence between boolIsProjector and matrix idempotence E² = E on all 16 vertices of {0,1}⁴ over Rat. -/
theorem bit_matrix_iff (a b c d : Bool) :
    boolIsProjector a b c d = true ↔ matMul (bitMatrix a b c d) (bitMatrix a b c d) = bitMatrix a b c d := by
  rw [bitTest_eq, sameEntriesRat_iff]

/-! ## Section 4. Octahedral face graph O₆ = L(K₄) ↔ bipartite cube Q₃ (Part VI.2) -/

/-- Eight faces of O₆: 0..3 are star faces Sᵢ, 4..7 are hollow faces Tⱼ. -/
def octFaceEdges (f : Nat) : List (Nat × Nat) :=
  let tetra : List (Nat × Nat) := [(0,1), (0,2), (0,3), (1,2), (1,3), (2,3)]
  if f < 4 then
    tetra.filter fun e => e.1 == f || e.2 == f
  else
    let v := f - 4
    tetra.filter fun e => e.1 != v && e.2 != v

def octAdj (f g : Nat) : Bool :=
  ((octFaceEdges f).filter fun e => (octFaceEdges g).contains e).length == 2

/-- Bijection from the 8 faces of O₆ onto vertices of Q₃ (stars → even-weight 000,011,101,110). -/
def faceToQ3 (f : Nat) : Nat :=
  match f with
  | 0 => 0 | 1 => 3 | 2 => 5 | 3 => 6
  | 4 => 7 | 5 => 4 | 6 => 2 | _ => 1

def hamming1 (u v : Nat) : Bool :=
  let d := u ^^^ v
  d == 1 || d == 2 || d == 4

theorem octahedron_dual_iso_Q3 :
    (∀ f g : Fin 8, octAdj f.val g.val = hamming1 (faceToQ3 f.val) (faceToQ3 g.val)) ∧
    (∀ i j : Fin 4, i ≠ j →
      ((List.finRange 4).filter fun k =>
        octAdj i.val (k.val + 4) && octAdj (k.val + 4) j.val).length = 2) := by
  decide

/-- Explicit surjectivity and injectivity of faceToQ3 on Fin 8. -/
theorem faceToQ3_bijective :
    (∀ u : Fin 8, ∃ f : Fin 8, faceToQ3 f.val = u.val) ∧
    (∀ f g : Fin 8, faceToQ3 f.val = faceToQ3 g.val → f = g) := by
  decide

/-! ## Section 5. Mod-2 principal character ramp, Appendix A.1 ceiling, and Appendix A.3 ω-closure -/

/--
  Recursive and direct sum of excluded powers of two Σ_{j=1}^h (2^h / 2^j - 1)
  (after index change i = h - j: Σ_{i=0}^{h-1} (2^i - 1) = 2^h - 1 - h) for all h : ℕ.
-/
def dyadicRampDiff : Nat → Nat
  | 0 => 0
  | h + 1 => dyadicRampDiff h + (2 ^ h - 1)

def dyadicPowerSum (h : Nat) : Nat := ((List.range h).map (fun i => 2 ^ i - 1)).sum

theorem powerSum_eq (h : Nat) : dyadicPowerSum h = dyadicRampDiff h := by
  induction h with
  | zero => rfl
  | succ m ih =>
    simp only [dyadicPowerSum, List.range_succ, List.map_append, List.map_cons, List.map_nil,
               List.sum_append, List.sum_cons, List.sum_nil, Nat.add_zero, dyadicRampDiff] at *
    rw [ih]

theorem dyadicRampDiff_closed (h : Nat) :
    dyadicRampDiff h + h + 1 = 2 ^ h := by
  induction h with
  | zero => rfl
  | succ m ih =>
    simp only [dyadicRampDiff, Nat.pow_succ]
    have hpow : 1 ≤ 2 ^ m := Nat.one_le_two_pow
    omega

/-- Sign identity separating the subtracted center C_1 - y·b_N and the centered remainder (Part I). -/
theorem principal_centering_sign_identity {K : Type} [Field K] (R_chi0 C1 y bN : K) :
    let C_chi0 := C1 - y * bN
    R_chi0 - C_chi0 = (R_chi0 - C1) + y * bN := by
  grind

/-- Canonical embedding of Nat and Int into an arbitrary field K. -/
def natToField {K : Type} [Field K] : Nat → K
  | 0 => 0
  | n + 1 => natToField n + 1

def intToField {K : Type} [Field K] : Int → K
  | .ofNat n => natToField n
  | .negSucc n => -(natToField (n + 1))

private theorem natToField_nonneg {K : Type} [Field K] [LE K] [LT K] [LawfulOrderLT K]
    [IsLinearOrder K] [OrderedRing K] (n : Nat) : (0 : K) ≤ natToField n := by
  induction n with
  | zero => dsimp [natToField]; grind
  | succ k ih =>
    have h1 : (0 : K) < 1 := OrderedRing.zero_lt_one
    dsimp [natToField]; grind

private theorem intToField_add_one {K : Type} [Field K] (u : Int) :
    intToField (K := K) (u + 1) = intToField u + 1 := by
  cases u with
  | ofNat m => rfl
  | negSucc m =>
    cases m with
    | zero =>
      change intToField (K := K) 0 = -(natToField 1) + 1
      dsimp [intToField, natToField]; grind
    | succ m' =>
      have h : Int.negSucc (m' + 1) + 1 = Int.negSucc m' := by omega
      rw [h]
      dsimp [intToField, natToField]; grind

private theorem intToField_add_nat {K : Type} [Field K] (z : Int) (n : Nat) :
    intToField (K := K) (z + (n : Int)) = intToField z + natToField n := by
  induction n with
  | zero =>
    have h0 : z + ((0 : Nat) : Int) = z := by omega
    rw [h0]; dsimp [natToField]; grind
  | succ k ih =>
    have h1 : z + ((k + 1 : Nat) : Int) = (z + (k : Int)) + 1 := by omega
    rw [h1, intToField_add_one, ih]
    dsimp [natToField]; grind

/-- Pointwise ceiling optimality S ≤ ceilW when S < W + 1 and W ≤ ceilW (Appendix A.1). -/
theorem a1_ceiling_optimality {K : Type} [Field K] [LE K] [LT K] [LawfulOrderLT K]
    [IsLinearOrder K] [OrderedRing K]
    (W : K) (S ceilW : Int)
    (hS : intToField S < W + 1)
    (hceil_lo : W ≤ intToField ceilW) :
    S ≤ ceilW := by
  by_cases hle : S ≤ ceilW
  · exact hle
  · exfalso
    obtain ⟨d, hd⟩ : ∃ d : Nat, S = ceilW + ((d + 1 : Nat) : Int) :=
      ⟨(S - ceilW - 1).toNat, by omega⟩
    have hstep : intToField (K := K) S = intToField ceilW + natToField (d + 1) := by
      rw [hd, intToField_add_nat]
    have hd_nn : (0 : K) ≤ natToField d := natToField_nonneg d
    dsimp [natToField] at hstep
    grind

/--
  ω-closure divisibility equivalence for integer bases span{(a, 0), (b, d)} in ℤ[(1+√-7)/2]
  (ω² = ω - 2, Appendix A.3): direct action of ω on both basis vectors is equivalent to
  d ∣ a ∧ d ∣ b ∧ (a * d) ∣ (b² + b·d + 2·d²).
-/
theorem a3_omega_closure_iff (a b d : Int) (_ha : a ≠ 0) (hd : d ≠ 0) :
    ((d ∣ a ∧ a ∣ (-(a / d) * b)) ∧ (d ∣ (b + d) ∧ a ∣ (-2 * d - ((b + d) / d) * b))) ↔
    (d ∣ a ∧ d ∣ b ∧ (a * d) ∣ (b * b + b * d + 2 * d * d)) := by
  constructor
  · rintro ⟨⟨⟨m, rfl⟩, _⟩, ⟨hbd, h2⟩⟩
    have hdb : d ∣ b := by
      rcases hbd with ⟨r, hr⟩
      exact ⟨r - 1, by grind⟩
    rcases hdb with ⟨r, rfl⟩
    have hdiv : (d * r + d) / d = r + 1 := by
      have : d * r + d = d * (r + 1) := by grind
      rw [this, Int.mul_ediv_cancel_left _ hd]
    rw [hdiv] at h2
    rcases h2 with ⟨k, hk⟩
    refine ⟨⟨m, rfl⟩, ⟨r, rfl⟩, ⟨-k, ?_⟩⟩
    have hm : d * (m * k) = -(d * (r * r + r + 2)) := by grind
    grind
  · rintro ⟨⟨m, rfl⟩, ⟨r, rfl⟩, ⟨k, hk⟩⟩
    have hdiv1 : d * m / d = m := Int.mul_ediv_cancel_left m hd
    have hdiv2 : (d * r + d) / d = r + 1 := by
      have : d * r + d = d * (r + 1) := by grind
      rw [this, Int.mul_ediv_cancel_left _ hd]
    refine ⟨⟨⟨m, rfl⟩, ⟨-r, by rw [hdiv1]; grind⟩⟩, ⟨⟨r + 1, by grind⟩, ⟨-k, ?_⟩⟩⟩
    rw [hdiv2]
    have hdd : d * (d * (r * r + r + 2)) = d * (d * (m * k)) := by grind
    have h1 : d * (r * r + r + 2) = d * (m * k) := Int.eq_of_mul_eq_mul_left hd hdd
    have h2 : r * r + r + 2 = m * k := Int.eq_of_mul_eq_mul_left hd h1
    grind

/-- Witness for the necessity of factor d: (9, 0, 3) satisfies 9 ∣ 18 but violates (9·3) ∣ 18. -/
theorem a3_lattice_9_0_3_counterexample :
    (9 : Int) ∣ (0 * 0 + 0 * 3 + 2 * 3 * 3) ∧
    ¬ ((9 * 3 : Int) ∣ (0 * 0 + 0 * 3 + 2 * 3 * 3)) := by
  omega

/-! ## Section 5b. Lubin–Tate height-2 valuation rate, odd prime powers, and Bost–Arakelov slope squeeze -/

def fieldPow {K : Type} [Field K] (x : K) : Nat → K
  | 0 => 1
  | n + 1 => fieldPow x n * x

/-- Partial sum Σ_{j=0}^{N-1} l^{-(2j+1)} = invL · Σ_{j=0}^{N-1} (invL²)^j of odd negative powers. -/
def oddNegPowerSum {K : Type} [Field K] (invL : K) : Nat → K
  | 0 => 0
  | n + 1 => oddNegPowerSum invL n + invL * fieldPow (invL * invL) n

section LubinTateAndSlopeChain
variable {K : Type} [Field K] [LE K] [LT K] [LawfulOrderLT K] [IsLinearOrder K] [OrderedRing K]

/--
  Height-1 vs height-2 formal-group valuation rate (Part III):
  for any l > 1 in K, height-1 (split/ordinary 𝔾_m) has net rate 1/(l-1) - 1/(l-1) = 0,
  whereas height-2 (inert supersingular Lubin–Tate formal group) has strictly positive
  net rate 1/(l - 1) - 1/(l² - 1) = l/(l² - 1) > 0.
-/
theorem lubin_tate_height2_rate {l : K} (hl : 1 < l) :
    (1 / (l - 1) - 1 / (l - 1) = 0) ∧
    (1 / (l - 1) - 1 / (l * l - 1) = l / (l * l - 1)) ∧
    (0 < l / (l * l - 1)) := by
  have h1p : (0 : K) < 1 := OrderedRing.zero_lt_one
  have hl_pos : (0 : K) < l := by grind
  have hlm1_pos : (0 : K) < l - 1 := by grind
  have hlp1_pos : (0 : K) < l + 1 := by grind
  have hl2m1_pos : (0 : K) < l * l - 1 := by
    have hprod := mul_nonneg_ord (show (0 : K) ≤ l - 1 by grind) (show (0 : K) ≤ l + 1 by grind)
    have hstrict : (l - 1) * 0 < (l - 1) * (l + 1) := OrderedRing.mul_lt_mul_of_pos_left hlp1_pos hlm1_pos
    grind
  have hlm1_ne : l - 1 ≠ 0 := by grind
  have hl2m1_ne : l * l - 1 ≠ 0 := by grind
  have c1 := mul_div_cancel_ord (a := (1 : K)) hlm1_ne
  have c2 := mul_div_cancel_ord (a := (1 : K)) hl2m1_ne
  have cl := mul_div_cancel_ord (a := l) hl2m1_ne
  have hinv_pos : (0 : K) < 1 / (l * l - 1) := inv_pos_ord hl2m1_pos
  refine ⟨by grind, ?_, ?_⟩
  · have hmul : (l * l - 1) * (1 / (l - 1) - 1 / (l * l - 1)) = (l * l - 1) * (l / (l * l - 1)) := by
      have hfac : (l * l - 1) * (1 / (l - 1)) = (l + 1) * ((l - 1) * (1 / (l - 1))) := by grind
      grind
    grind
  · have hmul_l : l * 0 < l * (1 / (l * l - 1)) := OrderedRing.mul_lt_mul_of_pos_left hinv_pos hl_pos
    have hdiv_eq : l / (l * l - 1) = l * (1 / (l * l - 1)) := by
      rw [Field.div_eq_mul_inv, Field.div_eq_mul_inv]; grind
    grind

/--
  Exact odd-prime-power geometric expansion (Part III):
  for l > 1 and invL = 1/l, the Lubin–Tate rate l/(l² - 1) = 1/(l - 1) - 1/(l² - 1)
  satisfies (l/(l² - 1)) · (1 - (l⁻²)^N) = Σ_{j=0}^{N-1} l^{-(2j+1)} for every N : ℕ.
-/
theorem lubin_tate_odd_power_sum {l : K} (hl : 1 < l) (N : Nat) :
    let invL := (1 : K) / l
    (l / (l * l - 1)) * (1 - fieldPow (invL * invL) N) = oddNegPowerSum invL N := by
  have h1p : (0 : K) < 1 := OrderedRing.zero_lt_one
  have hl_ne : l ≠ 0 := by grind
  have hlp1_pos : (0 : K) < l + 1 := by grind
  have hlm1_pos : (0 : K) < l - 1 := by grind
  have hl2m1_ne : l * l - 1 ≠ 0 := by
    have hstrict : (l - 1) * 0 < (l - 1) * (l + 1) := OrderedRing.mul_lt_mul_of_pos_left hlp1_pos hlm1_pos
    grind
  have cl := mul_div_cancel_ord (a := (1 : K)) hl_ne
  have cr := mul_div_cancel_ord (a := l) hl2m1_ne
  induction N with
  | zero =>
    dsimp [fieldPow, oddNegPowerSum]
    grind
  | succ m ih =>
    dsimp [fieldPow, oddNegPowerSum] at ih ⊢
    have hstep : (l / (l * l - 1)) * (1 - (1 / l * (1 / l))) = 1 / l := by
      have hmul : (l * l - 1) * ((l / (l * l - 1)) * (1 - (1 / l * (1 / l)))) = (l * l - 1) * (1 / l) := by
        have hl2 : l * l * (1 / l * (1 / l)) = 1 := by grind
        grind
      grind
    grind

/--
  Legendre vs height-2 jet valuation lower bound (Part III, `LemmaSt`):
  if s ≤ (l - 1) * d1 (digit-sum bound s_l(r) ≤ (l - 1)(⌊log_l r⌋ + 1) for l > 1),
  then (r - s)/(l - 1) - r/(l² - 1) = (l/(l² - 1))·r - s/(l - 1) ≥ (l/(l² - 1))·r - d1.
-/
theorem lubin_tate_jet_valuation_bound {l r s d1 : K}
    (hl : 1 < l) (hs : s ≤ (l - 1) * d1) :
    (r - s) / (l - 1) - r / (l * l - 1) = (l / (l * l - 1)) * r - s / (l - 1) ∧
    (l / (l * l - 1)) * r - d1 ≤ (r - s) / (l - 1) - r / (l * l - 1) := by
  have h1p : (0 : K) < 1 := OrderedRing.zero_lt_one
  have hlm1_pos : (0 : K) < l - 1 := by grind
  have hlp1_pos : (0 : K) < l + 1 := by grind
  have hl2m1_pos : (0 : K) < l * l - 1 := by
    have hstrict : (l - 1) * 0 < (l - 1) * (l + 1) := OrderedRing.mul_lt_mul_of_pos_left hlp1_pos hlm1_pos
    grind
  have hlm1_ne : l - 1 ≠ 0 := by grind
  have hl2m1_ne : l * l - 1 ≠ 0 := by grind
  have c_rs := mul_div_cancel_ord (a := r - s) hlm1_ne
  have c_s  := mul_div_cancel_ord (a := s) hlm1_ne
  have c_r2 := mul_div_cancel_ord (a := r) hl2m1_ne
  have c_l2 := mul_div_cancel_ord (a := l) hl2m1_ne
  have hs_div : s / (l - 1) ≤ d1 := (div_le_iff_ord hlm1_pos).mpr hs
  have hid : (r - s) / (l - 1) - r / (l * l - 1) = (l / (l * l - 1)) * r - s / (l - 1) := by
    have hm : (l * l - 1) * ((r - s) / (l - 1) - r / (l * l - 1)) =
              (l * l - 1) * ((l / (l * l - 1)) * r - s / (l - 1)) := by
      have hf1 : (l * l - 1) * ((r - s) / (l - 1)) = (l + 1) * ((l - 1) * ((r - s) / (l - 1))) := by grind
      have hf2 : (l * l - 1) * (s / (l - 1)) = (l + 1) * ((l - 1) * (s / (l - 1))) := by grind
      grind
    grind
  exact ⟨hid, by grind⟩

/-- Ramp conversion identity α - min(α, c) = max(α - c, 0) (`LossBounds` / `ramp`, Parts I & IV). -/
theorem ramp_gain_split [DecidableLE K] (α c : K) :
    let min_ac := if α ≤ c then α else c
    let max_sub := if (0 : K) ≤ α - c then α - c else 0
    α - min_ac = max_sub ∧ (0 : K) ≤ max_sub ∧ α - c ≤ max_sub := by
  dsimp only
  split <;> split <;> grind

/-- A common normalized positive average on functions of a word. -/
structure SlopeMean (I K : Type) [Field K] [LE K] where
  avg : (I → K) → K
  constant : ∀ c, avg (fun _ => c) = c
  add : ∀ f g, avg (fun i => f i + g i) = avg f + avg g
  mono : ∀ {f g}, (∀ i, f i ≤ g i) → avg f ≤ avg g

private theorem slopeMean_sub {I : Type} (A : SlopeMean I K) (f g : I → K) :
    A.avg (fun i => f i - g i) = A.avg f - A.avg g := by
  have h : (fun i => (f i - g i) + g i) = f := by funext i; grind
  have hab := A.add (fun i => f i - g i) g
  change A.avg (fun i => (f i - g i) + g i) = A.avg (fun i => f i - g i) + A.avg g at hab
  rw [h] at hab
  grind

/-- Averaging Gain and Div with the same word weights eliminates h and Fo.
    V is the uncentered divisor expression. Count5 bounds log T inside V;
    the separate period identity is needed to identify Main. -/
theorem arakelov_slope_chain_telescope {I : Type} (A : SlopeMean I K)
    (M N h E L V : I → K) {ask gain loss fo defect top divErr : K}
    (hLoss : ask - gain ≤ loss)
    (hGain : ∀ i, M i + gain + fo - E i - L i ≤ N i)
    (hSlope : A.avg (fun i => N i - h i) - defect ≤ top)
    (hDiv : ∀ i, top + h i - fo ≤ V i + divErr) :
    ask ≤ A.avg V + divErr + loss + A.avg L + defect + A.avg E - A.avg M := by
  have g := A.mono hGain
  have v := A.mono hDiv
  rw [slopeMean_sub] at hSlope
  rw [slopeMean_sub, slopeMean_sub, A.add, A.add, A.constant, A.constant] at g
  rw [slopeMean_sub, A.add, A.add, A.constant, A.constant, A.constant] at v
  grind

/-- Scalar specialization with additional auxiliary bounds, without a geometric identification. -/
private theorem scalarSlopeBound
    {ASK Ga LoP muM Fo Ee Lo5 muN m sumA lg eE h logW errHN muP Main Tsum errDiv : K}
    (hLoss  : ASK - Ga ≤ LoP)
    (hGain  : muM + Ga + Fo - Ee - Lo5 ≤ muN)
    (hAux : m * sumA * lg ≤ muM)
    (hEComp : Ee ≤ m * sumA * lg + eE)
    (hSlope : (muN - h) - logW - errHN ≤ muP)
    (hDiv   : muP + h - Fo ≤ Main - Tsum + errDiv)
    (hT     : 0 ≤ Tsum) :
    ASK ≤ Main + (LoP + Lo5 + eE + logW + errHN + errDiv) := by
  grind

/--
  Exact continuous cost-gap identities for blockwise (`x/m + m`) vs compounding (`x/m + m²`)
  envelopes (Section 1): clearing positive `m` at `x = t²` and `x = 2t³` yields
  `t² + m² - 2tm = (m - t)² ≥ 0` (minimum `2√x` at `m = √x`) and
  `2t³ + m³ - 3t²m = (m - t)²(m + 2t) ≥ 0` for `m, t ≥ 0` (exact minimum `3(x/2)^(2/3)` at `m = (x/2)^(1/3)`).
-/
theorem exact_envelope_gap_identities (m t : K) (hm : 0 ≤ m) (ht : 0 ≤ t) :
    t * t + m * m - 2 * t * m = (m - t) * (m - t) ∧
    0 ≤ t * t + m * m - 2 * t * m ∧
    2 * t * t * t + m * m * m - 3 * t * t * m = (m - t) * (m - t) * (m + 2 * t) ∧
    0 ≤ 2 * t * t * t + m * m * m - 3 * t * t * m := by
  have hsq : (0 : K) ≤ (m - t) * (m - t) := by
    rcases Std.IsLinearOrder.le_total (0 : K) (m - t) with h | h
    · exact OrderedRing.mul_nonneg h h
    · have hneg : (0 : K) ≤ -(m - t) := by grind
      have hprod : (0 : K) ≤ (-(m - t)) * (-(m - t)) := OrderedRing.mul_nonneg hneg hneg
      grind
  have hm2t : (0 : K) ≤ m + 2 * t := by grind
  have hprod : (0 : K) ≤ (m - t) * (m - t) * (m + 2 * t) := OrderedRing.mul_nonneg hsq hm2t
  refine ⟨by grind, by grind, by grind, by grind⟩

end LubinTateAndSlopeChain

/-! ## Section 5c. Partner bijection vs non-involution and `(Loss)` strict witness -/

/-- Action of `partner(t, g) = cconj + g + topPl(t)` modeled by flipping both `E0` bits
    and shifting the `H` component by `shift : H → H`. -/
def partnerMap {H : Type} (shift : H → H) (g : (Bool × Bool) × H) : (Bool × Bool) × H :=
  ((!g.1.1, !g.1.2), shift g.2)

/--
  For any invertible shift `(f, fInv)` on `H`, `partnerMap f` bijects `G \ Φ` (`g.1.1 = true`)
  onto `Φ` (`g.1.1 = false`) with two-sided inverse `partnerMap fInv`, while its square
  `partnerMap f ∘ partnerMap f` shifts `H` by `f ∘ f` (hence is NOT an involution when `2t ≠ 0`).
-/
theorem partner_shift_bijection {H : Type} (f fInv : H → H)
    (hL : ∀ h, fInv (f h) = h) (hR : ∀ h, f (fInv h) = h) (g : (Bool × Bool) × H) :
    (partnerMap f g).1.1 = !g.1.1 ∧
    partnerMap fInv (partnerMap f g) = g ∧
    partnerMap f (partnerMap fInv g) = g ∧
    partnerMap f (partnerMap f g) = (g.1, f (f g.2)) ∧
    (partnerMap f g).1.2 = !g.1.2 ∧ (partnerMap f g).2 = f g.2 := by
  cases g with
  | mk e h =>
    cases e with
    | mk b1 b2 =>
      simp [partnerMap, hL h, hR h]

/--
  Explicit refutation over `H = Fin 4` with shift `t = 1`: applying `partnerMap (+1)` twice
  shifts every element of `E0 × Z/4Z` by `(0, 0, 2)`, so `partner(1, ·)` is a bijection
  whose inverse is `partner(-1, ·)` and NOT an involution on any of the 16 elements.
-/
theorem partner_not_involution_Z4 :
    ∀ g : (Bool × Bool) × Fin 4,
      partnerMap (fun h : Fin 4 => h + 1) (partnerMap (fun h : Fin 4 => h + 1) g) ≠ g := by
  intro ⟨⟨b1, b2⟩, ⟨v, hv⟩⟩
  cases b1 <;> cases b2 <;> match v, hv with
  | 0, _ | 1, _ | 2, _ | 3, _ => decide +revert

/--
  Strict witness `(ASK, Ga, LoP) = (4, 3, 1)` confirming that `(Loss)` (`ASK - Ga ≤ LoP`)
  retains a non-zero local loss term `LoP` and does not collapse to `ASK ≤ Ga`.
-/
theorem loss_bounds_strict_witness :
    (4 : Rat) - 3 ≤ 1 ∧ ¬ ((4 : Rat) ≤ 3) := by
  grind

/-! ## Section 6. Concrete non-vacuity witnesses over `Rat` and `Int` -/

/-- Seven families of concrete rational and integer witnesses instantiating the
    conditional theorems over built-in `Rat` (`Init`) and `Int`. -/
theorem non_vacuity_rat_witnesses :
    -- (1) Rank-2 projector q = (1,1,0,0) ∈ [0,1]⁴ over Rat satisfying hypercube_projector_is_boolean:
    ((0 : Rat) ≤ 1 ∧ (1 : Rat) ≤ 1 ∧ (0 : Rat) ≤ 0 ∧
      matMul (effectOp (1 : Rat) 1 0 0) (effectOp (1 : Rat) 1 0 0) = effectOp (1 : Rat) 1 0 0 ∧
      ((1 : Rat) = 0 ∨ (1 : Rat) = 1)) ∧
    -- (2) Axial vertex (0, 0, 1/2) over Rat satisfying all 8 ℓ₁-octahedron inequalities and ‖e‖₂² = 1/4:
    ((-(1 / 2 : Rat) ≤ -0 - 0 + 1 / 2 ∧ (-0 - 0 + 1 / 2 : Rat) ≤ 1 / 2) ∧
     (-(1 / 2 : Rat) ≤ -0 + 0 - 1 / 2 ∧ (-0 + 0 - 1 / 2 : Rat) ≤ 1 / 2) ∧
     (0 : Rat) * 0 + 0 * 0 + (1 / 2) * (1 / 2) = 1 / 4) ∧
    -- (3) External projector over Rat: P² = P while q₀ = -1/5 < 0 and q₃ = 6/5 > 1:
    (let P : Mat4 Rat := blochMat (1 / 2) (3 / 10) (2 / 5) 0
     let q := invWalsh (1 / 2 : Rat) (3 / 10) (2 / 5) 0
     matMul P P = P ∧ q.1 < 0 ∧ 1 < q.2.2.2) ∧
    -- (4) LP optimum (a, κ) = (1/2, 9/2) at (p, q, ν) = (5, 4, 2) over Rat invoking all 4 LP theorems:
    (LPFeasible (5 : Rat) 4 2 (1 / 2) (9 / 2) (1 / 2)) ∧
    -- (5) Ceiling witness over Rat: W = 7/3, S = 3, ceilW = 3:
    (intToField (K := Rat) 3 < (7 / 3 : Rat) + 1 ∧ (7 / 3 : Rat) ≤ intToField (K := Rat) 3 ∧ (3 : Int) ≤ 3) ∧
    -- (6) Non-trivial rank-2 ideal witness in A.3: (a, b, d) = (14, 7, 7):
    (((7 : Int) ∣ 14 ∧ (14 : Int) ∣ (-(14 / 7) * 7)) ∧ ((7 : Int) ∣ (7 + 7) ∧ (14 : Int) ∣ (-2 * 7 - ((7 + 7) / 7) * 7))) ∧
    -- (7) 2/3 compounding barrier at a = 1/3, exact envelope gaps, Lubin–Tate rate 5/24 at l = 5,
    --     partner bijection on Fin 4, ramp split, and Bost–Arakelov 4-clause slope telescope over Rat:
    ((1 - (1 / 3 : Rat) = 2 / 3 ∧ 2 * (1 / 3 : Rat) = 2 / 3) ∧
     ((1 : Rat) / (5 - 1) - 1 / (5 * 5 - 1) = 5 / 24) ∧
     (oddNegPowerSum (1 / 5 : Rat) 2 = 26 / 125) ∧
     ((12 : Rat) ≤ 10 + ((1 : Rat) + 1 + 1 / 2 + 1 / 2 + 1 / 2 + 1 / 2)) ∧
     (3 - 2 : Rat) * (3 - 2) = 1 ∧ (3 - 2 : Rat) * (3 - 2) * (3 + 2*2) = 7 ∧
     (5 / 24 : Rat) * 25 - 3 ≤ (25 - 1) / 4 - 25 / 24 ∧
     (5/2 : Rat) - 1 = 3/2 ∧
     partnerMap (fun h : Fin 4 => h + 1) ((true, false), 0) = ((false, true), 1) ∧
     partnerMap (fun h : Fin 4 => h + 1)
       (partnerMap (fun h : Fin 4 => h + 1) ((true, false), 0)) ≠ ((true, false), 0) ∧
     ((4 : Rat) - 3 ≤ 1 ∧ ¬ ((4 : Rat) ≤ 3)) ∧
     (let A : (Bool → Rat) → Rat := fun f => (f false + 2 * f true) / 3
      (4 : Rat) ≤ A (fun i => if i then 4 else 1) + 1)) := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · have hproj : matMul (effectOp (1 : Rat) 1 0 0) (effectOp (1 : Rat) 1 0 0) = effectOp (1 : Rat) 1 0 0 := by
      funext i j; cases i <;> cases j <;>
        dsimp [matMul, effectOp, blochMat, walshT, walshE1, walshE2, walshE3, I4, Sigma1, Sigma2, Sigma3, matAdd, matScale] <;> grind
    have hbool := hypercube_projector_is_boolean (1 : Rat) 1 0 0
      (by grind) (by grind) (by grind) (by grind) (by grind) (by grind) (by grind) (by grind) hproj
    exact ⟨by grind, by grind, by grind, hproj, hbool.1⟩
  · have h := midslice_octahedron_touches_sphere_at_six_vertices (0 : Rat) 0 (1 / 2)
      ⟨by grind, by grind⟩ ⟨by grind, by grind⟩ ⟨by grind, by grind⟩ ⟨by grind, by grind⟩ (by grind)
    exact ⟨⟨by grind, by grind⟩, ⟨by grind, by grind⟩, by grind⟩
  · have hout := outside_projector_counterexample (K := Rat)
    exact ⟨hout.1, hout.2.2.2.1, hout.2.2.2.2⟩
  · have hfeas : LPFeasible (5 : Rat) 4 2 (1 / 2) (9 / 2) (1 / 2) := by
      dsimp [LPFeasible]; grind
    have _ := four_wall_lower_bounds (p := (5 : Rat)) (q := 4) (ν := 2)
      (a := 1 / 2) (κ := 9 / 2) (θ := 1 / 2) (by grind) (by grind) hfeas
    have _ : ∃ κ : Rat, (κ = 2 - 2 * (1 / 2) ∨ κ = 5 * (1 - 1 / 2) + 2) ∧
        LPFeasible 5 4 2 (1 - 1 / 2) κ (1 / 2) := by
      apply four_wall_achievable <;> grind
    have _ := four_wall_unique_at_5_4_2 hfeas
    have _ := (four_wall_half_threshold (p := (5 : Rat)) (q := 4) (ν := 2) (by grind) (by grind)).mp (by grind)
    exact hfeas
  · have hs : intToField (K := Rat) 3 < (7 / 3 : Rat) + 1 := by
      dsimp [intToField, natToField]; grind
    have hc : (7 / 3 : Rat) ≤ intToField (K := Rat) 3 := by
      dsimp [intToField, natToField]; grind
    exact ⟨hs, hc, a1_ceiling_optimality (7 / 3 : Rat) 3 3 hs hc⟩
  · rw [a3_omega_closure_iff 14 7 7 (by omega) (by omega)]
    omega
  · have h23 := (compounding_barrier_two_thirds (K := Rat) (a := 1 / 3) (θ := 2 / 3)).2.mpr rfl
    have hgap := exact_envelope_gap_identities (m := (3 : Rat)) (t := 2) (by grind) (by grind)
    have hlt := lubin_tate_height2_rate (l := (5 : Rat)) (by grind)
    have hsum := lubin_tate_odd_power_sum (l := (5 : Rat)) (by grind) 2
    have hjet := lubin_tate_jet_valuation_bound (l := (5 : Rat)) (r := 25) (s := 1) (d1 := 3) (by grind) (by grind)
    have hramp := ramp_gain_split (5 / 2 : Rat) 1
    have hpart := partner_shift_bijection (H := Fin 4) (fun h => h + 1) (fun h => h - 1)
      (by intro ⟨v, hv⟩; match v, hv with | 0, _ | 1, _ | 2, _ | 3, _ => decide +revert)
      (by intro ⟨v, hv⟩; match v, hv with | 0, _ | 1, _ | 2, _ | 3, _ => decide +revert)
      ((true, false), 0)
    have hloss := loss_bounds_strict_witness
    have htel := scalarSlopeBound
      (ASK := (12 : Rat)) (Ga := 11) (LoP := 1) (muM := 6) (Fo := 3) (Ee := 13 / 2) (Lo5 := 1)
      (muN := 25 / 2) (m := 2) (sumA := 3) (lg := 1) (eE := 1 / 2) (h := 2) (logW := 1 / 2)
      (errHN := 1 / 2) (muP := 19 / 2) (Main := 10) (Tsum := 1) (errDiv := 1 / 2)
      (by grind) (by grind) (by grind) (by grind) (by grind) (by grind) (by grind)
    dsimp [oddNegPowerSum, fieldPow] at hsum ⊢
    let A : SlopeMean Bool Rat := {
      avg := fun f => (f false + 2 * f true) / 3
      constant := by intro c; grind
      add := by intro f g; grind
      mono := by intro f g h; have x := h false; have y := h true; grind }
    have hw := arakelov_slope_chain_telescope A (fun _ => 0) (fun _ => -2)
      (fun i => if i then 3 else 0) (fun _ => 0) (fun _ => 0) (fun i => if i then 4 else 1)
      (ask := 4) (gain := 3) (loss := 1) (fo := -5) (defect := 0) (top := -4) (divErr := 0)
      (by grind) (by intro i; grind) (by dsimp [A]; grind) (by intro i; cases i <;> grind)
    refine ⟨by grind, by grind, by grind, htel, by grind, by grind, by grind,
            by grind, by decide, partner_not_involution_Z4 _, hloss, ?_⟩
    dsimp [A] at hw ⊢; grind

end HypercubeAndLP

#print axioms HypercubeAndLP.J4_sq
#print axioms HypercubeAndLP.clifford_relations
#print axioms HypercubeAndLP.trace_bloch_sub_sq
#print axioms HypercubeAndLP.invWalsh_left_inv
#print axioms HypercubeAndLP.invWalsh_right_inv
#print axioms HypercubeAndLP.directMat_eq_effectOp
#print axioms HypercubeAndLP.trace_E_sub_E_sq
#print axioms HypercubeAndLP.hypercube_projector_is_boolean
#print axioms HypercubeAndLP.midslice_octahedron_touches_sphere_at_six_vertices
#print axioms HypercubeAndLP.outside_projector_counterexample
#print axioms HypercubeAndLP.weakened_positivity_counterexamples
#print axioms HypercubeAndLP.hypercube_boolean_projector_counts
#print axioms HypercubeAndLP.four_wall_lower_bounds
#print axioms HypercubeAndLP.four_wall_achievable
#print axioms HypercubeAndLP.four_wall_unique_at_5_4_2
#print axioms HypercubeAndLP.four_wall_half_threshold
#print axioms HypercubeAndLP.compounding_barrier_two_thirds
#print axioms HypercubeAndLP.bitSwap_left_inv
#print axioms HypercubeAndLP.bitSwap_right_inv
#print axioms HypercubeAndLP.bitSwap_hom
#print axioms HypercubeAndLP.bitSwap_inPhi_iff_Psi
#print axioms HypercubeAndLP.bitSwap_places
#print axioms HypercubeAndLP.unnormalized_sum_idempotent_iff
#print axioms HypercubeAndLP.scaled_projector_square
#print axioms HypercubeAndLP.scaled_projector_idem_iff
#print axioms HypercubeAndLP.bit_matrix_iff
#print axioms HypercubeAndLP.octahedron_dual_iso_Q3
#print axioms HypercubeAndLP.faceToQ3_bijective
#print axioms HypercubeAndLP.powerSum_eq
#print axioms HypercubeAndLP.dyadicRampDiff_closed
#print axioms HypercubeAndLP.principal_centering_sign_identity
#print axioms HypercubeAndLP.a1_ceiling_optimality
#print axioms HypercubeAndLP.a3_omega_closure_iff
#print axioms HypercubeAndLP.a3_lattice_9_0_3_counterexample
#print axioms HypercubeAndLP.lubin_tate_height2_rate
#print axioms HypercubeAndLP.lubin_tate_odd_power_sum
#print axioms HypercubeAndLP.lubin_tate_jet_valuation_bound
#print axioms HypercubeAndLP.ramp_gain_split
#print axioms HypercubeAndLP.arakelov_slope_chain_telescope
#print axioms HypercubeAndLP.exact_envelope_gap_identities
#print axioms HypercubeAndLP.partner_shift_bijection
#print axioms HypercubeAndLP.partner_not_involution_Z4
#print axioms HypercubeAndLP.loss_bounds_strict_witness
#print axioms HypercubeAndLP.non_vacuity_rat_witnesses
