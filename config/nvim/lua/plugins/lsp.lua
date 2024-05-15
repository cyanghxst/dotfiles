return {

    -- lsp zero
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        -- config = false,
        keys = {
            {"<leader>i", "<cmd>LspInfo<cr>", "Lsp Info"},
            {"<leader>I", "<cmd>LspInstall<cr>", "Lsp Install"},
        },
    },

    -- lsp config
    {
        "neovim/nvim-lspconfig"
        lazy = false,
        config = function()
        end,
    },

    -- complete
    {
        "hrsh7th/cmp-nvim-lsp"
    },

    -- nvim cmp
    {
        "hrsh7th/nvim-cmp"
    },

    -- lua snip
    {
        "L3MON4D3/LuaSnip"
    },
}
