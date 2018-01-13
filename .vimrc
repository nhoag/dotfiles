" Use Vim-Plug plugin manager.
"
" @see: https://github.com/junegunn/vim-plug

" Automatic installation.
"
" @see: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins.
call plug#begin()
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'easymotion/vim-easymotion'
  Plug 'ervandew/supertab'
  Plug 'godlygeek/tabular'
  Plug 'ludovicchabant/vim-gutentags'
  Plug 'mileszs/ack.vim'
  Plug 'raimondi/delimitmate'
  Plug 'scrooloose/nerdtree'
  Plug 'sgur/vim-editorconfig'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'wikitopian/hardmode'
  Plug 'Xuyuanp/nerdtree-git-plugin'
call plug#end()

colorscheme peachpuff

set autoindent                 " Copy indent from current line when starting a new line.
set autoread                   " Automatically read external file changes.
set backspace=indent,eol,start " Improved backspace behavior.
set complete-=i                " Use tags instead of include scans.
set display+=lastline          " Display the last line.
set expandtab                  " Spaces over tabs.
set fileformats+=mac           " EOL formats to try.
set foldmethod=indent          " Fold on indent.
set foldnestmax=3              " Maximum nesting of folds.
set hidden                     " Open a new file without writing changes.
set history=1000               " Reasonable history size.
set hlsearch                   " Highlight all matches from previous search pattern.
set ignorecase                 " Ignore case.
set incsearch                  " Show pattern matches when searching.
set laststatus=2               " Always display a status line.
set modeline                   " Honor document modelines.
set mouse-=a                   " Ensure no VISUAL mode on mouse selection.
set noerrorbells               " Disable error messages.
set nofoldenable               " Ensure all folds are open.
set noswapfile                 " Don't create swap files.
set nrformats-=octal           " Bases for inc/decrementing character sequences.
set number                     " Display line numbers.
set ruler                      " Cursor and file position.
set scrolloff=8                " Lines to pad above and below cursor.
set shiftwidth=2               " Number of spaces to use for in/outdent.
set showbreak=" "              " String to put at the start of lines that have been wrapped.
set showcmd                    " Show (partial) command in the last line of the screen.
set showmode                   " Show the current mode.
set shortmess+=I               " Ensure the intro message is disabled when starting Vim.
set sidescroll=1               " Minimal number of columns to scroll horizontally.
set sidescrolloff=15           " Minimal number of screen columns to pad around the cursor.
set smartcase                  " Override ignorecase if search pattern contains upper case letters.
set smarttab                   " Tab behavior matches shiftwidth.
set switchbuf=usetab           " Jump to the first open window or tab.
set tabpagemax=50              " Maximum number of tab pages to open.
set tabstop=2                  " Visual display of tabs.
set title                      " Display a document title.
set undofile                   " Name of the undo file.
" @todo: Switch from viminfo to shada.
set viminfo='100,f1            " Save up to 100 marks, enable capital marks.
set visualbell                 " Use visual bell instead of beeping.
set wildmenu                   " Enhanced command-line completion.
set wildmode=longest,full      " String completion mode.
set winheight=5                " Window height.
set winminheight=5             " Minimum window height.
set winwidth=79                " Minimum window width.
set wrap linebreak             " Break lines at a word boundary.

filetype plugin indent on
let mapleader = "\<Space>"
let s:dir = '~/Library/Vim'
let &backupdir = expand(s:dir) . '/backup//'
let &undodir = expand(s:dir) . '/undo//'
let g:ctrlp_regexp = 1
if !isdirectory(expand(s:dir))
  call system("mkdir -p " . expand(s:dir) . "/{backup,undo}")
end

function! CloseWindowOrKillBuffer()
  let number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))
  if matchstr(expand("%"), 'NERD') == 'NERD'
    wincmd c
    return
  endif
  if number_of_windows_to_this_buffer > 1
    wincmd c
  else
    bdelete
  endif
endfunction

" Stop using arrow keys!
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

inoremap <C-s> <ESC>:w<CR>
inoremap <C-U> <C-G>u<C-U>
nmap j gj
nmap k gk
nnoremap <C-w>s <C-w>s<C-w>w
nnoremap <C-w>v <C-w>v<C-w>w
nnoremap <Leader>o :CtrlP<CR>
nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>
nnoremap <C-s> :w<CR>
nnoremap <Leader>/ :nohlsearch<CR>
noremap n nzz
noremap N Nzz
vmap j gj
vmap k gk

" Remove trailing whitespace on write.
autocmd BufWritePre * :%s/\s\+$//e

" Improved pasting experience for macOS.
"
" @see: https://stackoverflow.com/a/7053522
if &term =~ "xterm.*"
  let &t_ti = &t_ti . "\e[?2004h"
  let &t_te = "\e[?2004l" . &t_te
  function XTermPasteBegin(ret)
    set pastetoggle=<Esc>[201~
    set paste
    return a:ret
  endfunction
  map <expr> <Esc>[200~ XTermPasteBegin("i")
  imap <expr> <Esc>[200~ XTermPasteBegin("")
  vmap <expr> <Esc>[200~ XTermPasteBegin("c")
  cmap <Esc>[200~ <nop>
  cmap <Esc>[201~ <nop>
endif

nmap <Leader>n :NERDTreeToggle<CR>
noremap <Leader>n :NERDTreeToggle<cr>
noremap <Leader>f :NERDTreeFind<cr>

" ==== gutentags settings ====
" Exclude css, html, js files from generating tag files.
let g:gutentags_ctags_exclude = ['*.css', '*.html', '*.js', '*.json', '*.xml',
                            \ '*.phar', '*.ini', '*.rst', '*.md',
                            \ '*vendor/*/test*', '*vendor/*/Test*',
                            \ '*vendor/*/fixture*', '*vendor/*/Fixture*',
                            \ '*var/cache*', '*var/log*']
" Where to store tag files.
let g:gutentags_cache_dir = '~/.vim/gutentags'
" ==== End gutentags settings ====

" Allow adding cronjobs in macOS with Vim.
"
" @see: https://superuser.com/a/750528
if $VIM_CRONTAB == "true"
  set nobackup
  set nowritebackup
endif
