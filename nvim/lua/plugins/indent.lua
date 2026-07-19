return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = "VeryLazy",
	opts = {},
	keys = {
		{ "<leader>ig", "<cmd>IBLToggle<CR>", desc = "Toggle indent guides" },
	},
}
