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

Plug 'ajh17/Spacegray.vim'
Plug 'arzg/vim-substrata'
let g:substrata_italic_comments = 0
"let g:substrata_italic_functions = 0

Plug 'vim-scripts/DoxygenToolkit.vim'

"Plug 'sheerun/vim-polyglot'
Plug 'itchyny/vim-gitbranch'
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do' : './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-commentary'
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['compile_commands.json', '.gtag_root', '.exrc']
let g:gutentags_ctags_exclude = ['**/build/*', '**/binaries/*', '**/tools/linaro/*']

Plug 'neoclide/coc.nvim', { 'branch' : 'release' }

" CoC completion for vimscript
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'

call plug#end()

"---------------------------------
"          APPEARANCE
"---------------------------------

if !has('nvim')
    " DO NOT change these to single quote strings
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set termguicolors
colorscheme substrata
syntax enable

function! StatusLineMode() abort
    let l:mode_legend = {
                \ 'n': 'NORMAL',
                \ 'v': 'VISUAL',
                \ 'V': 'VISUAL-LINE',
                \ '\<C-v>': 'VISUAL-BLOCK',
                \ 'i': 'INSERT',
                \ 'R': 'REPLACE',
                \ 'c': 'COMMAND',
                \ 't': 'TERMINAL',
                \}

    return get(l:mode_legend, mode())
endfunction

function! StatusLine() abort
    let l:file_path = '[ %f ]'
    let l:branch_name = ''
    let l:gtags_status = ''

    if exists('g:loaded_gitbranch')
        let l:branch_name = ' ' . gitbranch#name()

        if !empty(l:branch_name)
            let l:branch_name = '[' . l:branch_name . ']'
        endif
    endif

    if exists('g:loaded_gutentags')
        let l:gtags_status = gutentags#statusline('[', ']')
    endif

    return ' [' . StatusLineMode() . '] [%l/%L] '. l:file_path . ' ' . l:branch_name . ' %m%r %=' . l:gtags_status  . ' %y '
endfunction

set statusline=%!StatusLine()
set laststatus=2
set noshowmode

"---------------------------------
"          AUTOCOMMANDS
"---------------------------------

augroup VimrcGeneral
    autocmd!
    " Auto-source config after writing
    autocmd BufWritePost $MYVIMRC source $MYVIMRC

    " Never get accidentally stuck in paste mode again
    autocmd InsertLeave * set nopaste

    " Go to previous position in a file
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif
augroup end

augroup FiletypeControls
    autocmd!

    " Header files in my projects are NOT cpp
    autocmd BufRead *.h set filetype=c
augroup end

"---------------------------------
"          OPTIONS
"---------------------------------

set exrc
set encoding=utf-8

" Tabs -> 4 spaces
set softtabstop=4
set shiftwidth=4
set expandtab

" Search settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Folding
set foldmethod=syntax
set foldnestmax=1

" Centralize swapfiles
set directory=$HOME/.vim/.swap/

" Show cmdline completion above the cmdline
set wildignore+=*.s,Makefile
set wildignorecase
set wildmenu

" Allow switching from buffers with unwritten changes
set hidden

" Enable vim builtin man viewer
runtime ftplugin/man.vim

"---------------------------------
"            BINDINGS
"---------------------------------

" Leader = Spacebar
let mapleader = "\<Space>"

" Open vimrc
nnoremap <silent><leader><Space>v :e $MYVIMRC<CR>

" Movement by visual lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Easy set paste
nnoremap <leader>v :set paste<CR>

" Use language server definitions instead of tags
"nmap <silent><C-]> <Plug>(coc-definition) 
"nmap <silent><leader><C-]> <Plug>(coc-declaration) 

" Navigate errors
nmap <silent><leader>p <Plug>(coc-diagnostic-prev)
nmap <silent><leader>n <Plug>(coc-diagnostic-next)
