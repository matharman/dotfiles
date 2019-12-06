#!/usr/bin/env bash

I3_CONF_DIR="$HOME/.config/i3"

if [ ! -d $I3_CONF_DIR ]; then
    echo "i3 config directory does not exist!"
    exit 1
fi

cd $I3_CONF_DIR

# Erase or create the initial config file
echo "" > config

for conf in conf.d/*; do
    cat $conf >> config
done
