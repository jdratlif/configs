#! /bin/sh

swayidle -w \
    timeout {{ idle_timeout.lock }} 'swaylock -f' \
    timeout $(({{ idle_timeout.lock }} + {{ idle_timeout.screen }})) 'hyprctl dispatch dpms off' \
    resume 'hyprctl dispatch dpms on'
