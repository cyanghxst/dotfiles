return {
    "catppuccin/nvim",
    enabled = false,
    priority = 1000,
    init = function()
        vim.cmd.colorscheme [[catppuccin]]
    end,
}
