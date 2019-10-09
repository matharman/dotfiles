#!/bin/sh

for pkg in */; do
    echo "Installing $pkg..."
    stow $pkg
done
