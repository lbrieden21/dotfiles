local opt = vim.opt

-- Indentation / tabs
opt.autoindent = true
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smarttab = true

opt.backspace = { "indent", "eol", "start" }

opt.lazyredraw = true

-- By default, complete includes 'i' (included files), which can cause
-- major slowdowns.
opt.complete:remove("i")

-- Don't assume numbers starting with zero are octal
opt.nrformats:remove("octal")

-- Time out on mappings and terminal key codes. Keep both low for
-- responsiveness.
opt.timeout = true
opt.timeoutlen = 300
opt.ttimeout = true
opt.ttimeoutlen = 10

opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.laststatus = 2
opt.ruler = true
opt.showcmd = true
opt.showtabline = 1
opt.title = true

opt.wildmenu = true
opt.wildmode = { "longest", "list" }
opt.wildignore:append({ "*/tmp/*", "*/node_modules/*" })

opt.showmatch = true

-- Force error/visual bells off
opt.belloff = "all"

-- Controls the number of lines/chars to keep visible before scrolling
opt.scrolloff = 3
opt.sidescrolloff = 10
opt.sidescroll = 1
opt.display:append("lastline")

-- Changes what Neovim displays for special chars like trailing space & tabs
opt.list = false
opt.listchars = {
	tab = "| ",
	trail = "\u{2591}",
	extends = ">",
	precedes = "<",
	nbsp = "\u{00b7}",
}

-- Search back (up) the directory tree for tags
opt.tags:remove("./tags")
opt.tags:prepend("./tags;")

opt.autoread = true

if vim.o.history < 1000 then
	opt.history = 1000
end

if vim.o.tabpagemax < 50 then
	opt.tabpagemax = 50
end

-- Control what is preserved in the shada file (renamed from viminfo)
--   ! save and restore all-caps-named GLOBAL variables
--   ' number of files for which we should remember marks
--   < maximum line count of a register that is saved
--   s maximum byte count of a register that is saved
--   h disable the hlsearch when loading shada
opt.shada = "!,'100,<1000,s100,h"

opt.sessionoptions:remove("options")

-- gruvbox.nvim (and modern colorschemes generally) expect true color support.
-- The screen-256color fallback for GNU screen sessions is handled in
-- plugins/colorscheme.lua, since gruvbox.nvim force-enables this on load.
opt.termguicolors = true

opt.number = true
opt.relativenumber = true

opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.showbreak = "↪"
opt.whichwrap:append("<,>,h,l")

opt.foldenable = true
opt.foldlevelstart = 10
opt.foldnestmax = 10
opt.foldmethod = "indent"

opt.splitright = true
opt.splitbelow = true

opt.mouse = "a"

opt.signcolumn = "yes"

-- Don't try to highlight lines longer than 800 characters.
opt.synmaxcol = 800

opt.undofile = true
opt.undolevels = 10000
opt.undoreload = 10000
