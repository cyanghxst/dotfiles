return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "windwp/nvim-ts-autotag"
    opts = {
        ensure_installed = 'all',
        auto_install = true,
        highlight = { enable = true, },
        indent = { enable = true, },
        autotag = { enable = false }, -- this breaks dot repeating with `>`
    }
}
