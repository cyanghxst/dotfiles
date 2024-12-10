return {
    "echasnovski/mini.indentscope",
    event = { "BufReadPre", "BufNewFile" },
    enabled = true,
    version = false,
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = {
                "alpha",
                "help",
                "lazy",
                "mason",
                "notify",
                "Trouble",
                "nvimtree",
                "dashboard",
                "neo-tree"
            },
            callback = function()
                vim.b.miniindentscope_disable = true
            end,
        })
    end,
    opts = {
        draw = {
            delay = 100,
            priority = 2,
        },
        mappings = {
            object_scope = "ii",
            object_scope_with_border = "ai",
            goto_top = "[i",
            goto_bottom = "]i",
        },
        options = {
            border = "both",
            indent_at_cursor = true,
            try_as_border = true,
        },
        symbol = "│",
    }
}
