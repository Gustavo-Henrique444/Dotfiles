#!/bin/bash

# Path to ambient sound
AMBIENT_SOUND="/home/luno/Audios/Background.mp3"

# Start mpv in idle mode with IPC enabled
mpv --loop=inf --volume=60 --no-video --idle=yes --input-ipc-server=/tmp/mpv-socket "$AMBIENT_SOUND" &
MPV_PID=$!

# Wait for mpv socket to be ready
while [ ! -e /tmp/mpv-socket ]; do sleep 0.1; done

is_paused=false

while true; do
    # Check for active audio from *any* app except mpv
    VU=$(pw-meter -n all -d 100ms | grep -v mpv | awk '{ sum += $2 } END { print sum }')
    
    if (( $(echo "$VU > 0.01" | bc -l) )); then
        if [ "$is_paused" = false ]; then
            echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpv-socket
            is_paused=true
        fi
    else
        if [ "$is_paused" = true ]; then
            echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpv-socket
            is_paused=false
        fi
    fi

    sleep 1
done
