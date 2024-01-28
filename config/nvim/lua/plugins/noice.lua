return {
    "folke/noice.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
        {"MunifTanjim/nui.nvim"},
        {
            "rcarriga/nvim-notify",
            opts = { background_colour = "#000000" },
        }
    },
    config = {
        cmdline = {
            enabled = true, -- enables the noice cmdline ui
            view = "cmdline_popup", -- view for rendering the cmdline. change to `cmdline` to get a classic cmdline at the bottom
            opts = {}, -- global options for the cmdline. see section on views
            format = {
                cmdline = { pattern = "^:", icon = ":", lang = "vim" },
                search_down = { kind = "search", pattern = "^/", icon = "/", lang = "regex" },
                search_up = { kind = "search", pattern = "^%?", icon = "?", lang = "regex" },
                filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋗" },
                input = {}, -- Used by input()
            }
        },
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = false, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        },

    },
    keys = {
        { "<leader><leader>", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    }
}
