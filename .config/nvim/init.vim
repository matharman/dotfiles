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
if has('nvim-0.5.0')
    Plug 'nvim-treesitter/nvim-treesitter'
    " Plug 'rktjmp/lush.nvim'
    " Gruvbox variant with treesitter highlight support
    " Plug 'npxbr/gruvbox.nvim'

    Plug 'folke/tokyonight.nvim'
endif

Plug 'romainl/vim-cool'

" COMMENTS/DOCS
Plug 'vim-scripts/DoxygenToolkit.vim'
let g:DoxygenToolkit_commentType = 'C++'
Plug 'tpope/vim-commentary'

" Snippets
Plug 'SirVer/ultisnips'
" let g:UltiSnipsSnippetDirectories=["~/Templates/UltiSnips"]
let g:UltiSnipsExpandTrigger=""

" SYNTAX
Plug 'pboettch/vim-cmake-syntax'
Plug 'ziglang/zig.vim'

" FILESYSTEM/UTILITIES
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/vim-clang-format'
let g:clang_format#auto_format=1
let g:clang_format#enable_fallback_style=0

" LSP/COMPLETION
Plug 'neoclide/coc.nvim', {'branch': 'release'}
set cmdheight=2
set updatetime=300
set shortmess+=c

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

set background=dark
" let g:gruvbox_italicize_comments=0
" colorscheme gruvbox
let g:tokyonight_style='night'
colorscheme tokyonight

if has('nvim-0.5.0')
lua << LUA
--    require'nvim-treesitter.configs'.setup {
--      highlight = {
--        enable = true,
--      },
--    }
--
--    local function highlight_invert_bg(bg)
--        return { bg = bg, fg = bg.rotate(135).darken(55) }
--    end
--
--    local lush = require'lush'
--    local gruvbox = require'gruvbox'
--
--    local diffadd = highlight_invert_bg(gruvbox.GruvboxGreen.fg)
--    local diffchange = highlight_invert_bg(gruvbox.GruvboxAqua.fg)
--    local diffdelete = highlight_invert_bg(gruvbox.GruvboxRed.fg)
--    local difftext = highlight_invert_bg(gruvbox.GruvboxYellow.fg)
--
--    colors_ext = lush.extends({gruvbox}).with(
--        function()
--            return {
--                DiffAdd {fg = diffadd.fg, bg = diffadd.bg},
--                DiffChange {fg = diffchange.fg, bg = diffchange.bg},
--                DiffDelete {fg = diffdelete.fg, bg = diffdelete.bg},
--                DiffText {fg = difftext.fg, bg = difftext.bg},
--                Function {gruvbox.GruvboxOrangeBold}
--            }
--        end
--    )
--    lush.apply(lush.compile(colors_ext))
LUA
endif

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

augroup VimrcGeneral
    autocmd!

    " Disable COC in git difftool
    autocmd DiffUpdated,BufReadPost * if &diff | let b:coc_enabled = 0 | endif

    " Disable COC when calling Gdiff
    autocmd OptionSet diff 
                \ if v:option_new
                \ |    silent execute 'CocDisable'
                \ | else
                \ |    if exists('b:coc_enabled') | unlet b:coc_enabled | endif
                \ |    silent execute 'CocEnable'
                \ | endif

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

" Leader = Spacebar
let mapleader = "\<Space>"

" Open vimrc
nnoremap <silent><leader><Space>v :e $MYVIMRC<CR>

" Movement by visual lines
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" LSP jumplist
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader><leader>gd <Plug>(coc-declaration)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gr <Plug>(coc-references)
nmap <silent> <leader><leader>gr <Plug>(coc-rename)

" Navigate errors
nmap <silent><leader>p <Plug>(coc-diagnostic-prev)
nmap <silent><leader>n <Plug>(coc-diagnostic-next)

" Snippets
imap <C-l> <Plug>(coc-snippets-expand-jump)
