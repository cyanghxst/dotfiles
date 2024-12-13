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

        -- Lua LSP setup
        lsp.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    workspace = { checkThirdParty = false },
                    completion = { callSnippet = "Replace" },
                },
            },
        })

        -- TypeScript LSP setup
        lsp.ts_ls.setup({
            init_options = {
                plugins = {
                    {
                        name = "@vue/typescript-plugin",
                        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                        languages = { "javascript", "typescript", "vue" },
                    },
                },
            },
            filetypes = { "javascript", "typescript", "vue" },
        })

        -- CSS LSP setup
        lsp.cssls.setup({ capabilities = capabilities })

        -- HTML LSP setup
        lsp.html.setup({ capabilities = capabilities })

        -- Ruby LSP setup
        lsp.ruby_lsp.setup({ capabilities = capabilities })

        -- Clangd LSP setup with custom formatting options
        lsp.clangd.setup({
            cmd = {
                "clangd",
                "--fallback-style=webkit"
            },
            filetypes = { "cpp", "c", "objc", "objcpp" },
            capabilities = capabilities,
        })

        -- Diagnostic configuration
        vim.diagnostic.config({
            virtual_text = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '',
                    [vim.diagnostic.severity.WARN] = '󰀧',
                    [vim.diagnostic.severity.INFO] = '󰞋',
                    [vim.diagnostic.severity.HINT] = '󰎃',
                },
            },
        })

        -- Hover and signature handlers with rounded borders
        vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
            vim.lsp.handlers.hover,
            { border = 'rounded' }
        )
        vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
            vim.lsp.handlers.signature_help,
            { border = 'rounded' }
        )
    end,
}
