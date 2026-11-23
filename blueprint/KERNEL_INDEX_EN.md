# Exact Index of Lean 4 Kernel Declarations (Edition 9.0)

This index covers exclusively L. Alpöge's source archive (`175,187` modules; our standalone zero-import module [`lean/HypercubeAndLPTheorems.lean`](../lean/HypercubeAndLPTheorems.lean) with `44` public theorems is documented separately) and is divided into two strictly separated tables:
1. **Table 1 — `233` kernel-live public archive declarations** across **`104` source modules** (`198` declarations from `v8.1` across `83` files plus `35` public declarations in both previously cited and newly cited files (`21` newly cited modules) added in `v9.0` covering the `DefFam` block-lift structure, the Lubin–Tate height-2 formal group `ltLog`/`CM2`/`CM3`/`LemmaSt`, the 4-clause Bost–Arakelov slope squeeze `LossBounds`/`QuotientSlopeBoundsWith`/`SlopeIneq`/`TheoremF`/`DIV`, and the top-level synthesis `Green`). Every row is verified by full kernel name, path under `lean/src/`, exact declaration start line (under component-wise `namespace` / `section` / `end` scoping in `Lean 4.33.1`), declaration kind, kernel `export_id`, and 5-bit root reachability mask.
2. **Table 2 — `7` kernel-live structure fields and Mathlib theorems** cited in the prose (`Deduction.CharFamily.adm`, `UpperTheory.Top.PairGood.boxes`, `Formalism.HC.HostRaw.QS`, `Formalism.L2.DIV.DefFam.L`, `Consts.eDiv`, `Consts.eLoss`, and `riemannZeta_one_sub`). Every row is verified by `(export_id, mask)` in the kernel reachability table and by exact declaration/call binding at the cited source line.

Together, the index records **`240` live `Lean 4` kernel entries** (bound local formula parameters such as `hY` and `ell` are explained alongside their formulas in [`BLUEPRINT_EN.md`](BLUEPRINT_EN.md)). Kernel IDs (`id`) and 5-bit reachability masks with respect to the five root theorems of `Main.lean` come from [`verification/kernel_reachability_5roots.tsv.zst`](../verification/kernel_reachability_5roots.tsv.zst) (`1,484,733` declarations, built from `solution.ndjson` with `SHA-256 = 5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e`).

| Bit | Root Theorem (`Main.lean`) | Reachable Declarations |
|---:|---|---:|
| 1 | `riemannHypothesis` | 1478198 |
| 2 | `riemannZeta_eq_zero_re` | 1478200 |
| 4 | `LFunction_ne_zero_of_half_lt_re` | 1478190 |
| 8 | `LFunction_eq_zero_re` | 1478203 |
| 16 | `LFunction_eq_zero_re_of_isPrimitive` | 1478193 |

The union of the five traversals contains **1,478,222** out of **1,484,733** declarations (3 standard axioms: `propext`, `Classical.choice`, `Quot.sound`). Mask `3` means reachable from the first two roots (`riemannHypothesis`, `riemannZeta_eq_zero_re`); mask `8` from `LFunction_eq_zero_re`; mask `16` from `LFunction_eq_zero_re_of_isPrimitive`; mask `31` from all five roots.

## Table 1. Live Public Archive Declarations (233 Names Across 104 Modules)

