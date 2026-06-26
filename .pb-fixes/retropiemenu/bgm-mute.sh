#!/bin/bash
# Python BGM script by Rydra inspired from original concept script of Livewire
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 26.06.2026

stop_bgm(){
    mkdir -p ~/.config/esbgm
    touch ~/.config/esbgm/disable.flag
    clear
    echo -e "\n\n\n Background Music Disabled\n\n\n"
    sleep 1
}

start_bgm(){
    rm -f ~/.config/esbgm/disable.flag
    echo -e "\n\n\n Background Music Enabled\n\n\n"
    sleep 1
}

case "$1" in
    stop) stop_bgm ;;
    start) start_bgm ;;
    *) 
        if [ -e ~/.config/esbgm/disable.flag ]; then
            start_bgm
        else
            stop_bgm
        fi
        ;;
esac
