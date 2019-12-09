#!/usr/bin/env bash

autorandr --load default
exec /usr/bin/i3 >> /dev/null
