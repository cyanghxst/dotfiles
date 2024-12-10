return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- Optional, for file icons
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    init = function()
        vim.api.nvim_set_hl(0, "NeoTreeModified", { fg = "#a9b1d6" }) -- Custom highlight for modified files
        vim.g.neo_tree_remove_legacy_commands = 1 -- Remove deprecated commands
    end,
    keys = {
        { "<leader>s", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    },
    opts = {
        close_if_last_window = true,
        -- enable_git_status = false,
        enable_diagnostics = false,
        enable_cursor_hijack = true,
        filesystem = {
            filtered_items = {
                hide_dotfiles = false, -- Show dotfiles (set true to hide)
            },
            follow_current_file = true, -- Focus the file in the tree
            hijack_netrw_behavior = "open_current", -- Open in current window like netrw
            use_libuv_file_watcher = true, -- Automatically update the tree
            components = {
                name = function(config, node, state)
                    local components = require("neo-tree.sources.common.components")
                    local name = components.name(config, node, state)
                    if node:get_depth() == 1 then
                        local root_name = vim.fs.basename(vim.loop.cwd() or '')
                        name.text = string.upper(root_name) -- Convert to uppercase
                        name.highlight = "NeoTreeRootName" -- Ensure the root folder has a specific highlight
                    end
                    return name
                end,
                icon = function(config, node, state)
                    if node:get_depth() == 1 then
                        return { text = " " } -- Remove icon for root folder
                    end
                    local components = require("neo-tree.sources.common.components")
                    return components.icon(config, node, state)
                end,
                indent = function(config, node, state)
                    if node:get_depth() == 1 then
                        return { text = "" } -- Remove indentation for root folder
                    end
                    local components = require("neo-tree.sources.common.components")
                    return components.indent(config, node, state)
                end,
            },
        },
        window = {
            width = 25,
            position = "left",
        },
        default_component_configs = {
            indent = {
                with_markers = false, -- Enable indentation for other levels
                with_expanders = true,
                expander_collapsed = "",
                expander_expanded = "",
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "",
                default = "",
                modified = "[+]",
            },
            modified = {
                symbol = "[+]", -- Symbol for modified files
            },
            git_status = {
                symbols = {
                    -- Change type
                    added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted   = "",-- this can only be used in the git_status source
                    renamed   = "",-- this can only be used in the git_status source
                    -- Status type
                    untracked = "",
                    ignored   = "",
                    unstaged  = "",
                    staged    = "",
                    conflict  = "",
                }
            },
            name = {
                use_git_status_colors = false, -- Disable git-based colors
            },
        },
        renderers = {
            directory = {
                { "indent" },
                { "icon" },
                { "name", highlight_opened_files = "none" },
            },
        },
    },
}
