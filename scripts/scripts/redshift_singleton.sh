#!/usr/bin/env bash

killall -q redshift
while pgrep -u $UID redshift > /dev/null; do sleep 0.5; done

redshift -l 34:-85 -t 6500k:3500k -b 0.85:0.75 &
