# ~/.xsession

. ~/.environment

# go to home directory
cd

# locale
set input-meta on
set output-meta on
set convert-meta off

# fonts and other
xset +fp $HOME/.fonts/misc/
xset +fp $HOME/.fonts/artwiz-aleczapka-se-1.3/
xset +fp $HOME/.fonts/proggyfonts.com/
xset fp rehash
xset b off         # no bell
xset m 3           # mouse buttons
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

setxkbmap -option ctrl:nocaps

# Load XTerm character class (for cutting/pasting)
# Contents of ${HOME}/.Xdefaults is as follows:
#   XTerm*charClass: 33:48,37:48,45-47:48,64:48
#xrdb -load ${HOME}/.Xdefaults

#######################################
# Start applications
#######################################
emacs --daemon &

gnome-keyring-daemon
if [ "`hostname`" == "castro" ]; then
    gnome-power-manager
fi

## Window Manager
WM="/usr/bin/xmonad"
#WM="$HOME/src/stumpwm/stumpwm"
#WM="compiz"
#WM="gnome-session"
#WM="awesome"
#WM="wmii"
#gnome-wm --sm-client-id default0 &  wmpid=$!
#gnome-panel --sm-client-id default1 &
#nautilus --no-default-window --sm-client-id default2 &

$WM & wmpid=$!

## Applications

unclutter -idle 4 -jitter 10 -root &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --tint 0x191970 --height 12 &
nm-applet &
pidgin &
skype &
ekiga &
#liferea --mainwindow-state=hidden &

gnome-power-manager

#boinc_client --attach_project setiathome.berkeley.edu 8f67d2858a1d59f59382538211bb086a >/dev/null &
cd

# background properties
xsetroot -solid black #-cursor_name left_ptr
hsetroot -fill $HOME/.backgrounds/hs-1999-25-a-full_jpg.jpg

# HANG POINT - wait for window manager to exit
wait $wmpid
