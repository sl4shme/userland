#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#
# User Aliases
#

if [[ -f "$HOME/.zalias" ]]; then
    source $HOME/.zalias
fi


#
# Gpg agent start
#

if [[ -d "$HOME/.gnupg" ]] && [[ -f "$HOME/.ssh/id_rsa" ]]; then
    if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
       gpg-agent --daemon --quiet
    fi
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
fi

