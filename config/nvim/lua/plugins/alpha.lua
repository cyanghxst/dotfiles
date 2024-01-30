return {
    "goolord/alpha-nvim",
    enabled = true,
    config = function()

        local present, alpha = pcall(require, "alpha")
        if not present then
            return "Alpha has an error"
        end

        local header = {
            type = "text",
            val = {

                [[                                                                   ]],
                [[      ████ ██████           █████      ██                    ]],
                [[     ███████████             █████                            ]],
                [[     █████████ ███████████████████ ███   ███████████  ]],
                [[    █████████  ███    █████████████ █████ ██████████████  ]],
                [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
                [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
                [[██████  █████████████████████ ████ █████ █████ ████ ██████]],

            },
            opts = {
                position = "center",
                hl = "Function",
            },
        }

        local function button(sc, txt, keybind)
            local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
            local opts = {
                position = "center",
                text = txt,
                shortcut = sc,
                cursor = 4,
                width = 19,
                align_shortcut = "right",
                hl_shortcut = "Number",
                hl = "Function",
            }
            if keybind then
                opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
            end
            return {
                type = "button",
                val = txt,
                on_press = function()
                    local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
                    vim.api.nvim_feedkeys(key, "normal", false)
                end,
                opts = opts,
            }
        end

        local buttons = {
            type = "group",
            val = {
                button("f", "   Find Files                          ", ":Telescope find_files<CR>"),
                button("t", "   Find Text                           ", ":Telescope live_grep<CR>"),
                button("n", "   New Files                           ", ":ene <BAR> startinsert<CR>"),
                button("r", "   Recents                             ", ":Telescope oldfiles<CR>"),
                button("u", "   Update                              ", ":Lazy update<CR>"),
                button("s", "   Settings                            " ,":cd ~/.config/nvim | :e lua/plugins/alpha.lua | :NvimTreeToggle<CR>"),
                button("q", "   Quit                                ", ":qa!<CR>"),
            },
            opts = {
                position = "center",
                spacing = 1,
            },
        }

        -- local function footer()
        --     local stats = require("lazy").stats()
        --     local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        --     return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        -- end

        local function footer()
            local plugins = #vim.tbl_keys(require("lazy").plugins())
            local version = vim.version()
            local nvim_version_info = version.major .. "." .. version.minor .. "." .. version.patch
            return "󰋼  " .. nvim_version_info .. "    " .. "  " .. plugins .. " Plugins"
        end

        local footer = {
            type = "text",
            val = footer,
            opts = {
                position = "center",
                hl = "DiagnosticUnnecessary",
            },
        }

        local section = {
            header = header,
            buttons = buttons,
            footer = footer,
        }

        local opts = {
            layout = {
                { type = "padding", val = 5 },
                section.header,
                { type = "padding", val = 3 },
                section.buttons,
                { type = "padding", val = 2 },
                section.footer,
            },
            opts = {
                margin = 44,
            },
        }

        alpha.setup(opts)
    end,
}
