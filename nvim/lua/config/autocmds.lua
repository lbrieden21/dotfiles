-- Highlight trailing whitespace
vim.cmd("highlight ExtraWhitespace ctermbg=red guibg=red")
vim.cmd([[match ExtraWhitespace /\s\+$/]])

-- Scratch/floating windows (completion popups, hover docs, etc.) also fire
-- BufWinEnter/InsertEnter for their own buffer, and their content is often
-- padded with trailing spaces for alignment - skip those so we only ever
-- mark up trailing whitespace in real editable buffers.
local function editing_normal_buffer()
	return vim.bo.buftype == "" and vim.api.nvim_win_get_config(0).relative == ""
end

local whitespace_group = vim.api.nvim_create_augroup("ExtraWhitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
	group = whitespace_group,
	callback = function()
		if editing_normal_buffer() then
			vim.cmd([[match ExtraWhitespace /\s\+$/]])
		end
	end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
	group = whitespace_group,
	callback = function()
		if editing_normal_buffer() then
			vim.cmd([[match ExtraWhitespace /\s\+\%#\@<!$/]])
		end
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group = whitespace_group,
	callback = function()
		if editing_normal_buffer() then
			vim.cmd([[match ExtraWhitespace /\s\+$/]])
		end
	end,
})
vim.api.nvim_create_autocmd("BufWinLeave", {
	group = whitespace_group,
	command = "call clearmatches()",
})

-- Restore cursor to last known position on file open (replaces vim-lastplace)
vim.api.nvim_create_autocmd("BufReadPost", {
	group = vim.api.nvim_create_augroup("RestoreCursorPosition", { clear = true }),
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local lcount = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Resize splits when the window is resized
vim.api.nvim_create_autocmd("VimResized", {
	group = vim.api.nvim_create_augroup("VimResizedEqualize", { clear = true }),
	command = "wincmd =",
})

-- Hybrid line numbers: relative while editing/focused, absolute otherwise
local numbertoggle_group = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
	group = numbertoggle_group,
	callback = function()
		if vim.wo.number then
			vim.wo.relativenumber = true
		end
	end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
	group = numbertoggle_group,
	callback = function()
		if vim.wo.number then
			vim.wo.relativenumber = false
		end
	end,
})

-- vim-fugitive buffer housekeeping
local fugitive_group = vim.api.nvim_create_augroup("FugitiveBuffers", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = fugitive_group,
	pattern = "fugitive://*",
	command = "set bufhidden=delete",
})
vim.api.nvim_create_autocmd("User", {
	group = fugitive_group,
	pattern = "fugitive",
	callback = function(args)
		local fugitive_type = vim.b[args.buf].fugitive_type
		if fugitive_type == "tree" or fugitive_type == "blob" then
			vim.keymap.set("n", "..", ":edit %:h<CR>", { buffer = args.buf, silent = true })
		end
	end,
})

-- Move help windows to a full-height vertical split on the far right
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("HelpWindowRight", { clear = true }),
	pattern = "help",
	command = "wincmd L",
})

-- Allow gx to open urls in the browser
vim.g.netrw_browsex_viewer = vim.fn.has("mac") == 1 and "open" or "xdg-open"

-- Enable spellchecking on git commit messages
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = vim.api.nvim_create_augroup("Spelling", { clear = true }),
	pattern = "COMMIT_EDITMSG",
	command = "set spell",
})

-- Shared per-filetype indent/list/textwidth settings
local ft_settings_group = vim.api.nvim_create_augroup("FiletypeSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = ft_settings_group,
	pattern = { "php", "javascript", "sql", "perl", "rgt", "c", "smarty", "python", "ruby" },
	command = "setlocal list",
})
vim.api.nvim_create_autocmd("FileType", {
	group = ft_settings_group,
	pattern = {
		"javascript",
		"javascriptreact",
		"json",
		"css",
		"html",
		"yaml",
		"puppet",
		"sh",
		"ruby",
		"eruby",
		"typescript",
		"typescriptreact",
		"perl",
	},
	command = "setlocal tabstop=2 expandtab shiftwidth=2 softtabstop=2",
})
vim.api.nvim_create_autocmd("FileType", {
	group = ft_settings_group,
	pattern = { "python", "ruby" },
	command = "setlocal textwidth=100",
})

-- Treesitter-based indentation, scoped to JS/TS/JSX/TSX only (see plan notes)
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterIndent", { clear = true }),
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})
