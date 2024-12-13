return {
    "goolord/alpha-nvim",
    enabled = true,
    event = "VimEnter",
    opts = function()
        local dashboard = require("alpha.themes.dashboard")

        local header = {
            [[                                                                   ]],
            [[      ████ ██████           █████      ██                    ]],
            [[     ███████████             █████                            ]],
            [[     █████████ ███████████████████ ███   ███████████  ]],
            [[    █████████  ███    █████████████ █████ ██████████████  ]],
            [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
            [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
            [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
        }
        dashboard.section.header.val = header

        -- Define buttons
        dashboard.section.buttons.val = {
            dashboard.button("f", " " .. " Find File", ":Telescope find_files<CR>"),
            dashboard.button("t", " " .. " Find Text", ":Telescope live_grep<CR>"),
            dashboard.button("n", " " .. " New File", ":ene | startinsert<CR>"),
            dashboard.button("r", " " .. " Recent", ":Telescope oldfiles<CR>"),
            dashboard.button("u", " " .. " Update", ":Lazy update<CR>"),
            dashboard.button("s", " " .. " Settings", ":cd ~/.config/nvim | :e lua/plugins/alpha.lua | :NvimTreeToggle<CR> | :lua vim.cmd('wincmd l')<CR>"),
            dashboard.button("q", " " .. " Quit", ":qa!<CR>"),
        }

        -- Set width
        for _, el in pairs(dashboard.section.buttons.val) do
            el.opts.position = "center"
            el.opts.width = 36
        end

        -- Dynamically calculate padding
        local term_height = vim.o.lines
        local header_padding = math.max(2, math.floor((term_height - 14) / 4)) -- Adjust as needed
        -- local footer_padding = math.max(1, math.floor((term_height - 20) / 6))

        -- Apply layout padding
        dashboard.opts.layout = {
            { type = "padding", val = header_padding },
            dashboard.section.header,
            { type = "padding", val = 4 }, -- Space between header and buttons
            dashboard.section.buttons,
            { type = "padding", val = 3 },
            dashboard.section.footer,
        }

        -- Set highlight groups
        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
        end

        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"

        return dashboard
    end,

    config = function(_, dashboard)

        -- Close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        require("alpha").setup(dashboard.opts)

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyVimStarted",
            callback = function()
                local stats = require("lazy").stats()
                local version = "󰋼  " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch

                local plugins = "  " .. stats.count .. " Plugins"
                local footer = " " ..version .. "\t  " .. plugins .. "\n"

                -- local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                -- local plugins = "  " .. stats.count .. " plugins in " .. ms .. " ms"
                -- local footer = version .. "\t" .. plugins .. "\n"

                dashboard.section.footer.val = footer
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}
