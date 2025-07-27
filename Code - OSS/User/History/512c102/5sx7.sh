#!/bin/bash

# Path to your sound (change this!)
SOUND_PATH="/home/luno/Audios/Background.mp3"

# Optional: browser process name
BROWSER="firefox"  # or 'chromium'

# Loop forever
while true; do
    # Check if there's a PipeWire node for the browser playing audio
    if pw-dump | grep -q "\"application.name\": \"$BROWSER\"" && \
       pw-dump | grep -q "\"state\": \"running\""; then

        echo "[+] Detected audio from $BROWSER, echoing sound!"
        paplay "$SOUND_PATH"  # or use mpv or aplay

        # Wait a bit to avoid echoing multiple times
        sleep 10
    fi

    sleep 1
done
