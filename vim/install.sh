#!/bin/bash

# run with bash -> the path may be differetn than the one you have in zshrc if you are using zsh
echo "\nStart vim installation"
if [ -r ~/.vim ] && [ ! -r ~/.vim.orig ]; then
  mv ~/.vim ~/.vim.orig
fi

# install VimPlug
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Add some folders for swap, bakcup and undo files
mkdir -p ~/.vim/tmp/{backup,swap,undo}

# install all vundle bundles
vim +PlugInstall +qall

# Get current working directory
CWD=$(pwd)

# ctrlp: create some folders (avoid problem with folder created as root)
if [ ! -r ~/.cache ]; then
  mkdir ~/.cache
fi
if [ ! -r ~/.cache/ctrlp ]; then
  mkdir ~/.cache/unite
fi

# syntasctic: just a Warning
echo "Syntasctic: Do not forget to install syntax checkers\n"

echo " Vim instaillation: Done!"
