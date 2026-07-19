return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua", -- already installed; neogit uses it as its picker
	},
	cmd = "Neogit",
	keys = {
		{ "<leader>gg", function() require("neogit").open() end, desc = "Neogit (magit)" },
	},
	opts = {},
}
