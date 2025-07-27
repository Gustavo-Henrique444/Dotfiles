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

bezier_ease() {
    t=$1
    # This is an approximation for cubic-bezier ease-in-out curve:
    # parametric formula: B(t) = 3*(1−t)^2*t*p1 + 3*(1−t)*t^2*p2 + t^3
    # For this example, only y-coords are used (p1=0, p2=1 approx)
    # To keep it simple, we use a polynomial approx of ease-in-out curve:

    # Using the common ease-in-out formula:
    # output = 3*t^2 - 2*t^3
    awk -v t="$t" 'BEGIN {print 3*t*t - 2*t*t*t}'
}

fade_out() {
    echo "[*] Fading out ambient sound..."
    mpv_cmd '{ "command": ["set_property", "pause", false] }'
    steps=20
    for i in $(seq 0 $steps); do
        progress=$(awk -v i="$i" -v steps="$steps" 'BEGIN {print i/steps}')
        eased=$(bezier_ease $progress)
        # Calculate volume from eased progress: starts from $TARGET_VOLUME down to 0
        vol=$(awk -v max="$TARGET_VOLUME" -v ease="$eased" 'BEGIN {print int(max*(1 - ease))}')
        mpv_cmd "{ \"command\": [\"set_property\", \"volume\", $vol] }"
        sleep 0.05
    done
    mpv_cmd '{ "command": ["set_property", "pause", true] }'
}

fade_in() {
    echo "[*] Fading in ambient sound..."
    mpv_cmd '{ "command": ["set_property", "pause", false] }'
    steps=20
    for i in $(seq 0 $steps); do
        progress=$(awk -v i="$i" -v steps="$steps" 'BEGIN {print i/steps}')
        eased=$(bezier_ease $progress)
        # Calculate volume from eased progress: starts from 0 to $TARGET_VOLUME
        vol=$(awk -v max="$TARGET_VOLUME" -v ease="$eased" 'BEGIN {print int(max*ease)}')
        mpv_cmd "{ \"command\": [\"set_property\", \"volume\", $vol] }"
        sleep 0.05
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
