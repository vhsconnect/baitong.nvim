local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local out_dir = vim.fn.expand(_G.arg[1] or "~/Pictures/baitong")
local chromium = vim.env.CHROMIUM or "chromium"

local schemes = {
  "baitong-dark",
  "baitong-light",
  "baitong-hard",
  "baitong-tritone-dark",
  "baitong-tritone-light",
  "baitong-tritone-hard",
} --[[@as const]]

local samples = {
  { file = "test/samples/sample.lua", lang = "lua" },
} --[[@as const]]

local width = 900
local line_height = 18
local padding = 40

vim.opt.rtp:prepend(root)
vim.cmd.packadd("nvim.tohtml")
vim.o.termguicolors = true
vim.o.tabstop = 2
-- Plugins bundled into a wrapped nvim still load with --clean; keep their
-- FileType hooks out of the capture
vim.o.eventignore = "FileType"
vim.fn.mkdir(out_dir, "p")

local tmp = vim.fn.tempname()
vim.fn.mkdir(tmp, "p")

for _, sample in ipairs(samples) do
  vim.cmd.edit(root .. "/" .. sample.file)
  local buf = vim.api.nvim_get_current_buf()
  vim.treesitter.start(buf, sample.lang)
  local lines = vim.api.nvim_buf_line_count(buf)

  for _, scheme in ipairs(schemes) do
    vim.cmd.colorscheme(scheme)
    vim.treesitter.get_parser(buf):parse(true)

    local html = require("tohtml").tohtml(0, { title = false, number_lines = true, font = { "JetBrains Mono", "DejaVu Sans Mono" } })
    table.insert(html, #html, ("<style>body{margin:0;padding:12px 16px;font-size:14px;line-height:%dpx}</style>"):format(line_height))

    local name = scheme .. "-" .. vim.fn.fnamemodify(sample.file, ":e")
    local html_path = tmp .. "/" .. name .. ".html"
    vim.fn.writefile(html, html_path)

    local png = out_dir .. "/" .. name .. ".png"
    local result = vim.system({
      chromium,
      "--headless",
      "--disable-gpu",
      "--hide-scrollbars",
      "--force-device-scale-factor=2",
      ("--window-size=%d,%d"):format(width, lines * line_height + padding),
      "--screenshot=" .. png,
      "file://" .. html_path,
    }, { text = true }):wait(60000)
    assert(result.code == 0, ("%s failed for %s: %s"):format(chromium, name, result.stderr))
    print(png)
  end
end

vim.fn.delete(tmp, "rf")
