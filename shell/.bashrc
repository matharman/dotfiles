# History
export HISTIGNORE=clear:ls
export HISTCONTROL=ignorespace:erasedups
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTFILE=$HOME/.config/bash_history

# XDG Utilities
export MANPAGER="vim -M +MANPAGER -"
export EDITOR=vim
export BROWSER=firefox

# FZF environment
export FZF_DEFAULT_COMMAND='rg --ignore-case --no-ignore-vcs --hidden --files'
export FZF_DEFAULT_OPTS='--layout=reverse'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Golang environment
export GOROOT=/usr/local/go
export GOPATH=$HOME/dev/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# C environment
export CC=/usr/bin/clang

# Enable quick project switching
CDPATH=".:$HOME/Dev:$HOME:$HOME/.config/"

# Coloration & Format for prompt
RGB_ESC='\[\033[00m\]'
RGB_SHELL='\[\033[38;2;75;80;86m\]'
RGB_USERNAME='\[\033[38;2;82;124;119m\]'
RGB_DIR='\[\033[38;2;102;137;157m\]'

PS1="${RGB_SHELL}╭─[ ${RGB_ESC}\
${RGB_USERNAME}\u${RGB_ESC} in \
${RGB_DIR}\w${RGB_ESC}\
${RGB_SHELL} ]\n╰─>${RGB_ESC} "

[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion
