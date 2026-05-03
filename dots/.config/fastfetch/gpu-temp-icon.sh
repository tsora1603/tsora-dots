#!/bin/bash

GPU="AMD Radeon RX $(lspci | grep -i 'vga\|3d\|display' | grep -i amd | grep -oP '(?<=\[)Radeon[^\]]*(?=\])' | cut -d'/' -f2 | sed 's/^[[:space:]]*//')"

TEMP=$(sensors amdgpu-pci-0800 | awk '/^edge/ {gsub(/[^0-9.]/, "", $2); print int($2)}')

if   [ "$TEMP" -ge 90 ]; then icon=""; color="\e[31m"
elif [ "$TEMP" -ge 75 ]; then icon=""; color="\e[33m"
elif [ "$TEMP" -ge 55 ]; then icon=""; color="\e[93m"
elif [ "$TEMP" -ge 35 ]; then icon=""; color="\e[32m"
else                          icon=""; color="\e[36m"
fi

echo -e "$GPU${color}$icon${TEMP}°C"
