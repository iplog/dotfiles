#!/bin/bash

# run with bash -> the path may be differetn than the one you have in zshrc if you are using zsh
echo "\nStart vim installation"
if [ -r ~/.vim ] && [ ! -r ~/.vim.orig ]; then
  mv ~/.vim ~/.vim.orig
fi

# install vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

# Add some folders for swap, bakcup and undo files
mkdir -p ~/.vim/tmp/{backup,swap,undo}

# install all vundle bundles
vim +NeoBundleInstall +qall

# Get current working directory
CWD=$(pwd)

# ctrlp: create some folders (avoid problem with folder created as root)
if [ ! -r ~/.cache ]; then
  mkdir ~/.cache
fi
if [ ! -r ~/.cache/ctrlp ]; then
  mkdir ~/.cache/unite
fi

# powerline
if [ ! -r ~/.config ]; then
  mkdir ~/.config
fi
if [ -r ~/.config/powerline ]; then
  mv ~/.config/powerline ~/.config/powerline.orig
fi

mkdir ~/.config/powerline
cp -R ~/.vim/bundle/powerline/powerline/config_files/* ~/.config/powerline

mv ~/.config/powerline/config.json ~/.config/powerline/config.json.orig
ln -s ${CWD}/vim/powerline/config.json ~/.config/powerline/config.json

mv ~/.config/powerline/themes/vim/default.json ~/.config/powerline/themes/vim/default.json.orig
ln -s ${CWD}/vim/powerline/themes/vim/default.json ~/.config/powerline/themes/vim/default.json

mv ~/.config/powerline/themes/powerline.json ~/.config/powerline/themes/powerline.json.orig
ln -s ${CWD}/vim/powerline/themes/powerline.json ~/.config/powerline/themes/powerline.json

echo "Powerline: installed. config files in ~/.config/powerline\n"

# syntasctic: just a Warning
echo "Syntasctic: Do not forget to install syntax checkers\n"

echo " Vim instaillation: Done!"
