#!/usr/bin/env bash

# Get focused window info
WINDOW=$(niri msg --json focused-window)
APP=$(echo "$WINDOW" | jq -r '.app_id')
WS_ID=$(echo "$WINDOW" | jq -r '.workspace_id')

# Find which monitor that workspace is on
MONITOR=$(niri msg --json workspaces | jq -r ".[] | select(.id == $WS_ID) | .output")

# Now check both conditions
if [ "$APP" = "float.kitty" ] && [ "$MONITOR" = "DP-1" ]; then
  niri msg action move-floating-window -x -180
  niri msg action set-window-width 950
  niri msg action set-window-height 520
fi

if [ "$APP" = "float.yazi" ] && [ "$MONITOR" = "DP-1" ]; then
  niri msg action move-floating-window -x -180 -y +460
  niri msg action set-window-width 900
  niri msg action set-window-height 500
fi

if [ "$APP" = "float.rmpc" ] && [ "$MONITOR" = "DP-1" ]; then
  niri msg action move-floating-window -x -180 -y +460
  niri msg action set-window-width 900
  niri msg action set-window-height 500
fi