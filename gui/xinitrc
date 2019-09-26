#!/bin/sh

compton &               # Compositor
udiskie &               # USB automounter
start-pulseaudio-x11    # Better pulse
redshift &              # Blue light filter

xinput disable 'pointer:ELAN Touchscreen'
xinput list | grep 'Topre'
if [ -z $? ]; then
    xinput disable 'keyboard:AT Translated Set 2 keyboard'
    xinput disable 'pointer:DELL0741:00 006CB:7E7E'
fi
xrdb -merge -I$HOME ~/.Xresources
./.fehbg

exec /usr/bin/i3 >> /dev/null
