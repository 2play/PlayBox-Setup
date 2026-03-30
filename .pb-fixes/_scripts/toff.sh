#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 03.2026
USER_UID=$(id -u pi)
export XDG_RUNTIME_DIR=/run/user/${USER_UID}
export PULSE_SERVER=unix:/run/user/${USER_UID}/pulse/native

# Log what's alive at shutdown time
echo "=== turnoff debug ===" >> /home/pi/.local/tmp/turnoff.log
echo "pulse socket exists: $(ls /run/user/${USER_UID}/pulse/native 2>&1)" >> /home/pi/.local/tmp/turnoff.log
echo "pipewire running: $(pgrep pipewire)" >> /home/pi/.local/tmp/turnoff.log
echo "wireplumber running: $(pgrep wireplumber)" >> /home/pi/.local/tmp/turnoff.log
date >> /home/pi/.local/tmp/turnoff.log

# If EmulationStation is running, kill it first to release framebuffer
if pgrep -x "emulationstatio" > /dev/null; then
    pkill -x "emulationstatio"
    sleep 1	
fi

chvt 2
exec /usr/bin/mpv --vo=drm --fs \
    /home/pi/PlayBox-Setup/turnoff.mp4 >/dev/null 2>&1
chvt 1