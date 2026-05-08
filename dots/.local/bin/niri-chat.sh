#!/usr/bin/env bash

niri msg action focus-workspace 󰡟
niri msg action move-workspace-to-monitor-next
niri msg action maximize-column

if [ "$(niri msg --json workspaces | jq -r '.[] | select(.is_focused==true) | .name')" = "󰡟" ]; then
    niri msg action maximize-column
fi