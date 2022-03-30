#!/usr/bin/env bash
# Python BGM script by Rydra inspired from original concept script of Livewire
# The PlayBox Project
# Copyright (C)2018-2022 2Play! (S.R.)
# 30.03.2022

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

if [ -e ~/.config/esbgm/disable.flag ]; then
        start_bgm
else
        stop_bgm
fi
exit
