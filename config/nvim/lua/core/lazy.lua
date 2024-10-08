-- Automatically install Lazy on startup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Automatically source all configs in plugins directory
require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
	ui = {
        -- border = "single",
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		-- size = {
		-- 	width = 0.8,
		-- 	height = 0.8,
		-- },
	},
})
