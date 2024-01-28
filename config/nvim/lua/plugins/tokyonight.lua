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

                local white = "#c0caf5"
                local light_gray = "#a9b1d6"
                local dark_gray = "#3b4261"
                local black = "#1e2231"
                local blue = "#3b4261"
                local comment = "#565f89"
                local blue = "#7aa2f7"
                local green = "#9ece6a"
                local purple = "#9d7cd8"

                -- CursorLine
                hl.CursorLineNr = { fg = blue, bold = true }
                hl.CursorLine= { bg = black }
  
                -- MiniIndentScope
                hl.MiniIndentscopeSymbol = { fg = dark_gray }

                -- Leap
                -- hl.LeapBackdrop = { fg = c.comment, link = "comment" }
                hl.LeapLabelPrimary = { fg = green, bold = true }
                -- hl.LeapLabelSecondary = { bg = purple, fg = comment }

                -- Gitsigns
                hl.GitSignsAdd = { fg = blue }
                hl.GitSignsAddNr = { fg = blue }
                hl.GitSignsAddLn = { fg = blue }
                hl.GitSignsChange = { fg = blue }
                hl.GitSignsChangeNr = { fg = blue }
                hl.GitSignsChangeLn = { fg = blue }
                hl.GitSignsCurrentLineBlame = { fg = blue }

                -- NvimTree
                hl.NvimTreeGitDirty = { fg = blue }
                hl.NvimTreeGitStaged = { fg = blue }
                hl.NvimTreeGitMerge = { fg = blue }
                hl.NvimTreeGitRenamed = { fg = blue }
                hl.NvimTreeGitNew = { fg = blue }
                hl.NvimTreeGitDeleted = { fg = blue }
                hl.NvimTreeFolderName = { fg = blue }
                hl.NvimTreeFolderArrowOpen = { fg = blue }
                hl.NvimTreeFolderArrowClosed = { fg = blue }
                hl.NvimTreeOpenedFolderName = { fg = blue }
                hl.NvimTreeEmptyFolderName = { fg = blue }
                hl.NvimTreeRootFolder = { fg = light_gray, bold = true }
                hl.NvimTreeSpecialFile = { fg = light_gray, bold = true }

            end,
        }
    end,
}
