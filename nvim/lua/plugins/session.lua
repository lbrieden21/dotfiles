return {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		-- matches the old g:session_autosave = 'no'
		autosave = false,
	},
	keys = {
		-- Capitalized to avoid clashing with the existing <leader>s (toggle
		-- spell) prefix.
		{
			"<leader>Ss",
			function()
				require("persistence").save()
			end,
			desc = "Save session",
		},
		{
			"<leader>Sl",
			function()
				require("persistence").load()
			end,
			desc = "Load session",
		},
	},
}
