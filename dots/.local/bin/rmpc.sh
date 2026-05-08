#!/usr/bin/env bash

if pgrep -x rmpc > /dev/null; then
    pkill rmpc
else
    kitty --class rmpc -e rmpc
fi