#!/usr/bin/env bash

if [[ -z $(hyprctl clients | grep 'class: rmpc') ]]; then
    kitty --class rmpc -e rmpc
else
    pkill rmpc
fi
