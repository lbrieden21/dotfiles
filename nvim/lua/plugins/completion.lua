return {
	"saghen/blink.cmp",
	version = "1.*",
	event = "InsertEnter",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"honza/vim-snippets",
		"justinj/vim-react-snippets",
	},
	opts = {
		keymap = {
			-- Closest match to the old single-key Tab-does-everything UltiSnips
			-- flow: accept/select completion -> snippet_forward -> fallback to
			-- a literal Tab. <S-Tab> mirrors it backward.
			preset = "super-tab",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<CR>"] = { "accept", "fallback" },
		},
		snippets = { preset = "luasnip" },
		-- Off by default in blink.cmp. This is what replaces per-argument
		-- snippet placeholders for servers like intelephense, which now send
		-- a bare `func($0)` plus a client-side "trigger parameter hints"
		-- command instead of a $1/$2/$3 snippet - show_on_accept_on_trigger_character
		-- (a default-on trigger option) picks that up since the cursor lands
		-- right after the "(" trigger character. <C-k> (super-tab preset)
		-- also shows/hides it manually.
		signature = { enabled = true },
		completion = {
			list = {
				selection = {
					-- Don't preselect a completion item while a snippet is still
					-- jumpable, so plain <Tab>/accept() has nothing to grab and
					-- falls through to snippet_forward instead of eating the
					-- keypress on an unrelated completion (super-tab pitfall).
					preselect = function()
						return not require("blink.cmp").snippet_active({ direction = 1 })
					end,
				},
			},
		},
	},
	config = function(_, opts)
		-- LuaSnip has never shipped an UltiSnips-format loader (only
		-- from_lua/from_snipmate/from_vscode - confirmed empirically against
		-- the installed plugin and its full git history, and LuaSnip's own
		-- wiki points UltiSnips migrators at from_snipmate). vim-snippets and
		-- vim-react-snippets both also ship a snipmate-format `snippets/`
		-- folder alongside their `UltiSnips/` one, so load that instead.
		require("luasnip.loaders.from_snipmate").lazy_load()
		require("blink.cmp").setup(opts)
	end,
}
