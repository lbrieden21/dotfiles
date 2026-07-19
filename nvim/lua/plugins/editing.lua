-- Feed a mini.align interactive sequence: enter align mode, target the
-- paragraph under cursor (or the active visual selection), set the split
-- pattern, and confirm. Recreates the old `<Leader>t*` Tabularize maps on
-- top of mini.align's live-preview engine.
local function align_on(pattern)
	return function()
		local mode = vim.fn.mode()
		local keys
		if mode == "v" or mode == "V" or mode == "\22" then
			keys = "ga" .. pattern .. "\r"
		else
			keys = "gaip" .. pattern .. "\r"
		end
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "m", false)
	end
end

return {
	-- Add/change/remove surrounding chars and tags
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},

	-- Allow surround (and other) changes to be repeated with .
	{ "tpope/vim-repeat", event = "VeryLazy" },

	-- Autoclose brackets
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- Mappings for HTML, XML, PHP, ASP, eRuby, JSP, and more
	{ "tpope/vim-ragtag", event = "VeryLazy" },

	-- File manip commands: Remove, Move, Rename, SudoWrite, ...
	{ "tpope/vim-eunuch", cmd = { "Remove", "Move", "Rename", "SudoWrite", "SudoEdit", "Mkdir" } },

	-- ga to print the unicode value of the char under the cursor
	{ "tpope/vim-characterize", keys = { "ga" } },

	-- Enhance CTRL-A/CTRL-X to increment dates, times, and more
	{ "tpope/vim-speeddating", event = "VeryLazy" },

	-- JSON manipulation and pretty printing (aj text object, gqaj, gwaj)
	{ "tpope/vim-jdaddy", ft = { "json", "javascript", "javascriptreact", "typescript", "typescriptreact" } },

	-- Instant table creation
	{ "dhruvasagar/vim-table-mode", keys = { "<leader>tm" } },

	-- Better visual star searching
	{ "bronson/vim-visual-star-search", event = "VeryLazy" },

	-- Ask what file you wanted to open when it's not a real file
	{ "EinfachToll/DidYouMean" },

	{
		"nvim-mini/mini.nvim",
		version = false,
		event = "VeryLazy",
		config = function()
			-- Replaces nvim-web-devicons
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()

			require("mini.extra").setup()

			-- Replaces targets.vim + vim-indent-object
			require("mini.ai").setup({
				custom_textobjects = {
					i = require("mini.extra").gen_ai_spec.indent(),
				},
			})

			-- Replaces tabular.vim
			require("mini.align").setup()
			local map = vim.keymap.set
			map({ "n", "v" }, "<Leader>t=", align_on("="))
			map({ "n", "v" }, "<Leader>t:", align_on(":"))
			map({ "n", "v" }, "<Leader>t,", align_on(","))
			map({ "n", "v" }, "<Leader>t/", align_on("//"))
			map({ "n", "v" }, "<Leader>t>", align_on("=>"))
			map({ "n", "v" }, "<Leader>t#", align_on("#"))

			-- Replaces splitjoin.vim, keeping the old gS (split) / gJ (join) keys
			require("mini.splitjoin").setup({
				mappings = { toggle = "", split = "gS", join = "gJ" },
			})
			-- Replaces vim-argwrap
			map("n", "<leader>A", function() require("mini.splitjoin").toggle() end)

			-- Replaces vim-unimpaired, kept only for the jump categories
			-- vim-unimpaired never had: git-conflict markers, treesitter nodes,
			-- yank-history, undo-tree states. Core Neovim 0.11+ already ships
			-- buffer/quickfix/location-list brackets, so those are disabled here
			-- to avoid double-mapping, and treesitter is moved off 't' since
			-- core's ]t/[t already means tag-jump.
			require("mini.bracketed").setup({
				buffer = { suffix = "" },
				quickfix = { suffix = "" },
				location = { suffix = "" },
				treesitter = { suffix = "n" },
			})

			-- Replaces vim-bbye
			require("mini.bufremove").setup()
			map("n", "<leader>q", function()
				require("mini.bufremove").delete(0, false)
			end)

			-- Replaces the ExtraWhitespace match autocmds
			require("mini.trailspace").setup()
			vim.api.nvim_set_hl(0, "MiniTrailspace", { bg = "red" })
			map("n", "<leader>tw", function()
				require("mini.trailspace").trim()
			end)
		end,
	},
}