| Full Kernel Name | Source File (`lean/src/...`) | Line | Kind | Kernel ID | Mask | Blueprint Section |
|---|---|---:|---|---:|---:|---|
| `riemannHypothesis` | `Main.lean` | 4 | `theorem` | 14065054 | 1 | Roots |
| `riemannZeta_eq_zero_re` | `Main.lean` | 6 | `theorem` | 14065057 | 2 | Roots |
| `LFunction_ne_zero_of_half_lt_re` | `Main.lean` | 8 | `theorem` | 14065064 | 4 | Roots |
| `LFunction_eq_zero_re` | `Main.lean` | 10 | `theorem` | 14065124 | 8 | Roots |
| `LFunction_eq_zero_re_of_isPrimitive` | `Main.lean` | 12 | `theorem` | 14065146 | 16 | Roots |
| `RiemannZetaZerosOnLine` | `Statements.lean` | 3 | `def` | 14065055 | 2 | Roots |
| `DirichletLNonvanishingRightOfHalf` | `Statements.lean` | 6 | `def` | 14065058 | 4 | Roots |
| `DirichletLZerosOnLine` | `Statements.lean` | 10 | `def` | 14065065 | 8 | Roots |
| `PrimitiveDirichletLZerosOnLine` | `Statements.lean` | 14 | `def` | 14065125 | 16 | Roots |
| `allChi` | `Supplements/Kernels/MainTheorems.lean` | 7 | `theorem` | 14065052 | 31 | Roots |
| `rhOfAll` | `Supplements/Kernels/MainTheorems.lean` | 9 | `theorem` | 14065053 | 3 | Roots |
| `claimAll` | `Supplements/Kernels/MainTheorems.lean` | 15 | `theorem` | 14065123 | 8 | Roots |
| `critAll` | `Supplements/Kernels/MainTheorems.lean` | 11 | `theorem` | 14065138 | 16 | Roots |
| `Claim.prim_zero` | `Development/AutomorphicArithmetic/CharacterBoxes/ClaimStrip.lean` | 23 | `theorem` | 14065085 | 8 | Roots |
| `Claim.strip` | `Development/AutomorphicArithmetic/CharacterBoxes/ClaimStrip.lean` | 59 | `theorem` | 14065107 | 8 | Roots |
| `Formalism.VW.rh_of_every` | `Formalism/GammaFactorNonvanishing/CritLine.lean` | 29 | `theorem` | 341189 | 3 | Roots |
| `Formalism.VW.critLine` | `Formalism/GammaFactorNonvanishing/CritLine.lean` | 11 | `theorem` | 14065131 | 16 | Roots |
| `Formalism.VW.gammaFactor_ne_zero` | `Formalism/GammaFactorNonvanishing/CritLine.lean` | 6 | `theorem` | 14065130 | 16 | Roots |
| `Formalism.BasicNotions.Scale` | `Formalism/LocalRingCardinality/DataParams₂.lean` | 9 | `structure` | 656581 | 31 | Parameters |
| `Formalism.BasicNotions.Scale.L` | `Formalism/LocalRingCardinality/DataParams₂.lean` | 27 | `def` | 656591 | 31 | Parameters |
| `Formalism.BasicNotions.Scale.b` | `Formalism/LocalRingCardinality/DataParams₂.lean` | 29 | `def` | 656592 | 31 | Parameters |
| `Formalism.BasicNotions.Scale.a` | `Formalism/LocalRingCardinality/DataParams₂.lean` | 31 | `def` | 656593 | 31 | Parameters |
| `Formalism.BasicNotions.Scale.X'` | `Formalism/LocalRingCardinality/DataParams₂.lean` | 33 | `def` | 656596 | 31 | Parameters |
| `Formalism.BasicNotions.Scale.b'` | `Formalism/LocalRingCardinality/DataParams₂.lean` | 35 | `def` | 656598 | 31 | Parameters |
| `Formalism.BasicNotions.Scale.delta1` | `Formalism/LocalRingCardinality/DataParams₂.lean` | 45 | `def` | 656726 | 31 | Parameters |
| `Formalism.BasicNotions.SizeData₂` | `Formalism/LocalRingCardinality/DataParams₂.lean` | 76 | `structure` | 656601 | 31 | Parameters |
| `Formalism.BasicNotions.Ranks` | `Formalism/LocalRingCardinality/Params.lean` | 6 | `structure` | 556053 | 31 | Parameters |
| `Formalism.BasicNotions.Ranks.n` | `Formalism/LocalRingCardinality/Params.lean` | 28 | `def` | 556448 | 31 | Parameters |
| `Formalism.BasicNotions.Ranks.f` | `Formalism/LocalRingCardinality/Params.lean` | 30 | `def` | 556845 | 31 | Parameters |
| `Formalism.BasicNotions.Ranks.r` | `Formalism/LocalRingCardinality/Params.lean` | 32 | `def` | 556456 | 31 | Parameters |
| `Formalism.BasicNotions.Ranks.nV` | `Formalism/LocalRingCardinality/Params.lean` | 34 | `def` | 556725 | 31 | Parameters |
| `Formalism.BasicNotions.eWL` | `Formalism/LocalRingCardinality/DataArith.lean` | 42 | `def` | 558236 | 31 | Parameters |
| `Formalism.MainNotions.S.StandingHypotheses` | `Formalism/SharpRestriction/CuspSpanNormBounds/StandingNumericalData.lean` | 106 | `def` | 808128 | 31 | Parameters |
| `Formalism.BasicNotions.m_pow_four_le_n` | `Formalism/LocalRingCardinality/FourthPowerRankLeNF.lean` | 8 | `theorem` | 4147071 | 31 | Parameters |
| `Formalism.BasicNotions.m_pow_four_le_f` | `Formalism/LocalRingCardinality/FourthPowerRankLeNF.lean` | 55 | `theorem` | 4147082 | 31 | Parameters |
| `GlobalTheory.EX.exists_even_between` | `Development/AbelianVarietyTheory/Proofs/GlobalInterpolation/ExistsRanksRankValFrame.lean` | 10 | `theorem` | 1550571 | 31 | Parameters |
| `GlobalTheory.EX.exists_ranks_rankVal_frame` | `Development/AbelianVarietyTheory/Proofs/GlobalInterpolation/ExistsRanksRankValFrame.lean` | 45 | `theorem` | 1550589 | 31 | Parameters |
| `GlobalTheory.OntoSizeRows.sizeRows_at` | `Development/AbelianVarietyTheory/Proofs/DivisorProofs/IndexBoundParameterRequirementsEventuallyFamily.lean` | 19 | `theorem` | 4143131 | 31 | Parameters |
| `GlobalTheory.OntoSizeRows.sizeRows_along` | `Development/AbelianVarietyTheory/Proofs/DivisorProofs/IndexBoundParameterRequirementsEventuallyFamily.lean` | 109 | `theorem` | 4143454 | 31 | Parameters |
| `GlobalTheory.Core.Deg.HypL` | `Development/AbelianVarietyTheory/Definitions/LatticeFrames/VanishingGramTermsBoundParams.lean` | 12 | `def` | 4998793 | 31 | Parameters |
| `GlobalTheory.Core.Deg.DataNW` | `Development/AbelianVarietyTheory/Definitions/LatticeFrames/VanishingGramTermsBoundParams.lean` | 43 | `def` | 4998798 | 31 | Parameters |
| `GlobalTheory.EX.words_real_bound` | `Development/AbelianVarietyTheory/Proofs/GlobalInterpolation/SzRowCardWordsLe.lean` | 8 | `theorem` | 2353004 | 31 | Parameters |
| `GlobalTheory.EX.m_pow_five_mul_f_mul_L_le` | `Development/AbelianVarietyTheory/Proofs/GlobalInterpolation/MPowFiveMulFMulLLe.lean` | 9 | `theorem` | 8022472 | 31 | Parameters |
| `GlobalTheory.EX.exists_injective_words` | `Development/AbelianVarietyTheory/Proofs/GlobalInterpolation/MPowFiveMulFMulLLe.lean` | 40 | `theorem` | 8022488 | 31 | Parameters |
| `GlobalTheory.TypeAsm.pairsPar` | `Development/AbelianVarietyTheory/Proofs/FlagMeasures/ParameterSizeConstraints.lean` | 9 | `theorem` | 5372006 | 31 | Parameters |
| `Formalism.LFunctionChainParameters.LChain.RestSize` | `Formalism/SizeWindowBrackets/SChain.lean` | 53 | `def` | 854503 | 31 | Parameters |
| `Deduction.CH.BNBoundsU` | `Development/AutomorphicArithmetic/DedekindLFunctions/SplitInertia.lean` | 74 | `def` | 855218 | 31 | Parameters |
| `GlobalTheory.RefSum.SizeTZ.parameters_scale_rank_gap_bounds` | `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/Sizes.lean` | 18 | `theorem` | 9454799 | 31 | Parameters |
| `UpperTheory.Top.HypV` | `Development/AutomorphicArithmetic/CharacterBoxes/DivinNOfHypV.lean` | 10 | `def` | 854031 | 31 | Parameters |
| `UpperTheory.Top.divinN_of_hypV` | `Development/AutomorphicArithmetic/CharacterBoxes/DivinNOfHypV.lean` | 117 | `theorem` | 1433508 | 31 | Parameters |
| `Deduction.ramp` | `Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean` | 10 | `def` | 864936 | 31 | Part I |
| `Deduction.Gchi` | `Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean` | 15 | `def` | 865282 | 31 | Part I |
| `Deduction.G` | `Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean` | 21 | `def` | 864937 | 31 | Part I |
| `Deduction.poleData_abstract` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/poleData.lean` | 22 | `theorem` | 868460 | 31 | Part I |
| `Deduction.poleData_dslope` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/poleData.lean` | 17 | `theorem` | 868459 | 31 | Part I |
| `Deduction.landau_dichotomy` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/LandauDichotomy.lean` | 24 | `theorem` | 869040 | 31 | Part I |
| `Deduction.landau_window_key` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/landauWindow.lean` | 40 | `theorem` | 868956 | 31 | Part I |
| `Deduction.landau_window_contra` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/landauWindow.lean` | 20 | `theorem` | 869252 | 31 | Part I |
| `Deduction.landau_tails` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/landauTails.lean` | 80 | `theorem` | 868882 | 31 | Part I |
| `Deduction.lemmaL` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/lemmaL.lean` | 13 | `theorem` | 869357 | 31 | Part I |
| `Deduction.windowHyp_of_rpow` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/WindowHypOfRpow.lean` | 27 | `theorem` | 869360 | 31 | Part I |
| `Deduction.zeroFree_of_rpow_window` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ZeroFreeOfRpowWindow.lean` | 11 | `theorem` | 869366 | 31 | Part I |
| `UpperTheory.Comparison₂.formB` | `Development/AutomorphicArithmetic/PrimitiveCosets/Imports.lean` | 8 | `theorem` | 869367 | 31 | Part I |
| `Formalism.BasicNotions.Host.emb` | `Formalism/LocalRingCardinality/DataHost.lean` | 122 | `def` | 558409 | 31 | Part IIa |
| `Formalism.BasicNotions.Host.topPlaces` | `Formalism/LocalRingCardinality/DataHost.lean` | 129 | `def` | 656656 | 31 | Part IIa |
| `Formalism.BasicNotions.Host.thickPlaces` | `Formalism/LocalRingCardinality/DataHost.lean` | 133 | `def` | 656654 | 31 | Part IIa |
| `Formalism.LFunctionChainParameters.characterSumData.ASK` | `Formalism/SizeWindowBrackets/FirstPrimeNeSecondPrime.lean` | 84 | `def` | 854229 | 31 | Part IIa |
| `Formalism.LFunctionChainParameters.characterSumData.MAIN` | `Formalism/SizeWindowBrackets/FirstPrimeNeSecondPrime.lean` | 89 | `def` | 855545 | 31 | Part IIa |
| `Formalism.LFunctionChainParameters.characterSumData.De` | `Formalism/SizeWindowBrackets/FirstPrimeNeSecondPrime.lean` | 93 | `def` | 857031 | 31 | Part IIa |
| `Formalism.HC.Frame.A0` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/ZsmulGeneratorEqZeroOfProjection.lean` | 63 | `def` | 854727 | 31 | Part IIa |
| `UpperTheory.Top.VVle` | `Development/AutomorphicArithmetic/CharacterBoxes/ExistsPageN.lean` | 12 | `def` | 550832 | 31 | Part IIa |
| `UpperTheory.Top.WinPair` | `Development/AutomorphicArithmetic/CharacterBoxes/ExistsPageN.lean` | 27 | `structure` | 550392 | 31 | Part IIa |
| `UpperTheory.Top.PageN` | `Development/AutomorphicArithmetic/CharacterBoxes/ExistsPageN.lean` | 39 | `def` | 550388 | 31 | Part IIa |
| `UpperTheory.Top.VWinAt` | `Development/AutomorphicArithmetic/CharacterBoxes/ExistsPageN.lean` | 44 | `def` | 550386 | 31 | Part IIa |
| `UpperTheory.Top.VWin` | `Development/AutomorphicArithmetic/CharacterBoxes/ExistsPageN.lean` | 49 | `def` | 551631 | 31 | Part IIa |
| `UpperTheory.Top.fieldChi` | `Development/AutomorphicArithmetic/CharacterBoxes/FieldChi.lean` | 20 | `theorem` | 1501944 | 31 | Part IIa |
| `UpperTheory.Top.boundedTw` | `Development/AutomorphicArithmetic/CharacterBoxes/BoundedTw.lean` | 45 | `theorem` | 1515011 | 31 | Part IIa |
| `UpperTheory.Top.PairGood` | `Development/AutomorphicArithmetic/CharacterBoxes/PairGood.lean` | 18 | `structure` | 1501230 | 31 | Part IIa |
| `UpperTheory.Top.ZeroBox` | `Development/AutomorphicArithmetic/CharacterBoxes/PairGood.lean` | 12 | `def` | 1501220 | 31 | Part IIa |
| `UpperTheory.Top.winPairs` | `Development/AutomorphicArithmetic/CharacterBoxes/WinPairs.lean` | 5 | `theorem` | 1506027 | 31 | Part IIa |
| `UpperTheory.Top.supplyChi` | `Development/AutomorphicArithmetic/CharacterBoxes/SupplyChi.lean` | 8 | `theorem` | 1550728 | 31 | Part IIa |
| `Deduction.ch_balance` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChBalance.lean` | 200 | `theorem` | 858589 | 31 | Part IIa |
| `Deduction.ch_top` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChTop.lean` | 37 | `theorem` | 864812 | 31 | Part IIa |
| `Deduction.CharacterBalanceMoves.sum_Th` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChCore.lean` | 56 | `lemma` | 858604 | 31 | Part IIa |
| `Deduction.CharacterBalanceMoves.th_le` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChCore.lean` | 75 | `lemma` | 857741 | 31 | Part IIa |
| `Deduction.CharacterBalanceMoves.core` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChCore.lean` | 283 | `lemma` | 858724 | 31 | Part IIa |
| `Deduction.ch_core` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChCore.lean` | 343 | `theorem` | 858797 | 31 | Part IIa |
| `UpperTheory.One.vwin_of_row` | `Development/AutomorphicArithmetic/AutomorphicVarieties/ModularityArgument/ThresholdArguments/DenseThresholdCases/VwinOfRow.lean` | 4 | `theorem` | 13125899 | 31 | Part IIa |
| `UpperTheory.Gal.Int.galoisLocalGlobalStrong_recParameter` | `Development/AutomorphicArithmetic/Foundations/GaloisRepresentations/IntegralStructures/RowSrc.lean` | 6 | `theorem` | 14065050 | 31 | Part IIa |
| `Formalism.DworkPowerSeriesWeights.BHyp` | `Formalism/GaussJetBounds/Statement.lean` | 85 | `def` | 810466 | 31 | Part III |
| `Formalism.DworkPowerSeriesWeights.LemmaS` | `Formalism/GaussJetBounds/Statement.lean` | 98 | `def` | 1335048 | 31 | Part III |
| `Formalism.A.nonempty_smith_normal_form` | `Formalism/SmithDeterminants/DivisibilityChains/SmithExists.lean` | 7 | `theorem` | 1232552 | 31 | Part III |
| `Formalism.A.smith_form_exists` | `Formalism/SmithDeterminants/DivisibilityChains/SmithExists.lean` | 96 | `theorem` | 1232587 | 31 | Part III |
| `Formalism.IncomingBounds.FlowLoadBounds.dpLoad` | `Formalism/IncomingBounds/FlowDegreeBounds/MaxFlowValueAttained.lean` | 15 | `def` | 1335153 | 31 | Part III |
| `UpperTheory.Top.topDesWin` | `Development/AutomorphicArithmetic/CharacterBoxes/DesWin.lean` | 11 | `theorem` | 1433585 | 31 | Part III |
| `UpperTheory.LiteratureTheorems.OpenLiteratureStatements` | `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/EveryCharacterOfLiteratureOfVWin.lean` | 215 | `structure` | 550020 | 31 | Part III |
| `UpperTheory.Lit.nonempty_hyps_definite_side_of_closed_bound` | `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/SiegelEisensteinSecondTermHypotheses.lean` | 44 | `theorem` | 8026822 | 31 | Part III |
| `UpperTheory.Lit.every_character_of_theta_integrals_local_matching` | `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/SiegelEisensteinSecondTermHypotheses.lean` | 69 | `theorem` | 8026888 | 31 | Part III |
| `UpperTheory.Top.zero_free_all_of_green_v_win` | `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/TopPlug.lean` | 12 | `theorem` | 1550745 | 31 | Part III |
| `UpperTheory.Top.every_character_of_green_v_win` | `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/TopPlug.lean` | 16 | `theorem` | 1550746 | 31 | Part III |
| `GlobalTheory.IndefiniteRowSideFullHecke.MeanPeriodLogarithms.MeanPeriodAt` | `Development/AbelianVarietyTheory/BlockTheory/GlobalSignature/MeanPeriodLogarithms.lean` | 11 | `def` | 6216516 | 31 | Part IV |
| `GlobalTheory.IndefiniteRowSideFullHecke.MeanPeriodLogarithms.logOmVal_eq` | `Development/AbelianVarietyTheory/BlockTheory/GlobalSignature/MeanPeriodLogarithms.lean` | 19 | `theorem` | 6224117 | 31 | Part IV |
| `Formalism.RankGapBounds.WeightedMeanData.wmean_mono` | `Formalism/RankGapBounds/RankGapProofs/WeightedMeanData.lean` | 16 | `lemma` | 864356 | 31 | Part IV |
| `Formalism.RankGapBounds.WeightedMeanData.Data.key_identity` | `Formalism/RankGapBounds/RankGapProofs/WeightedMeanData.lean` | 170 | `lemma` | 864518 | 31 | Part IV |
| `CompanionTheory.WaveGrid.WEnd.pow_four_le_rpow_nine_halves` | `CompanionTheory/AutomorphicTheory/BesselWaveGrids/PowFourLeRpowNineHalves.lean` | 17 | `theorem` | 6010963 | 31 | Part IV |
| `UpperTheory.Comparison₂.CoreAtH` | `Development/AutomorphicArithmetic/PrimitiveCosets/CoreAtH.lean` | 29 | `def` | 855228 | 31 | Part IV |
| `UpperTheory.Comparison₂.core_gm` | `Development/AutomorphicArithmetic/PrimitiveCosets/CoreGm.lean` | 12 | `theorem` | 864997 | 31 | Part IV |
| `UpperTheory.Comparison₂.windowInequality_of_artinInputs` | `Development/AutomorphicArithmetic/PrimitiveCosets/WindowInequalityOfArtinInputs.lean` | 17 | `theorem` | 865139 | 31 | Part IV |
| `UpperTheory.Comparison₂.level_family` | `Development/AutomorphicArithmetic/PrimitiveCosets/LevelFamily.lean` | 41 | `theorem` | 865317 | 31 | Part IV |
| `UpperTheory.Comparison₂.tiedCore_of_chainTied` | `Development/AutomorphicArithmetic/PrimitiveCosets/LevelGmLeOnFamilyScales.lean` | 13 | `theorem` | 865157 | 31 | Part V |
| `UpperTheory.Comparison₂.level_gm_le_on_family_scales` | `Development/AutomorphicArithmetic/PrimitiveCosets/LevelGmLeOnFamilyScales.lean` | 28 | `theorem` | 865267 | 31 | Part V |
| `Formalism.HC.ChebyshevInequalityOnWindows` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/TopWin.lean` | 26 | `def` | 855126 | 31 | Part V |
| `Formalism.HC.zeroFreeOn_of_tiedWin_cyc` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/TopWin.lean` | 90 | `theorem` | 855191 | 31 | Part V |
| `UpperTheory.Top.TopG` | `Development/AutomorphicArithmetic/CharacterBoxes/ZeroFreeAllOfTopG.lean` | 12 | `def` | 854514 | 31 | Part V |
| `UpperTheory.Top.zeroFreeAll_of_topG` | `Development/AutomorphicArithmetic/CharacterBoxes/ZeroFreeAllOfTopG.lean` | 26 | `theorem` | 869378 | 31 | Part V |
| `UpperTheory.EveryCharacter` | `Development/AutomorphicArithmetic/CharacterBoxes/EveryCharacter.lean` | 13 | `def` | 326947 | 31 | Part V |
| `UpperTheory.Top.imprimitive` | `Development/AutomorphicArithmetic/CharacterBoxes/Imprimitive.lean` | 5 | `theorem` | 854015 | 31 | Part V |
| `UpperTheory.FinalTheorems.everyCharacter_of_row` | `Development/AutomorphicArithmetic/CharacterBoxes/MainConclusion.lean` | 7 | `theorem` | 13125901 | 31 | Part V |
| `UpperTheory.FinalTheorems.everyCharacter` | `Development/AutomorphicArithmetic/CharacterBoxes/MainConclusion.lean` | 10 | `theorem` | 14065051 | 31 | Part V |
| `Deduction.CharFamily` | `Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean` | 24 | `structure` | 865276 | 31 | v6 addition |
| `Deduction.Gm` | `Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean` | 36 | `def` | 865291 | 31 | v6 addition |
| `Deduction.WindowHyp` | `Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean` | 41 | `def` | 865318 | 31 | v6 addition |
| `Deduction.ZeroFree` | `Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean` | 38 | `def` | 865292 | 31 | v6 addition |
| `Formalism.BasicNotions.Ranks.sigW` | `Formalism/LocalRingCardinality/Params.lean` | 46 | `def` | 556686 | 31 | v6 addition |
| `Formalism.D5.E0` | `Formalism/ThickAverageLoss/PartnersToFactorsAt.lean` | 13 | `abbrev` | 854068 | 31 | v6 addition |
| `Formalism.DworkPowerSeriesWeights.lemmaS` | `Formalism/GaussJetBounds/OneLetterRadius.lean` | 17 | `theorem` | 1340679 | 31 | v6 addition |
| `Formalism.HC.EAtH` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/ExplicitFormulaErrorOfHostConditions.lean` | 144 | `structure` | 854766 | 31 | v6 addition |
| `Formalism.IncomingBounds.maxFlowValueAttained` | `Formalism/IncomingBounds/FlowDegreeBounds/MaxFlowValueAttained.lean` | 425 | `theorem` | 1344896 | 31 | v6 addition |
| `Formalism.IncomingBounds.strongDuality` | `Formalism/IncomingBounds/FlowDegreeBounds/MaxFlowValueAttained.lean` | 430 | `theorem` | 1335143 | 31 | v6 addition |
| `Formalism.LFunctionChainParameters.LChain.SizeData₂` | `Formalism/SizeWindowBrackets/SChain.lean` | 17 | `def` | 854380 | 31 | v6 addition |
| `Formalism.LFunctionChainParameters.WeightedSlopeBounds.each_unit_bound_statement` | `Formalism/SizeWindowBrackets/ChainSlopeWindows/LevelOfCongruence.lean` | 175 | `theorem` | 864658 | 31 | v6 addition |
| `Formalism.LFunctionChainParameters.characterSumData.chC` | `Formalism/SizeWindowBrackets/FirstPrimeNeSecondPrime.lean` | 21 | `def` | 854193 | 31 | v6 addition |
| `Formalism.LFunctionChainParameters.characterSumData.sgc0` | `Formalism/SizeWindowBrackets/FirstPrimeNeSecondPrime.lean` | 17 | `def` | 855239 | 31 | v6 addition |
| `Formalism.VW.rh_of_right` | `Formalism/GammaFactorNonvanishing/RhOfRight.lean` | 5 | `theorem` | 341050 | 3 | v6 addition |
| `GlobalTheory.IndefiniteRowSideFullHecke.MeanPeriodLogarithms.MeanPeriod` | `Development/AbelianVarietyTheory/BlockTheory/GlobalSignature/MeanPeriodLogarithms.lean` | 15 | `def` | 6216535 | 31 | v6 addition |
| `GlobalTheory.MeanPeriodClosed.meanPeriod` | `Development/AbelianVarietyTheory/Proofs/DivisorProofs/MeanLogPeriodChowlaSelberg.lean` | 84 | `theorem` | 6224129 | 31 | v6 addition |
| `GlobalTheory.MeanPeriodClosed.meanPeriodAt` | `Development/AbelianVarietyTheory/Proofs/DivisorProofs/MeanLogPeriodChowlaSelberg.lean` | 58 | `theorem` | 6224118 | 31 | v6 addition |
| `GlobalTheory.MeanPeriodClosed.two_log_brN` | `Development/AbelianVarietyTheory/Proofs/DivisorProofs/MeanLogPeriodChowlaSelberg.lean` | 17 | `theorem` | 6224116 | 31 | v6 addition |
| `GlobalTheory.MeanPeriodGenerator.mean_logMet_eq` | `Development/AbelianVarietyTheory/Proofs/DivisorProofs/MeanLogMetricGeneratorEqMeanPeriod.lean` | 45 | `theorem` | 6218362 | 31 | v6 addition |
| `Claim.factor_ne_zero` | `Development/AutomorphicArithmetic/CharacterBoxes/ClaimStrip.lean` | 7 | `theorem` | 14065084 | 8 | v7 addition (Roots) |
| `Claim.gamma_ne_zero` | `Development/AutomorphicArithmetic/CharacterBoxes/ClaimStrip.lean` | 35 | `theorem` | 14065097 | 8 | v7 addition (Roots) |
| `Claim.prim_reflect` | `Development/AutomorphicArithmetic/CharacterBoxes/ClaimStrip.lean` | 42 | `theorem` | 14065102 | 8 | v7 addition (Roots) |
| `Claim.zeta` | `Development/AutomorphicArithmetic/CharacterBoxes/ClaimStrip.lean` | 75 | `theorem` | 14065122 | 8 | v7 addition (Roots) |
| `GlobalTheory.EX.exists_ranks_of_frame` | `Development/AbelianVarietyTheory/Proofs/GlobalInterpolation/ExistsRanksRankValFrame.lean` | 24 | `theorem` | 1550572 | 31 | v7 addition (Parameters) |
| `Formalism.BasicNotions.D7` | `Formalism/LocalRingCardinality/RhoDetPrimeEqMuTildeMulChiPow.lean` | 76 | `structure` | 556991 | 31 | v7 addition (Parameters) |
| `Formalism.BasicNotions.SizeData₂.MAIN` | `Formalism/LocalRingCardinality/DataParams₂.lean` | 232 | `def` | 869927 | 31 | v7 addition (Parameters) |
| `Formalism.LFunctionChainParameters.LChain.BNBounds` | `Formalism/SizeWindowBrackets/SChain.lean` | 33 | `def` | 854409 | 31 | v7 addition (Parameters) |
| `Formalism.GaloisCohomology.shaLen` | `Formalism/GaloisCohomology/Statement.lean` | 78 | `def` | 551607 | 31 | v7 addition (Parameters) |
| `Formalism.LFunctionChainParameters.LChain.CostWindows` | `Formalism/SizeWindowBrackets/SChain.lean` | 50 | `def` | 854494 | 31 | v7 addition (Part IIa) |
| `Formalism.LFunctionChainParameters.ThickSetMeanBounds.ThinScales` | `Formalism/SizeWindowBrackets/GrowthBoundGivesRiemannHypothesis.lean` | 55 | `def` | 854438 | 31 | v7 addition (Part IIa) |
| `Formalism.LFunctionChainParameters.ThickSetMeanBounds.psC` | `Formalism/SizeWindowBrackets/GrowthBoundGivesRiemannHypothesis.lean` | 16 | `def` | 854461 | 31 | v7 addition (Part IIa) |
| `Formalism.LFunctionChainParameters.ThickSetMeanBounds.chpsC` | `Formalism/SizeWindowBrackets/GrowthBoundGivesRiemannHypothesis.lean` | 31 | `def` | 854474 | 31 | v7 addition (Part IIa) |
| `Formalism.LFunctionChainParameters.characterSumData.partner` | `Formalism/SizeWindowBrackets/FirstPrimeNeSecondPrime.lean` | 19 | `def` | 854237 | 31 | v7 addition (Part IIa) |
| `Formalism.LFunctionChainParameters.characterSumData.GPsi` | `Formalism/SizeWindowBrackets/FirstPrimeNeSecondPrime.lean` | 68 | `def` | 854448 | 31 | v7 addition (Part IIa) |
| `Formalism.LFunctionChainParameters.characterSumData.primVal` | `Formalism/SizeWindowBrackets/FirstPrimeNeSecondPrime.lean` | 65 | `def` | 854148 | 31 | v7 addition (Part IIa) |
| `Formalism.D5.InPhi` | `Formalism/ThickAverageLoss/PartnersToFactorsAt.lean` | 20 | `def` | 854069 | 31 | v7 addition (Part IIa) |
| `Formalism.D5.cconj` | `Formalism/ThickAverageLoss/PartnersToFactorsAt.lean` | 24 | `def` | 854231 | 31 | v7 addition (Part IIa) |
| `Formalism.D5.topPl` | `Formalism/ThickAverageLoss/PartnersToFactorsAt.lean` | 26 | `def` | 854236 | 31 | v7 addition (Part IIa) |
| `Formalism.D5.thickPl` | `Formalism/ThickAverageLoss/PartnersToFactorsAt.lean` | 27 | `def` | 854415 | 31 | v7 addition (Part IIa) |
| `Formalism.D5.IsThickAt` | `Formalism/ThickAverageLoss/PartnersToFactorsAt.lean` | 97 | `def` | 854416 | 31 | v7 addition (Part IIa) |
| `Formalism.BasicNotions.Host.IsThin` | `Formalism/LocalRingCardinality/DataHost.lean` | 136 | `def` | 656657 | 31 | v7 addition (Part IIa) |
| `Formalism.HC.Frame.tau1` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/ZsmulGeneratorEqZeroOfProjection.lean` | 120 | `def` | 656600 | 31 | v7 addition (Part IIa) |
| `Formalism.HC.Frame.tau2` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/ZsmulGeneratorEqZeroOfProjection.lean` | 122 | `def` | 656651 | 31 | v7 addition (Part IIa) |
| `Formalism.HC.Frame.Psi` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/ZsmulGeneratorEqZeroOfProjection.lean` | 112 | `def` | 556123 | 31 | v7 addition (Part IIa) |
| `Formalism.HC.Frame.GG` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/ZsmulGeneratorEqZeroOfProjection.lean` | 89 | `abbrev` | 556071 | 31 | v7 addition (Part IIa) |
| `Deduction.CH.HostFactsS` | `Development/AutomorphicArithmetic/DedekindLFunctions/SplitInertia.lean` | 14 | `structure` | 855244 | 31 | v7 addition (Part IIa) |
| `Deduction.CH.SizesA` | `Development/AutomorphicArithmetic/DedekindLFunctions/SplitInertia.lean` | 42 | `def` | 855216 | 31 | v7 addition (Part IIa) |
| `Deduction.CH.PsiA` | `Development/AutomorphicArithmetic/DedekindLFunctions/SplitInertia.lean` | 26 | `def` | 855530 | 31 | v7 addition (Part IIa) |
| `Deduction.CH.gapA` | `Development/AutomorphicArithmetic/DedekindLFunctions/SplitInertia.lean` | 50 | `def` | 855551 | 31 | v7 addition (Part IIa) |
| `Deduction.CH.IdentU` | `Development/AutomorphicArithmetic/DedekindLFunctions/SplitInertia.lean` | 67 | `def` | 855207 | 31 | v7 addition (Part IV) |
| `Deduction.CharacterBalanceMoves.e1` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChCore.lean` | 16 | `def` | 856962 | 31 | v7 addition (Part IIa) |
| `UpperTheory.Top.IsChiField` | `Development/AutomorphicArithmetic/CharacterBoxes/ExistsPageN.lean` | 19 | `def` | 550819 | 31 | v7 addition (Part IIa) |
| `UpperTheory.Top.VAt` | `Development/AutomorphicArithmetic/CharacterBoxes/ExistsPageN.lean` | 41 | `def` | 551624 | 31 | v7 addition (Part IIa) |
| `UpperTheory.Top.PairEx` | `Development/AutomorphicArithmetic/CharacterBoxes/PairGood.lean` | 28 | `def` | 1505958 | 31 | v7 addition (Part IIa) |
| `UpperTheory.Top.RealBox` | `Development/AutomorphicArithmetic/CharacterBoxes/PairGood.lean` | 32 | `def` | 1515991 | 31 | v7 addition (Part IIa) |
| `UpperTheory.Top.ThinH` | `Development/AutomorphicArithmetic/CharacterBoxes/PairGood.lean` | 36 | `def` | 1515988 | 31 | v7 addition (Part IIa) |
| `UpperTheory.GalStar.Row0b` | `Development/AutomorphicArithmetic/Foundations/GaloisRepresentations/TypeConditions/WeightsConjBis.lean` | 69 | `def` | 421714 | 31 | v7 addition (Part IIa) |
| `Formalism.DworkPowerSeriesWeights.torus` | `Formalism/GaussJetBounds/Statement.lean` | 41 | `def` | 810392 | 31 | v7 addition (Part III) |
| `Formalism.DworkPowerSeriesWeights.NoLowBidegree` | `Formalism/GaussJetBounds/Statement.lean` | 48 | `def` | 810407 | 31 | v7 addition (Part III) |
| `Formalism.DworkPowerSeriesWeights.IsBiPower` | `Formalism/GaussJetBounds/Statement.lean` | 78 | `def` | 1335047 | 31 | v7 addition (Part III) |
| `Formalism.DworkPowerSeriesWeights.letterLog` | `Formalism/GaussJetBounds/Statement.lean` | 74 | `def` | 810419 | 31 | v7 addition (Part III) |
| `Formalism.DworkPowerSeriesWeights.Unram` | `Formalism/GaussJetBounds/Statement.lean` | 95 | `def` | 810384 | 31 | v7 addition (Part III) |
| `Formalism.DworkPowerSeriesWeights.WtGe` | `Formalism/GaussJetBounds/Statement.lean` | 22 | `def` | 1335041 | 31 | v7 addition (Part III) |
| `Formalism.DworkPowerSeriesWeights.MonoWtGe` | `Formalism/GaussJetBounds/Statement.lean` | 19 | `def` | 1335036 | 31 | v7 addition (Part III) |
| `UpperTheory.Zero.LLC.RecTExists` | `Development/AutomorphicArithmetic/Foundations/LocalLanglands/IsRecTOfIsRec.lean` | 78 | `def` | 550010 | 31 | v7 addition (Part III) |
| `UpperTheory.N.boundAtTwoThree_linked_of_recT` | `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/At23OfAll.lean` | 24 | `theorem` | 8026883 | 31 | v7 addition (Part III) |
| `Formalism.RankGapBounds.WeightedMeanData.Consts` | `Formalism/RankGapBounds/MeanBoundSecondForm.lean` | 15 | `structure` | 854055 | 31 | v7 addition (Part IV) |
| `Formalism.RankGapBounds.WeightedMeanData.Data.Main` | `Formalism/RankGapBounds/MeanBoundSecondForm.lean` | 107 | `def` | 864221 | 31 | v7 addition (Part IV) |
| `CompanionTheory.WaveGrid.WEnd.wBp_of` | `CompanionTheory/AutomorphicTheory/BesselWaveGrids/PowFourLeRpowNineHalves.lean` | 106 | `theorem` | 6010986 | 31 | v7 addition (Part IV) |
| `Deduction.ch_top_main_eq` | `Development/AutomorphicArithmetic/DedekindLFunctions/LandauTheorems/ChTop.lean` | 11 | `lemma` | 864226 | 31 | v8 addition (Part IV) |
| `UpperTheory.Comparison₂.sigA_le` | `Development/AutomorphicArithmetic/PrimitiveCosets/SigALe.lean` | 38 | `theorem` | 864855 | 31 | v8 addition (Part IIa) |
| `QH.pairEx` | `Development/AutomorphicArithmetic/MeanSquareBounds/pairEx.lean` | 112 | `theorem` | 1514479 | 31 | v8 addition (Part IIa) |
| `Formalism.HC.HostRaw` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/ConjEMemHostFIff.lean` | 12 | `structure` | 556084 | 31 | v8 addition (Part IIa) |
| `Formalism.HC.HostRaw.condN` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/ConjEMemHostFIff.lean` | 54 | `abbrev` | 556124 | 31 | v8 addition (Part IIa) |
| `UpperTheory.Comparison₂.toE` | `Development/AutomorphicArithmetic/PrimitiveCosets/RecH.lean` | 10 | `def` | 855193 | 31 | v8 addition (Part VI.2) |
| `UpperTheory.Comparison₂.toE_bij` | `Development/AutomorphicArithmetic/PrimitiveCosets/ToEBij.lean` | 37 | `theorem` | 863472 | 31 | v8 addition (Part VI.2) |
| `Formalism.MainNotions.ZetaZeroFreeRegion.Br.inPhi_iff` | `Formalism/SharpRestriction/GlobalSchurBounds/RamificationTwoAndConjugationAtQAndD.lean` | 343 | `theorem` | 1075613 | 31 | v8 addition (Part VI.2) |
| `Formalism.MainNotions.ZetaZeroFreeRegion.Br.top_place_of_first_tau` | `Formalism/SharpRestriction/GlobalSchurBounds/RamificationTwoAndConjugationAtQAndD.lean` | 350 | `theorem` | 1075721 | 31 | v8 addition (Part VI.2) |
| `GlobalTheory.GLq.Green` | `Development/AbelianVarietyTheory/Definitions/NonGaloisDescent/LabelDatum.lean` | 108 | `def` | 552613 | 31 | v9 addition (Part III) |
| `Formalism.BasicNotions.sizeBudget` | `Formalism/LocalRingCardinality/DataArith.lean` | 200 | `def` | 809130 | 31 | v9 addition (Parameters) |
| `Formalism.L2.DIV.DefFam` | `Formalism/LocalToGlobal/Divisibility/RowLat.lean` | 202 | `structure` | 683382 | 31 | v9 addition (Parameters) |
| `Formalism.L2.DIV.DefFam.etaJ` | `Formalism/LocalToGlobal/Divisibility/LiftLat.lean` | 147 | `def` | 759972 | 31 | v9 addition (Parameters) |
| `Formalism.L2.DIV.DefFam.JJ` | `Formalism/LocalToGlobal/Divisibility/LiftLat.lean` | 151 | `def` | 752538 | 31 | v9 addition (Parameters) |
| `Formalism.LFunctionChainParameters.ThickSetMeanBounds.GrowthSizeBound` | `Formalism/SizeWindowBrackets/GrowthBoundGivesRiemannHypothesis.lean` | 119 | `def` | 858752 | 31 | v9 addition (Part IV) |
| `Formalism.LFunctionChainParameters.ThickSetMeanBounds.proposition_size_bound` | `Formalism/SizeWindowBrackets/ChainSlopeWindows/LipschitzWeightAndMinimum.lean` | 507 | `theorem` | 858769 | 31 | v9 addition (Part IV) |
| `Formalism.LFunctionChainParameters.WeightedSlopeBounds.QuotientSlopeBoundsWith` | `Formalism/SizeWindowBrackets/QuotientSlopeBoundsWith.lean` | 19 | `def` | 854332 | 31 | v9 addition (Part IV) |
| `Formalism.LFunctionChainParameters.WeightedSlopeBounds.EComp5` | `Formalism/SizeWindowBrackets/QuotientSlopeBoundsWith.lean` | 24 | `def` | 854307 | 31 | v9 addition (Part IV) |
| `Formalism.LFunctionChainParameters.WeightedSlopeBounds.Count5` | `Formalism/SizeWindowBrackets/QuotientSlopeBoundsWith.lean` | 27 | `def` | 854320 | 31 | v9 addition (Part IV) |
| `Formalism.LFunctionChainParameters.WeightedSlopeBounds.LossBounds` | `Formalism/SizeWindowBrackets/QuotientSlopeBoundsWith.lean` | 34 | `def` | 854343 | 31 | v9 addition (Part IV) |
| `Formalism.LFunctionChainParameters.WeightedSlopeBounds.key_identity5` | `Formalism/SizeWindowBrackets/ChainSlopeWindows/LevelOfCongruence.lean` | 105 | `lemma` | 864538 | 31 | v9 addition (Part IV) |
| `Formalism.RankGapBounds.WeightedMeanData.Data.DIV` | `Formalism/RankGapBounds/MeanBoundSecondForm.lean` | 118 | `def` | 854294 | 31 | v9 addition (Part IV) |
| `Formalism.RankGapBounds.WeightedMeanData.Data.HComp` | `Formalism/RankGapBounds/MeanBoundSecondForm.lean` | 126 | `def` | 854314 | 31 | v9 addition (Part IV) |
| `Formalism.RankGapBounds.WeightedMeanData.Data.Slopes` | `Formalism/RankGapBounds/MeanBoundSecondForm.lean` | 139 | `def` | 854322 | 31 | v9 addition (Part IV) |
| `Formalism.RankGapBounds.WeightedMeanData.Data.SlopeIneq` | `Formalism/RankGapBounds/MeanBoundSecondForm.lean` | 151 | `def` | 854368 | 31 | v9 addition (Part IV) |
| `Formalism.HN.TheoremF` | `Formalism/HarderNarasimhan/StatementFrameF.lean` | 26 | `def` | 1070524 | 31 | v9 addition (Part IV) |
| `Formalism.HN.frameB_share` | `Formalism/HarderNarasimhan/HarderNarasimhanProofs/FrameHermSharpB.lean` | 25 | `theorem` | 1070945 | 31 | v9 addition (Part IV) |
| `Formalism.DivisorInequality.BoundsMu` | `Formalism/DivisorInequality/StatementObj.lean` | 17 | `def` | 1420999 | 31 | v9 addition (Part IV) |
| `Formalism.DivisionValues.divisor_inequality_assembly` | `Formalism/QuotientMetricDivisors/HermitianTwistDivisors/DivAssembly.lean` | 11 | `theorem` | 1422709 | 31 | v9 addition (Part IV) |
| `GlobalTheory.chowla_selberg_eta` | `Development/AbelianVarietyTheory/Proofs/HomogeneousIdeals/DedekindZetaEqSumRealEisenstein.lean` | 222 | `theorem` | 2844235 | 31 | v9 addition (Part IV) |
| `GlobalTheory.CovTop.Assembly.lcv_le` | `Development/AbelianVarietyTheory/Proofs/DivisorProofs/CovolumeFromGramAndBounds.lean` | 39 | `theorem` | 9601303 | 31 | v9 addition (Part III) |
| `SelfIntersectionVolumeEstimates.topCovolSlim2_use_alt_alt` | `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/TopCovolSlim2Use.lean` | 16 | `theorem` | 10381795 | 31 | v9 addition (Part III) |
| `GlobalTheory.BigTop.lamLow_of_hypotheses_alt_alt` | `Development/AutomorphicArithmetic/ThetaCorrespondence/ThetaPairLifts/ThirdPlaceSeries/LamLowOfPublished.lean` | 17 | `theorem` | 4974280 | 31 | v9 addition (Part III) |
| `Formalism.L2.G.Adm2InU.admissible_level_two` | `Formalism/LocalToGlobal/GroupLattices/AdmissibleAtGeneratorPlaces.lean` | 214 | `theorem` | 1383603 | 31 | v9 addition (Part III) |
| `Formalism.MainNotions.G.gainP` | `Formalism/SharpRestriction/GrowthBounds/IsResidueClassZero.lean` | 355 | `def` | 680432 | 31 | v9 addition (Part III) |
| `Formalism.MainNotions.FormalGroupSystem.adm2` | `Formalism/SharpRestriction/GrowthBounds/FormalGroupSystem.lean` | 548 | `def` | 809718 | 31 | v9 addition (Part III) |
| `Formalism.L2.Th1.CM.ltLog` | `Formalism/LocalToGlobal/TorsionIntegrality/CMGoodModels/Statement.lean` | 35 | `def` | 7843652 | 31 | v9 addition (Part III) |
| `Formalism.L2.Th1.CM.CM2` | `Formalism/LocalToGlobal/TorsionIntegrality/CMGoodModels/Statement.lean` | 45 | `def` | 7840334 | 31 | v9 addition (Part III) |
| `Formalism.L2.Th1.CM.CM3` | `Formalism/LocalToGlobal/TorsionIntegrality/CMGoodModels/Statement.lean` | 49 | `def` | 7843657 | 31 | v9 addition (Part III) |
| `GlobalTheory.Corev.CmTwoClosing.cmGoodModel_of_globalArtinReciprocity` | `Development/AbelianVarietyTheory/Proofs/DecoratedLatticeProofs/CmGoodModelOfGlobalArtinReciprocity.lean` | 10 | `theorem` | 7843478 | 31 | v9 addition (Part III) |
| `Formalism.DworkPowerSeriesWeights.LemmaSt` | `Formalism/GaussJetBounds/Statement.lean` | 107 | `def` | 1337855 | 31 | v9 addition (Part III) |
| `Formalism.DworkPowerSeriesWeights.LemmaRA` | `Formalism/GaussJetBounds/StatementG.lean` | 12 | `def` | 1335067 | 31 | v9 addition (Part III) |
| `Formalism.L2.KerInert.IntInert` | `Formalism/LocalToGlobal/InertKernelTheory/StatementInt.lean` | 18 | `def` | 7856454 | 31 | v9 addition (Part III) |
| `PI.OrbBoundFW.prvF_of_orbitLetterBounds` | `Formalism/PeriodIntegrals/UnitaryGroupMassFormula/OrbitValuationBounds/PrvFOfOrbitLetterBounds.lean` | 17 | `theorem` | 1382752 | 31 | v9 addition (Part III) |

