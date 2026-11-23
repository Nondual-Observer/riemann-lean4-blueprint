# Гипотеза Римана в Lean 4

[![Verify Blueprint & Lean 4](https://github.com/Nondual-Observer/riemann-lean4-blueprint/actions/workflows/verify.yml/badge.svg)](https://github.com/Nondual-Observer/riemann-lean4-blueprint/actions/workflows/verify.yml)
[![DOI препринта](https://zenodo.org/badge/DOI/10.5281/zenodo.24459320.svg)](https://doi.org/10.5281/zenodo.24459320)
[![DOI выпуска кода](https://zenodo.org/badge/DOI/10.5281/zenodo.24459582.svg)](https://doi.org/10.5281/zenodo.24459582)
[![Lean 4.33.1](https://img.shields.io/badge/Lean-4.33.1%20(0%20imports%2C%200%20sorry)-blue.svg)](lean/HypercubeAndLPTheorems.lean)
[![Julia 1.12+](https://img.shields.io/badge/Julia-1.12%2B%20stdlib%20(0%20deps)-9558B2.svg)](verification/verify_blueprint.jl)
[![Code License: Apache-2.0](https://img.shields.io/badge/Code-Apache--2.0-yellow.svg)](LICENSE)
[![Docs License: CC BY 4.0](https://img.shields.io/badge/Docs-CC%20BY%204.0-lightgrey.svg)](LICENSE-DOCS.md)

**[English version (README.md)](README.md)** · **[Доказательство на 1 странице PDF (`ONE_PAGE_PROOF_RU.pdf`)](blueprint/ONE_PAGE_PROOF_RU.pdf)** · **[На 1 странице (`ONE_PAGE_PROOF_RU.md`)](blueprint/ONE_PAGE_PROOF_RU.md)** · **[Полный чертёж (`BLUEPRINT_RU.md`)](blueprint/BLUEPRINT_RU.md)** · **[Полный PDF (`BLUEPRINT_RU.pdf`)](blueprint/BLUEPRINT_RU.pdf)** · **[Указатель 240 записей ядра (`KERNEL_INDEX_RU.md`)](blueprint/KERNEL_INDEX_RU.md)** · **[Модуль `Lean 4` (`44` теоремы)](lean/HypercubeAndLPTheorems.lean)** · **[Стенд `Julia`](verification/verify_blueprint.jl)** · **[Сравнение 8 репозиториев](verification/COMPARISON_8_REPOS_RU.md)** · **[Журнал верификации](verification/AUDIT_HISTORY_RU.md)** · **[Промпт ИИ-ревизора](prompts/AI_REFEREE_PROMPT_RU.md)**

---

## О проекте и разграничении ролей

20 ноября 2026 года Левент Альпёге опубликовал доказательство гипотезы Римана и её аналога для всех $L$-функций Дирихле, записанное совместно с Claude. Архив `Lean 4` содержит `175 187` файлов и `17 374 215` строк. По сообщению автора, автоматически развёрнутая запись заняла более `250 000` страниц. [Заметка автора](https://alpo.ge/remark.pdf) · [Сообщение Lean и Mathlib](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/)

Эндрю Сазерленд приводит результаты проверки скомпилированных модулей с помощью `leanchecker` и `lean4lean`. Полный экспорт `solution.ndjson` (`61.57 ГБ`) приняли `nanoda` и `con-leche`. Режим `--compare` сопоставляет пять утверждений `Main.lean` с исходными формулировками. В их списках аксиом встречаются только `propext`, `Classical.choice` и `Quot.sound`. [Протокол проверки в MIT](https://math.mit.edu/~drew/grh/)

Это издание прослеживает путь от оконной оценки суммы по степеням простых до утверждений о нулях на критической прямой. Каждая часть указывает объявления архива, на которые опирается переход.

1. **Формальное доказательство.** Левент Альпёге и Claude (2026) подготовили исходный архив из `175 187` модулей.
2. **Математическое изложение, сопроводительный модуль и верификационный стенд.** И. М. Жук, редакция 9.0; подготовлено в коллаборации с системами ИИ (Gemini и OpenAI Codex).
   - Пять шагов изложены [на одном листе (`blueprint/ONE_PAGE_PROOF_RU.md`)](blueprint/ONE_PAGE_PROOF_RU.md) и в [версии для печати (`blueprint/ONE_PAGE_PROOF_RU.pdf`)](blueprint/ONE_PAGE_PROOF_RU.pdf). В частях I–V [статьи (`blueprint/BLUEPRINT_RU.md`)](blueprint/BLUEPRINT_RU.md) приведены оценки, явные масштабы и порядок кванторов со ссылками на соответствующие объявления `Lean 4`. [Статья в печати, `12` стр. (`blueprint/BLUEPRINT_RU.pdf`)](blueprint/BLUEPRINT_RU.pdf)
   - В [указателе (`blueprint/KERNEL_INDEX_RU.md`)](blueprint/KERNEL_INDEX_RU.md) собраны `240` записей: `233` публичных объявления в `104` модулях и `7` полей структур или теорем Mathlib. Для каждой записи указаны `export_id` и пятибитная маска зависимостей в графе `Expr.const` из `1 484 733` объявлений, а одноимённые термы разведены по полному пространству имён.
   - [Сопроводительный модуль `Lean 4.33.1` (`lean/HypercubeAndLPTheorems.lean`)](lean/HypercubeAndLPTheorems.lean) компилируется с `0` импортов и `0 sorry`. Его `44` публичные теоремы формализуют классификацию проекторов $[0, 1]^4$, барьер $2/3$ и разность стоимостей $(m - t)^2(m + 2t)$, четырёхстенную задачу LP, скорости Любина–Тейта высот $2$ и $1$, среднее наклонов с общими весами, биекцию `partner` и семь семейств конкретных примеров над `Rat` и `Int`.
   - Проверочный стенд на стандартной библиотеке `Julia` без внешних пакетов ([`verification/verify_blueprint.jl`](verification/verify_blueprint.jl)) и построитель таблицы достижимости ([`verification/build_kernel_reachability_tsv.jl`](verification/build_kernel_reachability_tsv.jl)) выполняют `31` предпусковую проверку на подмену (`--self-gate`), автономно сверяют конечные расчёты, двуязычные ссылки и аксиомы `Lean 4.33.1` (`--portable`), а при наличии исходного архива сканируют все `175 187` модулей и `1 484 733` строки ядра (`--full`).

---

## Масштаб сжатия и опорные числа

| Уровень представления | Объём | Что проверяется |
|---|---|---|
| Распакованный ядерный экспорт `solution.ndjson` (протокол MIT) | `61.57 ГБ` (`1 065 214 335` выражений, `1 484 733` объявлений) | `1 478 222` достижимых объявления от `5` теорем `Main.lean`, `3` стандартные аксиомы |
| Таблица достижимости [`kernel_reachability_5roots.tsv.zst`](verification/kernel_reachability_5roots.tsv.zst) | `15.17 МиБ` (`1 484 733` строк `маска · id · имя`) | Включена в репозиторий (`SHA-256: 76b00059...`); пересобирается скриптом [`build_kernel_reachability_tsv.jl`](verification/build_kernel_reachability_tsv.jl) |
| Первичный архив исходников `Lean 4` (`original.part01..14`) | `239.28 МБ` (`175 187` файлов, `17 374 215` строк) | Полностью сканируется в режиме `--full` (`SHA-256: 9631b4f0...`) |
| Опорный позвоночник доказательства в [`KERNEL_INDEX_RU.md`](blueprint/KERNEL_INDEX_RU.md) | `104` модуля (`233` публичных объявления + `7` полей/Mathlib = **`240`** записей) | Точный путь, строка, категория, `export_id`, 5-битная маска корней, двуязычный паритет ссылок и диапазонов |
| Одностраничное доказательство [`ONE_PAGE_PROOF_RU.md`](blueprint/ONE_PAGE_PROOF_RU.md) | `1` печатная страница (`ONE_PAGE_PROOF_RU.pdf`) | Все пять этапов, скорость Любина–Тейта высоты 2, 4-звенное сжатие Боста–Аракелова, закон LP |
| Математический чертёж [`BLUEPRINT_RU.md`](blueprint/BLUEPRINT_RU.md) | `12` печатных страниц (`BLUEPRINT_RU.pdf`) | Панорама, Основная теорема, Части I–VI, Приложения А.1–А.3, словарь перегрузок Б, две векторные схемы |
| Автономный модуль [`HypercubeAndLPTheorems.lean`](lean/HypercubeAndLPTheorems.lean) | `0` импортов, `0` внешних библиотек, `0 sorry` | `44/44` публичных теорем + проверка `#print axioms` и семи семейств свидетелей над `Rat` и `Int` |

---

## Архитектура классического доказательства (Части I–V)

Аналитическая редукция сводит гипотезу Римана к односторонней верхней оценке $G_{\mathcal F}(x) \le x^{1/2 + O(\varepsilon)}$ на сколь угодно далёких мультипликативных окнах $[Z, Z^{3/2}]$ без условий на знак между окнами:

![Архитектура формального доказательства](assets/fig1_architecture_ru.svg)

**Примечание к рисунку 1.** В $(\mathrm{Div})$ первый член справа равен $S_{\rm div}$. Величина $\mathrm{Data.Main}$ появляется после объединения оценки числа слов с оценкой высоты в части IV. Лестница содержит $m$ сигнатур и $m-1$ подъёмов.

![Преодоление барьера 2/3 и четырёхстенный закон LP](assets/fig2_balance_lp_ru.svg)

**Рисунок 2(а).** Красная пунктирная прямая показывает показатель $2a$ суммы $\sum_{j=1}^{m}j=m(m+1)/2\sim m^2/2$.

1. **Исключение нулей на окне (Часть I).** Зафиксируем конечное допустимое семейство $\mathcal F = \{(a_i, \chi_i)\}$ с весами $a_i > 0$, содержащее целевой характер $\psi$ (без непримитивных главных характеров). Преобразование Меллина $\Phi(s)$ функции $G_{\mathcal F}(y)$ регулярно в $s = 1$; положительность весов исключает взаимное сокращение вычетов и даёт положительный вычет в вещественном нуле $\rho \in (0, 1)$. После замены $u = \log y$ гамма-плотность $\frac{\sigma^{k+1}}{k!} u^k e^{-\sigma u}\,du$ сосредоточивает $D_k(z) = (-1)^k\Phi^{(k)}(z)/k!$ на $[U, (1+\delta)U]$ вблизи $k/\sigma$. Оценка $G_{\mathcal F}(y) \le C y^\theta$ на сколь угодно далёких окнах $[Z, Z^{3/2}]$ ($\delta = 1/2$) исключает полюсы при $\Re s > \theta$: на вещественном луче через $\Re D_k(\sigma)$, а при сдвиге через выделение ближайшего полюса и сравнение $|D_k(\sigma + iv)|$ с $\Re D_k(\sigma)$.
2. **Отбор целевых характеров (Часть II).** На каждом окне $[Z, Z^{3/2}]$ одна пара простых $(q, d)$ ($q \equiv 3 \bmod 8$, $d \equiv 7 \bmod 16$) обслуживает сразу все $x \in [Z, Z^{3/2}]$. Над вещественным этажом степени $n = c\,2^e \asymp x^{2+8\varepsilon}$ ($1 \le c \le \operatorname{ord}(\psi)$) CM-поле $E$ имеет степень $[E:\mathbb Q] = 4n$ и группу Галуа $G = E_0 \times H$, где $E_0 = (\mathbb Z/2\mathbb Z)^2$ и $|H| = n$. Биекция $\mathrm{partner}(t, g) = \mathrm{cconj} + g + \mathrm{topPl}(t)$ из $G \setminus \Phi$ на $\Phi$ (с обратной $\mathrm{partner}(-t, \cdot)$, не инволюция при $2t \ne 0$) даёт тождество $\mathrm{ASK} - \mathrm{MAIN} = \mathrm{De}$, где в $\mathrm{ASK}$ срезки входят с кратностью два по нечётным степеням инертных простых вне $\{2, q, d\}$ вместе с отдельной суммой с множителем $\log d$ в простом $d$. Усреднение по $A_0 \le H$ выделяет аннулятор $\Psi_A$, а оценка $\Psi_A \setminus K_p$ сводит $G_{\mathcal F}(x) \le x^{1/2 + (e_D + e_L + 7)\varepsilon}$ на $[Z, Z^{3/2}]$ к оценке $\mathrm{gap}_A(u_0) = \sum (\mathrm{ASK} - \Re\,\mathrm{MAIN})$.
3. **Нечётные степени и высота $2$ (Часть III).** Унитарная лестница проходит $m \asymp x^{1/2-\varepsilon/16}$ сигнатур $(k + j - 1, m - j)$ ($1 \le j \le m$, $k \asymp x^{9/2+10\varepsilon}$) за $m - 1$ подъёмов и завершается в определённой сигнатуре $(r, 0)$ при $r = k + m - 1$. В хорошем простом $\ell \ge 5$, инертном в $\mathbb Q(\sqrt{-d})$, суперсингулярная редукция имеет формальную группу высоты $2$: показатель $\ell$ в знаменателях ряда, обратного к $\mathrm{ltLog}(X) = \sum_{j \ge 0} X^{\ell^{2j}}/\ell^j$, растёт со скоростью не выше $1/(\ell^2 - 1)$ против факториальной скорости Лежандра $1/(\ell - 1)$, давая чистую делимость $\gamma_\ell = \frac{1}{\ell - 1} - \frac{1}{\ell^2 - 1} = \frac{\ell}{\ell^2 - 1} = \sum_{e\,\text{нечётно}} \ell^{-e}$ (тогда как в расщеплённых простых высота равна $1$ и разность равна $0$). Усечение $\alpha - \min(\alpha, c) = \max(\alpha - c, 0)$ порождает срезки в $\mathrm{ASK}$.
4. **Сопоставление наклонов и выбор показателей (Часть IV).** Усреднение $(\mathrm{Gain})$ и $(\mathrm{Div})$ при фиксированном $u_0$ с одними и теми же положительными весами рангов сокращает среднюю высоту, $(\mathrm{Slope})$ исключает фактор-наклон, а $(\mathrm{Loss})$ удерживает местную потерю $\mathrm{LoP}$; на ступени $(r, 0)$ сокращаются $\pm\mathrm{Fo}(u_0)$ и $\pm\mu(P_{u_0})$. Оценка $\log T(u_0, u)$ снизу подсчётом слов и формула Чоулы–Сельберга $\log\Omega_{\mathrm{val}} = \gamma + \log(2\pi/\mathrm{rd}(E)) - \Re(L'/L)(1, \chi_{-d})$ переводят $S_{\rm div}$ в $\mathrm{Data.Main}(u_0) = \sum_{t, j} \Re\,\mathrm{MAIN}$. Поскольку $m$ блоков $F.\mathrm{L}_{j,t}$ делят общий запас $O(f m b x^\varepsilon)$ ($f = 2n$) вместо последовательного накопления $\sum_{j=1}^m j \asymp m^2$, барьер $\min_m(x/m + m^2) = 3(x/2)^{2/3}$ сменяется суммой $x/m + m$, а четырёхстенная задача LP для $m = x^a, k = x^\kappa, n = x^\nu$ в точке $(p, q, \nu) = (5, 4, 2)$ имеет единственный оптимум $(a, \kappa) = (1/2, 9/2)$, дающий $G_{\mathcal F}(x) \le x^{1/2 + (e_D + e_L + 7)\varepsilon}$.
5. **Спуск к пяти теоремам `Main.lean` (Часть V).** Переход к $\theta \downarrow 1/2$ и $\varepsilon \downarrow 0$ при фиксированном семействе $\mathcal F \ni \psi$ доказывает $L(s, \chi) \ne 0$ при $\Re s > 1/2$ (если $\chi \ne 1$ или $s \ne 1$). Отделение конечного числа эйлеровых множителей в полосе $0 < \Re s < 1$ и отражение примитивного функционального уравнения $s \leftrightarrow 1 - s$ исключают область $0 < \Re s < 1/2$, оставляя $\Re s = 1/2$.

### Критические ловушки сырого архива, снятые в указателе
- **Коллизии коротких имён и файлов:** `26` различных живых объявлений `adm2` в разных пространствах имён, два разных ряда `ltLog` (высоты 2 в `CMGoodModels/Statement.lean:35` против высоты 1 в другом модуле), два разных `SizeData₂`, три разных `MAIN` / `Data.Main`, различие `BNBounds` (произвольная конечная абелева $H$) и `BNBoundsU`, различие предиката `PairEx` и теоремы `QH.pairEx`, `86` файлов `Statement.lean`, `15` файлов `StatementG.lean`, четыре файла `RamificationTwoAndConjugationAtQAndD.lean`, два `ChCore.lean`, а также определение `sg`, отсутствующее в скомпилированном экспорте ядра.
- **Локальная перегрузка букв:** в `PowFourLeRpowNineHalves.lean:134` переменная `m := 2 * P.r + 2` обозначает размерность бесселевой сетки внутри `wBp_of`, а не число сигнатур `R.m` из `Params.lean`.
- **Перестановка битов между носителями:** переход между аддитивным носителем `E0 × H` (`PartnersToFactorsAt.lean`) и мультипликативным `Frame.GG` (`DataHost.lean`) задаётся групповым изоморфизмом `toE` (`RecH.lean:10`, `ToEBij.lean:37`), переставляющим первые два бита (`(a₁, a₂) ↦ ((-1)^{a₂}, (-1)^{a₁})`).

---

## Второстепенные исследовательские арки (Часть VI и Приложение А.3)

Классическое изложение доказательства полностью сосредоточено и замкнуто в **Частях I–V**. Две дополнительные исследовательские линии строго отделены от основного маршрута и снабжены явной маркировкой статуса утверждений:

1. **Структурные сопоставления с Теорией Наблюдаемого Различения (ТНР, Часть VI) и теорема о жёсткости гиперкуба $[0, 1]^4$:**
   - Инволюция функционального уравнения $s \leftrightarrow 1 - s$ на критической прямой слепа к симметричным четвёркам нулей $\frac{1}{2} \pm \sigma \pm i\gamma$ точно так же, как булево дополнение $q \mapsto 1 - q$ на четырёхмерном кубе $[0, 1]^4$ слепо к парам весов $(1, 3)$; выделение середины в обеих задачах требует отдельного **конуса положительности**.
   - В § VI.1 аналитически и формально в [`lean/HypercubeAndLPTheorems.lean`](lean/HypercubeAndLPTheorems.lean) доказана **теорема о проекторах непрерывного гиперкуба $[0, 1]^4$**: в силу тождества Уолша–Блоха
     $$\operatorname{tr}\bigl(E(q) - E(q)^2\bigr) = 4\bigl(t - t^2 - \|\mathbf e\|_2^2\bigr) = \sum_{i=1}^4 q_i(1 - q_i)$$
     в образе всего непрерывного гиперкуба $[0, 1]^4$ нет ни одного дополнительного ортогонального проектора. Их ровно **`8`** ($0$, $I_4$ и строго **`6`** проекторов вещественного ранга $2$, образующих вершины правильного $\ell_1$-октаэдра $O_6$, вписанного в сферу Блоха $\|\mathbf e\|_2 = 1/2$), тогда как непрерывная сфера проекторов возникает лишь во всём операторном интервале Клиффорда $0 \le E \le I_4$ за пределами $[0, 1]^4$.
   - Основной открытый репозиторий Теории Наблюдаемого Различения (ТНР): [канонический открытый репозиторий](https://github.com/Nondual-Observer/DOTheory).
2. **Открытая задача ранга $2$ над $\mathbb Q(\sqrt{-7})$ (Приложение А.3):**
   - Гипотезы о критической прямой для $\zeta(s)$ и $L(s, \chi_{-7})$ вместе равносильны оконной оценке одного целого определителя нормы идеала $N I_{M_j}(j)$ размера $2 \times 2$. В `Julia` проверены определители до `7 079` бит. Прямой вывод этой оценки без башни тета-подъёмов ранга $\asymp x^{9/2}$ остаётся открытой задачей.

---

## Быстрый старт и воспроизведение проверок

Требования: `Lean 4.33.1` (через `elan`, автоматически читает [`lean-toolchain`](lean-toolchain)) и стандартный `Julia 1.12+` (**ноль внешних пакетов**). Для полного режима `--full` дополнительно требуются стандартные системные утилиты `cat`, `gzip` и `zstd`, а также локальная папка `RH_ARCHIVE_DIR`, содержащая 14 частей авторского архива под именами `original.part01` … `original.part14` (либо слитный `original.tar.gz` с суммой `SHA-256 = 9631b4f0...`; таблица достижимости [`verification/kernel_reachability_5roots.tsv.zst`](verification/kernel_reachability_5roots.tsv.zst) уже включена в репозиторий и при желании пересобирается из `solution.ndjson` скриптом [`verification/build_kernel_reachability_tsv.jl`](verification/build_kernel_reachability_tsv.jl)).

```bash
# 1. Проверка криптографической целостности всех файлов репозитория:
shasum -a 256 -c SHA256SUMS.txt

# 2. Прямая компиляция автономного модуля Lean 4.33.1 (0 импортов, 0 sorry, 44/44 #print axioms):
lean lean/HypercubeAndLPTheorems.lean

# 3. Предпусковой контроль 31 враждебной ловушки (включая живой Lean 4.33.1):
OPENBLAS_NUM_THREADS=1 JULIA_NUM_THREADS=1 JULIA_LOAD_PATH=@stdlib \
  julia --startup-file=no -t1 verification/verify_blueprint.jl --self-gate

# 4. Переносная проверка конечной математики, двуязычного покрытия и аксиом Lean 4 (без архива Альпёге):
OPENBLAS_NUM_THREADS=1 JULIA_NUM_THREADS=1 JULIA_LOAD_PATH=@stdlib \
  julia --startup-file=no -t1 verification/verify_blueprint.jl --portable

# 5. Полное сканирование 175 187 модулей и 1 484 733 объявлений ядра (при наличии original.part01..14):
OPENBLAS_NUM_THREADS=1 JULIA_NUM_THREADS=1 JULIA_LOAD_PATH=@stdlib \
  RH_ARCHIVE_DIR=/путь/к/архиву julia --startup-file=no -t1 verification/verify_blueprint.jl --full
```

---

## Структура репозитория

```text
├── .github/workflows/verify.yml                 # Автоматический CI (Lean 4.33.1 + Julia stdlib + SHA-256)
├── README.md                                    # Англоязычный обзор (EN)
├── README_RU.md                                 # Русскоязычный обзор, архитектура и быстрый старт (RU)
├── CITATION.cff                                 # Метаданные цитирования (CFF 1.2.0)
├── LICENSE                                      # Apache License 2.0 (для кода на Lean 4, Julia и скриптов)
├── LICENSE-DOCS.md                              # CC BY 4.0 (для текста чертежей, таблиц и схем)
├── lean-toolchain                               # Фиксация компилятора leanprover/lean4:v4.33.1
├── assets/
│   ├── octahedron_borromean_emblem.png          # Исходник аватарки профиля (вне текста статей)
│   ├── social_preview_1280x640.png              # Карточка ссылок 2:1 (Open Graph / X / Discord)
│   ├── fig1_architecture_{en,ru}.{svg,pdf}      # Векторная схема архитектуры доказательства
│   └── fig2_balance_lp_{en,ru}.{svg,pdf}        # Векторная диаграмма преодоления барьера 2/3 и закона LP
├── blueprint/
│   ├── ONE_PAGE_PROOF_EN.md                     # Автономное доказательство на 1 странице (EN)
│   ├── ONE_PAGE_PROOF_EN.pdf                    # Печатный лист строго на 1 страницу (EN)
│   ├── ONE_PAGE_PROOF_RU.md                     # Автономное доказательство на 1 странице (RU)
│   ├── ONE_PAGE_PROOF_RU.pdf                    # Печатный лист строго на 1 страницу (RU)
│   ├── BLUEPRINT_EN.md                          # Полный математический чертёж (Части I–VI, Приложения A–B, EN)
│   ├── BLUEPRINT_EN.pdf                         # Печатный PDF из BLUEPRINT_EN.md (11 стр.)
│   ├── BLUEPRINT_RU.md                          # Полный математический чертёж (Части I–VI, Приложения А–Б, RU)
│   ├── BLUEPRINT_RU.pdf                         # Печатный PDF из BLUEPRINT_RU.md (12 стр.)
│   ├── KERNEL_INDEX_EN.md                       # Указатель 240 записей ядра Lean 4 и реестр коллизий (EN)
│   └── KERNEL_INDEX_RU.md                       # Указатель 240 записей ядра Lean 4 и реестр коллизий (RU)
├── lean/
│   └── HypercubeAndLPTheorems.lean              # Автономный модуль Lean 4.33.1 (0 импортов, 0 sorry, 44 теоремы)
├── scripts/
│   ├── build_figures.py                         # Генератор векторных фигур SVG/PDF
│   ├── build_pdfs.py                            # Сборка PDF (Pandoc, Tectonic и pdfinfo или pypdf)
│   ├── blueprint_pdf.lua                        # Lua-фильтр Pandoc для переносов имён Lean 4 и рамок теорем
│   └── blueprint_header.tex                     # Академическая преамбула XeLaTeX/Tectonic (CMU Serif + DejaVu Mono)
├── verification/
│   ├── verify_blueprint.jl                      # Единый stdlib-верификатор на чистом Julia
│   ├── build_kernel_reachability_tsv.jl         # Построитель таблицы достижимости 5 корней из solution.ndjson
│   ├── kernel_reachability_5roots.tsv.zst       # Таблица достижимости 1 484 733 строк (SHA-256: 76b00059...)
│   ├── COMPARISON_8_REPOS_EN.md                 # Сравнительный разбор 8 открытых репозиториев (EN)
│   ├── COMPARISON_8_REPOS_RU.md                 # Сравнительный разбор 8 открытых репозиториев (RU)
│   ├── AUDIT_HISTORY_EN.md                      # Журнал верификации и реестр 44 теорем Lean 4 (EN)
│   └── AUDIT_HISTORY_RU.md                      # Журнал верификации и реестр 44 теорем Lean 4 (RU)
├── prompts/
│   ├── AI_REFEREE_PROMPT_EN.md                  # Промпт для независимого ИИ-ревизора (EN)
│   └── AI_REFEREE_PROMPT_RU.md                  # Промпт для независимого ИИ-ревизора (RU)
└── SHA256SUMS.txt                               # Криптографический манифест всех файлов репозитория
```

---

## Первоисточники и литература

1. **L. Alpöge** (with Claude), Авторское сообщение, приложенное к архиву доказательства, Nov 20, 2026: https://alpo.ge/remark.pdf (`SHA-256` архива исходников: `9631b4f020199e580ba86178cb56c6e9b09f690c2369a80dc4334aa93f49c7fc`).
2. **A. V. Sutherland** (MIT), *Verification files for the Lean proof of the Riemann Hypothesis*, Nov 2026: https://math.mit.edu/~drew/grh/ (`SHA-256` распакованного экспорта `solution.ndjson`: `5ea74b912147c5c93cc2b6d70cc727cf908df2f62ac6a20480a3fa02f6be244e`).
3. **Сообщества Lean и Mathlib**, *Lean verification of the Riemann Hypothesis*, ноябрь 2026: https://leanprover-community.github.io/blog/posts/riemann-hypothesis/.
4. **E. Landau**, *Über einen Satz von Tschebyschef*, Math. Ann. **61** (1905), 527–550.
5. **S. Chowla, A. Selberg**, *On Epstein's zeta-function*, J. Reine Angew. Math. **227** (1967), 86–110.
6. **S. S. Kudla, J. J. Millson**, *Intersection numbers of cycles on locally symmetric spaces and Fourier coefficients of holomorphic modular forms in several complex variables*, Publ. Math. IHÉS **71** (1990), 121–172; **R. E. Borcherds**, *Automorphic forms with singularities on Grassmannians*, Invent. Math. **132** (1998), 491–562.
7. **L. Grenié, G. Molteni**, *Explicit versions of the prime ideal theorem for Dedekind zeta functions under GRH*, Math. Comp. **85** (2016), 889–906 (`arXiv:1312.4463`); **L. Faber, H. Kadiri**, *New bounds for $\psi(x)$*, Math. Comp. **84** (2015), 1339–1357 ([arXiv:1310.6374](https://arxiv.org/abs/1310.6374), с поправкой 2018 года).
8. **P. Massot**, *leanblueprint*; **A. Kontorovich, T. Tao et al.**, *PrimeNumberTheoremAnd* (`Lean 4` blueprint project).
9. **И. М. Жук**, *Теория Наблюдаемого Различения (ТНР)*: [канонический открытый репозиторий](https://github.com/Nondual-Observer/DOTheory).

---

## Цитирование и авторство

- **Автор математического чертежа, указателя ядра, автономного модуля `Lean 4` и верификационного кода:** Игорь Михайлович Жук · [ORCID `0009-0003-1670-8388`](https://orcid.org/0009-0003-1670-8388) · [GitHub `@Nondual-Observer`](https://github.com/Nondual-Observer).
- **Коллаборация с ИИ:** Исходный формальный архив из `175 187` модулей создан Левентом Альпёге совместно с Claude (20 ноября 2026 года); настоящее математическое изложение, указатель из `240` записей ядра, модуль `Lean 4.33.1` из `44` теорем и стенд проверки на `Julia` подготовлены в коллаборации с системами ИИ (Gemini и OpenAI Codex), а все цитируемые объявления, формальные теоремы и конечные расчёты проверены компилятором и программными тестами.
- **Препринт на Zenodo (редакция чертежа `9.0`, 4 PDF):** общий DOI всех редакций [`10.5281/zenodo.24459320`](https://doi.org/10.5281/zenodo.24459320) (актуальный выпуск `v9.0.1`: [`10.5281/zenodo.24459946`](https://doi.org/10.5281/zenodo.24459946)).
- **Программный выпуск на Zenodo (`v1.0.0`):** [DOI `10.5281/zenodo.24459582`](https://doi.org/10.5281/zenodo.24459582).
- Программный выпуск `1.0.0` сопровождает редакцию статьи `9.0`. Реквизиты для библиографических менеджеров приведены в файле [`CITATION.cff`](CITATION.cff). Код распространяется по лицензии [`Apache-2.0`](LICENSE), документация по лицензии [`CC BY 4.0`](LICENSE-DOCS.md).
