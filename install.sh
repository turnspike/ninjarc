#!/bin/bash

## Ninjarc install script
## Symlinks .rc files into ~
## https://github.com/turnspike/ninjarc

ESC_SEQ="\x1b["
ESC_RESET=$ESC_SEQ"39;49;00m"
ESC_GREEN=$ESC_SEQ"32;01m"

echo -e "$ESC_GREEN";
echo -e "---------------------- --   -";
echo " installing ninjarc: "
echo " super minimal .rc files for traipsing around Other People's Servers™"
echo -e "---------------------- --   -";
echo -e "$ESC_RESET";

DIR=$( cd $(dirname $0) ; pwd -P ) # get the path to the installer script
echo -e "installing from: $DIR\n"

# pass -f to force linking
FORCE=0;
while getopts f x; do
  echo "-f passed, will force overwrite existing ~/files"
  FORCE=1;
done; OPTIND=0

# loop through .files and try to symlink each line
filename="$DIR/.files"
while read file; do

  if [ ! -e $HOME/$file ] && [ ! -L $HOME/$file ]; then # file doesn't exist
    echo "linking ~/$file"
    ln -s $DIR/$file $HOME
  elif [ -e $HOME/$file ] && [ $FORCE -eq 1 ]; then # file exists and force set, overwrite
    echo "overwriting ~/$file"
    ln -fs $DIR/$file $HOME
  else # file exists, skip
    echo "~/$file exists, skipping..."
  fi

done < $filename

# reload bash
exec bash

echo "done."