## Table 2. Structure Fields and Mathlib Theorems Cited in Prose (7 Entries)

| Full Kernel Name | Source File (`lean/src/...`) | Line | Category | Source Snippet | Kernel ID | Mask |
|---|---|---:|---|---|---:|---:|
| `Deduction.CharFamily.adm` | `Development/AutomorphicArithmetic/DedekindLFunctions/CharFamily.lean` | 32 | `field` | `adm :` | 865328 | 31 |
| `UpperTheory.Top.PairGood.boxes` | `Development/AutomorphicArithmetic/CharacterBoxes/PairGood.lean` | 24 | `field` | `boxes :` | 1505973 | 31 |
| `Formalism.HC.HostRaw.QS` | `Formalism/SharpRestriction/RamificationFrobenius/TotientGaloisClasses/ConjEMemHostFIff.lean` | 16 | `field` | `QS : ℕ` | 556108 | 31 |
| `Formalism.RankGapBounds.WeightedMeanData.Consts.eDiv` | `Formalism/RankGapBounds/MeanBoundSecondForm.lean` | 19 | `field` | `eDiv : ℝ` | 854188 | 31 |
| `Formalism.RankGapBounds.WeightedMeanData.Consts.eLoss` | `Formalism/RankGapBounds/MeanBoundSecondForm.lean` | 33 | `field` | `eLoss : ℝ` | 854189 | 31 |
| `riemannZeta_one_sub` | `Formalism/GammaFactorNonvanishing/RhOfRight.lean` | 28 | `mathlib` | `have key := riemannZeta_one_sub` | 341024 | 3 |
| `Formalism.L2.DIV.DefFam.L` | `Formalism/LocalToGlobal/Divisibility/RowLat.lean` | 213 | `field` | `L : J → T → BlockDat K G Pl0` | 683410 | 31 |

