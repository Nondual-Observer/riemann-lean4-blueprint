#!/usr/bin/env python3
"""
Deterministic vector figure generator (SVG for GitHub Markdown + PDF for XeLaTeX/Tectonic)
for Edition 9.0 of the Riemann Hypothesis Lean 4 Blueprint.
Produces strictly monolingual English and Russian editions of:
  - assets/fig1_architecture_{en,ru}.{svg,pdf}
  - assets/fig2_balance_lp_{en,ru}.{svg,pdf}
Note: the bundled assets/ files retain the frozen initial release layout (clarified
by the captions under Figures 1 and 2), while this generator already incorporates
the updated in-diagram labels (`S_{\mathrm{div}}`, `signatures`, `m^2/2`).
"""

import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch, FancyArrowPatch

HERE = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(HERE)
ASSETS = os.path.join(REPO_ROOT, "assets")

plt.rcParams.update({
    "font.family": "DejaVu Sans",
    "mathtext.fontset": "dejavusans",
    "svg.fonttype": "path",
    "pdf.fonttype": 42,
})


def draw_box(ax, x, y, w, h, title, body, edge_col, fill_col, title_col=None, title_fs=9.6, body_fs=8.3):
    if title_col is None:
        title_col = edge_col
    patch = FancyBboxPatch(
        (x, y), w, h,
        boxstyle="round,pad=0.012,rounding_size=0.022",
        linewidth=1.35,
        edgecolor=edge_col,
        facecolor=fill_col,
        zorder=2,
    )
    ax.add_patch(patch)
    ax.text(
        x + w / 2.0, y + h - 0.036,
        title,
        ha="center", va="top",
        fontsize=title_fs, fontweight="bold", color=title_col, zorder=3,
    )
    ax.text(
        x + w / 2.0, y + (h - 0.055) * 0.46,
        body,
        ha="center", va="center",
        fontsize=body_fs, color="#1E293B", linespacing=1.32, zorder=3,
    )


def draw_arrow(ax, x0, y0, x1, y1, color="#334155", rad=0.0):
    arr = FancyArrowPatch(
        (x0, y0), (x1, y1),
        arrowstyle="-|>,head_length=6.5,head_width=4.0",
        connectionstyle=f"arc3,rad={rad}",
        linewidth=1.35,
        color=color,
        zorder=4,
    )
    ax.add_patch(arr)


