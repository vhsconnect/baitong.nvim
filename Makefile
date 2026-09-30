LUSH ?= $(HOME)/.local/share/nvim/baitong-test/lush.nvim

NVIM = nvim --headless --clean --cmd "set rtp^=$(LUSH),."

.PHONY: build check

build:
	$(NVIM) -l scripts/build.lua

check: build
	git diff --exit-code -- lua/baitong/compiled
