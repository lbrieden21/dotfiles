return {
	"heavenshell/vim-jsdoc",
	ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	build = "make install",
	init = function()
		vim.g.jsdoc_enable_es6 = 1
	end,
	keys = {
		-- g:jsdoc_default_mapping was removed in v0.3, so the old vimrc's
		-- <leader>pd comment had actually been dead documentation for a
		-- while - this is the real mapping it always implied.
		{ "<leader>pd", "<Plug>(jsdoc)" },
	},
}
