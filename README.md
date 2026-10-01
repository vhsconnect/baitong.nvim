# baitong.nvim

A Neovim port of the [baitong](https://github.com/cyphbt/baitong-theme) Alacritty theme: neon green on dark teal, written with [lush.nvim](https://github.com/rktjmp/lush.nvim) and compiled so it loads without it.

| Colorscheme | Variant |
|---|---|
| `baitong` | follows `'background'`, which Neovim sets from your terminal's background color at startup |
| `baitong-dark` | always dark |
| `baitong-hard` | always dark, but with a much darker background and green curly braces |
| `baitong-light` | always light |

`baitong-dark` and `baitong-light` set `'background'` when you switch to them and ignore later changes to it.

Covers Treesitter, LSP semantic tokens, diagnostics, gitsigns and telescope.

## Install

```lua
-- lazy.nvim
{
  "baitong.nvim",
  dir = "~/Repos/baitong.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("baitong")
  end,
}
```

## Tweaking

Colors live in `lua/baitong/palette.lua` and highlight groups in `lua/baitong/theme.lua`. Both need lush. Neovim loads the generated tables in `lua/baitong/compiled/`, so rebuild and commit them after a change:

```sh
make build   # regenerate lua/baitong/compiled/
make check   # rebuild and fail if the committed output is stale (for CI)
```

On pull requests, CI runs `make build` and pushes a rebuild commit to the branch if the output changed. PRs from forks can't be pushed to, so there it fails and asks for a rebuild instead.

`make build` vendors lush.nvim into `vendor/lush.nvim` (gitignored) on the first run, so no local setup is needed. To build against another lush checkout instead, override it with `make build LUSH=/path/to/lush.nvim`.

To try changes:

```sh
nvim -u test/init.lua lua/baitong/theme.lua
```

`test/init.lua` is a throwaway config with lush, gitsigns and telescope. Saving a file in this repo rebuilds and reloads the theme. `<leader>b` toggles `'background'`, and `<leader>ff` / `<leader>fg` open telescope. For changes as you type, run `:Lushify` inside `lua/baitong/theme.lua`.
