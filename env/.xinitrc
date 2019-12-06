#!/usr/bin/env bash

autorandr --load default
source ~/.bash_local
exec /usr/bin/i3 >> /dev/null
