return {
    "catppuccin/nvim",
    enabled = true,
    priority = 1000,
    init = function()
        vim.cmd.colorscheme [[catppuccin]]
    end,
}
