#!/bin/bash

. ~/.environment

# go to home directory
cd

# Fix DGA Mouse Support that conflicts with SDL
# see https://bugs.launchpad.net/ubuntu/+source/unclutter/+bug/61105
export SDL_VIDEO_X11_DGAMOUSE="0"

# locale
# set input-meta on
# set output-meta on
# set convert-meta off

# use dvorak
setxkbmap se_sv_dvorak
setxkbmap -option ctrl:nocaps

# move xsession errors out of the way
mv ~/.xsession-errors.1 ~/.xsession-errors.2
mv ~/.xsession-errors ~/.xsession-errors.1

# fonts and other
# [ -d /usr/share/fonts/type1/mathematica   ] && xset +fp /usr/share/fonts/type1/mathematica/
[ -d $HOME/.fonts/misc                    ] && xset +fp $HOME/.fonts/misc/
[ -d $HOME/.fonts/artwiz-aleczapka-se-1.3 ] && xset +fp $HOME/.fonts/artwiz-aleczapka-se-1.3/
[ -d $HOME/.fonts/proggyfonts.com         ] && xset +fp $HOME/.fonts/proggyfonts.com/
xset fp rehash

# misc settings
xset b off         # no bell
xset m 2 2         # mouse sensitivity
xset r rate 300 40 # keybord repeat rate
#xgamma -gamma 1.1

# merge in defaults and keymaps
USERRESOURCES=$HOME/.Xresources
USERMODMAP=$HOME/.Xmodmap

if [ -f $USERRESOURCES ]; then
    xrdb -merge $USERRESOURCES
fi
if [ -f $USERMODMAP ]; then
    xmodmap -quiet $USERMODMAP
fi

#######################################
# Start applications
gnome-keyring-daemon

## Window Manager
if [ $1 == "gnome" ]; then
    WM="gnome-session"
else
    WM="/usr/bin/xmonad"
    emacs &
fi

#WM="$HOME/src/stumpwm/stumpwm"
$WM & wmpid=$!

## Applications
#unclutter -idle 1 -jitter 10 -root &
xscreensaver -no-splash &

if [ "`hostname`" == "kollontaj" ]; then
    nm-applet &
    gnome-power-manager &
elif [ "`hostname`" == "huey" ]; then
    mpd &
fi

# set cursor
xsetroot -cursor_name left_ptr

# set background
if [ -x ~/bin/wallpaper.sh ]; then
    ~/bin/wallpaper.sh
fi

# HANG POINT - wait for window manager to exit
wait $wmpid
