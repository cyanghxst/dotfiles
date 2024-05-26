local opt = vim.opt
local cmd = vim.cmd

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

-- Statusline
opt.laststatus = 3

-- Disable command bar
opt.cmdheight=0

-- Clipboard
opt.clipboard = "unnamedplus"

-- Cursor
cmd[[set guicursor+=i:blinkon1]] -- Enable cursor blinking

-- Include error signs in the number column
-- opt.signcolumn = "number"

-- Status column
-- opt.statuscolumn = "%=%{v:relnum?v:relnum:v:lnum} %s"
opt.statuscolumn = "%=%{v:lnum} %s"
-- opt.numberwidth = 3
-- opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"

-- Cursorline
-- vim.wo.cursorline = true
-- cmd[[hi cursorline gui=bold]]
-- vim.api.nvim_set_option('number', false) -- Toggle hybrid relative number
-- vim.api.nvim_set_option('relativenumber', true) -- Toggle relative number

-- Hybrid Cursorline
-- vim.wo.cursorline = true
-- vim.api.nvim_set_option('number', false) -- Toggle hybrid relative number
-- vim.api.nvim_set_option('relativenumber', true) -- Toggle relative number

-- Backspace indent
-- opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position
