#!/bin/bash
# Pi0 BGM Off/On
# The PlayBox Project
# Copyright (C)2018-2023 2Play! (S.R.)
# 24.04.2023

infobox=""
infobox="${infobox}\n"
infobox="${infobox}Pi0 BGM Off/On\n\n"
infobox="${infobox}\n"
infobox="${infobox}This script will disable or enable the Pi0 BGM.\n"
infobox="${infobox}\n"
infobox="${infobox}\n\n"
infobox="${infobox}**Enable**\nEnable option: The BGM is enabled after reboot."
infobox="${infobox}\n"
infobox="${infobox}**Disable**\nDisable option: the BGM is disabled after reboot.\n"
infobox="${infobox}\n"
infobox="${infobox}\n"

dialog --backtitle "Pi0 BGM Off/On Switch" \
--title "Pi0 BGM Off/On Switch by 2Play!" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " Pi0 BGM MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            - "*** Pi0 BGM SELECTIONS ***" \
            1 " - Enable Pi0 BGM" \
            2 " - Disable Pi0 BGM" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) enable_BGM  ;;
            2) disable_BGM  ;;
            -) none  ;;
            *)  break ;;
        esac
    done
}


function enable_BGM() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	clear
	cp /opt/retropie/configs/all/autostartNOBGM.sh /opt/retropie/configs/all/autostart.sh
    clear
    echo -e "\n\n\n                               Background Music Disabled\n\n\n"
    sleep 3
	echo "Your Retropie is about to reboot so that the settings take effect!"
	sudo reboot
}

function disable_BGM() {
	dialog --infobox "...Removing..." 3 20 ; sleep 2
	clear
	cp /opt/retropie/configs/all/autostartBGM.sh /opt/retropie/configs/all/autostart.sh
    echo -e "\n\n\n                                    Background Music Enabled\n\n\n"
    sleep 3
	echo "Your Retropie is about to reboot so that the settings take effect!"
	sudo reboot
}

main_menu
