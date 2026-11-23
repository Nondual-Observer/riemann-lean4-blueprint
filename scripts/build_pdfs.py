#!/usr/bin/env python3
"""
Single-Source-of-Truth PDF builder for Edition 9.0:
  - blueprint/ONE_PAGE_PROOF_EN.md -> blueprint/ONE_PAGE_PROOF_EN.pdf (strictly 1 page!)
  - blueprint/ONE_PAGE_PROOF_RU.md -> blueprint/ONE_PAGE_PROOF_RU.pdf (strictly 1 page!)
  - blueprint/BLUEPRINT_EN.md      -> blueprint/BLUEPRINT_EN.pdf
  - blueprint/BLUEPRINT_RU.md      -> blueprint/BLUEPRINT_RU.pdf
Uses Pandoc + Lua filter + Tectonic (XeLaTeX engine, CMU Serif + DejaVu Sans Mono)
without modifying a single byte of the verified Markdown manuscripts.
"""

import os
import re
import tempfile
from pathlib import Path
import shutil
import subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(HERE)
HEADER_TEX = os.path.join(HERE, "blueprint_header.tex")
LUA_FILTER = os.path.join(HERE, "blueprint_pdf.lua")
BP_DIR = os.path.join(REPO_ROOT, "blueprint")

SPECS = [
    ("en", os.path.join(BP_DIR, "ONE_PAGE_PROOF_EN.md"), os.path.join(BP_DIR, "ONE_PAGE_PROOF_EN.pdf"), True),
    ("ru", os.path.join(BP_DIR, "ONE_PAGE_PROOF_RU.md"), os.path.join(BP_DIR, "ONE_PAGE_PROOF_RU.pdf"), True),
    ("en", os.path.join(BP_DIR, "BLUEPRINT_EN.md"),      os.path.join(BP_DIR, "BLUEPRINT_EN.pdf"),      False),
    ("ru", os.path.join(BP_DIR, "BLUEPRINT_RU.md"),      os.path.join(BP_DIR, "BLUEPRINT_RU.pdf"),      False),
]


def count_pdf_pages(pdf_path: str) -> int:
    if shutil.which("pdfinfo"):
        proc = subprocess.run(
            ["pdfinfo", pdf_path], capture_output=True, text=True,
            env={**os.environ, "LC_ALL": "C"}, check=True,
        )
        pages = re.search(r"^Pages:\s*(\d+)\s*$", proc.stdout, flags=re.M)
        if pages:
            return int(pages.group(1))
        raise RuntimeError(f"pdfinfo returned no page count for {pdf_path}")
    try:
        from pypdf import PdfReader
    except ImportError as exc:
        raise RuntimeError("Install Poppler (pdfinfo) or pypdf to check the PDF page tree") from exc
    return len(PdfReader(pdf_path).pages)


def build_one(lang: str, md_path: str, pdf_path: str, is_onepage: bool) -> None:
    if not os.path.isfile(md_path):
        raise FileNotFoundError(md_path)
    bcp47 = "ru-RU" if lang == "ru" else "en-US"
    toc_title = "\u0421\u043e\u0434\u0435\u0440\u0436\u0430\u043d\u0438\u0435" if lang == "ru" else "Contents"
    cmd = [
        "pandoc",
        md_path,
        "-f", "markdown+lists_without_preceding_blankline+tex_math_dollars+pipe_tables+raw_html",
        "--pdf-engine=tectonic",
        f"--lua-filter={LUA_FILTER}",
        f"--include-in-header={HEADER_TEX}",
        f"--resource-path={BP_DIR}:{REPO_ROOT}",
        "-V", f"lang={bcp47}",
        "-V", "documentclass=article",
        "-V", "fontsize=" + ("9pt" if is_onepage else "10pt"),
        "-V", "papersize=a4",
        "-V", "geometry:" + ("margin=11.5mm,top=10.5mm,bottom=10.5mm" if is_onepage else "margin=20mm,headheight=14pt"),
        "-V", "mainfont=cmunrm.otf",
        "-V", "mainfontoptions:BoldFont=cmunbx.otf,ItalicFont=cmunti.otf,BoldItalicFont=cmunbi.otf",
        "-V", "sansfont=cmunss.otf",
        "-V", "sansfontoptions:BoldFont=cmunsx.otf,ItalicFont=cmunsi.otf,BoldItalicFont=cmunso.otf",
        "-V", "monofont=DejaVuSansMono.ttf",
        "-V", "monofontoptions:BoldFont=DejaVuSansMono-Bold.ttf,ItalicFont=DejaVuSansMono-Oblique.ttf,BoldItalicFont=DejaVuSansMono-BoldOblique.ttf,Scale=" + ("0.76" if is_onepage else "0.81"),
        "-M", f"doclang={lang}",
        "-M", "onepage=" + ("true" if is_onepage else "false"),
    ]
    if not is_onepage:
        cmd.extend(["--toc", "--toc-depth=2", "-V", f"toc-title={toc_title}"])
    cmd.extend(["--standalone", "--to=latex"])

    print(f"[build_pdfs] Compiling {os.path.basename(pdf_path)} from {os.path.basename(md_path)} ...", flush=True)
    source = subprocess.run(cmd, cwd=BP_DIR, check=True, capture_output=True, text=True)
    with tempfile.TemporaryDirectory(dir=BP_DIR) as stage:
        # Working in BP_DIR preserves the relative paths to the two vector figures.
        tex = subprocess.run(["tectonic", "--keep-logs", "--outdir", stage, "-"],
                             input=source.stdout, cwd=BP_DIR, capture_output=True, text=True)
        if tex.returncode:
            raise RuntimeError(tex.stderr + tex.stdout)
        logs = list(Path(stage).glob("*.log"))
        pdfs = list(Path(stage).glob("*.pdf"))
        if len(logs) != 1 or len(pdfs) != 1:
            raise RuntimeError("Expected one TeX transcript and one PDF")
        log = logs[0].read_text(errors="replace")
        issues = [line for line in (log + "\n" + tex.stderr + "\n" + source.stderr).splitlines()
                  if re.search(r"Overfull\s+\\[hv]box|missing character|missing glyph", line, re.I)]
        if issues:
            raise RuntimeError(f"{md_path}: " + "\n".join(dict.fromkeys(issues)))
        pages = count_pdf_pages(str(pdfs[0]))
        if pages <= 0 or (is_onepage and pages != 1):
            raise RuntimeError(f"Unexpected page count {pages} for {md_path}")
        os.replace(pdfs[0], pdf_path)
    print(f"[build_pdfs] OK: {os.path.basename(pdf_path)} ({pages} pp., 0 missing glyphs, 0 overfull)", flush=True)


def main() -> None:
    for spec in SPECS:
        build_one(*spec)


if __name__ == "__main__":
    main()
