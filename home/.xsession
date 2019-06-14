#!/usr/bin/env bash
exec > "$HOME/.xsession_errors" 2>&1

printf 'Starting X session on %s\n' "$(date)"

PATH="$HOME/bin:$PATH"

# Makes fonts darker and thicker
#export INFINALITY_FT_BRIGHTNESS="-10"

# Not too sharp, not too smooth
#export INFINALITY_FT_FILTER_PARAMS="16 20 28 20 16"

# Fix video tearing
#compton --backend glx --paint-on-overlay --glx-no-stencil --vsync opengl-swc --unredir-if-possible &

# Fix naughty Java applications
wmname LG3D

xrdb -load ~/.Xdefaults

eval $(keychain --agents gpg,ssh --eval --quiet --noask)

#desktopcfg netbook
desktopcfg "$(hostname)"
#{ sleep 2; python $HOME/code/snippets/dwm_bar_winny.py; } &
redshift-gtk &

pulseaudio --daemon &

chkb dvorak &
xbindkeys &
#eval $(ssh-agent)
#eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)

#export SSH_AUTH_SOCK
xsetroot -solid '#252525' -cursor_name left_ptr
xscreensaver -no-splash &
xinput set-prop 'Logitech USB Trackball' 'Device Accel Constant Deceleration' .72 &

##################################################
# Move these over to WM_COMMAND
##################################################

#exec sh -c 'true; while [ $? -eq 0 ]; do $HOME/bin/dwm; done'
#exec awesome
#exec i3
#exec $HOME/bin/wingo
#exec startxfce4
#exec evilwm -term gnome-terminal -mask1 mod4 -mask2 mod4 \
#    -fn '-*-terminus-bold-*-*-*-*-280-*-*-*-*-iso10646-*' \
#    -app panel -f -dock \
#    -app xclock -f -dock
nvidia-composition-pipeline enable

#tmux new-session -s dwm_bar -d sh -c 'while true; do python ~/code/snippets/dwm_bar_winny.py; date; done'

#WM_COMMAND="$HOME/bin/dwm"
#WM_COMMAND=wmii
WM_COMMAND=i3
#WM_COMMAND=bspwm
#WM_COMMAND=fluxbox
#WM_COMMAND=wmaker


#while $WM_COMMAND; do
#    true
#done

if which ck-launch-session >/dev/null 2>&1; then
  _ck=ck-launch-session
else
  _ck=
fi

exec $_ck dbus-launch --sh-syntax --exit-with-session $WM_COMMAND
