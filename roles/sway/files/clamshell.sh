#!/bin/sh

# https://github.com/swaywm/sway/wiki#clamshell-mode

if grep -q open /proc/acpi/button/lid/LID/state; then
    swaymsg output <LAPTOP> enable
else
    swaymsg output <LAPTOP> disable
fi
