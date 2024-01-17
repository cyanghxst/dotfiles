-- Minimal line
return {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    opts = function()
        local colors = { 
            grey = "#414868",
            black = "#000000",
        }
        local minimal_theme = {
            normal = {
                a = { fg = colors.grey, bg = none },
                b = { fg = colors.grey, bg = none },
                c = { fg = colors.grey, bg = none },
            },
            inactive = {
                a = { fg = colors.grey, bg = none },
                b = { fg = colors.grey, bg = none },
                c = { fg = colors.grey, bg = none },
            },
        }
        return {
            options = {
                theme = minimal_theme,
                disabled_filetypes = {
                    "alpha",
                    "lazy",
                    "NvimTree",
                },
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
