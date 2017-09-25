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
ESC_RESET=$ESC_SEQ"39;49;00m" # reset color
ESC_HI=$ESC_SEQ"01;034m" # blue

# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

## set prompt colours
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
CPRE='\[\e[' # color prefix
NO_COLOR=$CPRE'0m\]'; # normal
MIN_COLOR=$CPRE'1;30m\]'; # gray
HI_COLOR=$CPRE'01;34m\]'; # highight color: blue

## different prompt if root
if [[ ${EUID} == 0 ]] ; then
    USER_COLOR=$CPRE'48;5;1m\]'; # show root as bold background
else
    USER_COLOR=${NO_COLOR};
    #USER_COLOR=${MIN_COLOR};
    # USER_COLOR=$CPRE'31;32m\]'; # green
fi

alias print-right="printf '%*s' $(tput cols)" # right align
hr() { printf '\e(0'; printf 'q%.0s' $(seq $(tput cols)); printf '\e(B'; } # horizontal rule

export PS1="${MIN_COLOR}$(hr)\n\w\n${USER_COLOR}\u${NO_COLOR}${HI_COLOR}@\h${MIN_COLOR} \342\210\264 ${NO_COLOR}"
export PS1="${MIN_COLOR}$(hr)\n${USER_COLOR}\u${NO_COLOR}${HI_COLOR}@\h${MIN_COLOR} \w\n\342\210\264 ${NO_COLOR}"
export PS1="${MIN_COLOR}$(hr)\n${USER_COLOR}\u${NO_COLOR}${HI_COLOR}@\h${MIN_COLOR} \w\n${HI_COLOR}\342\210\264 ${NO_COLOR}"
export PS1="${MIN_COLOR}$(hr)\n${USER_COLOR}\u${NO_COLOR}${HI_COLOR}@\h${MIN_COLOR} \w\n${HI_COLOR}\342\210\264 ${NO_COLOR}"

#-- detect distro
# if [ -f /etc/os-release ]
DISTRO=""
if [[ "$OSTYPE" == "linux-gnu" ]]; then # linux
	DISTRO=lsb_release -a | grep Description: | sed -e 's/^.*:\W*//'
	#DISTRO=lsb_release -ds 2>/dev/null || cat /etc/*release 2>/dev/null | head -n1 || uname -om
elif [[ "$OSTYPE" == "darwin"* ]]; then # macos
  DISTRO="$(sw_vers -productVersion)"
	DISTRO="MacOS $DISTRO"
fi

#-- display greeting

echo -e "${ESC_HI}";
echo -e "---------------------- --   -";
hostname
echo -e "${ESC_RESET}";
date
echo $DISTRO
echo -e "\nstarting bash ${BASH_VERSION%.*}...";
echo -e "${ESC_HI}---------------------- --   -";
echo -e "${ESC_RESET}";

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

## enable color support of ls and also add aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#-- aliases

## directories
alias ..='cd ..'
alias l='ls -CF'
alias ll='ls -alF'
alias la='ls -A'
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less' # recursive ls
alias b="pushd ." # bookmark current directory
alias r="popd" # return to previously bookmarked directory

## apps
alias g="git"

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
