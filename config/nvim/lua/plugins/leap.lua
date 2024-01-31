return {
    "ggandor/leap.nvim",
    event = { "BufReadPre", "BufNewFile" },
    enabled = true,
    config = function()
        -- local leap = require('leap')
        -- leap.add_default_mappings()

        --bidirectional search
        vim.keymap.set({"n", "x", "o"}, "s", function()
            local current_window = vim.fn.win_getid()
            require("leap").leap { target_windows = { current_window } }
        end)
        -- search in all windows
        vim.keymap.set({"n", "x", "o"}, "gs", function()
            local focusable_windows_on_tabpage = vim.tbl_filter(
            function (win) return vim.api.nvim_win_get_config(win).focusable end,
            vim.api.nvim_tabpage_list_wins(0)
            )
            require('leap').leap { target_windows = focusable_windows_on_tabpage }
        end)
        -- search in other windows
        -- vim.keymap.set({"n", "x", "o"}, "gs", function()
        --     require("leap").leap { target_windows = require("leap.util").get_enterable_windows() }
        -- end)
    end,
}
