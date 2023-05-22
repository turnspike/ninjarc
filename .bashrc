##|
##| ninjarc bash config
##| github.com/turnspike/ninjarc
##|

## ---- SETUP PROMPT ----

## define colors
ESC_SEQ="\x1b[" # start color sequence
ESC_NO=$ESC_SEQ"39;49;00m" # reset color
ESC_HI=$ESC_SEQ"01;034m" # blue
#export NINJARC=$( cd $(dirname $0) ; pwd -P )
#export NINJARC="~/.ninjarc"

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
export GIT_PS1_SHOWDIRTYSTATE=1
#export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
[ -f /usr/local/etc/bash_completion.d/git-prompt.sh ] && source /usr/local/etc/bash_completion.d/git-prompt.sh

export PS1="$C_NO$C_DIM$(hr)$C_NO\n$C_USER\u$C_NO$C_HI@\h$C_NO $C_DIM\w$C_NO\n$C_HI>$C_NO"

## use git prompt if available on system
#if [ "$OSTYPE" == "darwin"* ] || [ type __git_ps1 | grep -q '^function$' 2>/dev/null ] then
#W  export PS1="$C_NO$C_DIM$(hr)$C_NO\n$C_USER\u$C_NO$C_HI@\h$C_NO $C_DIM\w\$C_NO\n$C_HI>$C_NO"
#fi

## ---- DISPLAY GREETING ----

## detect distro
## TODO https://unix.stackexchange.com/a/6348
DISTRO=""
if [[ "$OSTYPE" == "linux-gnu" ]]; then # linux
	#DISTRO="$(lsb_release -a | grep Description: | sed -e 's/^.*:\W*//')"
  DISTRO=`$(hostnamectl | grep "Operating System:" | sed -e 's/^.*:\W*//')`
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

## ---- GENERAL SETTINGS ----

export BLOCKSIZE=1k # set default blocksize for ls, df, du
set completion-ignore-case On
export XMLLINT_INDENT=" "
export TERM=xterm-256color

## ---- HISTORY SETTINGS ----

## FIXME fzf doesn't seem to respect HISTIGNORE
#shopt -s histverify histreedit # load history substitute into readline rather than immediately executing
shopt -s histappend # append to the history file, don't overwrite it
shopt -s cmdhist # fix for multiline commands
export HISTCONTROL=ignoredups:erasedups # don't put duplicate lines or lines starting with space in the history.
#export HISTCONTROL=ignoreboth # don't put duplicate lines or lines with leading spaces in the history. See bash(1) for more options
export HISTSIZE=10000 # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTFILESIZE=20000
export HISTIGNORE='&:l:ll:ls:rm:[bf]g:exit:pwd:clear:mount:umount' # ignore uninteresting or dangerous commands

## eternal bash history
export HISTTIMEFORMAT="%s "
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo $$ $USER "$(history 1)" >> ~/.bash_eternal_history'

## ---- ALIASES ----

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
alias cdh='cd -' # enhancd history
#alias update-tags='cdr; ctags -R -f ./.git/tags .' # update tags for current git project

## system
alias md="mkdir"
alias rd="rmdir"

## ---- HELPER FUNCTIONS ----

alias dir_size="du -sh"
alias yt-audio-dl="youtube-dl --audio-format best -x" # download youtube audio best quality available (pass the URL)
alias find_proc="ps aux | percol | awk '{ print $2 }' | echo" # interactively search for process id
alias hosts="grep -w -i "Host" ~/.ssh/config | sed 's/Host//'" # list all hosts defined in .ssh/config
alias funcs="typeset -F | grep -v '^declare -f _.*'" # list all user-defined functions
alias kill_proc="ps aux | percol | awk '{ print $2 }' | xargs kill"
#alias list-big-files="du -ah /home | sort -n -r | head -n 15" # list 15 largest files
alias shell_name="ps -p $$" # display name of current shell
# TODO more percol: http://jacobbridges.github.io/post/awesome-percol-examples/

## find file with pattern in name
function find_item() { find . -type f -iname '*'"$*"'*' -ls 2>/dev/null; }

## create ZIP archive of a file or folder
function zip_item() { zip -r "${1%%/}.zip" "$1" ; }

## apply default perms
function fix_perms() { chmod -R u=rwX,g=rX,o= "$@" ; }

## autocomplete host entries
complete -o default -o nospace -W "$(grep "^Host" $HOME/.ssh/config | cut -d" " -f2)" scp sftp ssh

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

## ---- HELPER APPS ----

## -- load ssh keys
#  https://unix.stackexchange.com/a/217223
echo -e $ESC_HI"checking for ssh-agent..."$ESC_NO
if [ ! -S ~/.ssh/ssh_auth_sock ]; then # only one instance of ssh-agent per session
	echo "starting new instance of ssh-agent"
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
  ssh-add -l > /dev/null || ssh-add
fi

## -- load fzf
#     https://github.com/junegunn/fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

