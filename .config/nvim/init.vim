" Ensure vim-plug is always installed
" Get vim-plug: https://github.com/junegunn/vim-plug

call plug#begin()
" APPEARANCE CUSTOMIZATIONS
Plug 'nvim-treesitter/nvim-treesitter', { 'branch': '0.5-compat' }
Plug 'folke/tokyonight.nvim'

" COMMENTS/DOCS
" TODO maybe vim-doge?
Plug 'vim-scripts/DoxygenToolkit.vim'
let g:DoxygenToolkit_commentType = 'C++'
Plug 'tpope/vim-commentary'

" SEARCHING
Plug 'haya14busa/is.vim'

" SNIPPETS
Plug 'norcalli/snippets.nvim'

" FILESYSTEM/UTILITIES
Plug 'airblade/vim-rooter'
let g:rooter_cd_cmd = 'lcd'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'

" LSP/COMPLETION
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'kyazdani42/nvim-web-devicons'
if exists('g:use_coq') && g:use_coq == 1
    let g:coq_settings = { 'auto_start': v:true, 
                \ 'keymap.bigger_preview': '<C-S-Tab>', 
                \ 'keymap.jump_to_mark': '<C-S-Tab>',
                \ 'limits.completion_auto_timeout': 0.99,
                \ }
else
    Plug 'hrsh7th/nvim-compe'
    Plug 'andersevenrud/compe-tmux'
endif

Plug 'simrat39/rust-tools.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
set cmdheight=2
set updatetime=300
set shortmess+=c

call plug#end()

"---------------------------------
"          APPEARANCE
"---------------------------------
set cursorline
set termguicolors
set diffopt+=vertical

let g:tokyonight_style='night'
colorscheme tokyonight

lua << LUA
    -- TODO better detection of diffmode
    if not vim.o.diff then
        require'my/lsp'
    end
    if not vim.g.use_coq or vim.g.use_coq == 1 then
        require'my/compe'.setup({})
    end
    require'my/snippets'
    require'lsp_signature'.setup({
        fix_pos = true,
        hint_enable = false,
        hint_prefix = "",
    })
LUA

function! StatusLine() abort
    let l:line_cnt = ' [ %l/%L ]'
    let l:file_path = ' [ %f ]'
    let l:branch_name = ''
    let l:rw_status = ' %m%r'

    let l:branch_name = FugitiveHead(7)
    if !empty(l:branch_name)
        let l:branch_name = ' [  ' . l:branch_name . ' ]'
    endif

    return l:line_cnt . l:file_path . l:branch_name . l:rw_status . '%= %y '
endfunction

set statusline=%!StatusLine()
set laststatus=2

"---------------------------------
"          AUTOCOMMANDS
"---------------------------------

function! ManageExrc() abort
    if !exists('g:exrc_loaded') || g:exrc_loaded == 0
        let g:exrc_path = luaeval('require("tools").find_project_root(".exrc")') . '/.exrc'
        if filereadable(g:exrc_path)
            exec 'source ' . g:exrc_path
            let g:exrc_loaded = 1
        else
            let g:exrc_loaded = 0
        endif
    endif
endfunction

augroup VimrcGeneral
    autocmd!

    " Disable LSP when calling Gdiff
    autocmd OptionSet diff 
                \ if v:option_new
                \ |    silent execute 'LspStop'
                \ | else
                \ |    silent execute 'LspStart'
                \ | endif

    " Search upwards for project-local config
    autocmd BufEnter * call ManageExrc()

    " Auto-source config after writing
    autocmd BufWritePost $MYVIMRC source $MYVIMRC

    " Never get accidentally stuck in paste mode again
    autocmd InsertLeave * set nopaste

    " Go to previous position in a file
    " autocmd BufReadPost *
    "         \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    "         \ |   exe "normal! g`\""
    "         \ | endif
augroup end

augroup FiletypeControls
    autocmd!

    autocmd FileType yaml setlocal softtabstop=2 | setlocal shiftwidth=2

    " Golang prefers tabs to spaces
    autocmd FileType go,make,dts,kconfig setlocal noexpandtab | setlocal shiftwidth=8

    " No block-style comments in C/Cpp
    autocmd FileType c,cpp setlocal commentstring=//\ %s

    " Formatters, when LSP is not enabled
    " autocmd BufWritePost *.go 
    "             \ if executable('goimports') | 
    "             \     silent execute '!goimports -w' shellescape(expand('%'), 1) | 
    "             \     edit! | 
    "             \ endif

    " autocmd BufWritePost *.rs 
    "             \ if executable('rustfmt') | 
    "             \     silent execute '!rustfmt' shellescape(expand('%'), 1) | 
    "             \     edit! | 
    "             \ endif
augroup end

"---------------------------------
"          OPTIONS
"---------------------------------
set completeopt=menuone,noselect

" Per-project settings
set exrc
set secure

" Tabs -> 4 spaces
set softtabstop=4
set shiftwidth=4
set expandtab

" Search settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Centralize swapfiles
set directory=$HOME/.vim/.swap/

" Show cmdline completion above the cmdline
set wildignorecase
set wildmenu

" Allow switching from buffers with unwritten changes
set hidden

"---------------------------------
"            BINDINGS
"---------------------------------
" Leader = Spacebar
let mapleader = "\<Space>"

" FZF bindings
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>f :Files<CR>

" Completion bindings
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" Open vimrc
nnoremap <silent><leader><leader>v :e $MYVIMRC<CR>
nnoremap <silent><leader><leader>lua :e $HOME/.config/nvim/lua<CR>

" Movement by visual lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Expand snippets when completing them
inoremap <silent><expr> <CR> compe#confirm('<CR>')
