local map = vim.keymap.set

-- Quick ESC
map("i", "jj", "<ESC>")

-- Insert the hashrocket with CTRL+l
map("i", "<c-l>", "<space>=><space>")

-- map j to gj and k to gk, so line navigation ignores line wrap
-- ...but only if the count is undefined (otherwise, things like 4j
-- break if wrapped LINES are present)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Navigate splits more easily
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map({ "n", "v" }, "<leader>v", "<C-w>v")

-- List navigation
map("n", "<left>", ":cprev<cr>zvzz")
map("n", "<right>", ":cnext<cr>zvzz")

-- Diagnostic navigation (was :lprev/:lnext when ALE populated the location
-- list; native LSP/nvim-lint diagnostics don't, so jump via the diagnostic
-- API instead)
map("n", "<up>", function()
	vim.diagnostic.goto_prev()
	vim.cmd("normal! zvzz")
end, { desc = "Previous diagnostic" })
map("n", "<down>", function()
	vim.diagnostic.goto_next()
	vim.cmd("normal! zvzz")
end, { desc = "Next diagnostic" })

-- Key repeat hack for resizing splits, i.e., <C-w>+++- vs <C-w>+<C-w>+<C-w>-
-- see: http://www.vim.org/scripts/script.php?script_id=2223
-- <SID> scoping has no clean vim.keymap.set equivalent, so this stays a
-- literal embedded vimscript block.
vim.cmd([[
nmap <C-w>+ <C-w>+<SID>ws
nmap <C-w>- <C-w>-<SID>ws
nmap <C-w>> <C-w>><SID>ws
nmap <C-w>< <C-w><<SID>ws
nnoremap <script> <SID>ws+ <C-w>+<SID>ws
nnoremap <script> <SID>ws- <C-w>-<SID>ws
nnoremap <script> <SID>ws> <C-w>><SID>ws
nnoremap <script> <SID>ws< <C-w><<SID>ws
nmap <SID>ws <Nop>
]])

-- Tab handling
map("n", "<leader>(", ":tabprev<cr>")
map("n", "<leader>)", ":tabnext<cr>")
map("n", "<C-t>", ":tabnew<CR>")
map("i", "<C-t>", "<Esc>:tabnew<CR>")

-- Allow for some common quit/write cmd typos
vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Qall", "qall", {})

-- gv reselects the last visual selection, however doesn't work correctly
-- after cut/paste, so next command
-- Visually select the text that was last edited/pasted
map("n", "gV", "`[v`]")

-- reselect visual block after indent/outdent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- allow the . to execute once for each line of a visual selection
map("v", ".", ":normal .<CR>")

-- move selected lines up or down - accepts a count of how many times to
-- execute the command
local function move_line_or_visual_up_or_down(move_arg)
	local col_num = vim.fn.virtcol(".")
	vim.cmd("silent! " .. move_arg)
	vim.cmd("normal! " .. col_num .. "|")
end

local function move_line_or_visual_up(line_getter, range)
	local l_num = vim.fn.line(line_getter)
	local move_arg
	if l_num - vim.v.count1 - 1 < 0 then
		move_arg = "0"
	else
		move_arg = line_getter .. " -" .. (vim.v.count1 + 1)
	end
	move_line_or_visual_up_or_down(range .. "move " .. move_arg)
end

local function move_line_or_visual_down(line_getter, range)
	local l_num = vim.fn.line(line_getter)
	local move_arg
	if l_num + vim.v.count1 > vim.fn.line("$") then
		move_arg = "$"
	else
		move_arg = line_getter .. " +" .. vim.v.count1
	end
	move_line_or_visual_up_or_down(range .. "move " .. move_arg)
end

local function move_line_up()
	move_line_or_visual_up(".", "")
end

local function move_line_down()
	move_line_or_visual_down(".", "")
end

local function move_visual_up()
	move_line_or_visual_up("'<", "'<,'>")
	vim.cmd("normal! gv")
end

