##|
##| ninjarc bash config
##| github.com/turnspike/ninjarc
##|

## load global .bashrc
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# define colors
ESC_SEQ="\x1b[" # start color sequence
ESC_NO=$ESC_SEQ"39;49;00m" # reset color
ESC_HI=$ESC_SEQ"01;034m" # blue

## pretty print functions
shopt -sq checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
alias print-right="printf '%*s' $(tput cols)" # right align

## FIXME tput cols doesn't update when term win resized on macos
#export COLUMNS=$COLUMNS
#unset COLUMNS
#trap 'COLUMNS=$(COLUMNS= tput cols)' SIGWINCH
#trap 'export COLUMNS=$(COLUMNS= tput cols)' SIGWINCH
#function hr() { echo $(tput cols); echo "c"$1; printf '\e(0'; printf 'q%.0s' $(seq $COLUMNS); printf '\e(B'; } # horizontal rule
#function hr() { printf %"$(stty size | awk '{print $2}')"s |tr " " "-"; }
#PROMPT_COMMAND=hr
#function hr() {
#  local start=$'\e(0' end=$'\e(B' line='qqqqqqqqqqqqqqqq'
#  local cols=${COLUMNS:-$(tput cols)}
#  while ((${#line} < cols)); do line+="$line"; done
#  printf '%s%s%s\n' "$start" "${line:0:cols}" "$end"
#}

#function hr() { foo=1; } # horizontal rule

## define prompt colours
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
C_NO='\[\e[0m\]'; # normal
C_DIM='\[\e[0;90m\]'; # dark gray
C_HI='\[\e[1;34m\]'; # bold blue

## different prompt if root
if [[ ${EUID} == 0 ]] ; then
  C_USER='\[\e[101m\]'; # show root as bold background
else
  C_USER=$C_NO;
fi

## draw horizontal rule
function hr() {

  if ! [ -z $INSIDE_EMACS ]; then # shell is running inside emacs
    echo -e " ";
  else # normal shell
    printf '\e(0'; printf 'q%.0s' $(seq $(tput cols)); printf '\e(B';
  fi

}

## apply prompt
#export PS1="$C_NO$C_DIM$(hr)\n$C_NO$C_USER\u$C_NO$C_HI@\h$C_NO$C_DIM \w\n$C_NO$C_HI\342\210\264 $C_NO" # this is breaking <ctrl-r>
export PS1="$C_NO$C_DIM$(hr)$C_NO\n$C_USER\u$C_NO$C_HI@\h$C_NO $C_DIM\w$C_NO\n$C_HI>$C_NO"

## ---- display greeting ----

## detect distro
## TODO https://unix.stackexchange.com/a/6348
DISTRO=""
if [[ "$OSTYPE" == "linux-gnu" ]]; then # linux
	DISTRO="$(lsb_release -a | grep Description: | sed -e 's/^.*:\W*//')"
elif [[ "$OSTYPE" == "darwin"* ]]; then # macos
  DISTRO="$(sw_vers -productVersion)"
	DISTRO="MacOS "$DISTRO
fi

echo -e $ESC_HI"\n"$(hr)
echo -e $ESC_NO"ʕっ•ᴥ•ʔっ\t"$ESC_HI$(whoami)"@"$(hostname)
echo -e $(hr)$ESC_NO;
echo -e "\t\t"$DISTRO
echo -e "\t\t"$(date)
echo -e "\t\tstarting bash "${BASH_VERSION%.*}"...\n";

## ---- general settings ----

export BLOCKSIZE=1k # set default blocksize for ls, df, du
set completion-ignore-case On
export XMLLINT_INDENT=" "
export TERM=xterm-256color

## ---- history settings ----

## FIXME fzf doesn't seem to respect HISTIGNORE
#shopt -s histverify histreedit # load history substitute into readline rather than immediately executing
shopt -s histappend # append to the history file, don't overwrite it
shopt -s cmdhist # fix for multiline commands
#export HISTCONTROL=ignoredups:erasedups # don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth # don't put duplicate lines or lines with leading spaces in the history. See bash(1) for more options
export HISTSIZE=10000 # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTFILESIZE=20000
export HISTIGNORE='&:l:ll:ls:rm:[bf]g:exit:pwd:clear:mount:umount' # ignore uninteresting or dangerous commands

## eternal bash history
#export HISTTIMEFORMAT="%s "
#PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo $$ $USER "$(history 1)" >> ~/.bash_eternal_history'

## ---- aliases ----

## directories
alias ..='cd ..'
alias l='ls -aFhG'
alias ll='l -l'
alias b="pushd ." # bookmark current directory
alias r="popd" # return to previously bookmarked directory

## enable color support if dircolors available
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## apps
alias g="git"
alias cdr='cd $(git rev-parse --show-cdup)' # cd to git root
alias update-tags='cdr; ctags -R -f ./.git/tags .' # update tags for current git project

## system
alias md="mkdir"
alias rd="rmdir"

## ---- helper functions ----

alias shell-name="ps -p $$" # display name of current shell
#alias list-big-files="du -ah /home | sort -n -r | head -n 15" # list 15 largest files
alias list-hosts="grep -w -i "Host" ~/.ssh/config | sed 's/Host//'" # list all hosts defined in .ssh/config
alias dir-size="du -sh"
alias list-funcs="typeset -F | grep -v '^declare -f _.*'" # list all user-defined functions

## find file with pattern in name
function find-file() { find . -type f -iname '*'"$*"'*' -ls 2>/dev/null; }

## create ZIP archive of a file or folder
function zip-file() { zip -r "${1%%/}.zip" "$1" ; }

## apply default perms
function fix-perms() { chmod -R u=rwX,g=rX,o= "$@" ; }

## quote string for grep / regex
#function quote-str() { sed 's/[]\.|$(){}?+*^]/\\&/g' <<< "$*" }

## extract any archive eg .zip
extract() {
    if [ -f $1  ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

## ---- helper apps ----

## -- load ssh keys
## https://unix.stackexchange.com/a/217223
echo -e $ESC_HI"loading ssh-agent"$ESC_NO
if [ ! -S ~/.ssh/ssh_auth_sock ]; then # only one instance of ssh-agent per session
	echo "starting new instance of ssh-agent"
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
ssh-add -l > /dev/null || ssh-add

## -- load fzf
##    https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

## -- load enhancd
##    https://github.com/b4b4r07/enhancd
export ENHANCD_FILTER=fzf;
export ENHANCD_DISABLE_DOT=1;
export ENHANCD_HOOK_AFTER_CD="l";
[ -f ~/.enhancd/init.sh ] && source ~/.enhancd/init.sh

## -- load bashmarks
##    https://github.com/turnspike/bashmarks
export BASHMARKS_PREFIX="b";
if [ -f ~/.bashmarks/bashmarks.sh ]; then
    source ~/.bashmarks/bashmarks.sh
    alias ${BASHMARKS_PREFIX}a="bashmarks_s"
    alias ${BASHMARKS_PREFIX}j="bashmarks_g"
    alias ${BASHMARKS_PREFIX}e="bashmarks_p"
fi

## -- git tab completion
##    https://apple.stackexchange.com/a/55886
[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash

## ---- user config ----

if [ -f $HOME/.bashrc.user ]; then
	echo -e $ESC_HI"loading user config"$ESC_NO
	source $HOME/.bashrc.user
fi
