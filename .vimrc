" Use Vim-Plug plugin manager.
"
" @see: https://github.com/junegunn/vim-plug

" Automatic installation.
"
" @see: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins.
call plug#begin()
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'easymotion/vim-easymotion'
  Plug 'ervandew/supertab'
  Plug 'godlygeek/tabular'
  Plug 'mileszs/ack.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'sgur/vim-editorconfig'
  Plug 'takac/vim-hardtime'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-sleuth'
  Plug 'tpope/vim-surround'
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
set fixendofline               " Add EOL at end of file if missing.
set foldmethod=indent          " Fold on indent.
set foldnestmax=3              " Maximum nesting of folds.
set formatoptions-=t           " Prevent Vim from automatically reformatting when typing on existing lines.
set hidden                     " Open a new file without writing changes.
set history=1000               " Reasonable history size.
set hlsearch                   " Highlight all matches from previous search pattern.
set ignorecase                 " Ignore case.
set incsearch                  " Show pattern matches when searching.
set laststatus=2               " Always display a status line.
set linebreak                  " Break lines at word boundary.
set modeline                   " Honor document modelines.
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
set shortmess-=S               " Display match count with string search.
set sidescroll=1               " Minimal number of columns to scroll horizontally.
set sidescrolloff=15           " Minimal number of screen columns to pad around the cursor.
set smartcase                  " Override ignorecase if search pattern contains upper case letters.
set smarttab                   " Tab behavior matches shiftwidth.
set switchbuf=usetab           " Jump to the first open window or tab.
set tabpagemax=50              " Maximum number of tab pages to open.
set tabstop=2                  " Visual display of tabs.
set textwidth=0                " Prevent Vim from automatically inserting line breaks in newly entered text.
set title                      " Display a document title.
set undofile                   " Name of the undo file.
set viminfo='100,f1            " Save up to 100 marks, enable capital marks.
set visualbell                 " Use visual bell instead of beeping.
set wildmenu                   " Enhanced command-line completion.
set wildmode=longest,full      " String completion mode.
set winheight=5                " Window height.
set winminheight=5             " Minimum window height.
set winwidth=79                " Minimum window width.
set wrap                       " Break lines at a word boundary.
set wrapmargin=0               " Prevent Vim from automatically inserting line breaks in newly entered text.

" https://vi.stackexchange.com/a/10125
filetype plugin indent on

" Set leader to spacebar.
let mapleader = "\<Space>"

" Backup and undo directory configuration.
let s:dir = '~/Library/Vim'
let &backupdir = expand(s:dir) . '/backup//'
let &undodir = expand(s:dir) . '/undo//'
if !isdirectory(expand(s:dir))
  call system("mkdir -p " . expand(s:dir) . "/{backup,undo}")
end

" Use Q to intelligently close a window in a buffer. Kill the buffer with a
" single window.
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

nnoremap <silent> Q :call CloseWindowOrKillBuffer()<CR>

" Recover from accidental Ctrl-U.
"
" @see: https://vim.fandom.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" Move by visible lines with ':set wrap'.
"
" @see: https://vim.fandom.com/wiki/Move_cursor_by_display_lines_when_wrapping
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" BEGIN CtrlP configuration.
nnoremap <Leader>o :CtrlP<CR>
let g:ctrlp_regexp = 1
" END CtrlP configuration.

" Unhighlight the last search string.
nnoremap <Leader>/ :nohlsearch<CR>

" Ensure match count is always displayed.
nnoremap n nzzhn
nnoremap N Nzzhn

" Remove trailing whitespace on write.
autocmd BufWritePre * :%s/\s\+$//e

" Improved pasting experience for macOS.
"
" @see: https://stackoverflow.com/a/7053522
if has('mac')
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

" BEGIN NERDTree configuration.
nmap <Leader>n :NERDTreeToggle<CR>
noremap <Leader>n :NERDTreeToggle<cr>
noremap <Leader>f :NERDTreeFind<cr>
" END NERDTree configuration.

" Allow adding cronjobs in macOS with Vim.
"
" @see: https://superuser.com/a/750528
if $VIM_CRONTAB == "true"
  set nobackup
  set nowritebackup
endif

" BEGIN EasyMotion configuration.
" Disable default mappings
let g:EasyMotion_do_mapping = 0

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
" END EasyMotion configuration.

" BEGIN Hardtime configuration.
"let g:hardtime_default_on = 1
" END Hardtime configuration.

" Load work assets.
if !empty(glob("$HOME/.work/vim/*.vim"))
  source $HOME/.work/vim/*.vim
endif

