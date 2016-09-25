let mapleader = "\<Space>"
colorscheme peachpuff
set nocompatible
set autoindent
set backspace=indent,eol,start
set complete-=i
set tabstop=2
set shiftwidth=2
set expandtab
set smarttab
set nrformats-=octal
" Disable nvim default entering VISUAL mode on mouse selection
set mouse-=a
" Search behaviors
set incsearch
set hlsearch
nnoremap <Leader>/ :nohlsearch<CR>
set laststatus=2
set ruler
set showcmd
set wildmenu
set display+=lastline
set autoread
set fileformats+=mac
set history=1000
set tabpagemax=50
let s:dir = has('win32') ? '$APPDATA/Vim' : isdirectory($HOME.'/Library') ? '~/Library/Vim' : empty($XDG_DATA_HOME) ? '~/.local/share/vim' : '$XDG_DATA_HOME/vim'
let &backupdir = expand(s:dir) . '/backup//'
let &undodir = expand(s:dir) . '/undo//'
set undofile
inoremap <C-U> <C-G>u<C-U>
if !isdirectory(expand(s:dir))
  call system("mkdir -p " . expand(s:dir) . "/{backup,undo}")
end
" set cursorline
set scrolloff=8
set sidescroll=1
set sidescrolloff=15
set winwidth=79
set winheight=5
set winminheight=5
set hidden
set switchbuf=usetab
set wrap linebreak
set showbreak=" "
vmap j gj
vmap k gk
nmap j gj
nmap k gk
set wildmode=longest,full
set number
set noerrorbells
set visualbell
set modeline
set foldmethod=indent
set foldnestmax=3
set nofoldenable
set noswapfile
set viminfo='100,f1
set ignorecase
set showmode
set smartcase
noremap n nzz
noremap N Nzz
nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>
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
set title
nnoremap <C-w>s <C-w>s<C-w>w
nnoremap <C-w>v <C-w>v<C-w>w
set shortmess+=I

call plug#begin()
Plug 'sheerun/vim-polyglot'
call plug#end()

nnoremap <Leader>o :CtrlP<CR>

" Improved pasting
" @see http://stackoverflow.com/questions/5585129/pasting-code-into-terminal-window-into-vim-on-mac-os-x
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
