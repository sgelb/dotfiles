#!/bin/sh
# autostart window manager depending on tty

if [[ $(tty) = /dev/tty1 ]]; then
    sh ~/.config/autostart/autostart.sh &
    exec ~/bin/monsterwm
elif [[ $(tty) = /dev/tty2 ]]; then
    exec openbox-session
elif [[ $(tty) = /dev/tty3 ]]; then
    exec awesome
fi
