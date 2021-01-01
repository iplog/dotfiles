" Reset vim  to vim-defaults
if &compatible          " only if not set before:
  set nocompatible      " use vim-defaults instead of vi-defaults (easier, more user friendly)
endif


call plug#begin('~/.vim/plugged') " Required!
" Navigation and utils
" Plug 'qpkorr/vim-bufkill'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-vinegar'
Plug 'sjl/vitality.vim'
Plug 'tpope/vim-projectionist'

" Edition
Plug 'mattn/emmet-vim'
Plug 'scrooloose/nerdcommenter'
Plug 'sdanielf/vim-stdtabs'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'godlygeek/tabular'

" Code completion and check
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP client

" UI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'iplog/vim-popsicles'
Plug 'nathanaelkane/vim-indent-guides'

" Syntax
Plug 'sheerun/vim-polyglot'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ap/vim-css-color'
Plug 'elzr/vim-json'
Plug 'vim-erlang/vim-erlang-compiler'
" Plug 'vim-erlang/vim-erlang-runtime'
Plug 'vim-erlang/vim-erlang-omnicomplete'
Plug 'vim-erlang/vim-erlang-skeletons'
" Plug 'elixir-editors/vim-elixir'
Plug 'mhinz/vim-mix-format'
Plug 'ambv/black'
" Plug 'hashivim/vim-terraform'

" Misc
Plug 'vim-scripts/scratch.vim'
Plug 'mrtazz/simplenote.vim'
Plug 'takac/vim-hardtime'
Plug 'rizzatti/dash.vim'

call plug#end() " Required!

" Enable filetypes. required!
filetype on
filetype plugin on
filetype indent on
syntax on

" Color settings (if terminal/gui supports it)
if $TERM =~ '256color' || $TERM =~ '^xterm$'
  set t_Co=256
endif

if &t_Co > 2 || has("gui_running")
  syntax on          " enable colors
  set hlsearch       " highlight search (very useful!)
  set incsearch      " search incremently (search while typing)
endif

" Display settings
set background=dark     " enable for dark terminals
set scrolloff=2         " 2 lines above/below cursor when scrolling
set number              " show the current line real number
set relativenumber      " show relative line numbers
set showmode            " show mode in status bar (insert/replace/...)
set showcmd             " show typed command in status bar
set ruler               " show cursor position in status bar
set title               " show file in titlebar
set wildmenu            " completion with menu
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn,.git
set wildignorecase      " ingore case in the wildmenu
set laststatus=2        " use 2 lines for the status bar
set matchtime=2         " show matching bracket for 0.2 seconds
set showmatch           " show matching bracket (briefly jump)
set matchpairs+=<:>     " specially for html
set cursorline          " Higlight the current line

" Color Scheme
colorscheme popsicles

" Editor settings
set colorcolumn=80      " Colum lenght
set esckeys             " map missed escape sequences (enables keypad keys)
set autoindent smartindent      " turn on auto/smart indenting
set smarttab            " smart tab handling for indenting
set magic               " change the way backslashes are used in search patterns
set backspace=indent,eol,start " Allow backspacing over everything in insert mode
set list                " show invisibles
set tabstop=2           " number of spaces a tab counts for
set shiftwidth=2        " spaces for autoindents
set expandtab           " turn a tabs into spaces
set undolevels=10000             " number of forgivable mistakes
set updatecount=100             " write swap file to disk every 100 chars
set timeoutlen=3000
set fileformat=unix     " file mode is unix
set diffopt=filler,iwhite       " ignore all whitespace and sync
" set autowrite       "Write the old file out when switching between files.

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Better line wrapping
set wrap
set textwidth=79
set formatoptions=qrn1

" Better Side column
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Enable code folding
set foldenable

" Search options
set ignorecase
set hlsearch
set incsearch
set showmatch
set smartcase           " but become case sensitive if you type uppercase characters

" System settings
set lazyredraw          " no redraws in macros
set confirm             " get a dialog when :q, :w, or :wq fails
"set viminfo=%100,'100,/100,h,\"500,:100,n~/.vim/viminfo
set viminfo='20,\"500   " remember copy registers after quitting in the .viminfo file -- 20 jump links, regs up to 500 lines'
set hidden              " remember undo after quitting
set history=100         " keep 100 lines of command history
set mouse=a             " use mouse in all modes
set mousehide           "Hide mouse when typing
" set splitright          " the new window is created on the right

" Share OS clipboard
set clipboard=unnamed

" Characters list incrementation
set nrformats+=alpha

" Backups
if !isdirectory($HOME."/.vim/tmp/backup")
  call mkdir($HOME."/.vim/tmp/backup", "p")
endif
set backupdir=~/.vim/tmp/backup// " backups
if !isdirectory($HOME."/.vim/tmp/swap")
  call mkdir($HOME."/.vim/tmp/swap", "p")
endif
set directory=~/.vim/tmp/swap//   " swap files
if !isdirectory($HOME."/.vim/tmp/undo")
  call mkdir($HOME."/.vim/tmp/undo", "p")
endif
set undodir=~/.vim/tmp/undo// " undo files
set backup " enable backup
set undofile " enable undo

