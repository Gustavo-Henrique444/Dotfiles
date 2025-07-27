#!/bin/bash

NOTIFY_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"
BROWSER_PLAYER="firefox"

echo "Monitoring YouTube playback on $BROWSER_PLAYER..."

youtube_playing=false
last_seen=$(date +%s)

# Function to play notification
play_notify() {
    paplay "$NOTIFY_SOUND"
}

# Background timer check (every 3 seconds)
while true; do
    now=$(date +%s)
    diff=$(( now - last_seen ))

    if $youtube_playing && (( diff > 5 )); then
        # No YouTube playback detected for 5+ seconds
        youtube_playing=false
        echo "[+] YouTube stopped playing"
        play_notify
    fi

    sleep 3 &
    wait
done &

# Main event loop reading playerctl metadata
playerctl --player=$BROWSER_PLAYER metadata --follow --format '{{xesam:url}}' | while read -r url; do
    if [[ "$url" == *"youtube.com"* ]]; then
        if ! $youtube_playing; then
            echo "[+] YouTube started playing: $url"
            play_notify
            youtube_playing=true
        fi
        last_seen=$(date +%s)
    fi
done
