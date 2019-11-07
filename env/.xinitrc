#!/bin/sh

#compton -b               # Compositor
start-pulseaudio-x11     # Better pulse

MONITORS=`xrandr -q | grep -e " connected" | awk '{ print $1 }'`
N_MONITORS=`wc -w <<< $MONITORS`

case $N_MONITORS in
    3)
        xrandr --output HDMI1 --auto
        xrandr --output DP1 --left-of HDMI1 --primary
        ;;
    *)
        ;;
esac

xrdb -merge -I$HOME ~/.Xresources
#exec /usr/bin/i3 >> /dev/null