" Auto file reloading
set autoread
if !has('gui_running')
  " working thanks to vitality plugin and `set -g focus-events on` in tmux conf
  autocmd FocusGained,BufEnter * :silent! checktime
endif

" File type specifics
" All Trim trailing whitespace when saving a document
autocmd BufWritePre *\(.md\|.diff\)\@<! :%s/\s\+$//e
" Python
autocmd BufWritePost *.py execute ':Black'
let g:black_linelength = 88

" Markdown
augroup markdownSpell
  autocmd!
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal spell
augroup END

let g:markdown_folding = 1

" Custom commands
" System
nmap <leader>ev :tabedit $MYVIMRC<cr>
" COC
if filereadable(expand($HOME . "/.vim/cfg/coc.vim"))
  source $HOME/.vim/cfg/coc.vim
endif

" ctags
if executable('ctags') && !exists(':MakeTags')
  command! MakeTags !ctags -R .
  nmap <Leader>mt :MakeTags<CR>
endif

" FZF
nmap <leader>t :Files<CR>
nmap <Leader>o :Buffers<CR>
nmap <Leader>T :History<CR>

" Plugins configuration and shortcuts
" Ale
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = "[%linter%] %severity% %code% - %s"
let g:ale_linters = {
    \ 'typescript': ['eslint', 'tsserver'],
    \ 'typescriptreact': ['eslint', 'tsserver'],
    \ 'sh': ['shellcheck'],
\ }
let g:ale_fixers = {
    \ 'typescript': ['prettier'],
    \ 'markdown': ['prettier'],
\ }
  " \ 'sh': ['shfmt'],

let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0

" Airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#csv#enabled = 0
" let g:airline#extensions#ale = 0
let g:airline_theme = 'base16'
set noshowmode

" COC
if filereadable(expand($HOME . "/.vim/cfg/coc.vim"))
  source $HOME/.vim/cfg/coc.vim
endif

" IndentGuides
let indent_guides_enable_on_vim_startup = 1
if !has("gui_running")
  let g:indent_guides_auto_colors = 0
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=233
endif

" Go
" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"

" Mix Format
let g:mix_format_on_save = 1
let g:mix_format_options = '--check-equivalent'

" NERDCommenter
let NERDSpaceDelims = 1

" Ripgrep advanced
if executable('rg')
  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --hidden --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
  endfunction

  command! -bang -nargs=* RG call RipgrepFzf(<q-args>, <bang>0)

  set grepprg=rg\ -H\ --no-heading\ --vimgrep\ --smart-case\ --hidden\ --glob\ '!.git'
  command! -nargs=+ -complete=file -bar Rg silent! grep! <args>|cwindow|redraw!

  nnoremap <Leader>f :Rg<Space>
  " grep word under cursor
  nnoremap <Leader>F :Rg '\b<C-R><C-W>\b'
endif

" Tagbar
nmap <Leader>r :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1

let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'p:protocols',
        \ 'm:modules',
        \ 'e:exceptions',
        \ 'y:types',
        \ 'd:delegates',
        \ 'f:functions',
        \ 'c:callbacks',
        \ 'a:macros',
        \ 't:tests',
        \ 'i:implementations',
        \ 'o:operators',
        \ 'r:records'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 'p' : 'protocol',
        \ 'm' : 'module'
    \ },
    \ 'scope2kind' : {
        \ 'protocol' : 'p',
        \ 'module' : 'm'
    \ },
    \ 'sort' : 0
\ }

let g:tagbar_type_go = {
  \ 'ctagstype' : 'go',
  \ 'kinds'     : [
    \ 'p:package',
    \ 'i:imports:1',
    \ 'c:constants',
    \ 'v:variables',
    \ 't:types',
    \ 'n:interfaces',
    \ 'w:fields',
    \ 'e:embedded',
    \ 'm:methods',
    \ 'r:constructor',
    \ 'f:functions'
  \ ],
  \ 'sro' : '.',
  \ 'kind2scope' : {
    \ 't' : 'ctype',
    \ 'n' : 'ntype'
  \ },
  \ 'scope2kind' : {
    \ 'ctype' : 't',
    \ 'ntype' : 'n'
  \ },
  \ 'ctagsbin'  : 'gotags',
  \ 'ctagsargs' : '-sort -silent'
\ }

let g:tagbar_type_make = {
    \ 'kinds':[
        \ 'm:macros',
        \ 't:targets'
    \ ]
\ }

" Scratch
nmap <Leader>d :Sscratch<CR>:q<CR>:b __Scratch__<CR>
nmap <Leader>D :b __Scratch__<CR>:b#<CR>

" Simplenote
if filereadable(expand($HOME . "/.simplenoterc"))
  source $HOME/.simplenoterc
endif
let g:SimplenoteNoteFiletype = 'markdown'
let g:SimplenoteVertical = 1

" HardTime - No arrows
let g:hardtime_default_on = 1
let g:hardtime_maxcount = 2
let g:hardtime_allow_different_key = 1
let g:list_of_normal_keys = ["h", "j", "k", "l", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
" let g:hardtime_ignore_quickfix = 1

" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
  augroup myvimrchooks
    au!
    autocmd bufwritepost .vimrc source ~/.vimrc
  augroup END
endif
