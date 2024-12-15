return {
    "nvim-telescope/telescope-ui-select.nvim",
    enabled = false,
    config = function()
        require("telescope").setup({
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                    }
                }
            }
        })
        require("telescope").load_extension("ui-select")
    end,
}
