local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Lazy
keymap("n", "<leader>l", "<cmd>Lazy<cr>", opts)

-- Toggle highlight off by hitting carriage return
keymap("n", "<cr>", "<cmd>nohlsearch<cr>", opts)

-- Toggle highlight off by hitting escape key
keymap("n", "<esc>", "<cmd>nohlsearch<cr>", opts)

-- Better up/down
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Buffers
keymap("n", "H", "<cmd>bprevious<cr>", opts)
keymap("n", "L", "<cmd>bnext<cr>", opts)

-- Move blocks in visual mode
keymap("v", "J", ":m '>+1<CR>gv=gv", opts)
keymap("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Indent blocks in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Disable floating window when the return key is hit
keymap("n", "<cr>", function()
    local found_float = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win).relative ~= '' then
            vim.api.nvim_win_close(win, true)
            found_float = true
        end
    end

    if found_float then
        return
    end

    vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
end, { desc = 'Toggle Diagnostics' })

-- LSP
map("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
map("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
map("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
map("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
map("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
map("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
map("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
map("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
map("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
map("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>", opts)
map("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
map("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
map("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
map("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
map("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
map("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>", opts)

-- Filetype-specific keymaps (should use vim.keymap.set)
local keymap = vim.keymap.set

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