def build_fig1(lang: str) -> None:
    fig, ax = plt.subplots(figsize=(10.4, 5.55))
    ax.set_xlim(0.0, 1.0)
    ax.set_ylim(0.0, 1.0)
    ax.axis("off")

    if lang == "en":
        header = "Architecture of the Formal Proof: From Theta-Lift Lattices to the Critical Line"
        b_left_t = "Local Ultrametric Supply (Parts IIb-III)"
        b_left_b = (
            "Supersingular CM formal group of height 2 (ltLog, CM2, CM3)\n"
            + r"Jet gain $v_\ell(r!\,c_r) \geq \frac{\ell}{\ell^2 - 1}\,r - (\log_\ell r + 1)$ (LemmaSt)"
            + "\nOdd inert prime powers + Smith normal form (SmithExists)"
        )
        b_right_t = "Global Theta Ladder & Windows (Parts IIa, III)"
        b_right_b = (
            r"$m \asymp x^{1/2-\varepsilon/16}$ signatures $(k+j-1,\,m-j) \to (r,0)$, $k \asymp x^{9/2+10\varepsilon}$"
            + "\nCM tower " + r"$[E:\mathbb{Q}] = 4n \asymp x^{2+8\varepsilon}$" + ", single pair $(q,d)$ on $[Z, Z^{3/2}]$\n"
            + "Three top inputs: Green + VWin + Nonempty(HypsAlt)"
        )
        b_mid1_t = "Heart of the Proof: Four-Clause Bost-Arakelov Slope Squeeze (Parts III-IV)"
        b_mid1_b = (
            r"(Loss) $\mathrm{ASK} - \mathrm{Ga} \leq \mathrm{LoP}$   $\cdot$   "
            + r"(Gain) $\mu(M_u) + \mathrm{Ga} + \mathrm{Fo} - \mathrm{Ee} - \mathrm{Lo}_5 \leq \mu(N_u)$   $\cdot$   "
            + r"Block-local DefFam.L ($E_b \approx m B_0$)"
            + "\n"
            + r"(Slope / TheoremF) $\overline{\mu} - \log|W| - \mathrm{Err}_{\mathrm{HN}} \leq \mu(P_{u_0})$   $\cdot$   "
            + r"(Div / Chowla-Selberg) $\mu(P_{u_0}) + h - \mathrm{Fo} \leq S_{\mathrm{div}} - \Sigma a_t\log T + \mathrm{Err}_{\mathrm{Div}}$"
        )
        b_mid2_t = "Harmonic Isolation on G = E0 x H & Main-Term Cancellation (Parts IIa, IV)"
        b_mid2_b = (
            r"Exact balance $\mathrm{ASK} - \mathrm{MAIN} = \mathrm{De}$ (ch_balance)  $\longrightarrow$  "
            + r"Subgroup projector $\Pi_{A_0}$ (sum_Th) isolates $\Psi_A$, tail sigA_le"
            + "\n"
            + r"Identity $\mathrm{Data.Main}(u) = \sum_{t,j}\mathrm{Re}\,\mathrm{MAIN}$ (ch_top_main_eq)  $\Longrightarrow$  "
            + r"$G_{\mathcal{F}}(x) \leq x^{1/2 + (e_D + e_L + 7)\varepsilon}$ on windows $[Z, Z^{3/2}]$ (core_gm)"
        )
        b_bot_t = "Windowed Landau Criterion Without Global Sign & Reflection (Parts I, V -> Main.lean)"
        b_bot_b = (
            r"Gamma-concentrated derivatives $D_k(\sigma + iv)$ force $\mathrm{ZeroFree}(\mathrm{Re}\,s > \theta)$ for all $\theta > 1/2$ (zeroFree_of_rpow_window)"
            + "\n"
            + r"Imprimitive Euler factors (ClaimStrip) + functional equation $s \leftrightarrow 1 - s$  $\Longrightarrow$  "
            + "All 5 Root Theorems in Main.lean"
        )
    else:
        header = "\u0410\u0440\u0445\u0438\u0442\u0435\u043a\u0442\u0443\u0440\u0430 \u0444\u043e\u0440\u043c\u0430\u043b\u044c\u043d\u043e\u0433\u043e \u0434\u043e\u043a\u0430\u0437\u0430\u0442\u0435\u043b\u044c\u0441\u0442\u0432\u0430: \u043e\u0442 \u0440\u0435\u0448\u0451\u0442\u043e\u043a \u0442\u0435\u0442\u0430-\u043f\u043e\u0434\u044a\u0451\u043c\u043e\u0432 \u043a \u043a\u0440\u0438\u0442\u0438\u0447\u0435\u0441\u043a\u043e\u0439 \u043f\u0440\u044f\u043c\u043e\u0439"
        b_left_t = "\u041b\u043e\u043a\u0430\u043b\u044c\u043d\u044b\u0439 \u0443\u043b\u044c\u0442\u0440\u0430\u043c\u0435\u0442\u0440\u0438\u0447\u0435\u0441\u043a\u0438\u0439 \u0437\u0430\u043f\u0430\u0441 (\u0427\u0430\u0441\u0442\u0438 II\u0431-III)"
        b_left_b = (
            "\u0421\u0443\u043f\u0435\u0440\u0441\u0438\u043d\u0433\u0443\u043b\u044f\u0440\u043d\u0430\u044f CM-\u0444\u043e\u0440\u043c\u0430\u043b\u044c\u043d\u0430\u044f \u0433\u0440\u0443\u043f\u043f\u0430 \u0432\u044b\u0441\u043e\u0442\u044b 2 (ltLog, CM2, CM3)\n"
            + "\u0412\u044b\u0438\u0433\u0440\u044b\u0448 \u0441\u0442\u0440\u0443\u0439 " + r"$v_\ell(r!\,c_r) \geq \frac{\ell}{\ell^2 - 1}\,r - (\log_\ell r + 1)$ (LemmaSt)"
            + "\n\u041d\u0435\u0447\u0451\u0442\u043d\u044b\u0435 \u0441\u0442\u0435\u043f\u0435\u043d\u0438 \u0438\u043d\u0435\u0440\u0442\u043d\u044b\u0445 \u043f\u0440\u043e\u0441\u0442\u044b\u0445 + \u0444\u043e\u0440\u043c\u0430 \u0421\u043c\u0438\u0442\u0430 (SmithExists)"
        )
        b_right_t = "\u0413\u043b\u043e\u0431\u0430\u043b\u044c\u043d\u0430\u044f \u043b\u0435\u0441\u0442\u043d\u0438\u0446\u0430 \u0441\u0438\u0433\u043d\u0430\u0442\u0443\u0440 \u0438 \u043e\u043a\u043d\u0430 (\u0427\u0430\u0441\u0442\u0438 II\u0430, III)"
        b_right_b = (
            r"$m \asymp x^{1/2-\varepsilon/16}$ " + "\u0441\u0438\u0433\u043d\u0430\u0442\u0443\u0440 " + r"$(k+j-1,\,m-j) \to (r,0)$, $k \asymp x^{9/2+10\varepsilon}$"
            + "\nCM-\u0431\u0430\u0448\u043d\u044f " + r"$[E:\mathbb{Q}] = 4n \asymp x^{2+8\varepsilon}$" + ", \u043e\u0434\u043d\u0430 \u043f\u0430\u0440\u0430 $(q,d)$ \u043d\u0430 $[Z, Z^{3/2}]$\n"
            + "\u0422\u0440\u0438 \u0433\u043b\u043e\u0431\u0430\u043b\u044c\u043d\u044b\u0445 \u0432\u0445\u043e\u0434\u0430: Green + VWin + Nonempty(HypsAlt)"
        )
        b_mid1_t = "\u0421\u0435\u0440\u0434\u0446\u0435 \u0434\u043e\u043a\u0430\u0437\u0430\u0442\u0435\u043b\u044c\u0441\u0442\u0432\u0430: \u0447\u0435\u0442\u044b\u0440\u0451\u0445\u0437\u0432\u0435\u043d\u043d\u043e\u0435 \u0441\u0436\u0430\u0442\u0438\u0435 \u043d\u0430\u043a\u043b\u043e\u043d\u043e\u0432 \u0411\u043e\u0441\u0442\u0430-\u0410\u0440\u0430\u043a\u0435\u043b\u043e\u0432\u0430 (\u0427\u0430\u0441\u0442\u0438 III-IV)"
        b_mid1_b = (
            r"(Loss) $\mathrm{ASK} - \mathrm{Ga} \leq \mathrm{LoP}$   $\cdot$   "
            + r"(Gain) $\mu(M_u) + \mathrm{Ga} + \mathrm{Fo} - \mathrm{Ee} - \mathrm{Lo}_5 \leq \mu(N_u)$   $\cdot$   "
            + "\u041f\u043e\u0431\u043b\u043e\u0447\u043d\u0430\u044f \u043e\u043f\u043b\u0430\u0442\u0430 DefFam.L " + r"($E_b \approx m B_0$)"
            + "\n"
            + r"(Slope / TheoremF) $\overline{\mu} - \log|W| - \mathrm{Err}_{\mathrm{HN}} \leq \mu(P_{u_0})$   $\cdot$   "
            + "(Div / \u0427\u043e\u0443\u043b\u0430-\u0421\u0435\u043b\u044c\u0431\u0435\u0440\u0433) " + r"$\mu(P_{u_0}) + h - \mathrm{Fo} \leq S_{\mathrm{div}} - \Sigma a_t\log T + \mathrm{Err}_{\mathrm{Div}}$"
        )
        b_mid2_t = "\u0413\u0430\u0440\u043c\u043e\u043d\u0438\u0447\u0435\u0441\u043a\u0438\u0439 \u043e\u0442\u0431\u043e\u0440 \u043d\u0430 G = E0 x H \u0438 \u0441\u043e\u043a\u0440\u0430\u0449\u0435\u043d\u0438\u0435 \u0433\u043b\u0430\u0432\u043d\u043e\u0433\u043e \u0447\u043b\u0435\u043d\u0430 (\u0427\u0430\u0441\u0442\u0438 II\u0430, IV)"
        b_mid2_b = (
            "\u0422\u043e\u0447\u043d\u044b\u0439 \u0431\u0430\u043b\u0430\u043d\u0441 " + r"$\mathrm{ASK} - \mathrm{MAIN} = \mathrm{De}$ (ch_balance)  $\longrightarrow$  "
            + "\u041f\u0440\u043e\u0435\u043a\u0442\u043e\u0440 " + r"$\Pi_{A_0}$ (sum_Th) " + "\u0432\u044b\u0434\u0435\u043b\u044f\u0435\u0442 " + r"$\Psi_A$" + ", \u0445\u0432\u043e\u0441\u0442 sigA_le"
            + "\n"
            + "\u0422\u043e\u0436\u0434\u0435\u0441\u0442\u0432\u043e " + r"$\mathrm{Data.Main}(u) = \sum_{t,j}\mathrm{Re}\,\mathrm{MAIN}$ (ch_top_main_eq)  $\Longrightarrow$  "
            + r"$G_{\mathcal{F}}(x) \leq x^{1/2 + (e_D + e_L + 7)\varepsilon}$" + " \u043d\u0430 \u043e\u043a\u043d\u0430\u0445 $[Z, Z^{3/2}]$ (core_gm)"
        )
        b_bot_t = "\u041e\u043a\u043e\u043d\u043d\u044b\u0439 \u043a\u0440\u0438\u0442\u0435\u0440\u0438\u0439 \u041b\u0430\u043d\u0434\u0430\u0443 \u0431\u0435\u0437 \u0433\u043b\u043e\u0431\u0430\u043b\u044c\u043d\u043e\u0433\u043e \u0437\u043d\u0430\u043a\u0430 \u0438 \u043e\u0442\u0440\u0430\u0436\u0435\u043d\u0438\u0435 (\u0427\u0430\u0441\u0442\u0438 I, V -> Main.lean)"
        b_bot_b = (
            "\u0413\u0430\u043c\u043c\u0430-\u043b\u043e\u043a\u0430\u043b\u0438\u0437\u0430\u0446\u0438\u044f \u043f\u0440\u043e\u0438\u0437\u0432\u043e\u0434\u043d\u044b\u0445 " + r"$D_k(\sigma + iv)$" + " \u0434\u0430\u0451\u0442 "
            + r"$\mathrm{ZeroFree}(\mathrm{Re}\,s > \theta)$" + " \u043f\u0440\u0438 \u0432\u0441\u0435\u0445 " + r"$\theta > 1/2$ (zeroFree_of_rpow_window)"
            + "\n"
            + "\u042d\u0439\u043b\u0435\u0440\u043e\u0432\u044b \u043c\u043d\u043e\u0436\u0438\u0442\u0435\u043b\u0438 (ClaimStrip) + \u0444\u0443\u043d\u043a\u0446\u0438\u043e\u043d\u0430\u043b\u044c\u043d\u043e\u0435 \u0443\u0440\u0430\u0432\u043d\u0435\u043d\u0438\u0435 " + r"$s \leftrightarrow 1 - s$  $\Longrightarrow$  "
            + "\u0412\u0441\u0435 5 \u043a\u043e\u0440\u043d\u0435\u0432\u044b\u0445 \u0442\u0435\u043e\u0440\u0435\u043c Main.lean"
        )

    ax.text(0.5, 0.975, header, ha="center", va="top", fontsize=11.2, fontweight="bold", color="#0F172A")

    draw_box(ax, 0.02, 0.72, 0.465, 0.205, b_left_t, b_left_b, "#0F766E", "#F0FDFA", title_fs=9.3, body_fs=8.0)
    draw_box(ax, 0.515, 0.72, 0.465, 0.205, b_right_t, b_right_b, "#1E3A8A", "#EFF6FF", title_fs=9.3, body_fs=8.0)
    draw_box(ax, 0.02, 0.47, 0.96, 0.195, b_mid1_t, b_mid1_b, "#92400E", "#FFFBEB", title_fs=9.5, body_fs=8.05)
    draw_box(ax, 0.02, 0.24, 0.96, 0.175, b_mid2_t, b_mid2_b, "#3730A3", "#EEF2FF", title_fs=9.4, body_fs=8.05)
    draw_box(ax, 0.02, 0.02, 0.96, 0.165, b_bot_t, b_bot_b, "#881337", "#FFF1F2", title_fs=9.4, body_fs=8.05)

    draw_arrow(ax, 0.252, 0.715, 0.34, 0.670, "#0F766E")
    draw_arrow(ax, 0.748, 0.715, 0.66, 0.670, "#1E3A8A")
    draw_arrow(ax, 0.50, 0.465, 0.50, 0.420, "#92400E")
    draw_arrow(ax, 0.50, 0.235, 0.50, 0.190, "#3730A3")

    fig.subplots_adjust(left=0.005, right=0.995, top=0.99, bottom=0.01)
    for ext in ("svg", "pdf"):
        out = os.path.join(ASSETS, f"fig1_architecture_{lang}.{ext}")
        fig.savefig(out, format=ext, bbox_inches="tight", pad_inches=0.06)
    plt.close(fig)


