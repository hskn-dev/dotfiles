" Config
let mapleader = ' '
nmap <Esc><Esc> :nohl<CR>

" Buffer
map <C-l> :bn<CR>
map <C-h> :bp<CR>

" Indent / Syntax
" ----------------------------
filetype plugin indent on
syntax on

" Colors
" ----------------------------
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
hi Comment ctermfg=gray

" Editing
" ----------------------------
set clipboard=unnamed
set autoindent
set smartindent
set expandtab
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,utf-8,ucs-2,cp932,sjis
set tabstop=2
set shiftwidth=2
set number
set showmode
set showmatch
set title
set backspace=indent,eol,start
set inccommand=split
set imdisable
set hidden
set nobackup
set nowritebackup
set conceallevel=0

" htmlのマッチするタグに%でジャンプ
source $VIMRUNTIME/macros/matchit.vim

if has('mouse')
  set mouse=a
endif

" Window active/inactive background
" ----------------------------
augroup ChangeBackground
  autocmd!
  autocmd WinEnter * highlight Normal guibg=default
  autocmd WinEnter * highlight NormalNC guibg='#444444'
  autocmd FocusGained * highlight Normal guibg=default
  autocmd FocusLost * highlight Normal guibg='#444444'
augroup END
