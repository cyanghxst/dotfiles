return {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    opts = function()
        local colors = { 
            gray = "#414868",
        }
        local minimal_theme = {
            normal = {
                a = { fg = colors.gray, bg = none },
                b = { fg = colors.gray, bg = none },
                c = { fg = colors.gray, bg = none },
            },
            -- inactive = {
            --     a = { fg = colors.gray, bg = none },
            --     b = { fg = colors.gray, bg = none },
            --     c = { fg = colors.gray, bg = none },
            -- },
        }
        return {
            options = {
                theme = minimal_theme,
                disabled_filetypes = {
                    "alpha",
                    "lazy",
                    "NvimTree",
                    "dashboard",
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
