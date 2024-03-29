#!/bin/bash
# Mp4 Launching Screens.
# The PlayBox Project
# Copyright (C)2018-2024 2Play! (S.R.)
# 08.2023

infobox=""
infobox="${infobox}\n"
infobox="${infobox}Mp4 Launching Screen(s)\n\n"
infobox="${infobox}\n"
infobox="${infobox}This script will disable or enable the Mp4 Launching Screen(s).\n"
infobox="${infobox}You have the option to enable specific launching mp4 per system or just the default 2Play! launching mp4.\n"
infobox="${infobox}\n"
infobox="${infobox}**Enable** or **Disable**\nWill enabled or disable launching mp4"
infobox="${infobox}\n"
infobox="${infobox}**Per System**\nWill check if systems launching mp4 exist otherwise will play 2Play!'s mp4.\n"
infobox="${infobox}\n"
infobox="${infobox}\n"


dialog --backtitle "Mp4 Launching Screens" \
--title "Mp4 Launching Screens by 2Play!" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " VIDEO LAUNCHING SCREEN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Would you like to have video launching screens?" 25 75 20 \
            - "*** VIDEO LAUNCHING SCREEN SELECTIONS ***" \
            1 " - Enable 2lay! Mp4 Launching Screen" \
            2 " - Disable Mp4 Launching Screen(s)" \
            3 " - Per System Mp4 Launching Screens or..." \
            2>&1 > /dev/tty)

        case "$choice" in
            1) enable_mp4  ;;
            2) disable_mp4  ;;
            3) enable_systems_mp4  ;;
            -) none  ;;
            *)  break ;;
        esac
    done
}


function enable_mp4() {
	dialog --infobox "...Checking and Applying..." 3 31 ; sleep 2
	#Check If ESBGM them apply correct files
	if [ -f "/home/pi/.local/bin/esbgm" ]; then
	cp /home/pi/PlayBox-Setup/mp4/runcommand-onstart2PESBGM.sh /opt/retropie/configs/all/runcommand-onstart.sh
	else
	cp /home/pi/PlayBox-Setup/mp4/runcommand-onstart2P.sh /opt/retropie/configs/all/runcommand-onstart.sh
	fi
}

function disable_mp4() {
	dialog --infobox "...Checking and Applying..." 3 31 ; sleep 2
	#Check If ESBGM them apply correct files
	if [ -f "/home/pi/.local/bin/esbgm" ]; then
	rm /opt/retropie/configs/all/runcommand-onstart.sh;
	cp /home/pi/PlayBox-Setup/mp4/runcommand-onstartESBGM.sh /opt/retropie/configs/all/runcommand-onstart.sh
	cp /home/pi/PlayBox-Setup/mp4/runcommand-onendESBGM.sh /opt/retropie/configs/all/runcommand-onend.sh
	rm /opt/retropie/configs/all/*.orig
	else
	rm /opt/retropie/configs/all/runcommand-onstart.sh
	rm /opt/retropie/configs/all/runcommand-onend.sh
	fi
}

function enable_systems_mp4() {
	dialog --infobox "...Checking if Systems mp4 exist..." 3 41 ; sleep 2
	#Check If ESBGM them apply correct files
	if [ -f "/home/pi/.local/bin/esbgm" ]; then
	cp /home/pi/PlayBox-Setup/mp4/runcommand-onstartALLESBGM.sh /opt/retropie/configs/all/runcommand-onstart.sh
	else
	cp /home/pi/PlayBox-Setup/mp4/runcommand-onstartALL.sh /opt/retropie/configs/all/runcommand-onstart.sh
	fi
}

main_menu