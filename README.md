# baitong.nvim

A Neovim port of the [baitong](https://github.com/cyphbt/baitong-theme) Alacritty theme: neon green on dark teal, built with [lush.nvim](https://github.com/rktjmp/lush.nvim).

| Colorscheme | Variant |
|---|---|
| `baitong` | follows `'background'`, which Neovim sets from your terminal's background color at startup |
| `baitong-dark` | always dark |
| `baitong-light` | always light |

`baitong-dark` and `baitong-light` set `'background'` when you switch to them and ignore later changes to it.

Covers Treesitter, LSP semantic tokens, diagnostics, gitsigns and telescope.

## Install

```lua
-- lazy.nvim
{
  "baitong.nvim",
  dir = "~/Repos/baitong.nvim",
  dependencies = { "rktjmp/lush.nvim" },
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("baitong")
  end,
}
```

## Tweaking

```sh
nvim -u test/init.lua lua/baitong/theme.lua
```

`test/init.lua` is a throwaway config with lush, gitsigns and telescope. It reloads the theme whenever you save a file in this repo. `<leader>b` toggles dark and light, and `<leader>ff` / `<leader>fg` open telescope.

To see changes as you type, run `:Lushify` inside `lua/baitong/theme.lua`. Palette edits need a save.
