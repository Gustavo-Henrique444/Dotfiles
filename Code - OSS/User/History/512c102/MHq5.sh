mpv /home/luno/Audios/Background.mp3 --loop --idle --input-ipc-server=/tmp/mpv-socket


#!/bin/bash

SOCKET="/tmp/mpv-socket"
STATE=paused

while true; do
    ACTIVE=$(pw-dump | jq -r '[.[] | select(.type == "PipeWire:Interface:Node") | select(.info.props."media.class" == "Stream/Output") | select(.info.props."node.name" != "mpv") | select(.info.state == "running")] | length')

    if [[ "$ACTIVE" -gt 0 && "$STATE" == "playing" ]]; then
        echo "Pausing mpv..."
        echo '{ "command": ["set_property", "pause", true] }' | socat - "$SOCKET"
        STATE=paused
    elif [[ "$ACTIVE" -eq 0 && "$STATE" == "paused" ]]; then
        echo "Resuming mpv..."
        echo '{ "command": ["set_property", "pause", false] }' | socat - "$SOCKET"
        STATE=playing
    fi

    sleep 2
done
