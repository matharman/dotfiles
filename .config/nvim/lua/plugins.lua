local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use "lewis6991/impatient.nvim"

    -- Autogenerate docstrings :O
    use "danymat/neogen"

    -- Colors
    use "nvim-treesitter/nvim-treesitter"
    use "marko-cerovac/material.nvim"
    use "EdenEast/nightfox.nvim"

    -- Built-in LSP
    use "neovim/nvim-lspconfig"
    use "williamboman/nvim-lsp-installer"
    use "ray-x/lsp_signature.nvim"

    -- NVIM Config Hacking
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

    -- Rust goodies
    use "simrat39/rust-tools.nvim"

    -- Git goodies
    use "tpope/vim-fugitive"
    -- use {
    --     "TimUntersberger/neogit",
    --     requires = {
    --         "nvim-lua/plenary.nvim",
    --         "sindrets/diffview.nvim",
    --     },
    -- }

    use {
        "ruifm/gitlinker.nvim",
        requires = "nvim-lua/plenary.nvim",
    }

    -- Focus mode (nice for RO stuff)
    use "junegunn/goyo.vim"

    -- Motion comments
    use "numToStr/Comment.nvim"

    use { "junegunn/fzf", run = "./install --all" }
    use "junegunn/fzf.vim"

    -- Better tmux
    use "christoomey/vim-tmux-navigator"

    -- Must be placed after all plugin specs
    if packer_bootstrap then
        require('packer').sync()
    end
end)

local custom_cxx_template = {
    template = {
        annotation_convention = "custom",
        custom =  {
            { nil, "/// @file", { no_results = true, type = { "file" } } },
            { nil, "/// @brief $1", { no_results = true, type = { "func", "file" } } },
            { nil, "", { no_results = true, type = { "file" } } },

            { nil, "/// @brief $1", { type = { "func" } } },
            { "tparam", "/// @tparam %s $1" },
            { "parameters", "/// @param %s $1" },
            { "return_statement", "/// @return $1" },
        },
    }
}

require("neogen").setup {
    enabled = true,
    languages = {
        c = custom_cxx_template,
        cpp = custom_cxx_template,
    }
}

require("lsp_signature").setup()
require("gitlinker").setup()
require("Comment").setup()

vim.cmd([[
augroup PackerCompile
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]])

require("mh-cmp")
require("mh-lsp")
require("mh-snippets")
