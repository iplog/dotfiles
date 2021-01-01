#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset
# Exit script if a statement returns a non-true return value.
set -o errexit
# Use the error status of the first failure, rather than that of the last item
# in a pipeline.
set -o pipefail

CWD=$(pwd)
TARGET_PATH="$HOME"

prompt_confirm() {
  while true; do
    read -r -p "Are you sure? [y/N] " input

    case $input in
    [Yy][Ee][Ss] | [Yy]) # Yes or Y (case-insensitive).
      return 0
      break
      ;;
    [Nn][Oo] | [Nn]) # No or N.
      return 1
      break
      ;;
    *) ;;

    esac
  done
}

install_brew() {
  echo "Installing Homebrew..."

  if [ "$(command -v brew)" ]; then
    echo "Already installed"
    return 0
  fi

  prompt_confirm

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  brew update
}

install_stow() {
  if [ ! "$(command -v brew)" ]; then
    install_brew
  fi

  if ! brew list --formula | grep -q stow; then
    echo "Installing Stow..."
    brew update
    brew install stow
  fi
}

install_symlinks() {
  DIR_NAME=${1}
  # We need GNU Stow
  install_stow

  echo "Linking to $TARGET_PATH directory"
  stow -nvRt "$TARGET_PATH" "$DIR_NAME"

  if prompt_confirm; then
    stow -vRt "$TARGET_PATH" "$DIR_NAME"
  fi
}

install_bash() {
  echo "Installing bash..."
  prompt_confirm

  if ! brew list --formula | grep -q bash; then
    brew install bash
    sudo sh -c 'echo "$(brew --prefix)/bin/bash" >> /etc/shells'
  fi

  install_symlinks bash
}

install_zsh() {
  echo "Installing ZSH..."
  prompt_confirm

  install_brew

  if ! brew list --formula | grep -q zsh; then
    brew install zsh
    sudo sh -c 'echo "$(brew --prefix)/bin/zsh" >> /etc/shells'
  fi

  # install oh-my-zsh
  if [ ! -r "$TARGET_PATH/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  # Create custom env folder for zsh
  while true; do
    read -rp "Work Environment (e.g. home): " WORK_ENV
    echo -e "Thanks!\n"
    echo -e "Work Environment: $WORK_ENV"
    read -rp "Are the details ok? y/n " yn
      case $yn in
        [Yy]* ) break;;
        [Nn]* ) ;;
        * ) echo "Please answer yes or no.";;
      esac
  done

  install_symlinks oh-my-zsh

  mkdir -p "$TARGET_PATH/.env"
  touch "$TARGET_PATH/.env/$WORK_ENV.zsh"
  echo "$TARGET_PATH/.env/$WORK_ENV.zsh has been created"

  install_symlinks zsh

  echo "Make ZSH the main shell?"
  prompt_confirm

  chsh -s /usr/local/bin/zsh
}

install_ssh() {
  echo "Installing SSH config..."
  prompt_confirm

  install_symlinks ssh
}

install_local_bin() {
  echo "Installing local bin..."
  prompt_confirm

  install_symlinks local-bin
}

install_ctags() {
  echo "Installing ctags..."
  prompt_confirm

  install_brew

  if ! brew list --formula | grep -q universal-ctags; then
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags
  fi

  # Install some ctags dependencies
  if [ ! -d ctags/deps/ctags-patterns-for-javascript ]; then
    git clone https://github.com/agorf/ctags-patterns-for-javascript ctags/deps/ctags-patterns-for-javascript
  fi

  mkdir -p ctags/.ctags.d
  sed -e "s#{{cwd}}#${CWD}#" ctags/main.ctags.tmpl > ctags/.ctags.d/main.ctags

  install_symlinks ctags
}

install_git() {
  echo "Installing GIT..."
  prompt_confirm

  install_brew

  echo "Creating final git config"
  while true; do
    read -rp "First name (git): " FIRST_NAME
    read -rp "Last name (git): " LAST_NAME
    read -rp "Email (git): " EMAIL
    echo -e "Thanks!\n"
    echo -e "First name: $FIRST_NAME"
    echo -e "Last name: $LAST_NAME"
    echo -e "Email: $EMAIL"
    read -rp "Are the details ok? y/n " yn
      case $yn in
        [Yy]* ) break;;
        [Nn]* ) ;;
        * ) echo "Please answer yes or no.";;
      esac
  done

  # Create git conf file
  sed -e "s/{{firstName}}/$FIRST_NAME/" \
    -e "s/{{lastName}}/$LAST_NAME/" \
    -e "s/{{email}}/$EMAIL/" git/gitconfig.tmpl > git/.gitconfig

  install_symlinks git
}

