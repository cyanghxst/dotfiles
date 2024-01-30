return {
    "nvimdev/dashboard-nvim",
    enabled = true,
    event = "VimEnter",
    opts = function()

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

        logo = string.rep("\n", 5) .. logo .. "\n\n"

        local opts = {
            theme = "doom",
            hide = {
                -- this is taken care of by lualine
                -- enabling this messes up the actual laststatus setting after loading a file
                statusline = false,
            },
            config = {
                header = vim.split(logo, "\n"),
                -- stylua: ignore
                center = {
                    { action = "Telescope find_files",                                               desc = " Find file", icon = "  ", key = "f" },
                    { action = "Telescope live_grep",                                                desc = " Find text", icon = "  ", key = "n" },
                    { action = "ene | startinsert",                                                  desc = " New file",  icon = "  ", key = "r" },
                    { action = "Telescope oldfiles",                                                 desc = " Recent",    icon = "  ", key = "t" },
                    { action = "cd ~/.config/nvim | :e lua/plugins/alpha.lua | :NvimTreeToggle<CR>", desc = " Settings",  icon = "  ", key = "s" },
                    { action = "Lazy update",                                                        desc = " Update",    icon = "  ", key = "u" },
                    { action = "qa!",                                                                desc = " Quit",      icon = "  ", key = "q" },
                },

                -- footer = function()
                --     local plugins = #vim.tbl_keys(require("lazy").plugins())
                --     local version = vim.version()
                --     local nvim_version_info = version.major .. "." .. version.minor .. "." .. version.patch
                --     return { "󰋼  " .. nvim_version_info .. "    " .. "  " .. plugins .. " Plugins" }
                -- end,

                footer = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
                end,
            },
        }

        for _, button in ipairs(opts.config.center) do
            button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
            button.key_format = "  %s"
        end

        -- close Lazy and re-open when the dashboard is ready
        if vim.o.filetype == "lazy" then
            vim.cmd.close()
            vim.api.nvim_create_autocmd("User", {
                pattern = "DashboardLoaded",
                callback = function()
                    require("lazy").show()
                end,
            })
        end

        return opts
    end,
}
