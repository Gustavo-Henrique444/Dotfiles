#!/bin/bash

# Path to your sound (change this!)
SOUND_PATH="/home/luno/Audios/Background.mp3"

#playerctl metadata --format '{{mpris:trackid}}' --follow | while read -r track; do
    # Track ID is usually something like "spotify:track:xxx" or URL of media
    if echo "$track" | grep -q "youtube"; then
        echo "[+] YouTube playback started!"
        paplay "$SOUND_PATH"
    fi
done
