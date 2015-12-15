#!/bin/bash

xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
[[ -f ~/.Xresources  ]] && xrdb -merge ~/.Xresources

# autostart window manager depending on tty
wmname "LG3D"
if [[ $(tty) = /dev/tty1 ]]; then
    sh ~/.config/autostart/autostart.sh &
    exec ~/bin/monsterwm
elif [[ $(tty) = /dev/tty2 ]]; then
    exec openbox-session
elif [[ $(tty) = /dev/tty3 ]]; then
    exec ~/code/golang/bin/wingo
fi
