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
            on_highlights = function(hl, _)

                local white = "#c0caf5"
                -- local magenta = "#ff067d"
                -- local cyan = "#2ac3de"
                local blue = "#7aa2f7"
                local green = "#9ece6a"
                -- local purple = "#9d7cd8"
                local bone = "#a9b1d6"
                local gray1 = "#414868"
                local gray2 = "#3b4261"
                local gray3 = "#232435"
                -- local gray4 = "#201e2b"
                local black = "#1e2231"
                local background = "#16151d"

                -- EOB
                hl.EndOfBuffer = { fg = background}

                -- Telescope
                hl.TelescopePromptBorder = { fg = gray1 }
                -- hl.TelescopePromptTitle = { bg = blue, fg = background }
                hl.TelescopePromptTitle = { fg = gray1 }
                -- hl.TelescopeResultsTitle = { bg = blue, fg = background }
                hl.TelescopeResultsTitle = { fg = gray1 }
                hl.TelescopeResultsBorder = { fg = gray1 }
                -- hl.TelescopeSelection = { bg = gray3 }
                -- hl.TelescopeSelection = { fg = background, bg = blue }

                -- Dashboard
                hl.AlphaHeader = { fg = blue }
                hl.AlphaButtons = { fg = blue }
                hl.AlphaShortcut = { fg = blue }
                hl.AlphaFooter = { fg = gray2 }

                -- Search
                hl.Search = { bg = green, fg = black }
                hl.CurSearch = { bg = blue, fg = black }
                hl.IncSearch = { bg = blue, fg = black }

                -- CursorLine
                hl.CursorLineNr = { fg = white }
                hl.CursorLine = { bg = gray3 }

                -- menu
                hl.Pmenu = { bg = gray3 }
                hl.NormalFloat = { bg = gray3 }
                hl.FloatBorder = { fg = gray1 }
                hl.PmenuSel = { fg = background, bg = blue }

                -- mason
                hl.MasonNormal = { bg = background }

                -- MiniIndentScope
                hl.MiniIndentscopeSymbol = { fg = gray2 }

                -- lazy
                hl.LazyNormal = { bg = background }

                -- float
                hl.NormalFloat = { bg = background }

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
                -- hl.GitSignsDelete = { fg = magenta }
                -- hl.GitSignsDeleteNr = { fg = magenta }
                -- hl.GitSignsTopDelete = { fg = magenta }
                -- hl.GitSignsCurrentLineBlame = { fg = gray2 }

                -- Gitsigns
                hl.GitSignsAdd = { fg = gray2 }
                hl.GitSignsAddNr = { fg = gray2 }
                hl.GitSignsAddLn = { fg = gray2 }
                hl.GitSignsChange = { fg = gray2 }
                hl.GitSignsChangeNr = { fg = gray2 }
                hl.GitSignsChangeLn = { fg = gray2 }
                hl.GitSignsDelete = { fg = gray2 }
                hl.GitSignsDeleteNr = { fg = gray2 }
                hl.GitSignsTopDelete = { fg = gray2 }
                hl.GitSignsCurrentLineBlame = { fg = gray2 }

                -- NvimTree
                -- hl.NvimTreeGitDirty = { fg = blue }
                -- hl.NvimTreeGitStaged = { fg = blue }
                -- hl.NvimTreeGitMerge = { fg = blue }
                -- hl.NvimTreeGitRenamed = { fg = blue }
                -- hl.NvimTreeGitNew = { fg = blue }
                -- hl.NvimTreeGitDeleted = { fg = blue }
                -- hl.NvimTreeCursorLine = { bg = black }
                hl.NvimTreeFolderName = { fg = blue }
                hl.NvimTreeFolderArrowOpen = { fg = gray1 }
                hl.NvimTreeFolderArrowClosed = { fg = gray1 }
                hl.NvimTreeOpenedFolderName = { fg = blue }
                hl.NvimTreeEmptyFolderName = { fg = blue }
                hl.NvimTreeRootFolder = { fg = bone, bold = true }
                hl.NvimTreeSpecialFile = { fg = bone, bold = true }

            end,
        }
    end,
}
