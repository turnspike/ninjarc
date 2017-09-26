##|
##| Ninjarc bash config
##| github.com/turnspike/ninjarc
##|

# source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# exit if running non-interactively
case $- in
    *i*) ;;
      *) return;;
esac

#-- define colors

ESC_SEQ="\x1b[" # start color sequence
ESC_NO=$ESC_SEQ"39;49;00m" # reset color
ESC_HI=$ESC_SEQ"01;034m" # blue

alias print-right="printf '%*s' $(tput cols)" # right align
hr() { printf '\e(0'; printf 'q%.0s' $(seq $(tput cols)); printf '\e(B'; } # horizontal rule

## set prompt colours
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
C_NO='\e[0m\]'; # normal
C_DIM='\e[0;90m\]'; # dark gray
C_HI='\e[1;34m\]'; # bold blue

## different prompt if root
if [[ ${EUID} == 0 ]] ; then
  C_USER='\e[48;5;1m\]'; # show root as bold background
  C_USER='\[\033[31m\]\[\033[37m\]'; # show root as bold background
  C_USER='\e[101m\]'; # show root as bold background
else
  C_USER=$C_NO;
fi

export PS1="$C_NO$C_DIM$(hr)\n$C_NO$C_USER\u$C_NO$C_HI@\h$C_NO$C_DIM \w\n$C_NO$C_HI\342\210\264 $C_NO"

#-- detect distro
#TODO https://unix.stackexchange.com/a/6348
DISTRO=""
if [[ "$OSTYPE" == "linux-gnu" ]]; then # linux
	DISTRO="$(lsb_release -a | grep Description: | sed -e 's/^.*:\W*//')"
	#DISTRO=lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om
elif [[ "$OSTYPE" == "darwin"* ]]; then # macos
  DISTRO="$(sw_vers -productVersion)"
	DISTRO="MacOS $DISTRO"
fi

#-- display greeting

echo -e $ESC_HI"\n"$(hr)
echo -e $ESC_NO"ʕっ•ᴥ•ʔっ\t"$ESC_HI$(whoami)"@"$(hostname)
echo -e $(hr)$ESC_NO;
echo -e "\t\t"$DISTRO
echo -e "\t\t"$(date)
echo -e "\t\tstarting bash "${BASH_VERSION%.*}"...\n";

#-- general setings

export BLOCKSIZE=1k # set default blocksize for ls, df, du
set completion-ignore-case On
shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
export XMLLINT_INDENT=" "
export TERM=xterm-256color

#-- history settings
export HISTCONTROL="ignoreboth" # don't put duplicate lines or lines starting with space in the history.
export HISTIGNORE="&:ls:[bf]g:exit:l:ll" # ignore uninteresting commands
shopt -s histappend # append to the history file, don't overwrite it
# export HISTSIZE=1000 # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
# export HISTFILESIZE=2000
shopt -s cmdhist ## fix for multiline commands

#-- aliases

## directories
alias ..='cd ..'
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'
alias b="pushd ." # bookmark current directory
alias r="popd" # return to previously bookmarked directory

## enable color support of ls and also add aliases
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

## system
alias md="mkdir"
alias rd="rmdir"

#-- tweaks and helpers
alias shell-name="ps -p $$"
alias big-files="du -ah /home | sort -n -r | head -n 15"
alias ssh-hosts="grep -w -i "Host" ~/.ssh/config | sed 's/Host//'"
alias dir-size="du -sh"

## find file with pattern in name
function find-file() { find . -type f -iname '*'"$*"'*' -ls ; }

## create ZIP archive of a file or folder
function zip-file() { zip -r "${1%%/}.zip" "$1" ; }

## apply default perms
function fix-perms() { chmod -R u=rwX,g=rX,o= "$@" ; }

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

## load fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
