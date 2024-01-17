return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    init = function()
        vim.cmd.colorscheme [[tokyonight]]
    end,
    opts = { 
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
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
        on_colors = function(colors) end,
        on_highlights = function(highlights) end,
    },
}
