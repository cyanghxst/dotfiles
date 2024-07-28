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
    keys = {
        {"<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find Grep"},
        {"<leader>ft", "<cmd>Telescope help_tags<CR>", desc = "Find Tags"},
        {"<leader>fh", "<cmd>Telescope highlights<CR>", desc = "Find Highlights"},
        {"<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers"},
        {"<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files"},
        {"<leader>fo", "<cmd>Telescope oldfiles <CR>", desc = "Find Oldfiles"},
        {"<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true <CR>", desc = "Find All Files"},
    },
    opts = {
        defaults = {
            -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
            prompt_prefix = "  ",
            selection_caret = "  ",
            mappings = {
                i = {
                    ["<esc>"] = function(...)
                        return require("telescope.actions").close(...)
                    end,
                    ["?"] = function(...)
                        return require("telescope.actions.layout").toggle_preview(...)
                    end
                }
            },

            preview = {
                hide_on_startup = true -- hide previewer when picker starts
            },
        },
        pickers = {
            find_files = {
                theme = "dropdown",
            },

            live_grep = {
                theme = "dropdown",
            },

            help_tags = {
                theme = "dropdown",
            },

            highlights = {
                theme = "dropdown",
            },

            buffers = {
                theme = "dropdown",
            },

            oldfiles = {
                theme = "dropdown",
            },
        }
    }
}
