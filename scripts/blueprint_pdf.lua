-- Pandoc Lua filter for printable arXiv/Annals-grade PDF generation from
-- BLUEPRINT_{EN,RU}.md and ONE_PAGE_PROOF_{EN,RU}.md (Edition 9.0).
-- Keeps the Markdown sources 100% untouched (Single Source of Truth).

local repo_blob = "https://github.com/Nondual-Observer/riemann-lean4-blueprint/blob/main/"

local function is_dot_lean(chars, i, n)
  if i + 4 > n then
    return false
  end
  local tail = chars[i + 5] or ""
  return chars[i] == "." and chars[i + 1] == "l" and chars[i + 2] == "e"
    and chars[i + 3] == "a" and chars[i + 4] == "n"
    and not tail:match("^[A-Za-z0-9_]$")
end

local function escape_latex_char(chars, i, n)
  local ch = chars[i]
  local nxt = chars[i + 1] or ""
  local has_nxt = (i < n)
  if ch == "\\" then
    return "\\textbackslash{}"
  elseif ch == "{" then
    return "\\{"
  elseif ch == "}" then
    return "\\}"
  elseif ch == "%" then
    return "\\%"
  elseif ch == "$" then
    return "\\$"
  elseif ch == "&" then
    return "\\&"
  elseif ch == "#" then
    return "\\#"
  elseif ch == "_" then
    return (n > 8 and has_nxt) and "\\_\\penalty300\\relax{}" or "\\_"
  elseif ch == "^" then
    return "\\textasciicircum{}"
  elseif ch == "~" then
    return "\\textasciitilde{}"
  elseif n > 8 and has_nxt and ch == "." and nxt ~= "." and not is_dot_lean(chars, i, n) then
    return ".\\penalty300\\relax{}"
  elseif n > 8 and has_nxt and (ch == "/" or ch == ":" or ch == ",") then
    return ch .. "\\penalty300\\relax{}"
  elseif n >= 18 and i >= 5 and i <= n - 4 and ch:match("^[a-z]$") and nxt:match("^[A-Z]$") then
    return ch .. "\\penalty600\\relax{}"
  else
    return ch
  end
end

function Code(el)
  local chars = {}
  for _, code in utf8.codes(el.text) do
    table.insert(chars, utf8.char(code))
  end
  local buf = {}
  local n = #chars
  for i = 1, n do
    local ch = chars[i]
    if #ch == 1 then
      table.insert(buf, escape_latex_char(chars, i, n))
    else
      table.insert(buf, ch)
    end
  end
  return pandoc.RawInline("latex", "\\leancode{" .. table.concat(buf) .. "}")
end

function CodeBlock(el)
  local raw = "\\par\\medskip\\noindent\\begin{minipage}{\\textwidth}\\begin{proofmapbox}\n"
    .. "\\begin{Verbatim}[fontsize=\\scriptsize]\n"
    .. el.text .. "\n"
    .. "\\end{Verbatim}\n\\end{proofmapbox}\\end{minipage}\\par\\medskip"
  return pandoc.RawBlock("latex", raw)
end

function Image(el)
  -- Swap .svg to vector .pdf automatically when compiling via Tectonic/XeLaTeX
  local src = el.src
  if src:match("%.svg$") then
    el.src = src:gsub("%.svg$", ".pdf")
  end
  el.attributes["width"] = "100%"
  return el
end

function Link(el)
  local t = el.target
  if not t:match("^https?://") and not t:match("^#") and not t:match("^mailto:") then
    if t:match("^KERNEL_INDEX_") or t:match("^ONE_PAGE_PROOF_") or t:match("^BLUEPRINT_") then
      el.target = repo_blob .. "blueprint/" .. t
    else
      el.target = repo_blob .. t:gsub("^%.%./", "")
    end
  end
  return el
end

function HorizontalRule(_)
  return pandoc.RawBlock("latex", "\\vspace{3pt}")
end

function Table(tbl)
  if #tbl.colspecs == 4 then
    tbl.colspecs[1] = {tbl.colspecs[1][1], 0.16}
    tbl.colspecs[2] = {tbl.colspecs[2][1], 0.44}
    tbl.colspecs[3] = {tbl.colspecs[3][1], 0.17}
    tbl.colspecs[4] = {tbl.colspecs[4][1], 0.23}
  elseif #tbl.colspecs == 2 then
    tbl.colspecs[1] = {tbl.colspecs[1][1], 0.21}
    tbl.colspecs[2] = {tbl.colspecs[2][1], 0.79}
  end
  return tbl
end

