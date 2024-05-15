return {
    "nvim-treesitter/nvim-treesitter",
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
