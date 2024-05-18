return {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        require'nvim-treesitter.configs'.setup {
            autotag = {
                enable = true,
            }
        }
    end
}