install_vim() {
  echo "Installing Vim..."
  prompt_confirm

  install_brew

  if ! brew list --formula | grep -q vim; then
    brew install vim
  fi

  # Install Plug
  if [ ! -f "$TARGET_PATH/.vim/autoload/plug.vim" ]; then
    curl -fLo "$TARGET_PATH/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  # Add some folders for swap, bakcup and undo files
  mkdir -p ~/.vim/tmp/backup
  mkdir -p ~/.vim/tmp/swap
  mkdir -p ~/.vim/tmp/undo

  # install all plugins
  vim +'silent! PlugInstall' +qall

  install_symlinks vim
}

install_dev_tools() {
  echo "Installing Dev Tools..."
  prompt_confirm

  brew update
  brew bundle install
  brew cleanup
}

install_ripgrep() {
  echo "Installing RipGrep..."
  prompt_confirm

  install_brew

  if ! brew list --formula | grep -q ripgrep; then
    brew install ripgrep
  fi

  mkdir -p "$TARGET_PATH/.env"

  touch "$TARGET_PATH/.env/tools_ripgrep.zsh"
  echo -e "export RIPGREP_CONFIG_PATH=\"$HOME/.ripgreprc\"" > "$TARGET_PATH/.env/tools_ripgrep.zsh"

  touch "$TARGET_PATH/.env/tools_ripgrep.bash"
  echo -e "export RIPGREP_CONFIG_PATH=\"$HOME/.ripgreprc\"" > "$TARGET_PATH/.env/tools_ripgrep.bash"

  install_symlinks ripgrep
}

install_fzf() {
  echo "Installing FZF..."
  prompt_confirm

  install_brew

  if ! brew list --formula | grep -q fzf; then
    brew install fzf
  fi

  mkdir -p "$TARGET_PATH/.env"

  touch "$TARGET_PATH/.env/tools_fzf.zsh"
  echo -e "export FZF_DEFAULT_COMMAND=\"rg --files --follow --hidden --glob '!.git/*'\"" > "$TARGET_PATH/.env/tools_fzf.zsh"
  # shellcheck disable=SC2016
  echo -e 'export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"' >> "$TARGET_PATH/.env/tools_fzf.zsh"

  touch "$TARGET_PATH/.env/tools_fzf.bash"
  echo -e "export FZF_DEFAULT_COMMAND=\"rg --files --follow --hidden --glob '!.git/*'\"" > "$TARGET_PATH/.env/tools_fzf.bash"
  # shellcheck disable=SC2016
  echo -e 'export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"' >> "$TARGET_PATH/.env/tools_fzf.bash"
}

install_asdf() {
  echo "Installing ASDF..."
  prompt_confirm

  install_brew

  if ! brew list --formula | grep -q asdf; then
    brew install asdf
  fi

  mkdir -p "$TARGET_PATH/.env"

  touch "$TARGET_PATH/.env/tools_asdf.zsh"
  echo -e ". $(brew --prefix asdf)/asdf.sh" > "$TARGET_PATH/.env/tools_asdf.zsh"
  echo -e ". $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >> "$TARGET_PATH/.env/tools_asdf.zsh"

  touch "$TARGET_PATH/.env/tools_asdf.bash"
  echo -e ". $(brew --prefix asdf)/asdf.sh" > "$TARGET_PATH/.env/tools_asdf.bash"
  echo -e ". $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash" >> "$TARGET_PATH/.env/tools_asdf.bash"

  # Load asdf
  # shellcheck disable=SC1090,SC1091
  . "$(brew --prefix asdf)/asdf.sh"

  asdf plugin-add erlang
  asdf plugin-add elixir
  asdf plugin-add nodejs
  asdf plugin-add golang
  asdf plugin-add python
  asdf plugin-add ruby

  # Install the nodejs OpenPGP keys to main key ring
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

  while true; do
    read -rp "Erlang version to install: " erlangVersion
    read -rp "Elixir version to install: " elixirVersion
    read -rp "Node version to install: " nodejsVersion
    read -rp "Go version to install: " golangVersion
    read -rp "Python2 version to install: " python2Version
    read -rp "Python3 version to install: " python3Version

    read -rp "Are the details ok? y/n " yn
      case $yn in
        [Yy]* ) break;;
        [Nn]* ) ;;
        * ) echo "Please answer yes or no.";;
      esac
  done

  # Install Erlang
  asdf install erlang "$erlangVersion"
  asdf global erlang "$erlangVersion"
  echo "Installed Erlang $erlangVersion and defined as global version."

  # Install Elixir
  asdf install elixir "$elixirVersion"
  asdf global elixir "$elixirVersion"
  echo "Installed Elixir $elixirVersion and defined as global version."

  # Install NodeJs
  asdf install nodejs "$nodejsVersion"
  asdf global nodejs "$nodejsVersion"
  echo "Installed Nodejs $nodejsVersion and defined as global version."

  # Install Golang
  asdf install golang "$golangVersion"
  asdf global golang "$golangVersion"
  echo "Installed Golang $golangVersion and defined as global version."

  # Install Python 2 and 3
  asdf install python "$python2Version"
  echo "Installed Python2 $python2Version and defined as global version."
  asdf install python "$python3Version"
  echo "Installed Python3 $python2Version."
  asdf global python "$python2Version" "$python3Version"

  install_symlinks asdf
}

