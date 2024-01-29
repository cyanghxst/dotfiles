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
opt.scrolloff = 8
opt.showcmd = false
opt.showmode = false
opt.sidescrolloff = 30
opt.signcolumn = "yes"
opt.startofline = true
opt.wrap = false
-- vim.wo.cursorline = true

-- Searching
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.smartcase = true
opt.wildmenu = true

-- Statusline
opt.laststatus = 3

-- Clipboard
opt.clipboard = "unnamedplus"

-- Cursor
cmd[[set guicursor+=i:blinkon1]] -- Enable cursor blinking

-- Relative line numbers
vim.api.nvim_set_option('number', false)
vim.api.nvim_set_option('relativenumber', true)

-- Highlight groups
-- vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#3b4261" })
-- vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#3b4261" })

