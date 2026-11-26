LUSH ?= vendor/lush.nvim

NVIM = nvim --headless --clean --cmd "set rtp^=$(CURDIR)/$(LUSH),$(CURDIR)"

OUT ?= ~/Pictures/baitong

.PHONY: build check vendor screenshots

vendor/lush.nvim:
	git clone --depth 1 https://github.com/rktjmp/lush.nvim $@

vendor: vendor/lush.nvim

build: vendor
	$(NVIM) -l scripts/build.lua

check: build
	git diff --exit-code -- lua/baitong/compiled

screenshots:
	nvim --headless --clean -l scripts/screenshot.lua $(OUT)
