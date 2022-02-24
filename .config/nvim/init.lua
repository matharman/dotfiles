-- Startup time optimizer
pcall(require, "impatient")

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

local function load_project_nvimrc(path)
    path = path .. "/.nvimrc"
    local fstat = vim.loop.fs_stat(path)
    if fstat then
        local uid = vim.loop.getuid()
        local gid = vim.loop.getgid()
        if fstat.uid == uid or fstat.gid == gid then
            vim.cmd("source " .. path)
        end
    end
end

local function find_project_root(max_depth, patterns)
    patterns = patterns or { ".git", "compile_commands.json" }
    max_depth = max_depth or 10

    local path = vim.fn.getcwd()

    for _ = 1, max_depth do
        for _, value in pairs(patterns) do
            local fstat = vim.loop.fs_stat(path .. "/" .. value)
            if fstat then
                return path
            end
        end
        path = path .. "/.."
    end

    return nil
end

-- Manage local project settings
local root = find_project_root()
if root then
    load_project_nvimrc(root)
end
