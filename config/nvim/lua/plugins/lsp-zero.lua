return {
    "VonHeikemen/lsp-zero.nvim",
    enabled = true,
    branch = "v3.x",
    dependencies = {

        -- lsp support
        {"neovim/nvim-lspconfig"},

        -- autocompletion
        {"hrsh7th/cmp-nvim-lsp"},
        {"hrsh7th/nvim-cmp"},

        -- snippets
        {'L3MON4D3/LuaSnip'},
    },
}
