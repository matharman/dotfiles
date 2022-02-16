require("plugins")

-- COMPLETION
vim.o.completeopt = "menu,menuone,noselect"

-- APPEARANCE
vim.g.material_style = "deep ocean"
require("material").setup()
vim.cmd([[colorscheme material]])
vim.o.cursorline = true

-- BUFFER MANAGEMENT
vim.o.directory = os.getenv('HOME') .. "/.config/nvim/.swapfiles/"
vim.o.hidden = true

require("keybinds")

-- AUTOCMDS
vim.cmd([[
augroup Automation
	autocmd!

	" Automatically eval vimrc on save
	autocmd BufWritePost $MYVIMRC source $MYVIMRC

	autocmd FileType yaml setlocal softtabstop=2 | setlocal shiftwidth=2
augroup end
]])
