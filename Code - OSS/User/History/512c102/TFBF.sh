mpv /home/luno/Audios/Background.mp3 --loop --idle --input-ipc-server=/tmp/mpv-socket


pw-dump | jq '[.[] | select(.type == "PipeWire:Interface:Node") | select(.info.props."media.class" == "Stream/Output")]'
pw-dump | jq -r '[.[] | select(.type == "PipeWire:Interface:Node") | select(.info.props."media.class" == "Stream/Output") | select(.info.props."node.name" != "mpv") | select(.info.state == "running")] | length'


# Pause
echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpv-socket

# Resume
echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpv-socket
