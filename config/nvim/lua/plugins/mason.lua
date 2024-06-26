return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
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
            ensure_installed = {
                "tsserver",
                "cssls",
                "html",
                "lua_ls",
                "tailwindcss",
            },
            automatic_installation = true,
        })
    end
}
