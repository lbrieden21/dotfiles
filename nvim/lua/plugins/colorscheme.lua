return {
	-- Active colorscheme. To switch for good, move `priority = 1000` and the
	-- `config` function down to one of the schemes below (they're installed
	-- but otherwise inactive) — or just run `:colorscheme <name>` for a
	-- one-off session change.
	--
	-- Two variants of gruvbox are used depending on context: gruvbox.nvim
	-- (truecolor, rich) normally, and the classic morhetz/gruvbox (which
	-- has a full 256-color/cterm palette) inside GNU screen. Screen does
	-- not relay 24-bit true color escape codes at all, and gruvbox.nvim
	-- only defines gui (RGB) colors with no cterm fallback, so without
	-- this split, nvim renders with almost no color inside screen. The
	-- `cond` fields keep only one of these on the runtimepath per session,
	-- since both register a colorscheme named "gruvbox".
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		cond = function()
			return vim.env.STY == nil
		end,
		config = function()
			vim.o.background = "dark"
			vim.cmd.colorscheme("gruvbox")
		end,
	},

	{
		"morhetz/gruvbox",
		priority = 1000,
		cond = function()
			return vim.env.STY ~= nil
		end,
		config = function()
			vim.o.termguicolors = false
			vim.o.background = "dark"
			vim.cmd.colorscheme("gruvbox")
		end,
	},

	"altercation/vim-colors-solarized",
	"sickill/vim-monokai",
	"mhartington/oceanic-next",
	"sjl/badwolf",
	"sheerun/vim-wombat-scheme",
}
