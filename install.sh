#!/bin/sh

# Install node for CoC if not on Arch
#curl -sL install-node.now.sh | sudo sh

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Make dirs that should not be a stow-owned symlink
mkdir -p ~/.vim/.swap
mkdir -p ~/.config/i3

for pkg in */; do
    echo "Installing $pkg..."
    stow $pkg
done
