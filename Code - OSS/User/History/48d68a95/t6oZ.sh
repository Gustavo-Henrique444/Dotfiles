#!/bin/bash

while true; do
    focused_window=$(hyprctl activewindow -j | jq -r '.class')
    window_title=$(hyprctl activewindow -j | jq -r '.title')

    if [[ "$window_title" == *"YouTube"* ]]; then
        hyprctl dispatch opacity 0.8
    else
        hyprctl dispatch opacity 1.0
    fi

    sleep 1
done
