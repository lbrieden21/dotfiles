return {
	-- Shows git diff in the gutter (replaces vim-gitgutter)
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Adds the :G family of commands
	{
		"tpope/vim-fugitive",
		dependencies = { "tpope/vim-rhubarb" },
		cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite", "Gclog", "Gblame" },
	},

	-- Show multipanes when editing a COMMIT_EDITMSG
	{ "rhysd/committia.vim", ft = "gitcommit" },
}
