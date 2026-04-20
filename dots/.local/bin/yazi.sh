#!/usr/bin/env bash

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if [[ -z $(hyprctl clients | grep 'class: yazi') ]]; then
    kitty --class yazi -e yazi
else
    wtype q
fi
