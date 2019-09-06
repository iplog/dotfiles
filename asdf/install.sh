#! /usr/bin/env bash

# The 2 lines below are not necessary as they have already been saved to the
# `zsh/zshrc` file.
# echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
# echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

asdf plugin-add erlang
asdf plugin-add elixir
asdf plugin-add nodejs
asdf plugin-add golang
asdf plugin-add python
asdf plugin-add ruby

# Install the nodejs OpenPGP keys to main key ring
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

while true; do
  read -p "Erlang version to install: " erlangVersion
  read -p "Elixir version to install: " elixirVersion
  read -p "Node version to install: " nodejsVersion
  read -p "Go version to install: " golangVersion
  read -p "Python2 version to install: " python2Version
  read -p "Python3 version to install: " python3Version
done

# Install Erlang
asdf install erlang ${erlangVersion}
asdf global erlang ${erlangVersion}
echo "Installed Erlang ${erlangVersion} and defined as global version."

# Install Elixir
asdf install elixir ${elixirVersion}
asdf global elixir ${elixirVersion}
echo "Installed Elixir ${elixirVersion} and defined as global version."

# Install NodeJs
asdf install nodejs ${nodejsVersion}
asdf global nodejs ${nodejsVersion}
echo "Installed Nodejs ${nodejsVersion} and defined as global version."

# Install Golang
asdf install golang ${golangVersion}
asdf global golang ${golangVersion}
echo "Installed Golang ${golangVersion} and defined as global version."

# Install Python 2
asdf install python ${python2Version}
asdf global python ${python2Version}
echo "Installed Python2 ${pythonVersion} and defined as global version."

# Install Python 3
asdf install python ${python3Version}
echo "Installed Python3 ${pythonVersion}."
