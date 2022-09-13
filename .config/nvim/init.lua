vim.g.mapleader = " "

-- Startup time optimizer
pcall(require, "impatient")

local mh = require("mh")
require("mh.plugins")
require("mh.keybinds")

-- COMPLETION
vim.o.completeopt = "menu,menuone,noselect"

-- APPEARANCE
vim.o.cursorline = true
vim.o.termguicolors = true
vim.cmd[[colorscheme nightfox]]

-- DEFAULT TABS
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

-- AUTOCMDS
mh.create_automagic_cmd("Auto-source vimrc", "BufWritePost", {
    pattern = vim.fn.expand("$MYVIMRC"),
    command = "source $MYVIMRC",
})

local function load_project_nvimrc(path)
    path = path .. "/.nvimrc"
    local fstat = vim.loop.fs_stat(path)
    if fstat then
        local uid = vim.loop.getuid()
        local gid = vim.loop.getgid()
        if fstat.uid == uid or fstat.gid == gid then
            vim.cmd("source " .. path)
            print("loaded local config from " .. path)
        end
    end
end

-- Manage local project settings
local root = mh.find_project_root()
if root then
    load_project_nvimrc(root)
end

require("mh.lsp").setup_lsp()
require("mh.snippets")
require("mh.cmp")
