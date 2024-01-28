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
                local blue = "#7aa2f7"
                -- local blue0 = "#3d59a1"
                -- local blue1 = "#2ac3de"
                -- local blue2 = "#0db9d7"
                -- local blue5 = "#89ddff"
                -- local blue6 = "#b4f9f8"
                -- local blue7 = "#394b70"
                local purple = "#9d7cd8"

                -- CursorLine
                hl.CursorLineNr = { fg = blue, bold = true }
                hl.CursorLine= { bg = black, bold = true }

                -- MiniIndentScope
                hl.MiniIndentscopeSymbol = { fg = dark_gray }

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
                hl.NvimTreeFolderName = { fg = light_gray }
                hl.NvimTreeOpenedFolderName = { fg = light_gray }
                hl.NvimTreeEmptyFolderName = { fg = light_gray }
                hl.NvimTreeRootFolder = { fg = light_gray, bold = true }
                hl.NvimTreeSpecialFile = { fg = light_gray, bold = true }
                -- hl.NvimTreeNormalFloat = { bg = BG }
                -- hl.NvimTreeCursorLine = { bg = ALMOST_BG }
                -- hl.NvimTreeIndentMarker = { fg = STRONG_FADED_GRAY }
                -- hl.NvimTreeImageFile = { fg = WHITE }
                -- hl.NvimTreeFolderIcon = { fg = GRAY }
                -- hl.NvimTreeFolderIconOpen = { fg = GRAY }
                -- hl.NvimTreeFolderSymlink = { fg = GRAY }
                -- hl.NvimTreeDefault = { fg = GRAY }
                -- hl.NvimTreeSymlink = { fg = GRAY }
                -- hl.NvimTreeBookmark = { fg = GRAY }

            end,
        }
    end,
}
