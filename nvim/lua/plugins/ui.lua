return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-mini/mini.nvim" },
		event = "VeryLazy",
		opts = {
			options = {
				theme = "gruvbox",
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-mini/mini.nvim" },
		event = "VeryLazy",
		opts = {},
	},
}
