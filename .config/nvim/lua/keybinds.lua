vim.g.mapleader = " "

-- Easy FZF git file search
vim.keymap.set("n", "<leader>gf", "<Cmd>GFiles<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>f", "<Cmd>Files<CR>", { noremap = true, silent = true })

-- Easy FZF buffer switch
vim.keymap.set("n", "<leader>b", "<Cmd>Buffers<CR>", { noremap = true, silent = true })

local nvim_config_dir = "$HOME/.config/nvim"

-- Easy open vimrc
local vimrc_edit_cmd = "<Cmd>tabnew | e " .. nvim_config_dir .. " | vs $MYVIMRC<CR>"
vim.keymap.set("n", "<leader><leader>v", vimrc_edit_cmd, { noremap = true, silent = true })

-- Fugitive workflow
local function open_git_if_fugitive()
    if vim.g.loaded_fugitive then
        vim.api.nvim_command[[tabnew | Git | only]]
        local current_win = vim.api.nvim_get_current_win()

        vim.api.nvim_command[[vert Git log]]
        vim.api.nvim_set_current_win(current_win)
    end
end

vim.keymap.set("n", "<leader>G", open_git_if_fugitive, { noremap = true, silent = true })
