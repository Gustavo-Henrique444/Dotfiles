#!/bin/bash

AMBIENT_SOUND="/home/luno/Audios/Background.mp3"
MPV_SOCKET="/tmp/mpvbg"
BROWSER_PROCESS="firefox"
TARGET_VOLUME=60

# Start mpv with IPC server
echo "[*] Starting ambient sound..."
mpv --quiet --loop=inf --volume=$TARGET_VOLUME "$AMBIENT_SOUND" --input-ipc-server="$MPV_SOCKET" &
MPV_PID=$!

# Helpers to control mpv via IPC
mpv_cmd() {
    echo "$1" | socat - "$MPV_SOCKET" >/dev/null
}

fade_out() {
    echo "[*] Fading out ambient..."
    for v in $(seq $TARGET_VOLUME -5 0); do
        mpv_cmd "{ \"command\": [\"set_property\", \"volume\", $v] }"
        sleep 0.05
    done
    mpv_cmd '{ "command": ["set_property", "pause", true] }'
}

fade_in() {
    echo "[*] Fading in ambient..."
    mpv_cmd '{ "command": ["set_property", "pause", false] }'
    for v in $(seq 0 5 $TARGET_VOLUME); do
        mpv_cmd "{ \"command\": [\"set_property\", \"volume\", $v] }"
        sleep 0.05
    done
}

# Detect if Firefox has active audio via pw-dump
firefox_playing_audio() {
    pw-dump | jq -r '.[] | select(.type=="node") | select(.info.props."application.name"=="firefox") | .info.state' | grep -q "running"
}

last_state="idle"

echo "[*] Monitoring Firefox audio activity..."

while true; do
    if firefox_playing_audio; then
        if [[ "$last_state" != "playing" ]]; then
            fade_out
            last_state="playing"
        fi
    else
        if [[ "$last_state" == "playing" ]]; then
            fade_in
            last_state="idle"
        fi
    fi
    sleep 1
done
