# ~/.xsession

. ~/.environment

# go to home directory
cd

# Fix DGA Mouse Support that conflicts with SDL
# see https://bugs.launchpad.net/ubuntu/+source/unclutter/+bug/61105
export SDL_VIDEO_X11_DGAMOUSE="0"

# locale
set input-meta on
set output-meta on
set convert-meta off

# use dvorak
setxkbmap se_sv_dvorak
setxkbmap -option ctrl:nocaps

# fonts and other
xset +fp $HOME/.fonts/misc/
xset +fp $HOME/.fonts/artwiz-aleczapka-se-1.3/
xset +fp $HOME/.fonts/proggyfonts.com/
xset fp rehash
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

# Load XTerm character class (for cutting/pasting)
# Contents of ${HOME}/.Xdefaults is as follows:
#   XTerm*charClass: 33:48,37:48,45-47:48,64:48
#xrdb -load ${HOME}/.Xdefaults

#######################################
# Start applications
#######################################
gnome-keyring-daemon

## Window Manager
WM="/usr/bin/xmonad"
#WM="$HOME/src/stumpwm/stumpwm"
$WM & wmpid=$!

## Applications
unclutter -idle 1 -jitter 10 -root &
xscreensaver -no-splash &
nm-applet &

if [ "`hostname`" == "kollontaj" ]; then
#    gnome-power-manager
    nm-applet &
fi

# set cursor
xsetroot -cursor_name left_ptr

# set background
$HOME/bin/wallpaper.sh

# HANG POINT - wait for window manager to exit
wait $wmpid

