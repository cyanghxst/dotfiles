local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", opts)

-- Toggle highlight off by hitting carriage return
map("n", "<cr>", "<cmd>nohlsearch<cr>", opts)

-- Toggle highlight off by hitting escape key
map("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

-- Better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Better window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Buffers
map("n", "H", "<cmd>bprevious<cr>", opts)
map("n", "L", "<cmd>bnext<cr>", opts)

-- Move blocks in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Indent blocks in visual mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Disable annoying q:
map("n", "q:", "<nop>", opts)
