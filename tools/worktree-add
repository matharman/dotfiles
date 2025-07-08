#!/usr/bin/env bash

set -e -o pipefail

# Get the list of worktree paths before adding
before_worktrees=$(git worktree list --porcelain | grep worktree | cut -d' ' -f2)

# Create a git worktree
git worktree add "$@"

# Get the list of worktree paths after adding
after_worktrees=$(git worktree list --porcelain | grep worktree | cut -d' ' -f2)

# Find the new worktree path
new_worktree_path=$(comm -13 <(echo "$before_worktrees" | sort) <(echo "$after_worktrees" | sort))

if [ -d "$new_worktree_path" ]; then
    git -C "$new_worktree_path" submodule update --init --recursive
fi

# Initialize a jj repo in the new worktree
if command -v jj >/dev/null; then
    pushd "$new_worktree_path" >> /dev/null
    jj git init --git-repo . .
    popd >> /dev/null
fi

# Our worktree directory pattern is
# /path/to/project
# |---- (optional) cross-compile.lua: project local clangd cross comp settings
# |---- root: tracks trunk or one-off, short changes
# |---- others: all other worktrees
#
# When we detect that directory structure and the lua file exists, symlink it to the new worktree.
parent_dir="$(dirname "$new_worktree_path")"
if [ -d "$parent_dir/root" ]; then
    lua_file=$(find "$parent_dir" -maxdepth 1 -type f -name '*.lua' | head -n 1)
    if [ -n "$lua_file" ]; then
        ln -sf "$lua_file" "$new_worktree_path/.nvim.lua"
    fi
fi
