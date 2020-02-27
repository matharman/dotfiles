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

Plug 'itchyny/vim-gitbranch'

" COMMENTS/DOCS
Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'tpope/vim-commentary'

" SYNTAX
"Plug 'sheerun/vim-polyglot'
Plug 'rust-lang/rust.vim'

" FILESYSTEM/UTILITIES
Plug 'junegunn/vim-slash'
Plug 'junegunn/fzf', { 'dir' : '~/.fzf', 'do' : './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_add_default_project_roots = 0
let g:gutentags_project_root = ['compile_commands.json', '.gtag_root', '.exrc']
let g:gutentags_ctags_exclude = ['**ccls-cache/*', '**/build/*', '**/binaries/*', '**/tools/linaro/*']

" LSP/COMPLETION
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
let g:asyncomplete_popup_delay = 2

Plug 'prabirshrestha/vim-lsp'
" When enabled, this feature does completion twice, overwriting characters in the buffer
" Also pastes the header file containing the definition on occasion
let g:lsp_highlights_enabled = 0
let g:lsp_text_edit_enabled = 0
let g:lsp_virtual_text_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_signs_error = {'text': 'XX'}
let g:lsp_signs_warning = {'text': '!!'}
let g:lsp_signs_information = {'text': '>>'}
let g:lsp_signs_hint = {'text': '--'}

" Can specify toolchain in exrc like so: 
" 'cmd': {server_info->['ccls', '-init={"clang":{"extraArgs":["--target=arm-none-eabi"]}}']},
if executable('ccls')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif

if executable('gopls')
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ })
    autocmd BufWritePre *.go LspDocumentFormatSync
endif

if executable('ra_lsp_server')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'rust-analyzer',
                \ 'cmd': {server_info->['ra_lsp_server']},
                \ 'whitelist': ['rust'],
                \ })
endif

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
colorscheme spacegray
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
    autocmd BufNewFile,BufReadPre *.go setlocal noexpandtab shiftwidth=8
augroup end

"---------------------------------
"          OPTIONS
"---------------------------------

set encoding=utf-8

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
nmap <silent><leader><C-]> <Plug>(lsp-definition)
nmap <silent><leader><Shift><C-]> <Plug>(lsp-declaration) 

" Navigate errors
nmap <silent><leader>p <Plug>(lsp-previous-diagnostic)
nmap <silent><leader>n <Plug>(lsp-next-diagnostic)
