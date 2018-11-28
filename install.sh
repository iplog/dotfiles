#!/bin/bash

echo "Your dotfiles installation"
echo "Please enter some details: "

while true; do
  read -p "First name (git): " firstName
  read -p "Last name (git): " lastName
  read -p "Email (git): " email
  echo "Thanks!\n"
  echo "First name: ${firstName}"
  echo "Last name: ${lastName}"
  echo "Email: ${email}\n"
  read -p "Are the details ok? y/n " yn
    case $yn in
      [Yy]* ) break;;
      [Nn]* ) ;;
      * ) echo "Please answer yes or no.";;
    esac
done

# Create git conf file
sed -e s/{{firstName}}/${firstName}/ \
-e s/{{lastName}}/${lastName}/ \
-e s/{{email}}/${email}/ git/gitconfig.sample > git/gitconfig

# Install oh-my-zsh
if [ ! -r ~/.oh-my-zsh ]; then
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
fi

# List of files that need to be symlinked
declare -a confFiles=(
  git/gitconfig
  zsh/zshrc
  oh-my-zsh/perso.zsh-theme
  ssh/config
  vim/vimrc
  vim/gvimrc
  tmux/tmux.conf
  bash/bash_profile
)

# List of matching destinations
declare -a dests=(
  ~/.gitconfig
  ~/.zshrc
  ~/.oh-my-zsh/custom/perso.zsh-theme
  ~/.ssh/config
  ~/.vimrc
  ~/.gvimrc
  ~/.ackrc
  ~/.tmux.conf
  ~/.bash_profile
)

# Get current working directory
CWD=$(pwd)

# Create all the symlinks
for i in ${!confFiles[@]}; do
  confFile=${confFiles[$i]}
  dest=${dests[$i]}

  # Check for existing files and back them up
  if [ -f ${dest} ] && [ ! -f ${dest}.orig ]; then
    mv ${dest} ${dest}.orig
  elif [ -h ${dest} ]; then
    rm ${dest}
  fi

  # Create symlink
  ln -s ${CWD}/${confFile} ${dest}

  echo "${dest} installed!"
done

# Create custom env folder for zsh
mkdir ~/.env

# Install vim
sh vim/install.sh
echo "Vim has been installed"

echo "Installation: Done!"
