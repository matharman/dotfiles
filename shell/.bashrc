[ -f ~/.functions ] && source ~/.functions
safe_source ~/.aliases
safe_source ~/.bash_local

# History
export HISTIGNORE=clear:ls
export HISTCONTROL=ignorespace:erasedups
export HISTFILESIZE=10000
export HISTSIZE=60000
export HISTFILE=$HOME/.config/bash_history

# Bash Vi-mode
set -o vi

# XDG Utilities
export EDITOR=nvim
export BROWSER=firefox

# FZF environment
export FZF_DEFAULT_COMMAND='rg --ignore-case --no-ignore-vcs --hidden --files'
export FZF_DEFAULT_OPTS='--layout=reverse'
safe_source ~/.fzf.bash

# Coloration & Format for prompt
RGB_ESC='\[\033[00m\]'
RGB_SHELL='\[\033[38;2;75;80;86m\]'
RGB_USERNAME='\[\033[38;2;82;124;119m\]'
RGB_DIR='\[\033[38;2;102;137;157m\]'

PS1="${RGB_SHELL}╭─[ ${RGB_ESC}\
${RGB_USERNAME}\u${RGB_ESC} in \
${RGB_DIR}\w${RGB_ESC}\
${RGB_SHELL} ]\n╰─>${RGB_ESC} "
