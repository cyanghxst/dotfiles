return {
    "goolord/alpha-nvim",
    -- enabled = true,
    event = "VimEnter",
    opts = function()
        local dashboard = require("alpha.themes.dashboard")
        local logo = [[
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████


        ]]

        dashboard.section.header.val = vim.split(logo, "\n")
        dashboard.section.buttons.val = {
            dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
            dashboard.button("g", "󰷾 " .. " Find text", ":Telescope live_grep <CR>"),
            dashboard.button("b", " " .. " File browser", ":Joshuto <CR>"),
            dashboard.button("r", "󰄉 " .. " Recent files", ":Telescope oldfiles <CR>"),
            dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
            dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
            dashboard.button("q", " " .. " Quit", ":qa<CR>"),
        }

        -- set highlight
        for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = "AlphaButtons"
            button.opts.hl_shortcut = "AlphaShortcut"
        end
        dashboard.section.header.opts.hl = "AlphaHeader"
        dashboard.section.buttons.opts.hl = "AlphaButtons"
        dashboard.section.footer.opts.hl = "AlphaFooter"
        dashboard.opts.layout[1].val = 8
        return dashboard
    end,
    config = function(_, dashboard)
        -- close Lazy and re-open when the dashboard is ready
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
                local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                local version = "  󰥱 v" .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
                local plugins = "⚡Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                local footer = version .. "\t" .. plugins .. "\n"
                dashboard.section.footer.val = footer
                pcall(vim.cmd.AlphaRedraw)
            end,
        })
    end,
}

-- return {
--     "goolord/alpha-nvim",
--     enabled = false,
--     config = function()

--         local present, alpha = pcall(require, "alpha")
--         if not present then
--             return "Alpha has an error"
--         end

--         local header = {
--             type = "text",
--             val = {

--                 [[                                                                   ]],
--                 [[      ████ ██████           █████      ██                    ]],
--                 [[     ███████████             █████                            ]],
--                 [[     █████████ ███████████████████ ███   ███████████  ]],
--                 [[    █████████  ███    █████████████ █████ ██████████████  ]],
--                 [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
--                 [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
--                 [[██████  █████████████████████ ████ █████ █████ ████ ██████]],

--             },
--             opts = {
--                 position = "center",
--                 hl = "Function",
--             },
--         }

--         local function button(sc, txt, keybind)
--             local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
--             local opts = {
--                 position = "center",
--                 text = txt,
--                 shortcut = sc,
--                 cursor = 4,
--                 width = 19,
--                 align_shortcut = "right",
--                 hl_shortcut = "Number",
--                 hl = "Function",
--             }
--             if keybind then
--                 opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
--             end
--             return {
--                 type = "button",
--                 val = txt,
--                 on_press = function()
--                     local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
--                     vim.api.nvim_feedkeys(key, "normal", false)
--                 end,
--                 opts = opts,
--             }
--         end

--         local buttons = {
--             type = "group",
--             val = {
--                 button("f", "   Find Files                          ", ":Telescope find_files<CR>"),
--                 button("t", "   Find Text                           ", ":Telescope live_grep<CR>"),
--                 button("n", "   New Files                           ", ":ene <BAR> startinsert<CR>"),
--                 button("r", "   Recents                             ", ":Telescope oldfiles<CR>"),
--                 button("u", "   Update                              ", ":Lazy update<CR>"),
--                 button("s", "   Settings                            " ,":cd ~/.config/nvim | :e lua/plugins/alpha.lua | :NvimTreeToggle<CR>"),
--                 button("q", "   Quit                                ", ":qa!<CR>"),
--             },
--             opts = {
--                 position = "center",
--                 spacing = 1,
--             },
--         }

--         local function footer()
--             local stats = require("lazy").stats()
--             local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
--             return  "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms"
--         end

--         -- local function footer()
--         --     local plugins = #vim.tbl_keys(require("lazy").plugins())
--         --     local version = vim.version()
--         --     local nvim_version_info = version.major .. "." .. version.minor .. "." .. version.patch
--         --     return "󰋼  " .. nvim_version_info .. "    " .. "  " .. plugins .. " Plugins"
--         -- end

--         local footer = {
--             type = "text",
--             val = footer,
--             opts = {
--                 position = "center",
--                 hl = "DiagnosticUnnecessary",
--             },
--         }

--         local section = {
--             header = header,
--             buttons = buttons,
--             footer = footer,
--         }

--         local opts = {
--             layout = {
--                 { type = "padding", val = 5 },
--                 section.header,
--                 { type = "padding", val = 3 },
--                 section.buttons,
--                 { type = "padding", val = 2 },
--                 section.footer,
--             },
--             opts = {
--                 margin = 44,
--             },
--         }

--         alpha.setup(opts)
--     end,
-- }