## Critical Short-Name Collisions and Archive Edge Cases

* **`SizeData₂` (two distinct owners):** `Formalism.BasicNotions.SizeData₂` (`DataParams₂.lean:76`, `id=656601`) vs `Formalism.LFunctionChainParameters.LChain.SizeData₂` (`SChain.lean:17`, `id=854380`).
* **`MAIN` / `Main` (three distinct owners):** `Formalism.LFunctionChainParameters.characterSumData.MAIN` (`FirstPrimeNeSecondPrime.lean:89`), `Formalism.BasicNotions.SizeData₂.MAIN` (`DataParams₂.lean:232`), and `Formalism.RankGapBounds.WeightedMeanData.Data.Main` (`MeanBoundSecondForm.lean:107`; linked to the double real sum of `MAIN` by `Deduction.ch_top_main_eq`, `ChTop.lean:11`).
* **`BNBounds` vs `BNBoundsU`:** `Formalism.LFunctionChainParameters.LChain.BNBounds` (`SChain.lean:33`, arbitrary finite abelian group `H`, rows indexed by `H`) vs `Deduction.CH.BNBoundsU` (`SplitInertia.lean:74`, separate finite row set `U_0` with map `tr : U_0 → H`).
* **`PairEx` vs `QH.pairEx`:** `UpperTheory.Top.PairEx` (`PairGood.lean:28`, `Prop` statement) vs `QH.pairEx` (`MeanSquareBounds/pairEx.lean:112`, existence proof).
* **`sg` (source-only) vs `sgc0` (kernel-live):** `FirstPrimeNeSecondPrime.lean:15` defines `sg`, which is absent from the compiled kernel export, unlike `sgc0` on line 17 (mask `31`).
* **Bit transposition between `E0 × H` and `Frame.GG`:** in `PartnersToFactorsAt.lean:20–27` (`E0 × H`), `InPhi` fixes the 1st bit and `topPl`/`thickPl` differ in the 2nd bit; in `ZsmulGeneratorEqZeroOfProjection.lean:106–122` and `DataHost.lean:129–136` (`Frame.GG`), `R.Psi` fixes the 2nd sign and `tau1`/`tau2` differ in the 1st sign. Inverse map: `UpperTheory.Comparison₂.toE` (`RecH.lean:10`); bijectivity: `toE_bij` (`ToEBij.lean:37`); pointwise compatibility: `inPhi_iff` and `top_place_of_first_tau` (`GlobalSchurBounds/RamificationTwoAndConjugationAtQAndD.lean:343–351`; note that four distinct files in the archive share the basename `RamificationTwoAndConjugationAtQAndD.lean`, so citations always include `GlobalSchurBounds/`).
* **`adm2` (26 distinct live declarations in the kernel):** bare `adm2` is ambiguous across 26 namespaces; the formal-group level-two admissibility predicate on `FormalGroupSystem` is `Formalism.MainNotions.FormalGroupSystem.adm2` (`FormalGroupSystem.lean:548`, `id=809718`, `mask=31`), assembled globally by `Formalism.L2.G.Adm2InU.admissible_level_two` (`AdmissibleAtGeneratorPlaces.lean:214`, `id=1383603`, `mask=31`).
* **`FactNc` (source-only) vs `sizeBudget` (kernel-live):** `Formalism.BasicNotions.FactNc` (`DataArith.lean:207`) is absent from the compiled kernel export, whereas `Formalism.BasicNotions.sizeBudget` (`DataArith.lean:200`, `id=809130`, `mask=31`) and `GrowthSizeBound` (`GrowthBoundGivesRiemannHypothesis.lean:119`, `id=858752`, `mask=31`) are live on all five roots.
* **Basename collisions across the archive:** `Statement.lean` (86 modules in the archive, including `GaussJetBounds/Statement.lean`, `GaloisCohomology/Statement.lean`, and `CMGoodModels/Statement.lean`), `StatementG.lean` (15 modules, here `GaussJetBounds/StatementG.lean`), `LevelOfCongruence.lean` (`ChainSlopeWindows/` vs `CapelliIdentities/`), `TopCovolSlim2Use.lean` (`ThirdPlaceSeries/` vs `HodgeBundleWeights/` vs `HilbertSamuelApplications/`), `LamLowOfPublished.lean` (`ThirdPlaceSeries/` vs `DivisorProofs/`), `IsResidueClassZero.lean` (`GrowthBounds/` vs `GlobalTheory/`), `DedekindZetaEqSumRealEisenstein.lean` (`HomogeneousIdeals/` vs `MirabolicInduction/`), `ChCore.lean` (`DedekindLFunctions/LandauTheorems/` vs `CompactIntegralFields/`), `RamificationTwoAndConjugationAtQAndD.lean` (`GlobalSchurBounds/` vs `GlobalRankLatticeProofs/` vs `LevelLetterCocycles/` vs `InertiaEigenvalues/`).
* **Local overload of `m` in `PowFourLeRpowNineHalves.lean`:** theorem `pow_four_le_rpow_nine_halves` (line 17) proves `(2r + 2)^4 ≤ (2r + 2)^{9/2}`, while `wBp_of` (line 106, local `m := 2 * P.r + 2` at line 134) bounds Bessel exponents `m^4 ≤ m^5` and `m^2 * a ≤ |Ca| * m^5` (distinct from `R.m` in `Params.lean`).
* **Metaprogramming module:** `Formalism/HermitianCurvature/HermitianCurvatureProofs/CutCptCopy.lean` is kept outside the mathematical declaration table as part of the source trust boundary.

