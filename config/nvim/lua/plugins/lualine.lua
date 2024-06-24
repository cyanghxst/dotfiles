return {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    opts = function()
        local colors = { 
            gray = "#414868",
        }
        local minimal_theme = {
            normal = {
                a = { fg = colors.gray, bg = nil },
                b = { fg = colors.gray, bg = nil },
                c = { fg = colors.gray, bg = nil },
            },
            inactive = {
                a = { fg = colors.gray, bg = nil },
                b = { fg = colors.gray, bg = nil },
                c = { fg = colors.gray, bg = nil },
            },
        }
        return {
            options = {
                theme = minimal_theme,
                disabled_filetypes = { 
                    statusline = { "alpha", "lazy", "NvimTree", "Telescope" },
                },
                globalstatus = true,
            },
            sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {},
                lualine_x = {
                    {
                        "branch",
                        icons_enabled = false,
                    }
                },
                lualine_y = { "filename" },
                lualine_z = { "progress" },
            },
        }
    end,
}
