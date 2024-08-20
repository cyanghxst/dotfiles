return {
    "williamboman/mason.nvim",
    dependencies = {
        { "williamboman/mason-lspconfig.nvim" },
        { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    },
    config = function()
        require("mason").setup({
            ui = {
                check_outdated_packages_on_open = true,
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                -- border = "single",
                width = 0.8,
                height = 0.9,
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "pyright", "tsserver", "jdtls" }, -- List of servers to automatically install
            automatic_installation = true, -- Automatically install servers
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "java-debug-adapter",
                "java-test",
            }
        })

        local lspconfig = require('lspconfig')
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lsp_attach = function(client, bufnr)
            -- Create your keybindings here... 
        end

        require('mason-lspconfig').setup_handlers({
            function(server_name)
                if server_name ~= 'jdtls' then
                    lspconfig[server_name].setup({
                        on_attach = lsp_attach,
                        capabilities = lsp_capabilities,
                    })
                end
            end
        })
    end
}
