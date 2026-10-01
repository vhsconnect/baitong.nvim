local M = {}

---@param variant? "dark"|"light"|"hard" forces a variant; nil follows 'background'
function M.load(variant)
    if variant then
        -- Sync 'background' only for the dark/light variants; it rejects any
        -- other value (E474), and setting it during the reload Neovim does on a
        -- 'background' change makes Neovim drop the colorscheme
        if (variant == "dark" or variant == "light")
            and vim.g.colors_name ~= "baitong-" .. variant then
            vim.g.colors_name = nil
            vim.o.background = variant
        end
    else
        variant = vim.o.background == "light" and "light" or "dark"
    end

    local module = "baitong.compiled." .. variant
    package.loaded[module] = nil
    local compiled = require(module)

    vim.cmd("highlight clear")

    for group, attrs in pairs(compiled.groups) do
        vim.api.nvim_set_hl(0, group, attrs)
    end

    for i, color in ipairs(compiled.terminal) do
        vim.g["terminal_color_" .. (i - 1)] = color
    end
end

return M
