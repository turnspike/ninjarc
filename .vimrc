""|
""| ninjarc vimrc config
""| github.com/turnspike/ninjarc
""|

" -- TODO: each line should have a " reason

" ---- environment ----

" -- tabs and spaces
set autoindent                   " copy indent from current line when starting a new line
set expandtab                    " spaces not tabs
set shiftwidth=2                 " spaces used in >>, <<, ==, and autoindent
"set smarttab                    " Remove smarttab since you don't want to use tab characters
set softtabstop=2                " set tab to use 4 space characters
set tabstop=2                    " width of tab character

" -- don't hard wrap or autoformat
set nowrap
set textwidth=0
set linebreak
set formatoptions=l
"let &showbreak='▷ '
"map F6 :se wrap! | echo &wrap
"set wrap " soft wrap long lines 
"set textwidth=0
"set wrapmargin=0
"set linebreak
"set nolist " don't show hidden chars

"set tabstop=2
"set shiftwidth=2
"set softtabstop=2
"set expandtab
"set autoindent
"set cindent
"set smarttab

" -- buffers and splits
set hidden " enable multi file editing
set splitbelow " open hsplits down (defaults up)
set splitright " open vsplits right (defaults left)
"set autochdir " set working directory to current file eg for :e

" -- editing and cursor
set backspace=indent,eol,start
set nostartofline " preserve column on page movements

augroup Cursor
  autocmd InsertEnter,InsertLeave * set cul! " underline current line for insert mode only
augroup END

" -- timeouts (leader keys, esc)
set ttimeout
set ttimeoutlen=100

" -- commandline
set wildmenu " <tab> autocompletion in commandline
set wildmode=list:longest,full " more linuxy filename completion with <tab>
set wildignore+=*/tmp/*,*/.git/*,*.so,*.swp,*.zip " exclude from <tab> completion
set rtp+=~/.fzf " add fuzzy finder to runtime path

" -- backups
set nobackup
set noswapfile
set nowritebackup

" -- search and replace
"set gdefault " always use /g with %s/
set hlsearch " highlight search hits
set incsearch "incremental search
set wrapscan
set ignorecase
set smartcase
set infercase

" ---- keybinds ----

" -- move cursor naturally through wrapped lines
"nnoremap <silent> j gj
"nnoremap <silent> k gk
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'

"" select most recently edited/pasted text with gp
"nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

augroup Keybinds
  "" q will quit help buffer
  autocmd FileType help noremap <buffer> q :q<cr>
augroup END

" ---- file browser ----

" -- open netrw as left pane with :Ve
" https://shapeshed.com/vim-netrw/
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

" ---- command shortcuts ----

" -- vim config
command! ConfigEdit edit $MYVIMRC " edit config file
command! ConfigReload source $MYVIMRC " live reload config

" -- files
command! FilePath :echo resolve(expand('%:p')) " display path of current file

" expand :e %%/ on the command line to :e /some/path/
cabbr <expr> %% expand('%:p:h')

" -- typos
command! Q :q
command! W :w

" -- filetypes
filetype plugin indent on
au FileType * setlocal formatoptions=1 " don't autoformat 
"au FileType * setlocal formatoptions-=cro " don't autocomment newlines
"au BufNewFile,BufRead * setlocal formatoptions-=cro " no really, don't autocomment newlines
"au FileType * set tabstop=2|set shiftwidth=2|set noexpandtab " default indenting

" ---- display ----
"set number " show line numbers
colorscheme desert
set belloff=all " no bell
syntax enable " enable syntax highlighting
