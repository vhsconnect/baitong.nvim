local M = {}

---@param variant? "dark"|"light" forces a variant; nil follows 'background'
function M.load(variant)
  local ok, lush = pcall(require, "lush")
  if not ok then
    vim.notify("baitong: requires rktjmp/lush.nvim", vim.log.levels.ERROR)
    return
  end

  if variant then
    -- Only sync 'background' when switching to this variant. Setting it during
    -- the reload Neovim does on a 'background' change makes Neovim drop the
    -- colorscheme
    if vim.g.colors_name ~= "baitong-" .. variant then
      vim.g.colors_name = nil
      vim.o.background = variant
    end
  else
    variant = vim.o.background == "light" and "light" or "dark"
  end

  for name in pairs(package.loaded) do
    if name:match("^baitong%.") then
      package.loaded[name] = nil
    end
  end

  local p = require("baitong.palette")[variant]

  vim.cmd("highlight clear")

  lush(require("baitong.theme")(p, variant))

  local terminal = {
    p.black, p.red, p.green, p.green, p.aqua, p.magenta, p.sky, p.neutral,
    p.comment, p.red, p.fg, p.amber, p.aqua, p.cursor, p.aqua, p.neutral,
  }

  for i, color in ipairs(terminal) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M
