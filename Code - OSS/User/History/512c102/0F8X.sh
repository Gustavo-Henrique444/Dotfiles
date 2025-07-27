#!/bin/bash

MPV_IPC="/tmp/mpv-socket"
AMBIENT_PLAYER_PID=0

# Start ambient sound mpv if not already started
start_ambient() {
    if ! pgrep -f "mpv.*$MPV_IPC" > /dev/null; then
        mpv --input-ipc-server=$MPV_IPC --loop --no-video --volume=40 /home/luno/Audios/Background.mp3 &
        AMBIENT_PLAYER_PID=$!
        echo "Ambient sound started with PID $AMBIENT_PLAYER_PID"
    fi
}

# Send command to mpv socket
mpv_command() {
    local cmd=$1
    if [[ -e $MPV_IPC ]]; then
        echo "$cmd" | socat - $MPV_IPC > /dev/null 2>&1
    fi
}

# Check if other audio streams (excluding ambient's mpv) are active in PipeWire
other_audio_active() {
    active=$(pw-dump | jq '
        .[] | select(
            .type == "PipeWire:Interface:Node" and
            .info.props["media.class"] == "Audio/Sink" and
            .info.props["application.name"] != "mpv"
        ) | .info.props["node.name"]'
    )
    [[ -n "$active" ]]
}

start_ambient

pause_sent=false

while true; do
    if other_audio_active; then
        # Pause ambient if playing
        if ! $pause_sent; then
            mpv_command '{"command": ["set_property", "pause", true]}'
            echo "Other audio detected, ambient paused."
            pause_sent=true
        fi
    else
        # Resume ambient if paused
        if $pause_sent; then
            mpv_command '{"command": ["set_property", "pause", false]}'
            echo "No other audio detected, ambient resumed."
            pause_sent=false
        fi
    fi
    sleep 5
done
