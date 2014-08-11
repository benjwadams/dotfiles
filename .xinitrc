#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

setxkbmap -option compose:menu

if [ -s ~/.Xmodmap ]; then
   xmodmap ~/.Xmodmap
fi

if  [ -s ~/.Xresources ]; then
   xrdb -merge ~/.Xresources
fi
if  [ -s ~/.fehbg ]; then . ~/.fehbg; fi

xbindkeys
# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice



exec xmonad 
