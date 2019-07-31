#!/bin/bash

echo @@@ .xsession

. ~/.environment

cd $HOME

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
[ -e ~/.xsession-errors.2 ] && mv ~/.xsession-errors.2 ~/.xsession-errors.3
[ -e ~/.xsession-errors.1 ] && mv ~/.xsession-errors.1 ~/.xsession-errors.2
[ -e ~/.xsession-errors ] && mv ~/.xsession-errors ~/.xsession-errors.1

# fonts
# [ -d /usr/share/fonts/type1/mathematica   ] && xset +fp /usr/share/fonts/type1/mathematica/
[ -d $HOME/.fonts/misc                    ] && xset +fp $HOME/.fonts/misc/
[ -d $HOME/.fonts/artwiz-aleczapka-se-1.3 ] && xset +fp $HOME/.fonts/artwiz-aleczapka-se-1.3/
[ -d $HOME/.fonts/proggyfonts.com         ] && xset +fp $HOME/.fonts/proggyfonts.com/
xset fp rehash

# misc settings
xset b off         # no bell
xset m 2 2         # mouse sensitivity
xset r rate 200 50 # keybord repeat rate
#xgamma -gamma 1.1

# set cursor
xsetroot -cursor_name left_ptr

# merge in defaults and keymaps
USERRESOURCES=$HOME/.Xresources
USERMODMAP=$HOME/.Xmodmap

if [ -f $USERRESOURCES ]; then
    xrdb -merge $USERRESOURCES
fi
if [ -f $USERMODMAP ]; then
    xmodmap -quiet $USERMODMAP
fi

# unclutter
if ! pgrep unclutter > /dev/null; then
        unclutter -idle 3 -jitter 10 -root -noevents &
fi

# xscreensaver
xscreensaver -no-splash &

#~/.xinitrc.run $1

#exec /usr/bin/ck-launch-session /usr/bin/dbus-launch ~/.xinitrc.run $1

echo @@@ .xinitrc.run

# Start X applications

if ! pgrep gnome-keyring-daemon > /dev/null ; then
    export $(gnome-keyring-daemon --start --daemonize --components=gpg,pkcs11,secrets,ssh)
fi

## Window Manager
if [ "$1" == "gnome" ]; then
    WM="gnome-session"
else
    WM="/usr/bin/xmonad"
    emacs &
fi

#WM="$HOME/src/stumpwm/stumpwm"
$WM & wmpid=$!

if [ "`hostname`" == "kollontaj" ]; then
    nm-applet &
    gnome-power-manager &
elif [ "`hostname`" == "joffe" ]; then
    mpd &
    mpdscribble &
    # dropbox start &
    # sudo mount -o uid=skangas /dev/sdc2 /mnt/usb
fi

# set background
if [ -x ~/bin/wallpaper.sh ]; then
    ~/bin/wallpaper.sh
fi

# HANG POINT - wait for window manager to exit
wait $wmpid
