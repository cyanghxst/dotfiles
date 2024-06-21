return {
    "folke/tokyonight.nvim",
    enabled = true,
    priority = 1000,
    init = function()
        vim.cmd.colorscheme [[tokyonight]]
    end,
    opts = function()
        return {
            style = "night",
            transparent = true,
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
                functions = {},
                variables = {},
                sidebars = "transparent",
                floats = "transparent",
            },
            sidebars = { "qf", "help", "terminal", "packer", "nvimtree" },
            hide_inactive_statusline = true,
            dim_inactive = false,
            lualine_bold = false,
            on_colors = function(colors) end,
            on_highlights = function(hl, c)

                -- local white = "#c0caf5"
                local red = "#FF067D"
                local cyan = "#2ac3de"
                local blue = "#7aa2f7"
                local black = "#1e2231"
                local green = "#9ece6a"
                local purple = "#9d7cd8"
                local gray = "#414868"
                local gray_dark = "#3b4261"
                local gray_faded = "#232435"
                local gray_light = "#a9b1d6"

                -- EOB
                -- hl.EndOfBuffer = { fg = "#1616e" }

                -- Telescope
                hl.TelescopePromptBorder = { fg = cyan }
                hl.TelescopePromptTitle = { fg = cyan }
                hl.TelescopeResultsTitle = { fg = cyan }
                hl.TelescopeResultsBorder = { fg = cyan }
                hl.TelescopeMatching = { fg = cyan }

                -- Dashboard
                hl.AlphaHeader = { fg = blue }
                hl.AlphaButtons = { fg = blue }
                hl.AlphaShortcut = { fg = blue }
                hl.AlphaFooter = { fg = gray_dark }

                -- Search
                hl.Search = { bg = green, fg = black }
                hl.CurSearch = { bg = blue, fg = black }
                hl.IncSearch = { bg = blue, fg = black }

                -- CursorLine
                hl.CursorLineNr = { fg = white }
                hl.CursorLine = { bg = gray_faded }

                -- MiniIndentScope
                hl.MiniIndentscopeSymbol = { fg = gray_dark }

                -- Leap
                -- hl.LeapBackdrop = { fg = c.comment, link = "comment" }
                -- hl.LeapLabelPrimary = { fg = green, bold = true }
                -- hl.LeapLabelSecondary = { bg = purple, fg = comment }

                -- -- Gitsigns
                -- hl.GitSignsAdd = { fg = green }
                -- hl.GitSignsAddNr = { fg = green }
                -- hl.GitSignsAddLn = { fg = green }
                -- hl.GitSignsChange = { fg = purple }
                -- hl.GitSignsChangeNr = { fg = purple }
                -- hl.GitSignsChangeLn = { fg = purple }
                -- hl.GitSignsDelete = { fg = red }
                -- hl.GitSignsDeleteNr = { fg = red }
                -- hl.GitSignsTopDelete = { fg = red }
                -- hl.GitSignsCurrentLineBlame = { fg = gray_dark }

                -- Gitsigns
                hl.GitSignsAdd = { fg = gray_dark }
                hl.GitSignsAddNr = { fg = gray_dark }
                hl.GitSignsAddLn = { fg = gray_dark }
                hl.GitSignsChange = { fg = gray_dark }
                hl.GitSignsChangeNr = { fg = gray_dark }
                hl.GitSignsChangeLn = { fg = gray_dark }
                hl.GitSignsDelete = { fg = gray_dark }
                hl.GitSignsDeleteNr = { fg = gray_dark }
                hl.GitSignsTopDelete = { fg = gray_dark }
                hl.GitSignsCurrentLineBlame = { fg = gray_dark }

                -- NvimTree
                -- hl.NvimTreeGitDirty = { fg = blue }
                -- hl.NvimTreeGitStaged = { fg = blue }
                -- hl.NvimTreeGitMerge = { fg = blue }
                -- hl.NvimTreeGitRenamed = { fg = blue }
                -- hl.NvimTreeGitNew = { fg = blue }
                -- hl.NvimTreeGitDeleted = { fg = blue }
                -- hl.NvimTreeCursorLine = { bg = black }
                hl.NvimTreeFolderName = { fg = blue }
                hl.NvimTreeFolderArrowOpen = { fg = gray }
                hl.NvimTreeFolderArrowClosed = { fg = gray }
                hl.NvimTreeOpenedFolderName = { fg = blue }
                hl.NvimTreeEmptyFolderName = { fg = blue }
                hl.NvimTreeRootFolder = { fg = gray_light, bold = true }
                hl.NvimTreeSpecialFile = { fg = gray_light, bold = true }

            end,
        }
    end,
}
