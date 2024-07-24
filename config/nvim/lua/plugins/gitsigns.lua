return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    enabled = true,
    config = {
        numhl = false,
        -- signcolumn = false,
        linehl = false,
        watch_gitdir = {
            interval = 1000,
            follow_files = true,
        },

        signs = {
            add          = { text = "⎮" },
            change       = { text = "⎮" },
            delete       = { text = "_" },
            topdelete    = { text = "‾" },
            changedelete = { text = "~" },
            untracked    = { text = "┆" },
        },

        signs_staged = {
            add          = { text = "⎮" },
            change       = { text = "⎮" },
            delete       = { text = "_" },
            topdelete    = { text = "‾" },
            changedelete = { text = "~" },
            untracked    = { text = "┆" },
        },

        current_line_blame = false,
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        word_diff = false,
        -- keymaps = {},
    }
}
