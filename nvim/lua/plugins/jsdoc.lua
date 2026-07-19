return {
	"danymat/neogen",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "python" },
	opts = { snippet_engine = "luasnip" }, -- LuaSnip already installed via completion.lua
	keys = {
		{ "<leader>pd", function() require("neogen").generate() end, desc = "Generate annotation" },
	},
}
