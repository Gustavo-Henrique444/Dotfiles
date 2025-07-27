#!/bin/bash

NOTIFY_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"
AMBIENT_SOUND="/home/luno/Audios/Background.mp3"
MPV_SOCKET="/tmp/mpvbg"
BROWSER_PLAYER="firefox"

# Start ambient sound in background with IPC
echo "[*] Starting ambient sound..."
mpv --quiet --loop=inf --volume=60 "$AMBIENT_SOUND" --input-ipc-server="$MPV_SOCKET" &
MPV_PID=$!

# Helper functions
pause_ambient() {
    echo "[*] Pausing ambient sound"
    echo '{ "command": ["set_property", "pause", true] }' | socat - "$MPV_SOCKET"
}

resume_ambient() {
    echo "[*] Resuming ambient sound"
    echo '{ "command": ["set_property", "pause", false] }' | socat - "$MPV_SOCKET"
}

echo "[*] Monitoring YouTube playback via $BROWSER_PLAYER..."

last_state="stopped"

while true; do
    # Get player status and URL
    status=$(playerctl --player="$BROWSER_PLAYER" status 2>/dev/null)
    url=$(playerctl --player="$BROWSER_PLAYER" metadata --format '{{xesam:url}}' 2>/dev/null)

    if [[ "$url" == *"youtube.com"* ]]; then
        if [[ "$status" == "Playing" && "$last_state" != "playing" ]]; then
            echo "[+] YouTube is playing: $url"
            paplay "$NOTIFY_SOUND"
            pause_ambient
            last_state="playing"
        elif [[ "$status" != "Playing" && "$last_state" == "playing" ]]; then
            echo "[+] YouTube is paused/stopped: $url"
            resume_ambient
            last_state="paused"
        fi
    else
        if [[ "$last_state" == "playing" ]]; then
            echo "[+] YouTube closed or switched away"
            resume_ambient
            last_state="stopped"
        fi
    fi

    sleep 2
done
