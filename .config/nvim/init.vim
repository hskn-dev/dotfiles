" Config
let mapleader = ','

" Buffer
map <C-l> :bn<CR>
map <C-h> :bp<CR>

"  Path configs
" ---------------------------
let s:config_dir=empty($XDG_CONFIG_HOME) ? expand("$HOME/.config") : expand($XDG_CONFIG_HOME)
let s:cache_dir=empty($XDG_CACHE_HOME) ? expand("$HOME/.cache") : expand($XDG_CACHE_HOME)
let s:dein_dir = s:cache_dir . '/nvim/dein'
let s:toml = s:config_dir . '/nvim/dein.toml'
let s:lazy_toml = s:config_dir . '/nvim/dein.lazy.toml'
let s:dotfiles = $HOME . '/dotfiles'

" Install dein
" ----------------------------
if &runtimepath !~# '/dein.vim'
    let s:dein_repo = 'github.com/Shougo/dein.vim'
    let s:dein_repo_dir = s:dein_dir . '/repos/' . s:dein_repo

    if !isdirectory(s:dein_repo_dir)
        execute printf('!git clone %s %s', 'https://' . s:dein_repo, s:dein_repo_dir)
    endif

    execute 'set runtimepath^=' . s:dein_repo_dir
endif

" Install plugins
" ----------------------------
augroup PluginInstall
    autocmd!
    autocmd VimEnter * if dein#check_install() | call dein#install() | endif
augroup END

" Load plugins
" ----------------------------
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#end()
    call dein#save_state()
endif

" Remove plugins
" ----------------------------
let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
endif

" Update plugins (bind keymap)
" ----------------------------
nnoremap <Leader>du :call dein#update()<CR>

" Enable indent
" ----------------------------
filetype plugin indent on

" Others
" ----------------------------
syntax on
" colorscheme molokai
" colorscheme tender
" colorscheme dogrun
colorscheme dracula
" set t_Co=256
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set clipboard=unnamed
set autoindent
set smartindent
set expandtab
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,utf-8,ucs-2,cp932,sjis
set tabstop=2
set shiftwidth=2
" set cursorline
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

hi Comment ctermfg=gray

if has('mouse')
  set mouse=a
endif

""" COC
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

""" ale
" ローカルの設定ファイルを考慮する
let g:ale_javascript_prettier_use_local_config = 1
" エラーと警告の一覧を見るためにウィンドウを開く
let g:ale_open_list = 1
" フォーマッタの設定
let g:ale_fix_on_save = 1
let g:ale_fixers = {}
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'vue': ['prettier'],
\   'css': ['prettier']
\}
" リンターの設定
let g:ale_linters_explicit = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 1
let g:ale_linters = {
  \   'javascript': ['eslint'],
  \   'typescript': ['tsserver', 'eslint'],
  \   'vue': ['eslint', 'stylelint'],
  \   'css': ['stylelint']
  \ }
" let g:ale_linter_aliases = {'vue': 'css'}
" 表示に関する設定
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_statusline_format = ['E%d', 'W%d', 'OK']
let g:airline#extensions#ale#open_lnum_symbol = '('
let g:airline#extensions#ale#close_lnum_symbol = ')'
let g:ale_echo_msg_format = '[%linter%]%code: %%s'
highlight link ALEErrorSign Tag
highlight link ALEWarningSign StorageClass
" Ctrl + kで次の指摘へ、Ctrl + jで前の指摘へ移動
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

""" airline
let g:airline_theme = 'luna'
set laststatus=2
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#wordcount#enabled = 0
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'y', 'z']]
let g:airline_section_c = '%t'
let g:airline_section_x = '%{&filetype}'
let g:airline_section_z = '%3l:%2v %{airline#extensions#ale#get_warning()} %{airline#extensions#ale#get_error()}'
let g:airline#extensions#ale#error_symbol = ' '
let g:airline#extensions#ale#warning_symbol = ' '
let g:airline#extensions#default#section_truncate_width = {}
let g:airline#extensions#whitespace#enabled = 1

""" nerdtree
map <C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1

""" comfortable motion
let g:comfortable_motion_scroll_down_key = "j"
let g:comfortable_motion_scroll_up_key = "k"

""" fzf
nnoremap [Fzf] <Nop>
nmap <Leader>f [Fzf]
nnoremap [Fzf]f :<C-u>Files<CR>
nnoremap [Fzf]g :<C-u>GFiles<CR>
nnoremap [Fzf]G :<C-u>GFiles?<CR>
nnoremap [Fzf]b :<C-u>Buffers<CR>

""" markdown-preview-nvim
nmap <leader>p :MarkdownPreview<CR>
let g:mkdp_markdown_css = expand('~/.config/.markdown.css')

""" cheatsheet
let g:cheatsheet#cheat_file = expand('~/.cheatsheet.md')
nmap <Leader>c :Cheat<CR>

command! -nargs=0 Prettier :CocCommand prettier.formatFile

""" tmux vim active color setting
augroup ChangeBackground
  autocmd!
  autocmd WinEnter * highlight Normal guibg=default
  autocmd WinEnter * highlight NormalNC guibg='#444444'
  autocmd FocusGained * highlight Normal guibg=default 
  autocmd FocusLost * highlight Normal guibg='#444444'
augroup END
