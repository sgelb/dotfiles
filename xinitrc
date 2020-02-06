#!/bin/bash

function start_once () {
  PROGRAM="$1"
  pgrep "$PROGRAM" &> /dev/null || $PROGRAM &> /dev/null &
}

setxkbmap -option caps:escape
eval "$(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets)"
export SSH_AUTH_SOCK

touch "${HOME}/.xdbus"
chmod 600 "${HOME}/.xdbus"
env | grep DBUS_SESSION_BUS_ADDRESS > "${HOME}/.xdbus"
echo 'export DBUS_SESSION_BUS_ADDRESS' >> "${HOME}/.xdbus"



xrandr --dpi 120
~/.local/bin/display-hotplug.sh

start_once xbindkeys
start_once dunst
start_once udiskie
start_once redshift

# autostart window manager depending on tty
if [[ $(tty) = /dev/tty1 ]]; then
  # compton -CGb
  hsetroot -solid "#000000" -center /home/grml/images/backgrounds/waves.jpg
  exec spectrwm
elif [[ $(tty) = /dev/tty2 ]]; then
  xsetroot -cursor_name left_ptr
  exec ~/code/golang/bin/wingo
elif [[ $(tty) = /dev/tty3 ]]; then
  # exec openbox-session
  export XDG_SESSION_TYPE=x11
  export GDK_BACKEND=x11
  exec gnome-session
elif [[ $(tty) = /dev/tty4 ]]; then
  # started from .zshrc as as xinitr is not loaded by wayland
  exec sway
fi
