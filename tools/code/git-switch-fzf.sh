#!/usr/bin/env bash

git $@ | fzf | xargs git switch
