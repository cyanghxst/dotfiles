return {
    "hrsh7th/nvim-cmp",
    enabled = true,
    event = "InsertEnter",
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            build = (function()
                if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                    return
                end
                return "make install_jsregexp"
            end)(),
            dependencies = {
                {
                    "rafamadriz/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
            },
        },
        {
            "roobert/tailwindcss-colorizer-cmp.nvim",
            -- optionally, override the default options:
            config = function()
                require("tailwindcss-colorizer-cmp").setup({
                    color_square_width = 2,
                })
            end,
        },
        "onsails/lspkind.nvim",
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        luasnip.config.setup({})

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,noinsert,noselect",
                scrollbar = true,
            },

            window = {
                completion = {
                    winhighlight = "Normal:CmpPmenu,FloatBorder:TelescopeBorder",
                    scrollbar = true,
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                    -- border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                },
                documentation = {
                    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
                    -- border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" },
                    winhighlight = "Normal:CmpPmenu,FloatBorder:TelescopeBorder",
                },
            },
            snippet = {
                scrollbar = true,
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
                maxwidth = 10,
            },

            mapping = {
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<tab>"] = cmp.mapping.select_next_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.close(),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = false,
                }),
            },
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "nvim_lua" },
                { name = "path" },
            },
        })
    end,
}
