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
            -- el.opts.width = 40 -- or some other value
            el.opts.width = 36 -- or some other value
        end

        -- Set highlight
        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
        end

        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"

        -- Set padding
        -- dashboard.opts.layout[1].val = 2
        -- dashboard.opts.layout[1].val = 3
        -- dashboard.opts.layout[1].val = 6

        -- new layout
        dashboard.opts.layout[1].val = 7 -- header padding
        dashboard.opts.layout[3].val = 3 -- body padding
        table.insert(dashboard.config.layout, 5, {
            type = 'padding',
            val = 2, -- footer padding
        })

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
                -- local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

                -- local plugins = "  " .. stats.count .. " plugins in " .. ms .. " ms"
                -- local footer = version .. "\t" .. plugins .. "\n"

                local plugins = "  " .. stats.count .. " Plugins"
                local footer = " " ..version .. "\t  " .. plugins .. "\n"

                dashboard.section.footer.val = footer
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}
