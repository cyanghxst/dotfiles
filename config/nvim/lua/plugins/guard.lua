return {
    "nvimdev/guard.nvim",
    ft = { "lua", "cpp", "markdown" },
    dependencies = { "nvimdev/guard-collection" },
    config = function()
        vim.g.guard_config = {
            fmt_on_save = true,
            lsp_as_default_formatter = false,
            save_on_fmt = true,
        }
    end,
}
