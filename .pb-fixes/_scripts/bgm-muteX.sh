#!/bin/bash
# Python BGM script by Rydra inspired from original concept script of Livewire
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 29.06.2026
# PulseAudio fade + restore user level

STATE_FILE=/tmp/audio_mode

# Detect sinks dynamically
ANALOG_SINK=$(pactl list short sinks | grep analog | awk '{print $2}' | head -n1)
HDMI_SINK=$(pactl list short sinks | grep hdmi | awk '{print $2}' | head -n1)

# Pick default sink
DEFAULT_SINK=$(pactl info | grep "Default Sink" | awk '{print $3}')

fade_out(){
    # Save current volume (user’s level)
    CURVOL=$(pactl get-sink-volume "$DEFAULT_SINK" | awk '{print $5}' | head -1 | tr -d '%')

    # Fade down
    for v in $(seq $CURVOL -10 0); do
        pactl set-sink-volume "$DEFAULT_SINK" "${v}%"
        sleep 0.05
    done

    # Disable esbgm
    mkdir -p ~/.config/esbgm
    touch ~/.config/esbgm/disable.flag

    # Short delay to let esbgm stop
    sleep 3

    # Restore to the user’s original level
    pactl set-sink-volume "$DEFAULT_SINK" "${CURVOL}%"
    #echo "Background Music Disabled (faded, restored to ${CURVOL}%)"
}

fade_in(){
    rm -f ~/.config/esbgm/disable.flag
    #echo "Background Music Enabled"
}

case "$1" in
    stop) fade_out ;;
    start) fade_in ;;
    *)
        if [ -e ~/.config/esbgm/disable.flag ]; then
            fade_in
        else
            fade_out
        fi
        ;;
esac
