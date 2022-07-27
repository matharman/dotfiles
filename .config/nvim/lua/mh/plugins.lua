vim.g.use_telescope = true

-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false;
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = true
    vim.fn.execute("!git clone --depth 1 https://github.com/wbthomason/packer.nvim " .. install_path)
    vim.cmd[[packadd packer.nvim]]
end

require("packer").startup(function(use)
    --EXPERIMENTAL
    use "nathom/filetype.nvim"

    use "wbthomason/packer.nvim"
    use "lewis6991/impatient.nvim"

    -- Treesitter
    use "nvim-treesitter/nvim-treesitter"
    use "nvim-treesitter/nvim-treesitter-textobjects"

    -- Autogenerate docstrings :O
    use "danymat/neogen"
    -- Colors
    use "marko-cerovac/material.nvim"
    use "EdenEast/nightfox.nvim"
    use "rebelot/kanagawa.nvim"
    -- LSP
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig"
    use "ray-x/lsp_signature.nvim"
    -- Completion
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        }
    }
    -- Snippets
    use {
        "L3MON4D3/LuaSnip",
        requires = { "saadparwaiz1/cmp_luasnip" },
    }
    -- Rust goodies
    use "simrat39/rust-tools.nvim"
    -- Git goodies
    use "tpope/vim-fugitive"
    use {
        "ruifm/gitlinker.nvim",
        requires = "nvim-lua/plenary.nvim",
    }
    use "rhysd/git-messenger.vim"
    -- Focus mode (nice for RO stuff)
    use "folke/zen-mode.nvim"
    use "folke/twilight.nvim"
    -- Motion comments
    use "numToStr/Comment.nvim"

    -- TELESCOPE
    use {
        "nvim-telescope/telescope.nvim", tag = "0.1.0",
        requires = {"nvim-lua/plenary.nvim"},
        disable = not vim.g.use_telescope,
    }
    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        disable = not vim.g.use_telescope,
    }

    -- FZF
    use {
        "junegunn/fzf",
        run = "./install --all",
    }

    if not vim.g.use_telescope then
        use "junegunn/fzf.vim"
    end

    -- Better tmux
    use "christoomey/vim-tmux-navigator"

    -- Case mutations
    use "tpope/vim-abolish"

    if packer_bootstrap then
        print("Bootstrapping packer...");
        require("packer").sync()
        vim.fn.input("Bootstrap done. Exiting");
        vim.cmd[[quitall]]
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

require("mason").setup()
require("mason-lspconfig").setup()

require("neogen").setup {
    enabled = true,
    languages = {
        c = custom_cxx_template,
        cpp = custom_cxx_template,
    }
}

require("zen-mode").setup {}
require("twilight").setup {}

require("lsp_signature").setup()
require("gitlinker").setup()
require("Comment").setup()

local telescope = require("telescope")
telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = "which_key",
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
            },
        },
    },
    pickers = {
    },
    extensions = {
        -- fzf = {
        --     fuzzy = true,
        --     override_generic_sort = true,
        --     override_file_sort = true,
        -- },
    },
})

-- telescope.load_extension("fzf")

-- Livegrep
if vim.g.use_telescope then
    vim.api.nvim_create_user_command("Rg", "Telescope live_grep", {})
end

require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']]'] = '@function.outer',
              -- [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']['] = '@function.outer',
              -- [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[['] = '@function.outer',
              -- ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[]'] = '@function.outer',
              -- ['[]'] = '@class.outer',
            },
        },
    },
})

local group = vim.api.nvim_create_augroup("automagic", { clear = false })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = "plugins.lua",
    command = "source <afile> | PackerCompile",
})
