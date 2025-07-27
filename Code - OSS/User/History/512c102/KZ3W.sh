#!/bin/bash

AMBIENT_SOUND="/home/luno/Audios/Background.mp3"
MPV_SOCKET="/tmp/mpv-socket"

# Start mpv with IPC control
mpv --loop=inf --volume=60 --no-video \
    --idle=yes --input-ipc-server="$MPV_SOCKET" "$AMBIENT_SOUND" &
MPV_PID=$!

# Wait for the IPC socket to be ready
while [ ! -S "$MPV_SOCKET" ]; do sleep 0.1; done

is_paused=false

while true; do
    # Check for active non-mpv audio output nodes
    ACTIVE=$(pw-dump | jq '
        [.[] | 
         select(.type == "node") |
         select(.info.props."media.class" == "Stream/Output") |
         select(.info.props."application.name" != "mpv")
        ] | length')

    if [ "$ACTIVE" -gt 0 ]; then
        if [ "$is_paused" = false ]; then
            echo '{"command": ["set_property", "pause", true]}' | socat - "$MPV_SOCKET"
            is_paused=true
        fi
    else
        if [ "$is_paused" = true ]; th_]()
