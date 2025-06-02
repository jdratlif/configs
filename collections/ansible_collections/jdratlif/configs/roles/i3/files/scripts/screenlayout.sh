#! /bin/bash

START=0
M_LAPTOP=0
M_OFFICE=0
M_HOME=0

# check if laptop lid is open
grep -q open /proc/acpi/button/lid/LID/state

if [[ $? -eq 0 ]]; then
    LAPTOP_MODE="--mode 2560x1440 --pos 0x0"
    START=2560
else
    LAPTOP_MODE="--off"
fi

# check for office monitors
xrandr --listmonitors | grep -qE 'DP-1-8'

if [[ $? -eq 0 ]]; then
    MON1="DP-1-8"
    MON2="DP-1-1-8"
fi

xrandr --listmonitors | grep -qE 'DP-1-2'

if [[ $? -eq 0 ]]; then
    MON1="DP-1-1"
    MON2="DP-1-2"
fi

if [[ ! -z $MON1 ]]; then
    DOCK_MODE1="--output $MON1 --mode 2560x1440 --pos $((START))x0"
    DOCK_MODE2="--output $MON2 --mode 2560x1440 --pos $((START + 2560))x0"
fi

xrandr --output eDP-1 $LAPTOP_MODE $DOCK_MODE1 $DOCK_MODE2
