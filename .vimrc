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
"set cindent

" -- don't hard wrap or autoformat
set nowrap
set textwidth=0
set linebreak
"set formatoptions=l
set formatoptions=tqnj
"let &showbreak='▷ '
"map F6 :se wrap! | echo &wrap
"set wrap " soft wrap long lines 
"set textwidth=0
"set wrapmargin=0
"set linebreak
"set nolist " don't show hidden chars

" ---- BUFFERS AND SPLITS ----

set hidden " enable multi file editing
set splitbelow " open hsplits down (defaults up)
set splitright " open vsplits right (defaults left)
"set autochdir " set working directory to current file eg for :e

" ---- EDITING ----

set backspace=indent,eol,start
set nostartofline " preserve column on page movements
" set virtualedit=all " allow cursor to be moved one character past eol... actually no this is annoying

augroup copyPaste
  " unset paste on InsertLeave
  au InsertLeave * silent! set nopaste
augroup END

" ---- CURSOR ----

augroup Cursor
  autocmd!
  autocmd InsertEnter,InsertLeave * set cul! " underline current line for insert mode only
augroup END

set mouse=a " enable mouse

" -- #FIXME this causes lockups when pressing A,O and when exiting insert mode
" because of the escape chars!!
"if $TERM_PROGRAM =~ "iTerm"
"    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
"    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
"endif

" ---- TIMEOUTS (LEADER KEYS, ESC) ----

" timeouts can cause UI lag
"set timeoutlen=100 ttimeoutlen=0
set nottimeout " no timeouts for key combos
set notimeout " no timeouts for key combos

" ---- COMMANDLINE ----

set path+=** " search down into subfolders
set wildmenu " <tab> autocompletion in commandline
set wildmode=list:longest,full " more linuxy filename completion with <tab>
set wildignore+=*/tmp/*,*/.git/*,*.so,*.swp,*.zip " exclude from <tab> completion
set rtp+=/usr/local/opt/fzf " add fuzzy finder to runtime path

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

" Unset the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>

" ---- KEYBINDS ----

" alias for <esc> since Big Sur breaks remapping caps using third party apps...
" esc in insert mode
inoremap jk <esc>

" esc in command mode
cnoremap jk <C-C>

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

" move visual selection
vnoremap J :m '>+1gv=gv
vnoremap K :m '<-2gv=gv

" exit insert mode with <jk>
"imap <silent> jk <esc>

augroup Keybinds
  autocmd!
  " q will quit help buffer
  autocmd FileType help noremap <buffer> q :q<cr>
augroup END

" ---- LEADER KEYS ----

" nnoremap <leader>w :w<cr>

" close buffer
nnoremap <leader>x :Bdelete!<cr>

" ---- FILE BROWSER ----

" open netrw as left pane with :Ve
" https://shapeshed.com/vim-netrw/
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore " always show file drawer
"augroup END

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

set scrolloff=3 " scroll when cursor is 3 lines from top or bottom


" ---- COMMANDS ----

command! ConfigEdit edit ~/.config/ninjarc/.vimrc " edit config file
command! ConfigReload source $MYVIMRC " live reload config
" TODO: add command to change PWD to git root
" display path of current file " display path of current file
command! FilePath :echo resolve(expand('%:p'))
" expand :e %%/ on the command line to :e /some/path/
cabbr <expr> %% expand('%:p:h')
" set window working dir to file path
command! FileCd :lcd %:p:h


" ---- FUNCTIONS ----

" ---- PLUGINS ----

" initialise vimplug

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

"---- EDITING

Plug 'tpope/vim-repeat' " add . repeat for some plugins
Plug 'tpope/vim-unimpaired' " use ] and [ combos for :ex commands, eg ]b for next buffer
Plug 'tpope/vim-surround' " bracket manipulation eg cs'<p>
Plug 'tpope/vim-dispatch' " execute shell commands in the background
Plug 'tpope/vim-rsi' " emacs/readline style keybinds
" visually select outwards using <v>
Plug 'terryma/vim-expand-region'
" vipga= or gaip= to align on equal
Plug 'junegunn/vim-easy-align' 

"---- COMMENTING

Plug 'scrooloose/nerdcommenter'
let g:NERDDefaultAlign = 'left' " comment delimiters hard left
let g:NERDCompactSexyComs = 1 " use compact syntax for prettified multi-line comments
let g:NERDCommentEmptyLines = 1 " allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDTrimTrailingWhitespace = 1 " enable trimming of trailing whitespace when uncommenting

" Initialize plugin system
call plug#end()
