# theme perso
# use `$ spectrum_ls` to list colors and code :)

# Machine name.
function box_name {
  [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
  # source the git-prompt script. (installed by brew with git)
  source "/usr/local/etc/bash_completion.d/git-prompt.sh"
elif [ -f ~/.git-prompt.sh ]; then
  source "~/.git-prompt.sh"
fi

# set some options to diplay nice information
export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWSTASHSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1

PROMPT="%{$terminfo[bold]$FG[005]%}%n%{$reset_color%}\
%{$terminfo[bold]$FG[013]%}@%{$reset_color%}\
%{$terminfo[bold]$FG[004]%}$(box_name)%{$reset_color%}\
%{$terminfo[bold]$FG[015]%}:%{$reset_color%} \
%{$terminfo[bold]$FG[006]%}${current_dir}%{$reset_color%}\
%{$terminfo[bold]$FG[003]%}\$(__git_ps1 ' (%s)')%{$reset_color%} \
%{$FG[008]%}[%*]%{$reset_color%}
%{$terminfo[bold]$FG[0015]%}$ %{$reset_color%}"
