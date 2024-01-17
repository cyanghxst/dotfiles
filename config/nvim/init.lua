vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.fn.has("termguicolors") == 1 then
    vim.o.termguicolors = true
end

require("core.lazy")
require("core.options")
require("core.autocmds")
require("core.keymaps")
