require("config.lazy")

--  General config
vim.g.mapleader = " "
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")


-- Colour Scheme
vim.cmd.colorscheme "catppuccin"

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

-- oil
require("oil").setup({
	columns = {
		"icon",
	},
	delete_to_trash = false,
	view_options = {
		show_hidden = false,
	},
})

vim.keymap.set('n', '<leader>fm', require("oil").toggle_float)
