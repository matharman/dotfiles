vim.cmd [[ packadd packer.nvim ]]

require("packer").startup(function()
    use "wbthomason/packer.nvim"

    -- Colors
    use "nvim-treesitter/nvim-treesitter"
    use "marko-cerovac/material.nvim"
    use "EdenEast/nightfox.nvim"

    -- Built-in LSP
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"

    use "folke/lua-dev.nvim"

    -- Completion
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/nvim-cmp"

    -- Snippets
    use "L3MON4D3/LuaSnip"
    use "saadparwaiz1/cmp_luasnip"

    use "simrat39/rust-tools.nvim"
    use "tpope/vim-fugitive"
    use "junegunn/goyo.vim"
end)

vim.cmd([[
  augroup PackerCompile
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

require("mh-cmp")
require("mh-lsp")
