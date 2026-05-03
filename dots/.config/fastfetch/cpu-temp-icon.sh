#!/bin/bash

CPU=$(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed 's/^[[:space:]]*//' | sed 's/ [0-9]*-Core Processor//')

TEMP=$(sensors k10temp-pci-00c3 | awk '/^Tctl/ {gsub(/[^0-9.]/, "", $2); print int($2)}')

if   [ "$TEMP" -ge 85 ]; then icon=""; color="\e[31m"
elif [ "$TEMP" -ge 70 ]; then icon=""; color="\e[33m"
elif [ "$TEMP" -ge 50 ]; then icon=""; color="\e[93m"
elif [ "$TEMP" -ge 35 ]; then icon=""; color="\e[32m"
else                          icon=""; color="\e[36m"
fi

echo -e "$CPU ${color}$icon${TEMP}°C"