def build_fig2(lang: str) -> None:
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(10.4, 3.95))

    # Panel (a): 2/3 compounding barrier vs 1/2 block-local balance
    a = np.linspace(0.0, 1.0, 501)
    main_scale = 1.0 - a
    comp_err = np.maximum(1.0 - a, 2.0 * a)
    block_err = np.maximum(1.0 - a, a)

    ax1.fill_between(a, block_err, np.minimum(comp_err, 1.05), where=(comp_err > block_err),
                     color="#DBEAFE", alpha=0.55, zorder=1)
    ax1.plot(a, 1.0 - a, linestyle=":", linewidth=1.3, color="#64748B",
             label=(r"Window error $x/m \to 1 - a$" if lang == "en" else "\u041f\u043e\u0433\u0440\u0435\u0448\u043d\u043e\u0441\u0442\u044c \u043e\u043a\u043d\u0430 " + r"$x/m \to 1 - a$"))
    ax1.plot(a, np.clip(2.0 * a, 0, 1.05), linestyle="--", linewidth=1.3, color="#DC2626", alpha=0.65,
             label=(r"Prefix compounding $\sum j \sim m^2/2 \to 2a$" if lang == "en" else "\u041d\u0430\u043a\u043e\u043f\u043b\u0435\u043d\u0438\u0435 \u043f\u043e \u043f\u0440\u0435\u0444\u0438\u043a\u0441\u0443 " + r"$\sum j \sim m^2/2 \to 2a$"))
    ax1.plot(a, comp_err, linestyle="--", linewidth=2.1, color="#B91C1C",
             label=(r"Compounding envelope $\max(1-a,\,2a)$" if lang == "en" else "\u041e\u0433\u0438\u0431\u0430\u044e\u0449\u0430\u044f \u043d\u0430\u043a\u043e\u043f\u043b\u0435\u043d\u0438\u044f " + r"$\max(1-a,\,2a)$"))
    ax1.plot(a, block_err, linestyle="-", linewidth=2.4, color="#1D4ED8",
             label=(r"Block-local DefFam.L $\max(1-a,\,a)$" if lang == "en" else "\u041f\u043e\u0431\u043b\u043e\u0447\u043d\u0430\u044f \u043e\u043f\u043b\u0430\u0442\u0430 DefFam.L " + r"$\max(1-a,\,a)$"))

    ax1.scatter([1.0 / 3.0, 0.5], [2.0 / 3.0, 0.5], s=48, color=["#B91C1C", "#1D4ED8"], zorder=5)
    if lang == "en":
        ax1.annotate(r"Barrier $\theta = 2/3$ ($a = 1/3$)", xy=(1/3, 2/3), xytext=(0.05, 0.84),
                     fontsize=8.2, fontweight="bold", color="#991B1B",
                     arrowprops=dict(arrowstyle="->", color="#B91C1C", lw=1.1))
        ax1.annotate(r"Critical $\theta_* = 1/2$" + "\n" + r"($a = 1/2$)", xy=(0.5, 0.5), xytext=(0.64, 0.44),
                     fontsize=8.2, fontweight="bold", color="#1E3A8A",
                     arrowprops=dict(arrowstyle="->", color="#1D4ED8", lw=1.1))
        ax1.set_title("(a) Breaking the 2/3 Barrier via Block-Local Lifts", fontsize=9.8, fontweight="bold", pad=8)
        ax1.set_xlabel(r"Step-count exponent $a = \log_x m$", fontsize=8.8)
        ax1.set_ylabel(r"Upper-bound exponent $\theta$", fontsize=8.8)
    else:
        ax1.annotate("\u0411\u0430\u0440\u044c\u0435\u0440 " + r"$\theta = 2/3$ ($a = 1/3$)", xy=(1/3, 2/3), xytext=(0.04, 0.84),
                     fontsize=8.2, fontweight="bold", color="#991B1B",
                     arrowprops=dict(arrowstyle="->", color="#B91C1C", lw=1.1))
        ax1.annotate("\u041a\u0440\u0438\u0442\u0438\u0447\u0435\u0441\u043a\u0430\u044f " + r"$\theta_* = 1/2$" + "\n" + r"($a = 1/2$)", xy=(0.5, 0.5), xytext=(0.63, 0.44),
                     fontsize=8.2, fontweight="bold", color="#1E3A8A",
                     arrowprops=dict(arrowstyle="->", color="#1D4ED8", lw=1.1))
        ax1.set_title("(\u0430) \u041f\u0440\u0435\u043e\u0434\u043e\u043b\u0435\u043d\u0438\u0435 \u0431\u0430\u0440\u044c\u0435\u0440\u0430 2/3 \u043f\u043e\u0431\u043b\u043e\u0447\u043d\u043e\u0439 \u043e\u043f\u043b\u0430\u0442\u043e\u0439", fontsize=9.8, fontweight="bold", pad=8)
        ax1.set_xlabel("\u041f\u043e\u043a\u0430\u0437\u0430\u0442\u0435\u043b\u044c \u0447\u0438\u0441\u043b\u0430 \u0441\u0442\u0443\u043f\u0435\u043d\u0435\u0439 " + r"$a = \log_x m$", fontsize=8.8)
        ax1.set_ylabel("\u041f\u043e\u043a\u0430\u0437\u0430\u0442\u0435\u043b\u044c \u0432\u0435\u0440\u0445\u043d\u0435\u0439 \u043e\u0446\u0435\u043d\u043a\u0438 " + r"$\theta$", fontsize=8.8)

    ax1.set_xlim(0.0, 1.0)
    ax1.set_ylim(0.18, 1.04)
    ax1.grid(True, linestyle=":", alpha=0.45)
    ax1.legend(loc="lower left", fontsize=7.3, framealpha=0.92)

    # Panel (b): Four-Wall LP Law at (p, q) = (5, 4)
    nu = np.linspace(0.0, 3.2, 501)
    w1 = np.full_like(nu, 0.5)
    w2 = 1.0 - nu / 4.0
    w3 = (2.0 - 2.0 * nu) / 3.0
    w4 = (5.0 - nu) / 6.0
    theta_star = np.maximum.reduce([w1, w2, w3, w4])

    ax2.plot(nu, w2, "--", lw=1.2, color="#D97706", label=r"$1 - \nu/q = 1 - \nu/4$")
    ax2.plot(nu, w3, "--", lw=1.2, color="#7C3AED", label=r"$(2 - 2\nu)/3$")
    ax2.plot(nu, w4, "--", lw=1.2, color="#059669", label=r"$(p - \nu)/(p+1) = (5-\nu)/6$")
    ax2.plot(nu, w1, ":", lw=1.3, color="#64748B", label=r"Floor $1/2$" if lang == "en" else "\u041f\u043e\u0440\u043e\u0433 " + r"$1/2$")
    ax2.plot(nu, theta_star, "-", lw=2.5, color="#0F766E",
             label=(r"Exact LP optimum $\theta_*(\nu)$" if lang == "en" else "\u0422\u043e\u0447\u043d\u044b\u0439 \u043e\u043f\u0442\u0438\u043c\u0443\u043c LP " + r"$\theta_*(\nu)$"))

    ax2.scatter([1.0, 2.0], [0.75, 0.5], s=48, color=["#059669", "#0F766E"], zorder=5)
    if lang == "en":
        ax2.annotate(r"Unique $(a,\kappa) = (1/2,\,9/2)$" + "\n" + r"at $\nu_* = 2$, $\theta_* = 1/2$",
                     xy=(2.0, 0.5), xytext=(1.78, 0.73),
                     fontsize=8.1, fontweight="bold", color="#0F766E",
                     arrowprops=dict(arrowstyle="->", color="#0F766E", lw=1.1))
        ax2.set_title("(b) Four-Wall LP Phase Diagram at (p, q) = (5, 4)", fontsize=9.8, fontweight="bold", pad=8)
        ax2.set_xlabel(r"Tower degree exponent $\nu = \log_x n$", fontsize=8.8)
        ax2.set_ylabel(r"Minimal envelope exponent $\theta_*(\nu)$", fontsize=8.8)
    else:
        ax2.annotate("\u0415\u0434\u0438\u043d\u0441\u0442\u0432\u0435\u043d\u043d\u044b\u0439 " + r"$(a,\kappa) = (1/2,\,9/2)$" + "\n\u043f\u0440\u0438 " + r"$\nu_* = 2$, $\theta_* = 1/2$",
                     xy=(2.0, 0.5), xytext=(1.62, 0.73),
                     fontsize=8.1, fontweight="bold", color="#0F766E",
                     arrowprops=dict(arrowstyle="->", color="#0F766E", lw=1.1))
        ax2.set_title("(\u0431) \u0427\u0435\u0442\u044b\u0440\u0451\u0445\u0441\u0442\u0435\u043d\u043d\u044b\u0439 \u0437\u0430\u043a\u043e\u043d LP \u043f\u0440\u0438 (p, q) = (5, 4)", fontsize=9.8, fontweight="bold", pad=8)
        ax2.set_xlabel("\u041f\u043e\u043a\u0430\u0437\u0430\u0442\u0435\u043b\u044c \u044d\u0442\u0430\u0436\u0430 \u0431\u0430\u0448\u043d\u0438 " + r"$\nu = \log_x n$", fontsize=8.8)
        ax2.set_ylabel("\u041c\u0438\u043d\u0438\u043c\u0430\u043b\u044c\u043d\u044b\u0439 \u043f\u043e\u043a\u0430\u0437\u0430\u0442\u0435\u043b\u044c " + r"$\theta_*(\nu)$", fontsize=8.8)

    ax2.set_xlim(0.0, 3.2)
    ax2.set_ylim(0.32, 1.04)
    ax2.grid(True, linestyle=":", alpha=0.45)
    ax2.legend(loc="lower left", fontsize=7.3, framealpha=0.92)

    fig.tight_layout(pad=1.1)
    for ext in ("svg", "pdf"):
        out = os.path.join(ASSETS, f"fig2_balance_lp_{lang}.{ext}")
        fig.savefig(out, format=ext, bbox_inches="tight", pad_inches=0.06)
    plt.close(fig)


def main() -> None:
    os.makedirs(ASSETS, exist_ok=True)
    for lang in ("en", "ru"):
        build_fig1(lang)
        build_fig2(lang)
        print(f"[build_figures] Built fig1_architecture_{lang}.{{svg,pdf}} and fig2_balance_lp_{lang}.{{svg,pdf}}")


if __name__ == "__main__":
    main()