function Pandoc(doc)
  local new_blocks = {}
  local extracted_title = false
  local extracted_date = false
  local wrap_next_para_as_thm = false
  local doc_lang = pandoc.utils.stringify(doc.meta.doclang or "en")
  local is_onepage = (pandoc.utils.stringify(doc.meta.onepage or "false") == "true")

  if doc_lang == "ru" and not is_onepage then
    table.insert(new_blocks, pandoc.RawBlock("latex",
      "\\renewcommand{\\contentsname}{\u{0421}\u{043e}\u{0434}\u{0435}\u{0440}\u{0436}\u{0430}\u{043d}\u{0438}\u{0435}}"
      .. "\\markboth{\u{0421}\u{043e}\u{0434}\u{0435}\u{0440}\u{0436}\u{0430}\u{043d}\u{0438}\u{0435}}{}"))
  end

  if is_onepage then
    local author_str = (doc_lang == "ru")
      and "\u{0418}. \u{041c}. \u{0416}\u{0443}\u{043a} \\quad $\\cdot$ \\quad \\href{https://github.com/Nondual-Observer/riemann-lean4-blueprint}{github.com/Nondual-Observer/riemann-lean4-blueprint}"
      or "Igor M. Zhuk \\quad $\\cdot$ \\quad \\href{https://github.com/Nondual-Observer/riemann-lean4-blueprint}{github.com/Nondual-Observer/riemann-lean4-blueprint}"
    local title_tex = ""
    local sub_tex = ""
    for _, b in ipairs(doc.blocks) do
      if not extracted_title and b.t == "Header" and b.level == 1 then
        title_tex = pandoc.utils.stringify(b.content)
        extracted_title = true
      elseif extracted_title and not extracted_date and b.t == "Para" and #b.content == 1 and b.content[1].t == "Strong" then
        sub_tex = pandoc.utils.stringify(b.content[1].content)
        extracted_date = true
      elseif b.t == "HorizontalRule" then
        -- omit horizontal rules on 1-page account to save vertical space
      else
        table.insert(new_blocks, b)
      end
    end
    local banner = "\\hypersetup{pdftitle={" .. title_tex .. "}}\\thispagestyle{empty}\\pagestyle{empty}\\linespread{0.93}\\selectfont"
      .. "\\setlength{\\parskip}{1.9pt}\\setlength{\\abovedisplayskip}{2.8pt}\\setlength{\\belowdisplayskip}{2.8pt}"
      .. "\\noindent{\\large\\bfseries " .. title_tex .. "}\\hfill{\\footnotesize " .. sub_tex .. "}\\\\[1.5pt]"
      .. "{\\footnotesize " .. author_str .. "}\\par\\vspace{1.5pt}\\hrule\\vspace{3.5pt}"
    table.insert(new_blocks, 1, pandoc.RawBlock("latex", banner))
    doc.blocks = new_blocks
    return doc
  end

  for idx, b in ipairs(doc.blocks) do
    if not extracted_title and b.t == "Header" and b.level == 1 then
      doc.meta.title = pandoc.MetaInlines(b.content)
      extracted_title = true
    elseif extracted_title and not extracted_date and b.t == "Para" and #b.content == 1 and b.content[1].t == "Strong" then
      doc.meta.date = pandoc.MetaInlines(b.content[1].content)
      extracted_date = true
    elseif b.t == "Header" then
      local plain = pandoc.utils.stringify(b.content)
      local orig_level = b.level
      local nxt_block = doc.blocks[idx + 1]
      if nxt_block and nxt_block.t == "Table" then
        table.insert(new_blocks, pandoc.RawBlock("latex",
          "\\par\\ifdim\\pagetotal>0pt \\dimen0=\\pagetotal \\advance\\dimen0 by 7\\baselineskip \\ifdim\\dimen0>\\pagegoal \\newpage \\fi \\fi"))
      end
      if b.level >= 2 then
        b.level = b.level - 1
      end
      b.classes:insert("unnumbered")
      table.insert(new_blocks, b)
      if orig_level == 2 then
        local safe_mark = plain:gsub("[\\{}%%$&#_^~]", "")
        table.insert(new_blocks, pandoc.RawBlock("latex", "\\markboth{" .. safe_mark .. "}{}"))
      end
      if plain == "Main Theorem" or plain == "\u{041e}\u{0441}\u{043d}\u{043e}\u{0432}\u{043d}\u{0430}\u{044f} \u{0442}\u{0435}\u{043e}\u{0440}\u{0435}\u{043c}\u{0430}" then
        wrap_next_para_as_thm = true
      end
    elseif b.t == "Para" and b.content[1] and b.content[1].t == "Strong"
        and new_blocks[#new_blocks] and new_blocks[#new_blocks].t == "Figure" then
      -- Keep the explanatory paragraph with the image when TeX floats it.
      local figure = new_blocks[#new_blocks]
      local caption = figure.caption
      local lines = caption.long
      local last = lines[#lines]
      last.content:insert(pandoc.Str("."))
      last.content:insert(pandoc.Space())
      last.content:extend(b.content)
      lines[#lines] = last
      caption.long = lines
      figure.caption = caption
      new_blocks[#new_blocks] = figure
    elseif wrap_next_para_as_thm and b.t == "Para" then
      wrap_next_para_as_thm = false
      table.insert(new_blocks, pandoc.BlockQuote({b}))
    else
      table.insert(new_blocks, b)
    end
  end

  doc.blocks = new_blocks
  local author_name = (doc_lang == "ru") and "\u{0418}. \u{041c}. \u{0416}\u{0443}\u{043a}" or "Igor M. Zhuk"
  doc.meta.author = pandoc.MetaInlines({
    pandoc.Str(author_name),
    pandoc.RawInline("latex", " \\quad $\\cdot$ \\quad "),
    pandoc.Link({pandoc.Str("github.com/Nondual-Observer/riemann-lean4-blueprint")}, "https://github.com/Nondual-Observer/riemann-lean4-blueprint")
  })
  return doc
end
