#!/bin/bash
# Reset all of your ES controller configuration. Similar to EZH & RetroPie Setup Script.
# The PlayBox Project
# Copyright (C)2018-2022 2Play! (S.R.)
# 25.06.19

infobox=""
infobox="${infobox}\n"
infobox="${infobox}Complete Controller Configuration Reset Script, By 2Play!\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}This script will remove all controller profiles from your system, will apply a new clean es_input.cfg file so on your next reboot you will need to configure all.\n"
infobox="${infobox}\n"
infobox="${infobox}I suggest you always setup your controllers in order of preference.\nIf you have dual arcade, for example, first set P1 and P2 etc. If you prefer BT controller to be first start there and then connect your wired ones.\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}\n"


dialog --backtitle "Full Controllers Reset" \
--title "CONTROLLERS RESET!" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " CONTROLLERS RESET MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Are you ready?" 25 75 20 \
            - "*** CONTROLLERS SETUP RESET SELECTIONS ***" \
            1 " - Reset All ES Controller Configs" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) reset_ctrls  ;;
            -) none  ;;
            *)  break ;;
        esac
    done
}


function reset_ctrls() {
	dialog --infobox "...Resetting..." 3 20 ; sleep 2
	rm /opt/retropie/configs/all/retroarch-joypads/*
	rm $HOME/.emulationstation/es_input.cfg
	cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_input.cfg $HOME/.emulationstation/
	echo
	read -n 1 -s -r -p "Press any key to continue."
	echo
	echo "[OK System Will Restart now...]"
	sleep 3
	clear
	sudo reboot
}

main_menu
