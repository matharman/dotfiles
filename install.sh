#!/usr/bin/env bash

# Install node for CoC if not on Arch
#curl -sL install-node.now.sh | sudo sh

# Make dirs that should not be a stow-owned symlink
mkdir -p ~/.vim
mkdir -p ~/.config/nvim/.swap
mkdir -p ~/.config/i3

for pkg in */; do
    echo "Installing $pkg..."
    stow $pkg
done

# Concatenate the i3 config
$HOME/scripts/i3_conf_gen.sh

# Setup symlinks for vanilla vim
ln -s ~/.config/nvim/init.vim ~/.vim/vimrc
ln -s ~/.config/nvim/.swap ~/.vim/.swap
