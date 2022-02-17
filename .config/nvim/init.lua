require("plugins")

-- COMPLETION
vim.o.completeopt = "menu,menuone,noselect"

-- APPEARANCE
vim.o.cursorline = true
vim.cmd([[colorscheme nightfox]])

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

	autocmd FileType yaml setlocal softtabstop=2 | setlocal shiftwidth=2 | set expandtab
augroup end
]])

-- Load project local settings
local project_settings = vim.fn.getcwd() .. "/.nvimrc"
local fstat = vim.loop.fs_stat(project_settings)
if fstat then
    local uid = vim.loop.getuid()
    local gid = vim.loop.getgid()
    if fstat.uid == uid or fstat.gid == gid then
        vim.cmd("source " .. project_settings)
    end
end
