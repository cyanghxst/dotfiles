return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    -- dependencies = "windwp/nvim-ts-autotag",
    opts = {
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

            -- low level
            "c",
            "zig"
        },
        auto_install = true,
        highlight = { enable = true, },
        indent = { enable = true, },
        autotag = { enable = false }, -- this breaks dot repeating with `>`
    }
}
