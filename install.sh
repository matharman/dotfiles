#!/bin/sh

# Install node for CoC if not on Arch
#curl -sL install-node.now.sh | sudo sh

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
mkdir -p ~/.vim/.swap

for pkg in */; do
    echo "Installing $pkg..."
    stow $pkg
done
