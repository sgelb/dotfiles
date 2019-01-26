#!/bin/bash

function start_once () {
  PROGRAM="$1"
  pgrep "$PROGRAM" &> /dev/null || $PROGRAM &> /dev/null &
}

setxkbmap -option caps:escape
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)"
export SSH_AUTH_SOCK

xrandr --dpi 120
~/bin/display-hotplug.sh

start_once xbindkeys
start_once dunst
start_once udiskie
start_once redshift

# autostart window manager depending on tty
if [[ $(tty) = /dev/tty1 ]]; then
  compton -CGb
  # hsetroot -solid "#000000" /home/grml/images/demolition/main_1506.png
  hsetroot -fill /home/grml/images/demolition/main_1506.png
  exec spectrwm
elif [[ $(tty) = /dev/tty2 ]]; then
  xsetroot -cursor_name left_ptr
  exec ~/code/golang/bin/wingo
elif [[ $(tty) = /dev/tty3 ]]; then
  exec openbox-session
fi
