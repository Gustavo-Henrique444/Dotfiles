#!/bin/bash

AMBIENT_PID=""
AMBIENT_STARTED=false

start_ambient() {
    if ! $AMBIENT_STARTED; then
        echo "Starting ambient..."
        mpv --loop=inf --volume=30 /path/to/ambient.mp3 --no-video --no-terminal &
        AMBIENT_PID=$!
        AMBIENT_STARTED=true
    fi
}

stop_ambient() {
    if $AMBIENT_STARTED && [ -n "$AMBIENT_PID" ]; then
        echo "Stopping ambient..."
        kill "$AMBIENT_PID"
        wait "$AMBIENT_PID" 2>/dev/null
        AMBIENT_STARTED=false
    fi
}

while true; do
    # Count how many streams are playing that aren't mpv
    ACTIVE_COUNT=$(pw-dump | jq '[.[] | select(.type == "stream" and .info.props."media.class" == "Stream/Output" and .info.props.app.name != "mpv")] | length')

    if [ "$ACTIVE_COUNT" -gt 0 ]; then
        stop_ambient
    else
        start_ambient
    fi

    sleep 2
done
