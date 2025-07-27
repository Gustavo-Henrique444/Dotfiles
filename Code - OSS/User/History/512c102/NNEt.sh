#!/bin/bash

# Path to notification sound
NOTIFY_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"
mpv --loop=inf --volume=60 /home/luno/Audios/Background.mp3 --input-ipc-server=/tmp/mpvbg



# Set your browser player name here (check with 'playerctl -l')
BROWSER_PLAYER="firefox"

echo "Listening for YouTube playback on $BROWSER_PLAYER..."

playerctl --player=$BROWSER_PLAYER metadata --follow --format '{{xesam:url}}' | while read -r url; do
    if [[ "$url" == *"youtube.com"* ]]; then
        echo "[+] YouTube playback started: $url"
        paplay "$NOTIFY_SOUND"
        echo '{ "command": ["quit"] }' | socat - /tmp/mpvbg
    fi
done
