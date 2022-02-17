vim.g.mapleader = " "

-- Easy open vimrc
vim.api.nvim_set_keymap("n", "<leader><leader>v", "<Cmd>e $MYVIMRC<CR>", { noremap = true, silent = true })
