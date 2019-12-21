[ -f ~/.functions ] && source ~/.functions

safe_source ~/.aliases
safe_source ~/.bash_local

# History
export HISTIGNORE=clear:ls
export HISTCONTROL=ignorespace:erasedups
export HISTFILESIZE=10000
export HISTSIZE=10000
export HISTFILE=$HOME/.config/bash_history

# Bash Vi-mode
set -o vi

# XDG Utilities
#export MANPAGER="nvim -M +MANPAGER -"
export EDITOR=nvim
export BROWSER=firefox

# FZF environment
export FZF_DEFAULT_COMMAND='rg --ignore-case --no-ignore-vcs --hidden --files'
export FZF_DEFAULT_OPTS='--layout=reverse'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Golang environment
export GOROOT=/usr/local/go
export GOPATH=$HOME/dev/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# Nordic environment
safe_source ~/dev/ncs/zephyr/zephyr-env.sh
export PATH=~/gnuarmemb/gcc-arm-none-eabi-7/bin:$PATH

# Linaro GCC environment
export PATH=~/dev/m2md-repo/tools/linaro/gcc-linaro-4.9-2015.02-3-x86_64_arm-linux-gnueabi/bin:$PATH
export PATH=~/dev/m2md-repo/tools/linaro/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf/bin:$PATH

# Rust environment
safe_source ~/.cargo/env
export PATH=$PATH:~/.cargo/bin

# Enable quick project switching
CDPATH=".:$HOME/dev:$HOME/dev/ncs:$HOME/dev/m2md-repo:$HOME"

# Coloration & Format for prompt
RGB_ESC='\[\033[00m\]'
RGB_SHELL='\[\033[38;2;75;80;86m\]'
RGB_USERNAME='\[\033[38;2;82;124;119m\]'
RGB_DIR='\[\033[38;2;102;137;157m\]'

PS1="${RGB_SHELL}╭─[ ${RGB_ESC}\
${RGB_USERNAME}\u${RGB_ESC} in \
${RGB_DIR}\w${RGB_ESC}\
${RGB_SHELL} ]\n╰─>${RGB_ESC} "
