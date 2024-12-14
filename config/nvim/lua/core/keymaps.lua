local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================
-- General Keymaps
-- ============================

-- Lazy plugin manager
keymap("n", "<leader>l", "<cmd>Lazy<cr>", opts)

-- Toggle highlight off
keymap("n", "<cr>", "<cmd>nohlsearch<cr>", opts)
keymap("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

-- Duplicate a line and comment out the first line
keymap("n", "yc", "yygccp", { remap = true, silent = true})

-- Move selected lines with shift+j or shift+k
keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

-- Better navigation
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Buffer navigation
keymap("n", "H", "<cmd>bprevious<cr>", opts)
keymap("n", "L", "<cmd>bnext<cr>", opts)

-- Move blocks in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Indent blocks in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Disable floating window on return key
keymap("n", "<cr>", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, true)
            return
        end
    end
    vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
end, { desc = 'Toggle Diagnostics' })

-- ============================
-- Telescope Keymaps
-- ============================

keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" })
keymap("n", "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>", { desc = "Find All Files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Find Grep" })
keymap("n", "<leader>ft", "<cmd>Telescope help_tags<CR>", { desc = "Find Tags" })
keymap("n", "<leader>fh", "<cmd>Telescope highlights<CR>", { desc = "Find Highlights" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find Buffers" })
keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "Find Oldfiles" })

-- ============================
-- LSP Keymaps
-- ============================

keymap("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
keymap("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
keymap("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
keymap({ "n", "v" }, "<leader>gf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
keymap("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
keymap("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
keymap("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
keymap("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>", opts)

-- ============================
-- DAP (Debugging) Keymaps
-- ============================

keymap("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", opts)
keymap("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", opts)
keymap("n", "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>", opts)
keymap("n", "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dd", function()
    require('dap').disconnect()
    require('dapui').close()
end, opts)
keymap("n", "<leader>dt", function()
    require('dap').terminate()
    require('dapui').close()
end, opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>di", function() require "dap.ui.widgets".hover() end, opts)
keymap("n", "<leader>d?", function()
    local widgets = require "dap.ui.widgets"
    widgets.centered_float(widgets.scopes)
end, opts)
keymap("n", "<leader>df", "<cmd>Telescope dap frames<cr>", opts)
keymap("n", "<leader>dh", "<cmd>Telescope dap commands<cr>", opts)
keymap("n", "<leader>de", function()
    require('telescope.builtin').diagnostics({ default_text = ":E:" })
end, opts)

-- ============================
-- Filetype-Specific Keymaps
-- ============================

keymap("n", "<leader>go", function()
    if vim.bo.filetype == "java" then
        require("jdtls").organize_imports()
    end
end, opts)

keymap("n", "<leader>gu", function()
    if vim.bo.filetype == "java" then
        require("jdtls").update_projects_config()
    end
end, opts)

keymap("n", "<leader>tc", function()
    if vim.bo.filetype == "java" then
        require("jdtls").test_class()
    end
end, opts)
