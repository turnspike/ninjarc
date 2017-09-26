"----
"---- Ninjarc: minimal vimrc
"---- https://github.com/turnspike/ninjarc
"----

"-- TODO: each line should have a " reason

"---- Environment ----

"-- tabs and spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set cindent
set smarttab

"-- buffers and splits
set hidden " enable multi file editing
set splitbelow " open hsplits down (defaults up)
set splitright " open vsplits right (defaults left)

"-- cursor
set backspace=indent,eol,start
set nostartofline " preserve column on page movements
autocmd InsertEnter,InsertLeave * set cul! " underline current line for insert mode only

"-- timeouts (leader keys, esc)
set ttimeout
set ttimeoutlen=100

"-- commandline
set wildmenu
set wildmode=list:longest,full " more linuxy filename completion with <tab>
set wildignore+=*/tmp/*,*/.git/*,*.so,*.swp,*.zip
set rtp+=~/.fzf

"-- backups
set nobackup
set noswapfile
set nowritebackup

"-- filetypes
set nocp
filetype plugin indent on
au FileType * setlocal formatoptions-=cro " don't autocomment newlines
au BufNewFile,BufRead * setlocal formatoptions-=cro " no really, don't autocomment newlines
au FileType * set tabstop=2|set shiftwidth=2|set noexpandtab " default indenting

"-- search and replace
set gdefault " always use /g with %s/
set hlsearch " highlight search hits
set incsearch "incremental search
set wrapscan
set ignorecase
set smartcase
set infercase

"---- Keybinds ----
"let mapleader = "\<space>"
"let maplocalleader = "\<space>"

" move cursor naturally through wrapped lines
nnoremap <silent> j gj
nnoremap <silent> k gk

"---- Display ----
set number " show line numbers
colorscheme desert
syntax on
