vim.g.mapleader = " "

-- Easy FZF file search
vim.api.nvim_set_keymap("n", "<leader>f", "<Cmd>Files<CR>", { noremap = true, silent = true })

-- Easy FZF buffer switch
vim.api.nvim_set_keymap("n", "<leader>b", "<Cmd>Buffers<CR>", { noremap = true, silent = true })

-- Easy open vimrc
vim.api.nvim_set_keymap("n", "<leader><leader>v", "<Cmd>e $MYVIMRC<CR>", { noremap = true, silent = true })

-- Easy open nvim config
local nvim_config_dir = "$HOME/.config/nvim"
vim.api.nvim_set_keymap("n", "<leader>lu", "<Cmd>Files " .. nvim_config_dir .. "<CR>", { noremap = true })
