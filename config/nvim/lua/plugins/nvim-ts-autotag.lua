return {
    "PriceHiller/nvim-ts-autotag",
    enabled = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("nvim-ts-autotag").setup({

        })
    end
}
