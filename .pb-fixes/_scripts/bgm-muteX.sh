#!/bin/bash
# Python BGM script by Rydra inspired from original concept script of Livewire
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 26.06.2026

fade_out(){
    # Save current volume
    CURVOL=$(amixer get Master | grep -o '[0-9]*%' | head -1 | tr -d '%')

    # Fade down
    for v in $(seq $CURVOL -10 0); do
        amixer -q sset Master ${v}%
        sleep 0.05
    done

    # Disable esbgm
    mkdir -p ~/.config/esbgm
    touch ~/.config/esbgm/disable.flag

    # Restore volume immediately
    sleep 3
	amixer -q sset Master ${CURVOL}%
    #echo "Background Music Disabled (faded)"
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
