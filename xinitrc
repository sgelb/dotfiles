#!/bin/bash

[[ -f ~/.Xresources  ]] && xrdb -merge ~/.Xresources

setxkbmap -option caps:escape
xbindkeys

# autostart window manager depending on tty
if [[ $(tty) = /dev/tty1 ]]; then
  exec ~/code/golang/bin/wingo
elif [[ $(tty) = /dev/tty2 ]]; then
  exec openbox-session
elif [[ $(tty) = /dev/tty3 ]]; then
  wmname "LG3D"
  sh ~/.config/autostart/autostart.sh &
  exec ~/bin/monsterwm
fi