## -- load enhancd
#     https://github.com/b4b4r07/enhancd
export ENHANCD_FILTER=fzf;
export ENHANCD_DISABLE_DOT=1;
export ENHANCD_HOOK_AFTER_CD="l";
export ENHANCD_DISABLE_HOME="1";
[ -f ~/.enhancd/init.sh ] && source ~/.enhancd/init.sh

## -- load bashmarks
#     https://github.com/turnspike/bashmarks
export BASHMARKS_PREFIX="b";
if [ -f ~/.bashmarks/bashmarks.sh ]; then
    source ~/.bashmarks/bashmarks.sh
    alias ${BASHMARKS_PREFIX}a="bashmarks_s"
    alias ${BASHMARKS_PREFIX}j="bashmarks_g"
    alias ${BASHMARKS_PREFIX}e="bashmarks_p"
fi

## ---- MACOS SPECIFIC ----

if [[ "$(uname)" = "Darwin" ]]; then
  alias l="gls -h --group-directories-first --color=always"
  alias ll="gls -alFhG --group-directories-first --color=always" # use gnu ls instead of system ls (enable better color support)
  alias em="/usr/local/bin/emacs"
  export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH" # homebrew
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" # use coreutils readlink
  export OCI_DIR="$(brew --prefix)/lib" # Oracle Instant Client from homebrewa
  export NLS_LANG="American_Australia.UTF8" # Oracle language setting
  #source /usr/local/share/chruby/chruby.sh # chruby for ruby version mgmt 
  #source /usr/local/share/chruby/auto.sh # load .ruby_version automatically after cd #
  export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
  if which rbenv > /dev/null; then eval "$(rbenv init - --no-rehash)"; fi
  #ssh-add -K ~/.ssh/id_rsa # autoload default ssh key # mfa makes this annoying, disabling for now
  [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
fi

## ---- FZF FUNCTIONS ----

# fuzzy grep open via ag with line number
fzg() {
  local file
  local line

  read -r file line <<<"$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]
  then
     vim $file +$line
  fi
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

## ---- GIT FUNCTIONS ----

# Amend the last commit message and push the changes to remote by force
# USAGE: gamend "Your New Commit Msg"
# https://dev.to/mrahmadawais/one-command-to-change-the-last-git-commit-message--42hb
function gamend() {
    git commit --amend -m "$@"
    git push --force-with-lease
}

# git tab completion
# https://apple.stackexchange.com/a/55886
[ -f ~/.git-completion.bash ] && source ~/.git-completion.bash

## ---- TAB COMPLETION FOR ALIASES ----
#  https://stackoverflow.com/questions/342969/how-do-i-get-bash-completion-to-work-with-aliases

# wrap_alias takes three arguments:
# $1: The name of the alias
# $2: The command used in the alias
# $3: The arguments in the alias all in one string
# Generate a wrapper completion function (completer) for an alias
# based on the command and the given arguments, if there is a
# completer for the command, and set the wrapper as the completer for
# the alias.
function wrap_alias() {
  [[ "$#" == 3 ]] || return 1

  local alias_name="$1"
  local aliased_command="$2"
  local alias_arguments="$3"
  local num_alias_arguments=$(echo "$alias_arguments" | wc -w)

  # The completion currently being used for the aliased command.
  local completion=$(complete -p $aliased_command 2> /dev/null)

  # Only a completer based on a function can be wrapped so look for -F
  # in the current completion. This check will also catch commands
  # with no completer for which $completion will be empty.
  echo $completion | grep -q -- -F || return 0

  local namespace=alias_completion::

  # Extract the name of the completion function from a string that
  # looks like: something -F function_name something
  # First strip the beginning of the string up to the function name by
  # removing "* -F " from the front.
  local completion_function=${completion##* -F }
  # Then strip " *" from the end, leaving only the function name.
  completion_function=${completion_function%% *}

  # Try to prevent an infinite loop by not wrapping a function
  # generated by this function. This can happen when the user runs
  # this twice for an alias like ls='ls --color=auto' or alias l='ls'
  # and alias ls='l foo'
  [[ "${completion_function#$namespace}" != $completion_function ]] && return 0

  local wrapper_name="${namespace}${alias_name}"

  eval "
function ${wrapper_name}() {
  ((COMP_CWORD+=$num_alias_arguments))
  args=( \"${alias_arguments}\" )
  COMP_WORDS=( $aliased_command \${args[@]} \${COMP_WORDS[@]:1} )
  $completion_function
  }
"

  # To create the new completion we use the old one with two
  # replacements:
  # 1) Replace the function with the wrapper.
  local new_completion=${completion/-F * /-F $wrapper_name }
  # 2) Replace the command being completed with the alias.
  new_completion="${new_completion% *} $alias_name"

  eval "$new_completion"
}

# For each defined alias, extract the necessary elements and use them
# to call wrap_alias.
eval "$(alias -p | sed -e 's/alias \([^=][^=]*\)='\''\([^ ][^ ]*\) *\(.*\)'\''/wrap_alias \1 \2 '\''\3'\'' /')"

unset wrap_alias
