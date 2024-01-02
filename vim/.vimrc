" Reset vim  to vim-defaults
if &compatible          " only if not set before:
  set nocompatible      " use vim-defaults instead of vi-defaults (easier, more user friendly)
endif


call plug#begin('~/.vim/plugged') " Required!
" Navigation and utils
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-vinegar'
Plug 'tmux-plugins/vim-tmux-focus-events'
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
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'rhysd/vim-lsp-ale'
Plug 'github/copilot.vim'

" UI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'iplog/vim-popsicles'
Plug 'preservim/vim-indent-guides'

" Syntax
Plug 'sheerun/vim-polyglot'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ap/vim-css-color'
Plug 'evanleck/vim-svelte', {'branch': 'main'}

" Test Integrations
Plug 'vim-test/vim-test'
Plug 'preservim/vimux'

" Misc
Plug 'vim-scripts/scratch.vim'
Plug 'mrtazz/simplenote.vim'
Plug 'takac/vim-hardtime'
Plug 'rizzatti/dash.vim'
Plug 'will133/vim-dirdiff'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end() " Required!

" Enable filetypes. required!
filetype on
filetype plugin on
filetype indent on

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
set formatoptions=qrn1j

" Better Side column
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Disable automatic code folding
set nofoldenable

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
set history=1000        " keep 1000 lines of command history
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
  " working thanks to 'tmux-plugins/vim-tmux-focus-events' and the
  " `set -g focus-events on` command in the tmux conf.
  autocmd FocusGained,BufEnter * :silent! checktime
endif

" File type specifics
" All Trim trailing whitespace when saving a document
autocmd BufWritePre *\(.md\|.diff\)\@<! :%s/\s\+$//e

" Color Scheme
set termguicolors
colorscheme catppuccin-mocha-popsicles


" Custom commands and Plugins configuration
" System
nmap <leader>ev :tabedit $MYVIMRC<cr>

" ctags
if executable('ctags') && !exists(':MakeTags')
  command! MakeTags !ctags -R .
  nmap <Leader>mt :MakeTags<CR>
endif

" FZF
let $FZF_DEFAULT_OPTS = '--bind alt-q:select-all+accept,ctrl-u:preview-page-up,ctrl-d:preview-page-down'
let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['', 'ctrl-h']

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Special'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Special']
\ }

nmap <leader>t :Files<CR>
nmap <Leader>o :Buffers<CR>
nmap <Leader>T :History<CR>

nnoremap <Leader>O :new<CR>:0r! ls<CR>:norm gggf<CR>:bd!#<CR>

" Ripgrep advanced
if executable('rg')
  " Use `rg` as the vim grep program
  set grepprg=rg\ -H\ --no-heading\ --vimgrep\ --smart-case\ --hidden\ --glob\ '!.git'
  command! -nargs=+ -complete=file -bar Rgrep silent! grep! <args>|cwindow|redraw!

  function! s:fill_quickfix(list, ...)
    if len(a:list) > 1
      call setqflist(a:list)
      copen
      wincmd p
      if a:0
        execute a:1
      endif
    endif
  endfunction

  function! s:rg_to_qf(line)
    let parts = matchlist(a:line, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')
    let dict = {'filename': &acd ? fnamemodify(parts[1], ':p') : parts[1], 'lnum': parts[2], 'text': parts[4]}
    if len(parts[3])
      let dict.col = parts[3]
    endif
    return dict
  endfunction

  function! s:rg_handler(lines)
    let list = map(filter(a:lines, 'len(v:val)'), 's:rg_to_qf(v:val)')
    if empty(list)
      return
    endif

    " Tries to simpply open the file if only 1 selected
    if len(list) == 1
      let first = list[0]
      try
        execute "e" first.filename
        execute first.lnum
        if has_key(first, 'col')
          call cursor(0, first.col)
        endif
        normal! zvzz
        catch
        endtry
        return
    endif

    call s:fill_quickfix(list)
    execute "copen"
  endfunction

  command! -bang -nargs=+ -complete=file Rg call
  \ fzf#run(
  \   fzf#wrap(
  \     fzf#vim#with_preview({
  \      'source': "rg -H --vimgrep --no-heading --color=always --smart-case --hidden --glob '!.git' ".<q-args>,
  \      'sink*': function('<sid>rg_handler'),
  \      'options': [
  \        '--multi', '--ansi', '--delimiter', ':', '--preview-window', '+{2}-/2',
  \        '--bind', 'enter:accept,alt-a:select-all,alt-d:deselect-all,ctrl-g:select-all+accept'
  \      ]
  \    })
  \   )
  \ )

  " Extends errorformat to match the format created by the `fill_quickfix` function
  set errorformat+=%f\|%l\ col\ %c\|%m

  nnoremap <Leader>f :Rg<Space>
  nnoremap <Leader>g :Rgrep<Space>
  " grep word under cursor
  nnoremap <Leader>F :Rg '\b<C-R><C-W>\b'
