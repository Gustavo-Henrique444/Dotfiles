#!/bin/bash

NOTIFY_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"
AMBIENT_SOUND="/home/luno/Audios/Background.mp3"
MPV_SOCKET="/tmp/mpvbg"
BROWSER_PLAYER="firefox"
TARGET_VOLUME=60

# Start ambient sound in background with IPC
echo "[*] Starting ambient sound..."
mpv --quiet --loop=inf --volume=$TARGET_VOLUME "$AMBIENT_SOUND" --input-ipc-server="$MPV_SOCKET" &
MPV_PID=$!

# Helper to send command to mpv
mpv_cmd() {
    echo "$1" | socat - "$MPV_SOCKET" >/dev/null
}

fade_out() {
    echo "[*] Fading out ambient sound..."
    for v in $(seq $TARGET_VOLUME -5 0); do
        mpv_cmd "{ \"command\": [\"set_property\", \"volume\", $v] }"
        sleep 0.1
    done
    mpv_cmd '{ "command": ["set_property", "pause", true] }'
}

fade_in() {
    echo "[*] Fading in ambient sound..."
    mpv_cmd '{ "command": ["set_property", "pause", false] }'
    for v in $(seq 0 5 $TARGET_VOLUME); do
        mpv_cmd "{ \"command\": [\"set_property\", \"volume\", $v] }"
        sleep 0.1
    done
}

echo "[*] Monitoring YouTube playback via $BROWSER_PLAYER..."

last_state="stopped"

while true; do
    status=$(playerctl --player="$BROWSER_PLAYER" status 2>/dev/null)
    url=$(playerctl --player="$BROWSER_PLAYER" metadata --format '{{xesam:url}}' 2>/dev/null)

    if [[ "$url" == *"youtube.com"* ]]; then
        if [[ "$status" == "Playing" && "$last_state" != "playing" ]]; then
            echo "[+] YouTube is playing: $url"
            paplay "$NOTIFY_SOUND"
            fade_out
            last_state="playing"
        elif [[ "$status" != "Playing" && "$last_state" == "playing" ]]; then
            echo "[+] YouTube paused/stopped: $url"
            fade_in
            last_state="paused"
        fi
    else
        if [[ "$last_state" == "playing" ]]; then
            echo "[+] YouTube closed or switched away"
            fade_in
            last_state="stopped"
        fi
    fi

    sleep 2
done
