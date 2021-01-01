# vim key binding
# set -o vi

# brew
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH

# git (brew isntallation)
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/git-prompt.sh

# git prompt
export GIT_PS1_SHOWDIRTYSTATE=1 \
  GIT_PS1_SHOWSTASHSTATE=1 \
  GIT_PS1_SHOWUNTRACKEDFILES=1 &&
export PS1='\[\033[1;35m\]\u@\[\033[1;34m\]\h:\[\033[1;36m\]\w\[\033[0;33m\]$(__git_ps1 " (%s)")\[\033[0;0m\]\n\$ '

# Customize to your needs...
# node
export PATH=~/node_modules/.bin:$PATH
export PATH=~/local/bin:$PATH

# Load all existing env files in .env
files=( $(find -f ~/.env/*.bash 2>/dev/null) )
for file in $files; do
  source $file
done
