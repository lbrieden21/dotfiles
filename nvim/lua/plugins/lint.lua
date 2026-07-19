return {
	"mfussenegger/nvim-lint",
	event = { "BufWritePost", "BufReadPost", "InsertLeave" },
	config = function()
		local lint = require("lint")

		-- Faithfully matches what was actually live in the old ALE config
		-- (ale_disable_lsp=1 meant ALE only did non-LSP CLI linting, and the
		-- only explicit setting was ale_php_phpcs_standard = 'phpcs.xml').
		-- Perl's perlcritic is deliberately not duplicated here since
		-- PerlNavigator's LSP already runs it.
		lint.linters_by_ft = {
			php = { "phpcs" },
			css = { "stylelint" },
			html = { "htmlhint" },
			markdown = { "markdownlint" },
			lua = { "luacheck" },
		}
		lint.linters.phpcs.args = vim.list_extend({ "--standard=phpcs.xml" }, lint.linters.phpcs.args or {})

		-- stylelint requires a project-level config file and simply errors
		-- (plain text, not JSON) when one isn't present. nvim-lint's own
		-- parser turns that into a fake "Stylelint error, run..." diagnostic;
		-- override it to just skip linting silently in that case instead.
		local stylelint_severities = {
			warning = vim.diagnostic.severity.WARN,
			error = vim.diagnostic.severity.ERROR,
		}
		lint.linters.stylelint.parser = function(output)
			local ok, decoded = pcall(vim.json.decode, output)
			if not ok then
				return {}
			end
			decoded = decoded[1]
			local diagnostics = {}
			for _, message in ipairs(decoded.warnings or {}) do
				table.insert(diagnostics, {
					lnum = message.line - 1,
					col = message.column - 1,
					end_lnum = message.line - 1,
					end_col = message.column - 1,
					message = message.text,
					code = message.rule,
					user_data = { lsp = { code = message.rule } },
					severity = stylelint_severities[message.severity],
					source = "stylelint",
				})
			end
			return diagnostics
		end

		-- nvim-lint shows a blocking "Error in ... Autocommands" prompt when a
		-- linter's binary isn't installed/on PATH (e.g. a project without
		-- phpcs available). Only run linters whose executable actually
		-- resolves, so a missing tool is silently skipped instead.
		local function available_linters()
			local names = lint.linters_by_ft[vim.bo.filetype] or {}
			return vim.tbl_filter(function(name)
				local linter = lint.linters[name]
				local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
				return vim.fn.executable(cmd) == 1
			end, names)
		end

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("NvimLint", { clear = true }),
			callback = function()
				local names = available_linters()
				if #names > 0 then
					lint.try_lint(names)
				end
			end,
		})
	end,
}
