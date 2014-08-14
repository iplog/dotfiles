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
vim +BundleInstall +qall

# Specific Bundle conf and installation
CWD=$(pwd)

# tern for vim: install necessary package
if [ command -v /usr/bin/node 2>/dev/null ] || [ command -v /usr/local/bin/node 2>/dev/null ]; then
  cd ~/.vim/bundle/tern_for_vim
  npm install
  cd $CWD

  echo "Tern for vim: installed\n"
else
  echo "Node is not installed. Tern for vim installation has not been completed."
  echo "To finish the installation, install nodejs and then do:\n"
  echo "  cd ~/.vim/bundle/tern_for_vim"
  echo "  npm install\n"
fi

# ctrlp: create some folders (avoid problem with folder created as root)
if [ ! -r ~/.cache ]; then
  mkdir ~/.cache
fi
if [ ! -r ~/.cache/ctrlp ]; then
  mkdir ~/.cache/ctrlp
fi

# powerline
if [ ! -r ~/.config ]; then
  mkdir ~/.config
fi
if [ -r ~/.config/powerline ]; then
  mv ~/.config/powerline ~/.config/powerline.orig
fi
cp -R ~/.vim/bundle/powerline/powerline/config_files/* ~/.config/powerline

mv ~/.config/powerline/config.json ~/.config/powerline/config.json.orig
ln -s ${CWD}/vim/powerline/config.json ~/.config/powerline/config.json

mv ~/.config/powerline/themes/vim/default.json ~/.config/powerline/themes/vim/default.json.orig
ln -s ${CWD}/vim/powerline/themes/default.json ~/.config/powerline/themes/vim/default.json

echo "Powerline: installed. config files in ~/.config/powerline\n"

# syntasctic: just a Warning
echo "Syntasctic: Do not forget to install syntax checkers\n"

echo " Vim instaillation: Done!"
