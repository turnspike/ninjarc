""|
""| ninjarc vimrc config
""| github.com/turnspike/ninjarc
""|

" -- TODO: each line should have a " reason

" ---- FORMATTING ----

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

" ---- BUFFERS AND SPLITS ----

set hidden " enable multi file editing
set splitbelow " open hsplits down (defaults up)

set splitright " open vsplits right (defaults left)
"set autochdir " set working directory to current file eg for :e

" ---- EDITING ----

set backspace=indent,eol,start
set nostartofline " preserve column on page movements

augroup copyPaste
  " unset paste on InsertLeave
  au InsertLeave * silent! set nopaste
augroup END

" ---- CURSOR ----

augroup Cursor
  autocmd!
  autocmd InsertEnter,InsertLeave * set cul! " underline current line for insert mode only
augroup END

" -- this causes lockups when pressing A,O and when exiting insert mode
" because of the escape chars!!
"if $TERM_PROGRAM =~ "iTerm"
"    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
"    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
"endif

" ---- TIMEOUTS (LEADER KEYS, ESC) ----

"" -- timeouts can cause UI lag
"set timeoutlen=100 ttimeoutlen=0
set nottimeout " no timeouts for key combos
set notimeout " no timeouts for key combos

" ---- COMMANDLINE ----

set path+=** " search down into subfolders
set wildmenu " <tab> autocompletion in commandline
set wildmode=list:longest,full " more linuxy filename completion with <tab>
set wildignore+=*/tmp/*,*/.git/*,*.so,*.swp,*.zip " exclude from <tab> completion
"set rtp+=~/.fzf " add fuzzy finder to runtime path

" ---- BACKUPS ----

set nobackup
set noswapfile
set nowritebackup

" ---- SEARCH AND REPLACE ----

"set gdefault " always use /g with %s/
set hlsearch " highlight search hits
set incsearch "incremental search
set wrapscan
set ignorecase
set smartcase
set infercase

" ---- KEYBINDS ----

" -- move cursor naturally through wrapped lines
"nnoremap <silent> j gj
"nnoremap <silent> k gk
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'

" select most recently edited/pasted text with gp
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" reselect text when indenting in visual mode
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" exit insert mode with <jk>
"imap <silent> jk <esc>

augroup Keybinds
  autocmd!
  " q will quit help buffer
  autocmd FileType help noremap <buffer> q :q<cr>
augroup END

" ---- LEADER KEYS ----

""nnoremap <leader>w :w<cr>
nnoremap <leader>x :Bdelete!<cr>

" ---- FILE BROWSER ----

"" -- open netrw as left pane with :Ve
"" https://shapeshed.com/vim-netrw/
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore " always show file drawer
""augroup END

" ---- TYPOS ----

cnoreabbrev W w
cnoreabbrev X x
cnoreabbrev Q q

" ---- FILETYPES ----

filetype plugin indent on
augroup Filetypes
  autocmd!
  autocmd FileType * setlocal formatoptions=1 " don't autoformat 
  autocmd FileType * setlocal formatoptions-=cro " don't autocomment newlines
  autocmd BufNewFile,BufRead * setlocal formatoptions-=cro " no really, don't autocomment newlines
  "au FileType * set tabstop=2|set shiftwidth=2|set noexpandtab " default indenting
augroup END

" ---- DISPLAY ----

augroup display
  " http://vim.wikia.com/wiki/Highlight_unwanted_spaces
  au BufNewFile,BufRead,InsertLeave * silent! match ExtraWhitespace /\s\+$/
  au InsertEnter * silent! match ExtraWhitespace /\s\+\%#\@<!$/
augroup END

"set number " show line numbers
colorscheme desert
set noerrorbells " no bell
syntax enable " enable syntax highlighting

" ---- COMMANDS ----

command! ConfigEdit edit ~/.config/ninjarc/.vimrc " edit config file
command! ConfigReload source $MYVIMRC " live reload config
" TODO: add command to change PWD to git root
command! FilePath :echo resolve(expand('%:p')) " display path of current file

"
" expand :e %%/ on the command line to :e /some/path/
cabbr <expr> %% expand('%:p:h')

" ---- FUNCTIONS ----
