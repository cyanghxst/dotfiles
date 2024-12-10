-- Disable sign column in tree
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
        if vim.bo.filetype == "neo-tree" then
        -- if vim.bo.filetype == "NvimTree" then
            vim.wo.statuscolumn = ""
        end
    end,
})

-- Disable sign column in alpha
vim.api.nvim_create_autocmd("Filetype", {
    pattern = "alpha",
    callback = function()
        vim.opt_local.statuscolumn = ""
    end
})

-- -- Autoclose tree
-- vim.api.nvim_create_autocmd('BufEnter', {
--     command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
--     nested = true,
-- })

vim.api.nvim_set_hl(0, "NeoTreeRootName", { fg = "#a9b1d6", bold = false, italic = false })

-- Disable automatic comment insertion
vim.cmd[[autocmd FileType * setlocal formatoptions-=cro]]

-- Disable mini.indentscope when entering insert mode
vim.cmd[[
augroup DisableMiniIndentScope
autocmd!
autocmd InsertEnter * lua vim.g.miniindentscope_disable = true
autocmd InsertLeave * lua vim.g.miniindentscope_disable = false
augroup END
]]

-- Highlight yanked text for 300ms using the "Visual" highlight group
vim.cmd[[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=300})
augroup END
]]

-- Jump to last edit position on opening file
vim.cmd[[
au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
]]

-- Fix auto-indentation for YAML files
vim.cmd[[
augroup yaml_fix
    autocmd!
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
augroup END
]]
