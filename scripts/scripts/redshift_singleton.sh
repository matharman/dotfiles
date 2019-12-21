#!/usr/bin/env bash

killall -q redshift
while pgrep -u $UID redshift > /dev/null; do sleep 0.5; done

redshift -c ~/.config/redshift/redshift.conf &
