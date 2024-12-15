return {
    "brenoprata10/nvim-highlight-colors",
    enabled = true,
    config = function()
        require("nvim-highlight-colors").setup {
            render = 'virtual',
            virtual_symbol = '',
            virtual_symbol_suffix = '',
            virtual_symbol_position = 'eol',

            enable_hex = true,
            enable_short_hex = true,
            enable_rgb = true,
            enable_hsl = true,
            enable_var_usage = true,
            enable_named_colors = false,
            enable_tailwind = false,

            custom_colors = {
                { label = '%-%-theme%-primary%-color', color = '#0f1219' },
                { label = '%-%-theme%-secondary%-color', color = '#5a5d64' },
            },
        }
    end
}
