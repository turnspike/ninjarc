#!/bin/bash

## Ninjarc install script
## speed through Other People's Servers™ (minimal .rc files)
## https://github.com/turnspike/ninjarc

## ---- INITIALIZE ----

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

## ---- READ CLI FLAGS ----

## pass -f to force linking
FORCE=0;
while getopts f x; do
  echo "-f passed, will force overwrite existing ~/files"
  FORCE=1;
done; OPTIND=0

print-h "symlinking .rc files..."

## ---- CREATE SYMLINKS ----

## loop through ./symlinks.rc and try to symlink each line
input_file="$DIR/symlinks.rc"
while read file; do

  if [ ! -e $HOME/$file ]; then # file doesn't exist
    echo "linking ~/$file"
    ln -s $DIR/$file $HOME
  elif [ -w $HOME/$file ] && [ $FORCE -eq 1 ]; then # file exists and force set, overwrite
    echo "overwriting ~/$file"
    ln -sf $DIR/$file $HOME
  elif [ -w $HOME/$file ] && [ $FORCE -ne 1 ]; then # file exists and force not set, skip
    echo "~/$file exists, skipping..."
  else # file exists and is not writeable or other issue eg it's a directory
    echo "couldn't write ~/$file, skipping"
  fi

done < $input_file

## ---- ADD SOURCE LINES ----

## loop through ./sources.rc,
##   touch ~/$file, add a line that sources $DIR/$file
##   this allows eg .bashrc to use ninjarc settings without overwriting the whole user file with a symlink

input_file="$DIR/sources.rc"
while read file; do

  echo "sourcing $DIR/$file in ~/$file"
  touch $HOME/$file
  
  ## TODO check if "source" line exists and skip if present
  ## reference FZF installer for method
  echo -e "source $DIR/$file" >> ~/$file

done < $input_file

## ---- INSTALL SYSTEM UTILITIES ----

## TODO make these git submodules

## -- install fzf
print-h "installing fuzzyfinder fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd ~/.fzf; git pull
~/.fzf/install --key-bindings --completion --no-update-rc
echo "use <c-t>, <c-r>, <alt-c> to fuzzy find in shell"

## -- install bashmarks
print-h "installing bashmarks..."
git clone git://github.com/turnspike/bashmarks.git ~/.bashmarks
cd ~/.bashmarks; git pull
make install

## -- install enhancd
print-h "installing enhancd..."
git clone https://github.com/b4b4r07/enhancd ~/.enhancd
cd ~/.enhancd; git pull

## -- install git tab completion
## TODO install under ~/.config
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

## -- install vim plugins
vim +PlugInstall +qall

## ---- MACOS ----
if [[ "$(uname)" = "Darwin" ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew install hh
fi

## ---- FINALIZE ----

## reload bash
print-h "restarting bash..."
exec bash

echo "done."
