local opt = vim.opt
local o = vim.o

-- Disable command bar
opt.cmdheight = 0

-- Status column
opt.statuscolumn = "%=%{v:lnum} %s"

-- Colors
opt.termguicolors = true

-- Indentation
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.smartindent = true
opt.smarttab = true
opt.tabstop = 4

-- Look and feel
opt.number = true
-- opt.relativenumber = true
opt.scrolloff = 17
opt.showcmd = false
opt.showmode = false
opt.sidescrolloff = 17
opt.signcolumn = "yes"
opt.startofline = true
opt.wrap = false
opt.foldcolumn = "1"

-- Searching
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true
opt.wildmenu = true

-- Clipboard
opt.clipboard = "unnamedplus"

-- Cursorline
o.cursorline = true
o.cursorlineopt = "number"
-- Uncomment if you want to enable cursorline
-- vim.cmd[[hi CursorLine gui=bold]]

-- Hybrid Cursorline
-- Uncomment if you want to toggle hybrid relative number
-- vim.api.nvim_set_option('number', false)
-- vim.api.nvim_set_option('relativenumber', true)

-- Backspace indent
-- Uncomment if you want to allow backspace on indent, end of line, or insert mode start position
-- opt.backspace = "indent,eol,start"
