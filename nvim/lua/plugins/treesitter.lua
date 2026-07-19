local parsers = {
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"javascript",
	"typescript",
	"tsx",
	"json",
	"php",
	"css",
	"html",
	"yaml",
	"bash",
	"ruby",
	"python",
	"gitcommit",
	"git_rebase",
	"gitignore",
	"diff",
	"puppet",
}

-- Filetypes to enable highlighting for. Mostly mirrors `parsers` above, but
-- some parsers cover filetypes with a different name (vimdoc->help,
-- bash->sh, javascript/tsx also cover the *react filetypes).
local highlight_filetypes = {
	"lua",
	"vim",
	"help",
	"query",
	"markdown",
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
	"json",
	"php",
	"css",
	"html",
	"yaml",
	"sh",
	"ruby",
	"python",
	"gitcommit",
	"gitrebase",
	"gitignore",
	"diff",
	"puppet",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		config = function()
			require("nvim-treesitter").install(parsers)

			vim.treesitter.language.register("javascript", "javascriptreact")
			vim.treesitter.language.register("tsx", "typescriptreact")
			vim.treesitter.language.register("bash", "sh")
			vim.treesitter.language.register("vimdoc", "help")
			vim.treesitter.language.register("git_rebase", "gitrebase")

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterHighlight", { clear = true }),
				pattern = highlight_filetypes,
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
			})

			-- select.keymaps was dropped from this plugin's config schema on
			-- the main branch; keymaps must be wired up explicitly instead.
			local select = require("nvim-treesitter-textobjects.select")
			local map = vim.keymap.set
			map({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end)
			map({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end)
			map({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
			map({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)

			-- Replaces vim-pythonsense's function/class jump motions, now
			-- available in every treesitter-supported language, not just Python.
			local move = require("nvim-treesitter-textobjects.move")
			map({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer") end)
			map({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer") end)
			map({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer") end)
			map({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer") end)
		end,
	},
}
