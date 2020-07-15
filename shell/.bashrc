[ -f ~/.functions ] && source ~/.functions
safe_source ~/.aliases
safe_source ~/.bash_local

# History
export HISTIGNORE=clear:ls
export HISTCONTROL=ignorespace:erasedups
export HISTFILESIZE=75000
export HISTSIZE=50000
export HISTFILE=$HOME/.config/bash_history

# Bash Vi-mode
set -o vi

# XDG Utilities
export EDITOR=nvim
export BROWSER=firefox

# FZF environment
export FZF_DEFAULT_COMMAND='rg --ignore-case --no-ignore-vcs --hidden --files'
export FZF_DEFAULT_OPTS='--layout=reverse'

eval "$(starship init bash)"
