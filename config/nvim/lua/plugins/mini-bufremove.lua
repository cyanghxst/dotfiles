return {
    "echasnovski/mini.bufremove",
    keys = {
        {
            "<leader>ww", 
            function()
                require("mini.bufremove").delete(0, false)
            end,
            desc = "Delete Buffer"
        },
        {
            "<leader>wq",
            function()
                require("mini.bufremove").delete(0, true)
            end,
            desc = "Delete Buffer (Force)"
        }
    }
}
