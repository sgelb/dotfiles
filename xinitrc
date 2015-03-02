#!/bin/bash

xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
[[ -f ~/.Xresources  ]] && xrdb -merge ~/.Xresources

# autostart window manager depending on tty
if [[ $(tty) = /dev/tty1 ]]; then
    wmname "LG3D"
    sh ~/.config/autostart/autostart.sh &
    exec ~/bin/monsterwm
elif [[ $(tty) = /dev/tty2 ]]; then
    exec openbox-session
fi
