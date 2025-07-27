MPV_IPC="/tmp/mpv-socket"
AMBIENT_PLAYER_PID=0

# Start ambient sound mpv if not already started
start_ambient() {
    if ! pgrep -f "mpv.*$MPV_IPC" > /dev/null; then
        mpv --input-ipc-server=$MPV_IPC --loop --no-video /home/luno/Audios/Background.mp3 &
        AMBIENT_PLAYER_PID=$!
        echo "Ambient sound started with PID $AMBIENT_PLAYER_PID"
    fi
}

# Send command to mpv socket
mpv_command() {
    local cmd=$1
    if [[ -e $MPV_IPC ]]; then
        echo "$cmd" | socat - $MPV_IPC > /dev/null 2>&1
    fi
}

# Check if other audio streams (excluding ambient's) are active in PipeWire
other_audio_active() {
    # List all output streams
    # The ambient sound mpv stream will be identified by pid or description to exclude
    # For a simple method, check "pw-play -l" or "pw-dump"

    # Example filtering using pw-dump for streams with "output" direction and state running
    active=$(pw-dump | jq '.nodes[] | select(.media.class=="Audio/Source" and .props."media.name" != "ambient-mpv") | .info.props."node.name"')

    # Alternatively, identify streams excluding your mpv by pipewire node properties or names.
    # This is a placeholder; adjust based on your environment.

    # Here, just check if any stream besides mpv socket is present and running
    # This example is only conceptual
    [[ -n "$active" ]]
}

start_ambient

pause_sent=false

while true; do
    if other_audio_active; then
        # Pause ambient if playing
        if ! $pause_sent; then
            mpv_command '{"command": ["set_property", "pause", true]}'
            echo "Other audio detected, ambient paused."
            pause_sent=true
        fi
    else
        # Resume ambient if paused
        if $pause_sent; then
            mpv_command '{"command": ["set_property", "pause", false]}'
            echo "No other audio detected, ambient resumed."
            pause_sent=false
        fi
    fi
    sleep 5
done