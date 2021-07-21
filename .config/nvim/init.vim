" Ensure vim-plug is always installed
if has('nvim')
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        augroup AutoPlug
            autocmd!
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        augroup end
    endif

else
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        augroup AutoPlug
            autocmd!
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        augroup end
    endif
endif

call plug#begin()
" APPEARANCE CUSTOMIZATIONS
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'folke/tokyonight.nvim'

Plug 'romainl/vim-cool'

" COMMENTS/DOCS
Plug 'vim-scripts/DoxygenToolkit.vim'
let g:DoxygenToolkit_commentType = 'C++'
Plug 'tpope/vim-commentary'

" Snippets
Plug 'norcalli/snippets.nvim'

" SYNTAX
Plug 'pboettch/vim-cmake-syntax'

" FILESYSTEM/UTILITIES
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/vim-clang-format'
let g:clang_format#auto_format=1
let g:clang_format#enable_fallback_style=0

" LSP/COMPLETION
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
set cmdheight=2
set updatetime=300
set shortmess+=c

call plug#end()

"---------------------------------
"          APPEARANCE
"---------------------------------
set cursorline
set termguicolors

let g:tokyonight_style='night'
colorscheme tokyonight

lua << LUA
    require'my/lsp'
    require'my/snippets'
    require'my/compe'.setup({})
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
        lua require'tools'
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
    autocmd FileType go,make setlocal noexpandtab shiftwidth=8

    autocmd FileType dts setlocal softtabstop=8 | setlocal shiftwidth=8

    " No block-style comments in C/Cpp
    autocmd FileType c,cpp setlocal commentstring=//\ %s

    " Formatters
    autocmd BufWritePost *.go 
                \ if executable('goimports') | 
                \     silent execute '!goimports -w' shellescape(expand('%'), 1) | 
                \     edit! | 
                \ endif

    autocmd BufWritePost *.rs 
                \ if executable('rustfmt') | 
                \     silent execute '!rustfmt' shellescape(expand('%'), 1) | 
                \     edit! | 
                \ endif
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
set wildignore+=*.s,Makefile
set wildignorecase
set wildmenu

" Allow switching from buffers with unwritten changes
set hidden

"---------------------------------
"            BINDINGS
"---------------------------------
" Completion bindings
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Leader = Spacebar
let mapleader = "\<Space>"

" Open vimrc
nnoremap <silent><leader><leader>v :e $MYVIMRC<CR>
nnoremap <silent><leader><leader>lua :e $HOME/.config/nvim/lua<CR>

" Movement by visual lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Expand snippets when completing them
inoremap <silent><expr> <CR> compe#confirm('<CR>')
