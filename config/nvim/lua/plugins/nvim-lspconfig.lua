return {
    "neovim/nvim-lspconfig",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
        local lsp = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Uncomment this if you need additional customization
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        lsp.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    completion = { callSnippet = "Replace" },
                },
            },
        })

        lsp.tsserver.setup({
            init_options = {
                plugins = {
                    {
                        name = "@vue/typescript-plugin",
                        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                        languages = {"javascript", "typescript", "vue"},
                    },
                },
            },
            filetypes = {
                "javascript",
                "typescript",
                "vue",
            },
        })

        lsp.cssls.setup({
            capabilities = capabilities,
        })

        lsp.html.setup({
            capabilities = capabilities,
        })

        -- You must make sure volar is setup
        -- e.g. require'lspconfig'.volar.setup{}
        -- See volar's section for more information
        lsp.clangd.setup({
            capabilities = capabilities
        })

        vim.diagnostic.config({
            virtual_text = true,
        })

        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            {border = 'rounded'}
        )

        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            {border = 'rounded'}
        )
    end,
}
