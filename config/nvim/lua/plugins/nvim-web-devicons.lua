return {
    "nvim-tree/nvim-web-devicons",
    enabled = true,
    config = {
        override = {
            js = {
                icon = "",
                color = "#f7e019",
                cterm_color = "185",
                name = "Javascript"
            },
            zip = {
                icon = "󰗄",
                color = "#eca517",
                cterm_color = "214",
                name = "zip"
            },
            default_icon = {
                icon = "󰈔",
                color = "#6d8086",
                cterm_color = "66",
                name = "default"
            }
        };
    }
}
