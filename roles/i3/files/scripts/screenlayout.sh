#! /bin/bash

xrandr --listmonitors | grep -qE 'DP-1-8'

if [[ $? -eq 0 ]]; then
    # office monitors detected
    xrandr --output eDP-1 --off \
        --output DP-1-8 --mode 2560x1440 --pos 0x0 --rotate normal \
        --output DP-1-1-8 --mode 2560x1440 --pos 2560x0 --rotate normal
else
    xrandr --output eDP-1 --off \
        --output DP-1-1 --mode 2560x1440 --pos 0x0 --rotate normal \
        --output DP-1-2 --mode 2560x1440 --pos 2560x0 --rotate normal
fi
