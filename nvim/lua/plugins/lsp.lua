-- coc-extension -> mason/lspconfig server mapping:
--   coc-tsserver -> ts_ls          coc-json    -> jsonls
--   coc-html     -> html           coc-css     -> cssls
--   coc-pyright  -> pyright        coc-phpls   -> intelephense
--   coc-sh       -> bashls         coc-vimlsp  -> vimls
-- New (no maintained LSP existed when the old vimrc was written):
--   Perl     -> perlnavigator (bscan/PerlNavigator)
--   Puppet   -> puppet (puppet-editor-services, Ruby-based)
--   Lua      -> lua_ls (no coc-lua equivalent existed)
--   Markdown -> marksman (old vimrc never had live markdown tooling)
local servers = {
	"ts_ls",
	"jsonls",
	"html",
	"cssls",
	"pyright",
	"intelephense",
	"bashls",
	"vimls",
	"perlnavigator",
	"puppet",
	"lua_ls",
	"marksman",
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspAttachKeymaps", { clear = true }),
	callback = function(args)
		local opts = { buffer = args.buf, silent = true }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]g", vim.diagnostic.goto_next, opts)
	end,
})

return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
			"saghen/blink.cmp",
		},
		opts = {
			ensure_installed = servers,
			-- stylua ships an `lsp/stylua.lua` config in nvim-lspconfig (it has
			-- an `--lsp` mode), so mason-lspconfig's automatic_enable would
			-- otherwise attach it as a second client on lua buffers alongside
			-- lua_ls. It's only installed here as a CLI formatter for
			-- conform.nvim, so exclude it from auto-enable.
			automatic_enable = { exclude = { "stylua" } },
		},
		config = function(_, opts)
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
					},
				},
			})

			vim.diagnostic.config({
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✗",
						[vim.diagnostic.severity.WARN] = "⚠",
						[vim.diagnostic.severity.INFO] = "ℹ",
						[vim.diagnostic.severity.HINT] = "➤",
					},
				},
				virtual_text = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			require("mason-lspconfig").setup(opts)
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"prettier",
				"stylua",
				"stylelint",
				"htmlhint",
				"markdownlint",
				"luacheck",
			},
		},
	},
}
