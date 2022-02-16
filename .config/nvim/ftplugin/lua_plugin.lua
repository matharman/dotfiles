-- EZ source binding
vim.api.nvim_buf_set_keymap(0, "n", "<Leader>s", ":luafile %<CR>", { noremap = true})

vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true