local function move_visual_down()
	move_line_or_visual_down("'>", "'<,'>")
	vim.cmd("normal! gv")
end
-- exposed for potential normal-mode use, matching the old vimrc's function
-- family (only the visual maps are actually wired up below, as before)
_G.MoveLineUp = move_line_up
_G.MoveLineDown = move_line_down

map("v", "<C-k>", move_visual_up, { silent = true })
map("v", "<C-j>", move_visual_down, { silent = true })

-- Back to the buffer we came from
map("n", "<C-e>", ":e#<CR>")

-- Easy bouncing buffers
map("n", "<C-n>", ":bnext<CR>")
map("n", "<C-p>", ":bprev<CR>")

-- Open tag in vertical split
map("n", "<C-\\>", ':vs <CR>:exec("tag ".expand("<cword>"))<CR>')

-- Clear search string to remove highlighting
map("n", [[\\]], ":nohlsearch<CR>", { silent = true })

-- Reload our config
map("n", "<leader>~", function()
	vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.lua")
	vim.cmd("redraw!")
	local ok, lualine = pcall(require, "lualine")
	if ok then
		lualine.refresh()
	end
	print("init.lua reloaded!")
end, { desc = "Reload nvim config" })

-- Write file
map("n", "<leader>w", ":w<CR>")

-- Toggle spelling
map("n", "<leader>s", ":set invspell<CR>:set spell?<CR>")

-- Fix spelling
map("n", "<Leader>fs", "1z=")

-- Hide buffer
map("n", "<leader>Q", ":hide<CR>")

-- Toggle wrap
map("n", "<leader>W", ":set invwrap<CR>:set wrap?<CR>")

-- Open/closes folds
map("n", "<leader>z", "za")

-- Toggle background dark/light with <leader>B
local function toggle_background()
	local snark
	if vim.o.background == "dark" then
		vim.o.background = "light"
		snark = "Hey, wake up!!"
	else
		vim.o.background = "dark"
		snark = "Who turned out the lights???"
	end
	local ok, lualine = pcall(require, "lualine")
	if ok then
		lualine.refresh()
	end
	vim.cmd("redraw")
	print(snark)
end
map("n", "<leader>B", toggle_background, { silent = true })

-- Toggle paste mode. Nvim 0.12 dropped the 'pastetoggle' auto-binding
-- option, but the underlying 'paste' option it toggled is still there.
map({ "n", "i" }, "<F2>", "<Cmd>set invpaste<CR>")

-- upper/lower word
-- (set a mark, visually select inner word, u/U, return to mark)
map("n", "<leader>U", "m`gUiw``")
map("n", "<leader>L", "m`guiw``")

-- Reindent the entire file
map("n", "<leader>=", [[gg=G``:echo "reindent global"<CR>]])

-- Toggle match highlight
map("n", "<leader>l", ":set invhlsearch<CR>")

-- Highlight the current search match when jumping to next/prev
vim.cmd("highlight CurSearch ctermfg=white ctermbg=red guifg=white guibg=red")
map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })

-- Toggle numbers
map("n", "<leader>n", ":setlocal number!<CR>:setlocal relativenumber!<CR>")

-- unmap F1 - stupid help key
map({ "i", "n", "v" }, "<F1>", "<Esc>")

-- Generate a random password
vim.api.nvim_create_user_command("GeneratePassword", function(opts)
	vim.cmd("r !openssl rand -base64 48 | tr -d '*/\\_-' | cut -c1-" .. opts.args)
end, { nargs = 1 })

-- Display timestamp under cursor as date
if vim.fn.has("linux") == 1 then
	map("n", "<leader>ts", [[:echo system('date -d @' . expand('<cword>') . ' "+%Y-%m-%d %H:%M:%S"')<CR>]])
elseif vim.fn.has("mac") == 1 or vim.fn.system("uname"):lower():match("freebsd") then
	map("n", "<leader>ts", [[:echo system('date -j -f "%s" ' . expand('<cword>') . ' "+%Y-%m-%d %H:%M:%S"')<CR>]])
end
