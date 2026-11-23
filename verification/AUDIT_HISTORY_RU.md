# Журнал многоконтурной верификации чертежа, указателя ядра и автономного модуля `Lean 4.33.1`

**Дата выпуска:** 23 ноября 2026 года · **Редакция чертежа:** `v9.0`  
**Автор чертежа, указателя и кода сопровождения:** И. М. Жук (`ORCID: 0009-0003-1670-8388`)

---

## 1. Первичная база проверки и граница ответственности

1. **Первичный формальный архив (Л. Альпёге и Claude, 20 ноября 2026 г.):**
   - `175 187` исходных модулей `Lean 4` (`17 374 215` строк, `239.28 МБ`, `SHA-256` слитного архива `original.part01..14`: `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc`).
   - Скомпилированный экспорт выражений ядра `solution.ndjson` (протокол Э. Сазерленда, MIT, https://math.mit.edu/~drew/grh/): `61 570 595 788` байт (`SHA-256`: `5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e`), `1 484 733` объявлений, из которых **`1 478 222`** достижимы в графе констант `Expr.const` от пяти корневых теорем `Main.lean` при опоре исключительно на стандартные аксиомы `propext`, `Classical.choice`, `Quot.sound` (`1 478 198` объявлений для классической `riemannHypothesis`).
2. **Граница ответственности настоящего репозитория:**
   - Скрипт [`verification/verify_blueprint.jl`](verify_blueprint.jl) не заменяет внешние чекеры ядра `Lean 4` (`leanchecker`, `lean4lean`, `nanoda`, `con-leche`) на `61.57 ГБ` экспорта.
   - В режиме `--full` он проверяет версию компилятора `lean --version` (`4.33.1`), заново распаковывает и сканирует все `175 187` модулей архива собственным покомпонентным анализатором областей видимости `Lean 4.33.1` (`namespace` / `section` / `end`), сверяет каждую из `240` записей указателя ([`KERNEL_INDEX_RU.md`](../blueprint/KERNEL_INDEX_RU.md) и [`KERNEL_INDEX_EN.md`](../blueprint/KERNEL_INDEX_EN.md)) с исходными строками и таблицей достижимости [`kernel_reachability_5roots.tsv.zst`](kernel_reachability_5roots.tsv.zst) (`1 484 733` объявлений ядра, пересобираемой скриптом [`build_kernel_reachability_tsv.jl`](build_kernel_reachability_tsv.jl)), проверяет все файловые ссылки и отдельные диапазоны строк в обеих языковых версиях полного чертежа и одностраничного доказательства, вычисляет конечные математические сертификаты на двух независимых базисах и компилирует модуль [`lean/HypercubeAndLPTheorems.lean`](../lean/HypercubeAndLPTheorems.lean).

---

## 2. Эволюция за 20 раундов перекрёстной ревизии (`v1.0 → v9.0`)

| Этап | Результат и устранённые классы ловушек |
|---|---|
| `v1.0 – v3.0` | Декомпиляция маршрута от `Main.lean` до локальных струй Гаусса и формулы Чоулы–Сельберга; выделение 4-стенного закона предельных показателей LP; построение задачи ранга $2$ над $\mathbb Q(\sqrt{-7})$ (Приложение А.3). |
| `v4.0` | Полный обход графа `Expr.const` экспорта `solution.ndjson` (`1 484 733` объявлений); переход от поиска по `import` и коротким подстрокам к проверке истинной достижимости в ядре; учёт четвёртой стены Бесселя $m^4 \le f$ в LP и точного множителя $(1 - 1/x)$ при выборе порога $X'/3$. |
| `v5.0 – v6.0` | Атомарная схема указателя `(полное_имя, единственный_файл, строка, export_id, 5-битная_маска)`; разделение одноимённых структур `SizeData₂`, трёх разных `MAIN`/`Main` и пар `BNBounds`/`BNBoundsU`; замена троичной сетки и угловых миноров на все `30` непустых главных миноров Сильвестра; создание словаря перегруженных обозначений (Приложение Б). |
| `v7.0` | Раскрытие перегрузки локального `m := 2r + 2` внутри `wBp_of` (`PowFourLeRpowNineHalves.lean:134`) и группового изоморфизма перестановки битов `toE` (`RecH.lean:10`, `ToEBij.lean:37`) между аддитивным носителем `E0 × H` и мультипликативным `Frame.GG`. |
| `v8.0` | Доказательство **теоремы ТНР о проекторах непрерывного гиперкуба $[0, 1]^4$** ($\operatorname{tr}(E - E^2) = \sum q_i(1-q_i) \implies$ ровно `8` проекторов и `6` ранга `2` на всём $[0, 1]^4$); двухсекционный указатель `198 + 6 = 204` живых записей ядра; проверка всех диапазонов после запятых; ненулевой свидетель `sum_Th` (`7/4` и `7/8`), квадратура Ромберга А.2 (`~1.12·10⁻²⁷`) и покомпонентный стек `Lean 4.33.1`. |
| `v8.1` | Разведение знаков центрирования главного характера $C_{\chi_0}(y) = C_1(y) - y b_N$ и $R_{\chi_0}(y) - C_{\chi_0}(y) = R_{\chi_0}(y) - C_1(y) + y b_N$; привязка имени поля к исходной строке и родительской `structure` в Таблице 2; полная сетка `2 003` целых и `6 002` дробных точек в А.3; все `6/6` фикстур живого `Lean 4.33.1`; перевод всех `34` выключных блоков формул в формат `$$ ... $$` для штатного рендеринга GitHub; включение `kernel_reachability_5roots.tsv.zst` и `build_kernel_reachability_tsv.jl`; доведение модуля [`lean/HypercubeAndLPTheorems.lean`](../lean/HypercubeAndLPTheorems.lean) до `34/34` публичных теорем (`0` импортов, `0 sorry`). |
| `v9.0` | Переход к журнальной классической прозе (`0` кода внутри фраз, дискретные блоки `*[Lean: ...]*`, чистка Анти-ИИ-Слоп по Правилам 1–6, сжатие медианы длины фраз с `40` до `14` слов); автономные 1-страничные доказательства (`ONE_PAGE_PROOF_{EN,RU}.{md,pdf}`); векторные схемы архитектуры и фазовой диаграммы LP; явный вывод поблочной индексации `DefFam.L` против барьера $2/3$ с точным тождеством $(m - t)^2(m + 2t)$, скорости Любина–Тейта высоты 2 $\ell/(\ell^2-1)$ с проверкой обращения Лагранжа до степени `81` и коллизий `ltLog` / `adm2`, четырёхзвенного сжатия Боста–Аракелова с общим положительным нормированным средним `SlopeMean`, точным разведением `Count5` / `EComp5` / `Data.DIV` и свидетелем `(Loss)` $(4, 3, 1)$, точной параметризацией каспидальных характеров `GlobalTheory.GLq.Green`, формулировкой дихотомии Ландау без глобального максимума и исправлением `partner(t, g)` с «инволюции» на биекцию с обратной `partner(-t, ·)` (`partner_not_involution_Z4`); расширение до **`233 + 7 = 240` записей ядра** (`104` модуля), **`44/44` теорем `Lean 4.33.1`**, **`31/31` ловушки**, полный разбор TeX-лога в `scripts/build_pdfs.py` и сравнительный разбор 8 репозиториев ([`COMPARISON_8_REPOS_RU.md`](COMPARISON_8_REPOS_RU.md)). |

---

## 3. Реестр 44 публичных теорем модуля `lean/HypercubeAndLPTheorems.lean`

Файл [`lean/HypercubeAndLPTheorems.lean`](../lean/HypercubeAndLPTheorems.lean) компилируется стандартным бинарником `Lean 4.33.1` без `Lake`, без `Mathlib` и без единого оператора `import`. Он формализует алгебраические, операторно-матричные, многогранные и решёточные ядра конечных утверждений чертежа (свёртка группового кольца при усреднении по конечной подгруппе и суммирование Абеля в А.1 изложены аналитически в тексте чертежа, а ранги матриц и положительная половина `81`-векторного контрпримера дополнительно проверяются в `Julia`):

| № | Теорема (`HypercubeAndLP.*`) | Точное формальное содержание | Аксиомы ядра |
|---:|---|---|---|
| 1 | `J4_sq` | $J_4^2 = -I_4$ над произвольным полем $K$ | `propext, Classical.choice, Quot.sound` |
| 2 | `clifford_relations` | Коммутирование $\Sigma_i$ с $J_4$ и соотношения $\Sigma_i\Sigma_j + \Sigma_j\Sigma_i = 2\delta_{ij} I_4$ | `propext, Classical.choice, Quot.sound` |
| 3 | `trace_bloch_sub_sq` | След $\operatorname{tr}(B - B^2) = 4(t - t^2 - e_1^2 - e_2^2 - e_3^2)$ для матрицы Блоха | `propext, Classical.choice, Quot.sound` |
| 4 | `invWalsh_left_inv` | Левая обратимость преобразования Уолша–Блоха | `propext, Classical.choice, Quot.sound` |
| 5 | `invWalsh_right_inv` | Правая обратимость преобразования Уолша–Блоха | `propext, Classical.choice, Quot.sound` |
| 6 | `directMat_eq_effectOp` | Поэлементное равенство прямой матрицы $(u, v, h, j)$ и оператора $E(q) = t I_4 + \sum e_i \Sigma_i$ | `propext, Classical.choice, Quot.sound` |
| 7 | `trace_E_sub_E_sq` | Тождество $\operatorname{tr}(E(q) - E(q)^2) = 4(t - t^2 - \|\mathbf e\|_2^2) = \sum_{i=1}^4 q_i(1-q_i)$ | `propext, Classical.choice, Quot.sound` |
| 8 | `hypercube_projector_is_boolean` | **Теорема жёсткости гиперкуба:** $q \in [0, 1]^4 \land E(q)^2 = E(q) \implies q \in \{0, 1\}^4$ | `propext, Classical.choice, Quot.sound` |
| 9 | `midslice_octahedron_touches_sphere_at_six_vertices` | На сечении $t = 1/2$: пересечение $\ell_1$-октаэдра со сферой $\|\mathbf e\|_2 = 1/2$ даёт `6` осевых вершин | `propext, Classical.choice, Quot.sound` |
| 10 | `outside_projector_counterexample` | Внешний проектор $P = \frac{1}{2}I_4 + \frac{3}{10}\Sigma_1 + \frac{2}{5}\Sigma_2$: $P^2=P$, прообраз $(-1/5, 3/5, 2/5, 6/5) \notin [0,1]^4$ | `propext, Classical.choice, Quot.sound` |
| 11 | `weakened_positivity_counterexamples` | Отрицательные свидетели $-3/64$ и $-1/64$ для троичной сетки и угловых миноров | `propext, Classical.choice, Quot.sound` |
| 12 | `hypercube_boolean_projector_counts` | Пересчёт на $\{0,1\}^4$: `16` вершин и распределение `(1, 0, 6, 0, 1)` для `boolIsProjector` | **нет аксиом (`0`)** |
| 13 | `four_wall_lower_bounds` | Четыре двойственные нижние границы 4-стенного закона LP над упорядоченным полем $K$ | `propext, Classical.choice, Quot.sound` |
| 14 | `four_wall_achievable` | Достижимость $\theta^*(p, q, \nu)$ при $a = 1 - \theta$ | `propext, Classical.choice, Quot.sound` |
| 15 | `four_wall_unique_at_5_4_2` | Единственность $(a, \kappa) = (1/2, 9/2)$ и четырёх значений при $(p, q, \nu) = (5, 4, 2)$ | `propext, Classical.choice, Quot.sound` |
| 16 | `four_wall_half_threshold` | Эквивалентность трёх нижних границ на $\nu$ условиям $\theta \le 1/2$ | `propext, Classical.choice, Quot.sound` |
| 17 | `bitSwap_left_inv` | Левая обратимость отображения перестановки битов | **нет аксиом (`0`)** |
| 18 | `bitSwap_right_inv` | Правая обратимость отображения перестановки битов | **нет аксиом (`0`)** |
| 19 | `bitSwap_hom` | Гомоморфизм перестановки битов `E0 × H ≃ Frame.GG` для произвольной операции на $H$ | **нет аксиом (`0`)** |
| 20 | `bitSwap_inPhi_iff_Psi` | Согласование `InPhi(g) ↔ Psi(bitSwap(g))` | `propext` |
| 21 | `bitSwap_places` | Образы четырёх выделенных меток `topPl`, `thickPl`, `cconj`, `sgc0` при перестановке битов | **нет аксиом (`0`)** |
| 22 | `unnormalized_sum_idempotent_iff` | Арифметическое ядро $k^2 = k \iff k = 1$ при $k > 0$ | `propext, Classical.choice, Quot.sound` |
| 23 | `scaled_projector_square` | Матричное тождество $(c P)^2 = c(c P)$ для любого $4\times 4$ проектора $P^2 = P$ над полем $K$ | `propext, Classical.choice, Quot.sound` |
| 24 | `scaled_projector_idem_iff` | Матричный критерий $(c P)^2 = c P \iff c = 1$ при $P^2 = P$, $P_{ij} \ne 0$ и $c \ne 0$ | `propext, Classical.choice, Quot.sound` |
| 25 | `bit_matrix_iff` | Эквивалентность `boolIsProjector` и матричного равенства $E^2 = E$ на всех `16` вершинах $\{0,1\}^4$ над `Rat` | `propext, Classical.choice, Quot.sound` |
| 26 | `octahedron_dual_iso_Q3` | Согласование смежности граней октаэдра $O_6$ и рёбер куба $Q_3$ + `2` кратчайших пути | `propext` |
| 27 | `faceToQ3_bijective` | Сюръективность и инъективность отображения `faceToQ3` на `Fin 8` | `propext, Quot.sound` |
| 28 | `powerSum_eq` | Равенство прямой суммы $\sum_{i=0}^{h-1}(2^i - 1)$ и рекурсии `dyadicRampDiff h` | `propext` |
| 29 | `dyadicRampDiff_closed` | Замкнутая индуктивная формула `dyadicRampDiff h + h + 1 = 2^h` для всех $h \in \mathbb N$ | `propext, Quot.sound` |
| 30 | `principal_centering_sign_identity` | Алгебраическое разведение знаков центрирования $C_{\chi_0} = C_1 - y b_N$ | `propext, Classical.choice, Quot.sound` |
| 31 | `a1_ceiling_optimality` | Поточечная целочисленная оценка $S \le \lceil W \rceil$ из $S < W + 1$ и $W \le \lceil W \rceil$ | `propext, Classical.choice, Quot.sound` |
| 32 | `a3_omega_closure_iff` | Эквивалентность делимостей $\omega$-замкнутости решётки над $\mathbb Z[(1+\sqrt{-7})/2]$ | `propext, Classical.choice, Quot.sound` |
| 33 | `a3_lattice_9_0_3_counterexample` | Свидетель существенности множителя $d$: $9 \mid 18$, но $(9\cdot 3) \nmid 18$ | `propext, Classical.choice, Quot.sound` |
| 34 | `compounding_barrier_two_thirds` | Барьер накопления по префиксу $\max(1-a, 2a) \ge 2/3$ с равенством тогда и только тогда, когда $a = 1/3$ | `propext, Classical.choice, Quot.sound` |
| 35 | `lubin_tate_height2_rate` | Нулевая скорость высоты 1 против скорости Любина–Тейта высоты 2 $1/(l-1) - 1/(l^2-1) = l/(l^2-1) > 0$ | `propext, Classical.choice, Quot.sound` |
| 36 | `lubin_tate_odd_power_sum` | Индуктивное тождество $(l/(l^2-1))(1 - l^{-2N}) = \sum_{j=0}^{N-1} l^{-(2j+1)}$ по нечётным степеням | `propext, Classical.choice, Quot.sound` |
| 37 | `lubin_tate_jet_valuation_bound` | Нижняя оценка струй $(r-s)/(l-1) - r/(l^2-1) \ge (l/(l^2-1))r - d_1$ | `propext, Classical.choice, Quot.sound` |
| 38 | `ramp_gain_split` | Переход к архимедовой рампе $\alpha - \min(\alpha, c) = \max(\alpha - c, 0)$ | `propext, Classical.choice, Quot.sound` |
| 39 | `arakelov_slope_chain_telescope` | Телескопическое сложение четырёх неравенств наклонов Боста–Аракелова `(Loss)+(Gain)+(Slope)+(Div)` с общим положительным нормированным средним `SlopeMean I K` | `propext, Classical.choice, Quot.sound` |
| 40 | `exact_envelope_gap_identities` | Точные зазоры $t^2 + m^2 - 2tm = (m-t)^2 \ge 0$ и $2t^3 + m^3 - 3t^2 m = (m-t)^2(m+2t) \ge 0$ | `propext, Classical.choice, Quot.sound` |
| 41 | `partner_shift_bijection` | Биекция `partnerMap f : G \ Φ → Φ` с обратной `partnerMap fInv` и сдвигом квадрата `f ∘ f` | `propext` |
| 42 | `partner_not_involution_Z4` | Универсальное опровержение на `E0 × Fin 4` (`t = 1`): `partner(1, partner(1, g)) ≠ g` для всех `16` элементов | `propext` |
| 43 | `loss_bounds_strict_witness` | Строгий свидетель `(Loss)` `(4, 3, 1)`: `4 - 3 ≤ 1`, но `¬(4 ≤ 3)` | `propext, Classical.choice, Quot.sound` |
| 44 | `non_vacuity_rat_witnesses` | Семь семейств рациональных и целых свидетелей выполнимости посылок над `Rat` и `Int` | `propext, Classical.choice, Quot.sound` |

## Предпубликационная проверка редакции 9.0

В архивном определении `ZeroBox` область без нулей лежит правее 399/400 в пределах заданной высоты. В одностраничном изложении восстановлен множитель $f=2n$ в оценке блока. В приложении А.2 внутренний интеграл оценён вместе с весом Меллина. Проверка выпуска сопоставляет адреса исходных объявлений в обеих редакциях по порядку и требует точного совпадения версии Lean.
