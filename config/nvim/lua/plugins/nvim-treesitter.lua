return {
    "nvim-treesitter/nvim-treesitter",
    opts = {
        auto_install = true,
        autotag = {
            enable = true,
            filetypes = {
                "html", "javascript", "typescript", "svelte", "vue", "tsx", "jsx", "rescript",
                "css", "lua", "xml", "php", "markdown"
            },
        },
        indent = { enable = true },
        ensure_installed = {
            -- defaults 
            "vim",
            "lua",
            "vimdoc",

            -- web dev 
            "html",
            "css",
            "javascript",
            "typescript",
            "tsx",
            "astro",
            "vue",
            "svelte",
            "markdown",
            "markdown_inline",
            "json",
            "scss",
            "yaml"
        }
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function ()
            require('nvim-ts-autotag').setup()
        end,
        lazy = true,
        event = "VeryLazy"
    },
}
