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

                local blue = "#7aa2f7"
                local black = "#1e2231"
                local cyan = "#2ac3de"
                local green = "#9ece6a"
                local gray = "#414868"
                local dark_gray = "#3b4261"
                local light_gray = "#a9b1d6"
                -- local white = "#c0caf5"

                -- EOB
                -- hl.EndOfBuffer = { fg = "#1616e" }

                -- Telescope
                hl.TelescopePromptBorder = { fg = cyan }
                hl.TelescopePromptTitle = { fg = cyan }
                hl.TelescopeResultsTitle = { fg = cyan }
                hl.TelescopeResultsBorder = { fg = cyan }

                -- Dashboard
                hl.AlphaHeader = { fg = blue }
                hl.AlphaButtons = { fg = blue }
                hl.AlphaShortcut = { fg = blue }
                hl.AlphaFooter = { fg = dark_gray }

                -- CursorLine
                -- hl.CursorLineNr = { fg = blue }
                -- hl.CursorLine= { bg = "#16161e" }

                -- MiniIndentScope
                hl.MiniIndentscopeSymbol = { fg = dark_gray }

                -- Leap
                -- hl.LeapBackdrop = { fg = c.comment, link = "comment" }
                -- hl.LeapLabelPrimary = { fg = green, bold = true }
                -- hl.LeapLabelSecondary = { bg = purple, fg = comment }

                -- Gitsigns
                hl.GitSignsAdd = { fg = dark_gray }
                hl.GitSignsAddNr = { fg = dark_gray }
                hl.GitSignsAddLn = { fg = dark_gray }
                hl.GitSignsChange = { fg = dark_gray }
                hl.GitSignsChangeNr = { fg = dark_gray }
                hl.GitSignsChangeLn = { fg = dark_gray }
                hl.GitSignsCurrentLineBlame = { fg = dark_gray }

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
                hl.NvimTreeRootFolder = { fg = light_gray, bold = true }
                hl.NvimTreeSpecialFile = { fg = light_gray, bold = true }

            end,
        }
    end,
}
