#!/bin/bash

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

# fonts and other
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
xsetroot -cursor_name right_ptr

# merge in defaults and keymaps
USERRESOURCES=$HOME/.Xresources
USERMODMAP=$HOME/.Xmodmap

if [ -f $USERRESOURCES ]; then
    xrdb -merge $USERRESOURCES
fi
if [ -f $USERMODMAP ]; then
    xmodmap -quiet $USERMODMAP
fi

~/.xinitrc.run $1

#exec /usr/bin/ck-launch-session /usr/bin/dbus-launch ~/.xinitrc.run $1
