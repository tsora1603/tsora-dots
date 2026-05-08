#!/usr/bin/env bash

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if pgrep -x yazi > /dev/null; then
    pkill yazi
    kitty
else
    if pgrep -x kitty > /dev/null; then
        pkill kitty
    else
        kitty
    fi
fi