## Primary Archive and Kernel Export Checksums

| Primary Artifact | SHA-256 |
|---|---|
| Concatenated source archive (`original.part01..14`, `175,187` modules) | `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc` |
| Uncompressed kernel export (`solution.ndjson`, `61.57 GB`) | `5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e` |
| Five-root reachability table (`verification/kernel_reachability_5roots.tsv.zst`) | `76b00059f4c146d6fc45a7332eb8c3205845e4599022f104a7f58c7f168d4b09` |
| `original.part01` | `86974b1c242ca7b6748f3299df4fc64ee0f6e06c776ac964fb64888101a3de77` |
| `original.part02` | `1c2a2477354a9dfa97ff1ce54861e96ed885bd456fffbaaabc2028314a229c42` |
| `original.part03` | `1465a23b1b579a881e24e5ffaf7c4c3727af28ea24741f1ec80e1d67947530a3` |
| `original.part04` | `3929e327eecb4e2c5c7cae30e104e6a4a52fa6b82d28325bcda8e9da1c86893b` |
| `original.part05` | `f25d7e80f7c4ad6d674aa18b323ca760f848857c8755501c149317c38a66c75d` |
| `original.part06` | `a8c651a68327811b37dce3cca8eda5e0b2102fa227c0d395cbb7553e4dd69939` |
| `original.part07` | `65c7e502a9b236a0f8d9e0aa6e089d4c09b9fc7a0960a149384063ccbe5e869` |
| `original.part08` | `71b027ad6e4179c3a50ce72921e3fec0a2dd751ec7472ac2c644ad145a50ec7e` |
| `original.part09` | `47718977ebaa8613f1647e93134479780db9320c5fa911463fd312a6257b96f` |
| `original.part10` | `1d85ece78e0779cec26b0cce29c6462d9f90180e56d78120b152df101715240b` |
| `original.part11` | `cf83a159d1a9540012229c376562587dd966da10cd657cbcef53acfd03232448` |
| `original.part12` | `1aa5415bd2db83b2689afeeb946419303b3c4f599ae790ad74d38465f768b502` |
| `original.part13` | `2de4edbce8ebdbfd0b94bc89bab518c7294209f408ec5b14a7be9e4832d9da81` |
| `original.part14` | `53f8ea43a9b5dcab97b84a52f3ac2848711c844a5420a4c56418093bacb3c6f6` |
