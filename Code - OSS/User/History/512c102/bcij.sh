#!/bin/bash

# Path to notification sound
NOTIFY_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"

# Path to ambient sound
AMBIENT_SOUND="/home/luno/Audios/Background.mp3"

# IPC socket path for mpv control
MPV_SOCKET="/tmp/mpvbg"

# Start ambient background sound using mpv in background with IPC
echo "[*] Starting ambient sound..."
mpv --quiet --loop=inf --volume=60 "$AMBIENT_SOUND" --input-ipc-server="$MPV_SOCKET" &

# Save PID so we can kill it if needed later
MPV_PID=$!

# Set your browser player name here (check with 'playerctl -l')
BROWSER_PLAYER="firefox"

echo "[*] Listening for YouTube playback on $BROWSER_PLAYER..."

playerctl --player="$BROWSER_PLAYER" metadata --follow --format '{{xesam:url}}' | while read -r url; do
    if [[ "$url" == *"youtube.com"* ]]; then
        echo "[+] YouTube playback started: $url"
        paplay "$NOTIFY_SOUND"

        # Stop ambient sound if mpv is running
        if [[ -S "$MPV_SOCKET" ]]; then
            echo '[*] Stopping ambient sound...'
            echo '{ "command": ["quit"] }' | socat - "$MPV_SOCKET"
        else
            echo "[!] MPV IPC socket not found: $MPV_SOCKET"
        fi

        break  # Optional: stop script after first YouTube playback
    fi
done
