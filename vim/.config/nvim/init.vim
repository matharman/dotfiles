call plug#begin()
" APPEARANCE CUSTOMIZATIONS
Plug 'ajh17/Spacegray.vim'

" COMMENTS/DOCS
Plug 'tpope/vim-commentary'

" FILESYSTEM/UTILITIES
Plug 'christoomey/vim-tmux-navigator'
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do' : './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'

" LSP/COMPLETION
Plug 'neoclide/coc.nvim', {'branch': 'release'}
set updatetime=300

call plug#end()
"---------------------------------
"            BINDINGS
"---------------------------------
" Movement by visual lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Completion bindings
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Leader = Spacebar
let mapleader = "\<Space>"

" Open vimrc
nnoremap <silent><leader><Space>v :e $MYVIMRC<CR>

" FZF maps
nmap <leader><leader>f :Files<CR>
nmap <leader><leader>b :Buffers<CR>

" Traverse diagnostics
nmap <silent><leader>n <Plug>(coc-diagnostic-next)
nmap <silent><leader>p <Plug>(coc-diagnostic-prev)
" Jump to definition
nmap <silent><leader>gd <Plug>(coc-definition)
nmap <silent><leader><leader>gd <Plug>(coc-declaration)

" Get all symbol references
nmap <silent><leader>gr <Plug>(coc-reference)
" Rename symbol
nmap <silent><leader>gR <Plug>(coc-rename)

"---------------------------------
"          OPTIONS
"---------------------------------
set termguicolors
colorscheme spacegray
syntax enable

" Tabs -> 4 spaces
set softtabstop=4
set shiftwidth=4
set expandtab

" Search settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" Allow switching from buffers with unwritten changes
set hidden

" Don't autoinsert text during autocomplete
set completeopt+=menuone,noselect,noinsert
set shortmess+=c

"---------------------------------
"          AUTOCOMMANDS
"---------------------------------
augroup General
    autocmd!
    " Auto-source config after writing
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup end

augroup Filetypes
    " Makefile whitespace must be width 8 tabs
    " Golang also prefers this
    autocmd FileType make,go setlocal noexpandtab shiftwidth=8

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

