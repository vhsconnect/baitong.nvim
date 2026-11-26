local lush = require("lush")

---@alias baitong.Variant "dark"|"light"|"hard"
---@alias baitong.Style "classic"|"tritone"

---@param p table palette from baitong.palette
---@param variant baitong.Variant
---@param style baitong.Style
local function syntax_colors(p, variant, style)
    if style == "tritone" then
        return {
            constant = p.fg,
            string = p.sky,
            func = p.fg,
            keyword = p.magenta,
            type = p.magenta,
            special = p.fg,
            tag = p.magenta,
            module = p.fg,
            builtin = p.fg,
            braces = variant == "hard" and p.green or p.fg,
            regexp = p.sky,
            url = p.sky,
            link = p.fg,
        }
    end
    return {
        constant = p.red,
        string = p.sky,
        func = p.aqua,
        keyword = p.magenta,
        type = p.neutral,
        special = p.amber,
        tag = p.aqua,
        module = p.neutral,
        builtin = p.red,
        -- Curly braces (@constructor) are green in hard, neutral elsewhere
        braces = variant == "hard" and p.green or p.neutral,
        regexp = p.amber,
        url = p.aqua,
        link = p.aqua,
    }
end

---@param p table palette from baitong.palette
---@param variant baitong.Variant
---@param style? baitong.Style
local function build(p, variant, style)
    local s = syntax_colors(p, variant, style or "classic")

    local h = {}
    for name, hex in pairs(p) do
        h[name] = lush.hsl(hex)
    end

    local c = {
        sunken = variant ~= "light" and h.bg.da(35) or h.bg.da(5),
        cursorline = h.bg.mix(h.fg, 6),
        visual = h.bg.mix(h.green, 22),
        diff_add = h.bg.mix(h.green, 18),
        diff_change = h.bg.mix(h.sky, 15),
        diff_text = h.bg.mix(h.sky, 32),
        diff_delete = h.bg.mix(h.red, 18),
    }

    ---@diagnostic disable: undefined-global
    return lush(function(injected)
        local sym = injected.sym
        return {
            Normal({ fg = p.fg, bg = p.bg }),
            NormalNC({ Normal }),
            NormalFloat({ fg = p.fg, bg = c.sunken }),
            FloatBorder({ fg = p.border, bg = c.sunken }),
            FloatTitle({ fg = p.on_purple, bg = p.purple, gui = "bold" }),
            FloatFooter({ FloatTitle }),
            WinSeparator({ fg = p.border }),
            VertSplit({ WinSeparator }),

            Cursor({ fg = p.bg, bg = p.cursor }),
            lCursor({ Cursor }),
            CursorIM({ Cursor }),
            TermCursor({ Cursor }),
            CursorLine({ bg = c.cursorline }),
            CursorColumn({ CursorLine }),
            ColorColumn({ CursorLine }),
            LineNr({ fg = p.subtle }),
            LineNrAbove({ LineNr }),
            LineNrBelow({ LineNr }),
            CursorLineNr({ fg = p.fg, gui = "bold" }),
            SignColumn({ fg = p.subtle }),
            FoldColumn({ SignColumn }),
            Folded({ fg = p.comment, bg = c.cursorline }),

            Visual({ bg = c.visual }),
            VisualNOS({ Visual }),
            Search({ fg = p.black, bg = p.search }),
            CurSearch({ fg = p.black, bg = p.cursor }),
            IncSearch({ CurSearch }),
            Substitute({ fg = p.black, bg = p.magenta }),
            MatchParen({ fg = p.cursor, gui = "bold,underline" }),

            StatusLine({ fg = p.on_purple, bg = p.purple }),
            StatusLineNC({ fg = p.comment, bg = c.sunken }),
            WinBar({ fg = p.fg, gui = "bold" }),
            WinBarNC({ fg = p.comment }),
            TabLine({ fg = p.comment, bg = c.sunken }),
            TabLineFill({ bg = c.sunken }),
            TabLineSel({ fg = p.on_purple, bg = p.purple, gui = "bold" }),

            Pmenu({ fg = p.fg, bg = c.sunken }),
            PmenuSel({ fg = p.on_purple, bg = p.purple, gui = "bold" }),
            PmenuSbar({ bg = c.sunken }),
            PmenuThumb({ bg = p.border }),
            PmenuMatch({ fg = p.magenta, gui = "bold" }),
            PmenuMatchSel({ fg = p.on_purple, bg = p.purple, gui = "bold,underline" }),
            WildMenu({ PmenuSel }),

            NonText({ fg = p.subtle }),
            EndOfBuffer({ NonText }),
            Whitespace({ NonText }),
            SpecialKey({ NonText }),
            Conceal({ fg = p.comment }),
            Directory({ fg = p.aqua }),
            Title({ fg = p.magenta, gui = "bold" }),
            Question({ fg = p.aqua }),
            MoreMsg({ fg = p.green }),
            ModeMsg({ fg = p.fg, gui = "bold" }),
            MsgArea({ Normal }),
            ErrorMsg({ fg = p.red, gui = "bold" }),
            WarningMsg({ fg = p.amber }),
            QuickFixLine({ bg = c.visual, gui = "bold" }),

            SpellBad({ sp = p.red, gui = "undercurl" }),
            SpellCap({ sp = p.amber, gui = "undercurl" }),
            SpellLocal({ sp = p.aqua, gui = "undercurl" }),
            SpellRare({ sp = p.magenta, gui = "undercurl" }),

            DiffAdd({ bg = c.diff_add }),
            DiffChange({ bg = c.diff_change }),
            DiffText({ bg = c.diff_text }),
            DiffDelete({ fg = p.red, bg = c.diff_delete }),
            Added({ fg = p.green }),
            Changed({ fg = p.sky }),
            Removed({ fg = p.red }),

            Comment({ fg = p.comment, gui = "italic" }),
            Constant({ fg = s.constant }),
            String({ fg = s.string }),
            Character({ String }),
            Number({ Constant }),
            Boolean({ Constant }),
            Float({ Constant }),
            Identifier({ fg = p.fg }),
            Function({ fg = s.func }),
            Statement({ fg = s.keyword }),
            Conditional({ Statement }),
            Repeat({ Statement }),
            Label({ Statement }),
            Operator({ fg = p.punct }),
            Keyword({ Statement }),
            Exception({ Statement }),
            PreProc({ fg = s.keyword }),
            Include({ PreProc }),
            Define({ PreProc }),
            Macro({ PreProc }),
            PreCondit({ PreProc }),
            Type({ fg = s.type, gui = "bold" }),
            StorageClass({ Statement }),
            Structure({ Type }),
            Typedef({ Type }),
            Special({ fg = s.special }),
            SpecialChar({ Special }),
            Tag({ fg = s.tag }),
            Delimiter({ fg = p.punct }),
            SpecialComment({ fg = p.comment, gui = "bold" }),
            Debug({ Special }),
            Underlined({ gui = "underline" }),
            Ignore({ fg = p.subtle }),
            Error({ fg = p.red, gui = "bold" }),
            Todo({ fg = p.black, bg = p.amber, gui = "bold" }),

            DiagnosticError({ fg = p.red }),
            DiagnosticWarn({ fg = p.amber }),
            DiagnosticInfo({ fg = p.sky }),
            DiagnosticHint({ fg = p.aqua }),
            DiagnosticOk({ fg = p.green }),
            DiagnosticUnderlineError({ sp = p.red, gui = "undercurl" }),
            DiagnosticUnderlineWarn({ sp = p.amber, gui = "undercurl" }),
            DiagnosticUnderlineInfo({ sp = p.sky, gui = "undercurl" }),
            DiagnosticUnderlineHint({ sp = p.aqua, gui = "undercurl" }),
            DiagnosticUnderlineOk({ sp = p.green, gui = "undercurl" }),
            DiagnosticVirtualTextError({ fg = p.red, bg = c.diff_delete }),
            DiagnosticVirtualTextWarn({ fg = p.amber, bg = h.bg.mix(h.amber, 12) }),
            DiagnosticVirtualTextInfo({ fg = p.sky, bg = c.diff_change }),
            DiagnosticVirtualTextHint({ fg = p.aqua, bg = h.bg.mix(h.aqua, 12) }),
            DiagnosticUnnecessary({ fg = p.comment }),
            DiagnosticDeprecated({ gui = "strikethrough" }),

            LspReferenceText({ bg = c.cursorline.mix(h.fg, 6) }),
            LspReferenceRead({ LspReferenceText }),
            LspReferenceWrite({ LspReferenceText, gui = "underline" }),
            LspInlayHint({ fg = p.comment, bg = c.cursorline }),
            LspSignatureActiveParameter({ fg = p.magenta, gui = "bold,underline" }),

            sym("@variable")({ Identifier }),
            sym("@variable.builtin")({ fg = s.builtin, gui = "italic" }),
            sym("@variable.parameter")({ fg = p.fg, gui = "italic" }),
            sym("@variable.member")({ fg = p.green }),
            sym("@property")({ sym("@variable.member") }),
            sym("@constant")({ Constant }),
            sym("@constant.builtin")({ Constant }),
            sym("@constant.macro")({ Macro }),
            sym("@module")({ fg = s.module }),
            sym("@label")({ Label }),
            sym("@string")({ String }),
            sym("@string.escape")({ SpecialChar }),
            sym("@string.regexp")({ fg = s.regexp }),
            sym("@string.special")({ Special }),
            sym("@string.special.url")({ fg = s.url, gui = "underline" }),
            sym("@character")({ Character }),
            sym("@number")({ Number }),
            sym("@boolean")({ Boolean }),
            sym("@type")({ Type }),
            sym("@type.builtin")({ fg = s.type, gui = "italic" }),
            sym("@attribute")({ PreProc }),
            sym("@function")({ Function }),
            sym("@function.builtin")({ fg = s.func, gui = "italic" }),
            sym("@function.macro")({ Macro }),
            sym("@constructor")({ fg = s.braces }),
            sym("@operator")({ Operator }),
            sym("@keyword")({ Keyword }),
            sym("@keyword.function")({ Keyword }),
            sym("@keyword.return")({ Keyword, gui = "bold" }),
            sym("@punctuation")({ Delimiter }),
            sym("@punctuation.special")({ Special }),
            sym("@comment")({ Comment }),
            sym("@comment.error")({ fg = p.black, bg = p.red, gui = "bold" }),
            sym("@comment.warning")({ fg = p.black, bg = p.amber, gui = "bold" }),
            sym("@comment.todo")({ Todo }),
            sym("@comment.note")({ fg = p.black, bg = p.sky, gui = "bold" }),
            sym("@markup.heading")({ Title }),
            sym("@markup.strong")({ gui = "bold" }),
            sym("@markup.italic")({ gui = "italic" }),
            sym("@markup.strikethrough")({ gui = "strikethrough" }),
            sym("@markup.underline")({ gui = "underline" }),
            sym("@markup.link")({ fg = s.link }),
            sym("@markup.link.url")({ sym("@string.special.url") }),
            sym("@markup.raw")({ fg = p.sky }),
            sym("@markup.list")({ fg = p.magenta }),
            sym("@markup.quote")({ fg = p.comment, gui = "italic" }),
            sym("@diff.plus")({ Added }),
            sym("@diff.minus")({ Removed }),
            sym("@diff.delta")({ Changed }),
            sym("@tag")({ Tag }),
            sym("@tag.attribute")({ fg = p.green, gui = "italic" }),
            sym("@tag.delimiter")({ Delimiter }),

            sym("@lsp.type.namespace")({ sym("@module") }),
            sym("@lsp.type.type")({ sym("@type") }),
            sym("@lsp.type.class")({ sym("@type") }),
            sym("@lsp.type.enum")({ sym("@type") }),
            sym("@lsp.type.interface")({ sym("@type") }),
            sym("@lsp.type.struct")({ sym("@type") }),
            sym("@lsp.type.typeParameter")({ sym("@type") }),
            sym("@lsp.type.parameter")({ sym("@variable.parameter") }),
            sym("@lsp.type.variable")({}),
            sym("@lsp.type.property")({ sym("@property") }),
            sym("@lsp.type.enumMember")({ sym("@constant") }),
            sym("@lsp.type.function")({ sym("@function") }),
            sym("@lsp.type.method")({ sym("@function") }),
            sym("@lsp.type.macro")({ sym("@function.macro") }),
            sym("@lsp.type.decorator")({ sym("@attribute") }),
            sym("@lsp.mod.deprecated")({ DiagnosticDeprecated }),
            sym("@lsp.typemod.variable.defaultLibrary")({ sym("@variable.builtin") }),
            sym("@lsp.typemod.function.defaultLibrary")({ sym("@function.builtin") }),

            GitSignsAdd({ fg = p.green }),
            GitSignsChange({ fg = p.sky }),
            GitSignsDelete({ fg = p.red }),
            GitSignsChangedelete({ fg = p.amber }),
            GitSignsTopdelete({ GitSignsDelete }),
            GitSignsUntracked({ fg = p.subtle }),
            GitSignsAddInline({ bg = h.bg.mix(h.green, 35) }),
            GitSignsChangeInline({ bg = h.bg.mix(h.sky, 35) }),
            GitSignsDeleteInline({ bg = h.bg.mix(h.red, 35) }),
            GitSignsCurrentLineBlame({ fg = p.comment, gui = "italic" }),

            TelescopeNormal({ NormalFloat }),
            TelescopeBorder({ FloatBorder }),
            TelescopePromptNormal({ fg = p.fg, bg = c.cursorline }),
            TelescopePromptBorder({ fg = p.border, bg = c.cursorline }),
            TelescopePromptPrefix({ fg = p.magenta, bg = c.cursorline }),
            TelescopePromptCounter({ fg = p.comment, bg = c.cursorline }),
            TelescopePromptTitle({ FloatTitle }),
            TelescopeResultsTitle({ fg = c.sunken, bg = p.green, gui = "bold" }),
            TelescopePreviewTitle({ fg = c.sunken, bg = p.aqua, gui = "bold" }),
            TelescopeSelection({ bg = c.visual, gui = "bold" }),
            TelescopeSelectionCaret({ fg = p.cursor, bg = c.visual }),
            TelescopeMultiSelection({ fg = p.magenta }),
            TelescopeMatching({ fg = p.magenta, gui = "bold" }),
        }
    end)
end

-- require() passes the module name; :Lushify runs the buffer with no args and
-- needs a spec back
if ... then
    return build
end

local variant = vim.o.background == "light" and "light" or "dark"
local style = (vim.g.colors_name or ""):match("tritone") and "tritone" or "classic"
return build(require("baitong.palette")[variant], variant, style)
