#!/bin/bash

## Ninjarc install script
## - Symlinks .rc files into ~
## - Installs fzf
## - Installs vim plugins (minimal set)
## https://github.com/turnspike/ninjarc

ESC_SEQ="\x1b[" # color escape sequence
ESC_NO=$ESC_SEQ"39;49;00m" # reset to normal color
ESC_HI=$ESC_SEQ"01;034m" # blue

function hr() { printf '\e(0'; printf 'q%.0s' $(seq $(tput cols)); printf '\e(B'; } # horizontal rule
function print-h() { echo -e "\n "$ESC_HI$1"\n"$(hr)$ESC_NO"\n"; }

echo -e $ESC_HI$(hr)
echo " installing ninjarc: "
echo " super minimal .rc files for traipsing around Other People's Servers™"
echo -e $(hr)$ESC_NO

DIR=$( cd $(dirname $0) ; pwd -P ) # get the path to the installer script
echo "installing from: $DIR"

## pass -f to force linking
FORCE=0;
while getopts f x; do
  echo "-f passed, will force overwrite existing ~/files"
  FORCE=1;
done; OPTIND=0

print-h "symlinking .rc files..."

## loop through .files and try to symlink each line
filename="$DIR/.files"
while read file; do

  if [ ! -e $HOME/$file ]; then # file doesn't exist
    echo "linking ~/$file"
    ln -s $DIR/$file $HOME
  elif [ -w $HOME/$file ] && [ $FORCE -eq 1 ]; then # file exists and force set, overwrite
    echo "overwriting ~/$file"
    ln -fs $DIR/$file $HOME
  elif [ -w $HOME/$file ] && [ $FORCE -ne 1 ]; then # file exists and force not set, skip
    echo "~/$file exists, skipping..."
  else # file exists and is not writeable or other issue eg it's a directory
    echo "couldn't write ~/$file, skipping"
  fi

done < $filename

## install fzf as it is portable
print-h "installing fuzzyfinder fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --key-bindings --completion --no-update-rc
echo "use <c-t>, <c-r>, <alt-c> to fuzzy find in shell"
## install vim plugins
##vim +PlugInstall +qall

## reload bash
print-h "restarting bash..."
exec bash

echo "done."
