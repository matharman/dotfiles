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
Plug 'ajh17/Spacegray.vim'
Plug 'arzg/vim-substrata'
let g:substrata_italic_comments = 0
Plug 'chriskempson/base16-vim'
let base16colorspace=256

Plug 'itchyny/vim-gitbranch'
Plug 'romainl/vim-cool'

" COMMENTS/DOCS
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'tpope/vim-commentary'

" SYNTAX
Plug 'pboettch/vim-cmake-syntax'

" FILESYSTEM/UTILITIES
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do' : './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['compile_commands.json', '.gtag_root', '.exrc']
let g:gutentags_ctags_exclude = ['**ccls-cache/*', '**/build/*', '**/binaries/*', '**/tools/linaro/*']
Plug 'tpope/vim-fugitive'

" LSP/COMPLETION
Plug 'neoclide/coc.nvim', {'branch': 'release'}
set cmdheight=2
set signcolumn=yes
set updatetime=300

call plug#end()

"---------------------------------
"          APPEARANCE
"---------------------------------

if !has('nvim')
    " DO NOT change these to single quote strings
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set cursorline
set termguicolors
colorscheme base16-phd
syntax enable

function! StatusLine() abort
    let l:line_cnt = ' [ %l/%L ]'
    let l:file_path = ' [ %f ]'
    let l:branch_name = ''
    let l:rw_status = ' %m%r'

    if exists('g:loaded_gitbranch')
        let l:branch_name = gitbranch#name()

        if !empty(l:branch_name)
            let l:branch_name = ' [  ' . l:branch_name . ' ]'
        endif
    endif

    return l:line_cnt . l:file_path . l:branch_name . l:rw_status . '%= %y '
endfunction

set statusline=%!StatusLine()
set laststatus=2

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
    autocmd BufReadPre *.h setlocal filetype=c

    " Golang prefers tabs to spaces
    "autocmd BufNewFile,BufReadPre *.go setlocal noexpandtab shiftwidth=8
    autocmd FileType go setlocal noexpandtab shiftwidth=8

    " Formatters
    autocmd BufWritePost *.go 
                \ if executable('goimports') | 
                \     silent execute '!goimports -w %' | 
                \     edit! | 
                \ endif
    autocmd BufWritePost *.rs 
                \ if executable('rustfmt') | 
                \     silent execute '!rustfmt %' | 
                \     edit! | 
                \ endif
augroup end

"---------------------------------
"          OPTIONS
"---------------------------------

" Per-project settings
set exrc

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
inoremap <expr> <cr>    pumvisible() ? "\<C-y>\<Esc>" : "\<cr>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Leader = Spacebar
let mapleader = "\<Space>"

" Open vimrc
nnoremap <silent><leader><Space>v :e $MYVIMRC<CR>

" Movement by visual lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Easy set paste
nnoremap <leader>v :set paste<CR>

" LSP jumplist
nmap <silent>gd <Plug>(coc-definition) 
nmap <silent><leader>gd <Plug>(coc-declaration)

" Navigate errors
nmap <silent><leader>p <Plug>(coc-diagnostic-prev)
nmap <silent><leader>n <Plug>(coc-diagnostic-next)