endif

" Plugins configuration and shortcuts
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
let g:lsp_use_native_client = 1
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_preview_float = 1
let g:lsp_experimental_workspace_folders = 1

let g:lsp_settings = {
\   'pylsp-all': {
\     'workspace_config': {
\       'pylsp': {
\         'plugins': {
\           'pycodestyle': {
\             'enabled': 0
\           },
\           'pyflakes': {
\             'enabled': 0
\           },
\           'yapf': {
\             'enabled': 0
\           }
\         }
\       }
\     }
\   },
\}


function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  " set foldmethod=expr
  "   \ foldexpr=lsp#ui#vim#folding#foldexpr()
  "   \ foldtext=lsp#ui#vim#folding#foldtext()

  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <leader>r <plug>(lsp-document-symbol)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gy <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> <leader>rf <plug>(lsp-code-action)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover-preview)
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" Ale
let g:ale_fix_on_save = 1
let ale_virtualtext_cursor = 1
let g:ale_completion_enabled = 0
let g:ale_close_preview_on_insert = 1
let g:ale_warn_about_trailing_whitespace = 0

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = "[%linter%] %severity% %code% - %s"
let g:ale_linter_aliases = {'svelte': ['css', 'javascript']}

let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'typescript': ['eslint'],
    \ 'svelte': ['stylelint', 'eslint'],
    \ 'typescriptreact': ['eslint'],
    \ 'python': ['flake8', 'mypy', 'pylint', 'pyright'],
    \ 'css': ['stylelint'],
    \ 'go': [],
    \ 'sh': ['shellcheck'],
    \ 'json': ['jq'],
    \ 'elixir': ['elixir-ls'],
    \ 'graphql': [],
\ }
let g:ale_fixers = {
    \ 'javascript': ['prettier', 'eslint'],
    \ 'javascriptreact': ['prettier', 'eslint'],
    \ 'typescript': ['prettier', 'eslint'],
    \ 'typescriptreact': ['prettier', 'eslint'],
    \ 'svelte': ['prettier', 'eslint', 'stylelint'],
    \ 'markdown': ['prettier'],
    \ 'html': ['prettier'],
    \ 'css': ['prettier', 'stylelint'],
    \ 'python': ['isort', 'black'],
    \ 'json': ['jq', 'prettier'],
    \ 'elixir': ['mix_format'],
    \ 'graphql': ['prettier'],
\ }
  " \ 'sh': ['shfmt'],

nmap <Leader>e <plug>(ale_detail)

" Airline
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#csv#enabled = 0
" let g:airline#extensions#ale = 0
let g:airline_theme = 'base16'
set noshowmode

" IndentGuides
let indent_guides_enable_on_vim_startup = 1
if !has("gui_running")
  let g:indent_guides_auto_colors = 0
  autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#181825
endif

" Go
" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"

" Markdown
augroup markdownSpell
  autocmd!
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal spell
augroup END
let g:markdown_folding = 1

" NERDCommenter
let NERDSpaceDelims = 1

" Scratch
nmap <Leader>d :Sscratch<CR>:q<CR>:b __Scratch__<CR>
nmap <Leader>D :b __Scratch__<CR>:b#<CR>

" Simplenote
if filereadable(expand($HOME . "/.simplenoterc"))
  source $HOME/.simplenoterc
endif
let g:SimplenoteNoteFiletype = 'markdown'
let g:SimplenoteVertical = 1

" Svelte
let g:svelte_preprocessor_tags = [
  \ { 'name': 'ts', 'tag': 'script', 'as': 'typescript' }
  \ ]
let g:svelte_preprocessors = ['ts']

" HardTime - No arrows
let g:hardtime_default_on = 1
let g:hardtime_maxcount = 2
let g:hardtime_allow_different_key = 1
let g:list_of_normal_keys = ["h", "j", "k", "l", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
" let g:hardtime_ignore_quickfix = 1

" Vim Test
" make test commands execute using dispatch.vim
let test#strategy = "vimux"
nmap <leader>rtn :TestNearest<Space>
nmap <leader>rtc :TestClass<Space>
nmap <leader>rtf :TestFile<Space>
nmap <leader>rta :TestSuite<Space>
nmap <leader>rtl :TestLast<Space>
nmap <silent> <leader>rtg :TestVisit<Space>
nmap <silent> <leader>rTn :TestNearest<CR>
nmap <silent> <leader>rTc :TestClass<CR>
nmap <silent> <leader>rTf :TestFile<CR>
nmap <silent> <leader>rTa :TestSuite<CR>
nmap <silent> <leader>rTl :TestLast<CR>
let test#python#runner = 'pytest'

" Source the vimrc file after saving it. This way, you don't have to reload Vim to see the changes.
if has("autocmd")
  augroup myvimrchooks
    au!
    autocmd bufwritepost .vimrc source ~/.vimrc
  augroup END
endif
