return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		fzf_colors = true,
	},
	keys = {
		{
			"<Leader>o",
			function()
				require("fzf-lua").files()
			end,
			desc = "Find files",
		},
		{
			"<Leader>;",
			function()
				require("fzf-lua").buffers()
			end,
			desc = "Find buffers",
		},
		{
			"<Leader>r",
			function()
				require("fzf-lua").tags()
			end,
			desc = "Find tags",
		},
		{
			"<Leader>a",
			function()
				require("fzf-lua").live_grep()
			end,
			desc = "Live grep",
		},
		{
			"<Leader>ag",
			function()
				require("fzf-lua").grep_cword()
			end,
			desc = "Grep word under cursor",
		},
		{
			"<leader>co",
			function()
				require("fzf-lua").lsp_document_symbols()
			end,
			desc = "Document symbols",
		},
	},
}
