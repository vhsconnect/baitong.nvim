local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h")
local deps = vim.fn.stdpath("data") .. "/baitong-test"

for _, repo in ipairs({ "rktjmp/lush.nvim", "lewis6991/gitsigns.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" }) do
  local path = deps .. "/" .. repo:match("/(.+)$")
  if not vim.uv.fs_stat(path) then
    vim.fn.system({ "git", "clone", "--depth=1", "https://github.com/" .. repo, path })
  end
  vim.opt.rtp:prepend(path)
end
vim.opt.rtp:prepend(root)

vim.o.termguicolors = true
vim.o.number = true
vim.o.cursorline = true
vim.o.signcolumn = "yes"

require("gitsigns").setup({ current_line_blame = true })
require("telescope").setup({})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*/baitong.nvim/lua/baitong/*.lua", "*/baitong.nvim/colors/*.lua" },
  callback = function()
    dofile(root .. "/scripts/build.lua")
    vim.cmd.colorscheme(vim.g.colors_name or "baitong")
  end,
})

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>b", function()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
end)

vim.cmd.colorscheme("baitong")
