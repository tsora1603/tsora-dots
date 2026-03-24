#!/usr/bin/env bash

if [[ -z $(hyprctl clients | grep 'class: yazi') ]]; then
    kitty --class yazi -e yazi
else
    wtype q
fi
