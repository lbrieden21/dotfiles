-- Manual-only: no format_on_save, no autocmd, no keymap. Run
-- :lua require("conform").format() (or :ConformInfo) explicitly.
return {
	"stevearc/conform.nvim",
	cmd = "ConformInfo",
	opts = {
		formatters_by_ft = {
			css = { "prettier" },
			html = { "prettier" },
			markdown = { "prettier" },
			lua = { "stylua" },
		},
	},
}
