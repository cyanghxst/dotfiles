return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
        {"nvim-lua/plenary.nvim"},
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = function()
                return vim.fn.executable("make") == 1
            end
        }
    },
    opts = {
        defaults = {
            -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            prompt_prefix = "  ",
            selection_caret = "  ",
            mappings = {
                i = {
                    ["<esc>"] = function(...) return require("telescope.actions").close(...) end,
                    ["?"] = function(...) return require("telescope.actions.layout").toggle_preview(...) end }
                },
            preview = { hide_on_startup = true },
        },

        pickers = {
            find_files = { theme = "dropdown", },
            live_grep = { theme = "dropdown", },
            help_tags = { theme = "dropdown", },
            highlights = { theme = "dropdown", },
            buffers = { theme = "dropdown", },
            oldfiles = { theme = "dropdown", },
        }
    }
}