install_tmux() {
  echo "Installing Tmux..."
  prompt_confirm

  install_brew

  if ! brew list --formula | grep -q tmux; then
    brew install tmux
  fi

  install_symlinks tmux
}

install_alacritty() {
  echo "Installing Alacritty..."
  prompt_confirm

  install_brew

  if ! brew list --cask | grep -q alacritty; then
    brew install alacritty
  fi

  install_symlinks alacritty
}

refresh_system() {
  vim +PlugUpdate +qall

  brew update
  brew upgrade
  brew upgrade --cask
  brew cleanup
}

install_initials() {
  install_brew
  install_dev_tools

  # Specific individual installations
  install_bash
  install_zsh
  install_local_bin
  install_ssh
  install_git
  install_ctags
  install_ripgrep
  install_fzf
  install_vim
  install_tmux
  install_asdf
  install_alacritty

  echo "🍺  Installation: Done!"
}

show_help() {
  echo 'usage: ./install.sh [command] -- Dotfiles installation'
  echo 'COMMANDS:'
  echo '          init: Initial setup on a new machine, installs everything needed'
  echo '          brew: Install Homebrew'
  echo '     dev_tools: Install dev tools (curl, git, rg, htop...)'
  echo '      gui_apps: Install dev tools (alacritty, docker, ...)'
  echo '          bash: Install bash and bash profile'
  echo '           zsh: Install zsh and zshrc'
  echo '           ssh: Install openssh and ssh config'
  echo '           git: Install git and gitconfig'
  echo '         ctags: Install ctags and ctags config'
  echo '       ripgrep: Install ripgrep and ripgrepconfig'
  echo '           fzf: Install fzf and fzf config'
  echo '          tmux: Install tmux and tmux.conf'
  echo '          asdf: Install asdf and asdf config'
  echo '     alacritty: Install alacritty and alacritty config'
  echo '           vim: Install vim and vim config '
  echo 'refresh_system: Upgrade all packages, gui_app and vim plugs'
  exit 1
}


# Process arguments
if [ "$#" -lt 1 ]; then
  cmds=( "help" )
else
  cmds=( "$@" )
fi

for cmd in "${cmds[@]}"; do
  case "$cmd" in
    init)
      install_initials
      ;;
    homebrew | brew)
      install_brew
      ;;
    bash)
      install_bash
      ;;
    zsh)
      install_zsh
      ;;
    ssh)
      install_ssh
      ;;
    git)
      install_git
      ;;
    ctags)
      install_ctags
      ;;
    alacritty)
      install_alacritty
      ;;
    fzf)
      install_fzf
      ;;
    ripgrep)
      install_ripgrep
      ;;
    asdf)
      install_asdf
      ;;
    vim)
      install_vim
      ;;
    tmux)
      install_tmux
      ;;
    dev_tools)
      install_dev_tools
      ;;
    local_bin)
      install_local_bin
      ;;
    refresh_system)
      refresh_system
      ;;
    *)
      show_help
      ;;
  esac
done
