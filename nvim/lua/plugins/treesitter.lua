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
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
			})
		end,
	},
}
