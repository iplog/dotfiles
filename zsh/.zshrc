# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="perso"

# Example aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"

# Path modifications (has to be before the plugins because of the ASDF plugin)
# node
export PATH=~/node_modules/.bin:$PATH

# personal scripts
export PATH=~/local/bin:$PATH

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew heroku colorize node npm themes macos vi-mode tmux docker asdf)

source $ZSH/oh-my-zsh.sh

## Vi mode tweaks
export EDITOR=$(which vim)

# https://github.com/vodik/dotfiles/blob/5d4b2f7e1efe36d3dd2d73540f2ea2f08033f5b0/shell/zsh/bindkeys.zsh#L16
# bindkey -v # Use vi-mode omzsh plugin :)

# shift-tab
if [[ -n $terminfo[kcbt] ]]; then
  bindkey "$terminfo[kcbt]" reverse-menu-complete
fi

# delete
if [[ -n $terminfo[kdch1] ]]; then
  bindkey          "$terminfo[kdch1]" delete-char
  bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
fi

# Load all existing env files in .env
files=( $(find -f ~/.env/*.zsh) )
for file in $files; do;
  source $file
done
