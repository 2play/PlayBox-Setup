#!/usr/bin/env bash
# The PlayBox Project
# Copyright (C)2018-2022 2Play! (S.R.)
# 26.03.2022

infobox= ""
infobox="${infobox}\n"
infobox="${infobox}Background Music on PlayBox v2\n\n"
infobox="${infobox}This script will install and setup background music for you.\n"
infobox="${infobox}	NOTE: Your system will reboot after removal or Install of Background Music\n"
infobox="${infobox}Just copy your mp3 files to the 'music' directory in your roms directory. Or use PlayBox Toolkit to enable one of the selections.\n"
infobox="${infobox}Once installed you can adjust the volume to your liking with this script as well.\n"
infobox="${infobox}There is also a 'Music On/Off' script to your default RetropieMenu so you can mute the music off or on at will.\n\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox} Original script By Luis Torres aka Naprosnia & PlayBox v2 Custom by 2Play!\n"
infobox="${infobox} Credit also to crcerror aka CyperGhost !\n"
infobox="${infobox}\n"


dialog --backtitle "Background Music Livewire/EZH - 2Play!" \
--title "Background Music Script" \
--msgbox "${infobox}" 23 80

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " BACKGROUND MUSIC MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            - "*** BACKGROUND MUSIC SELECTIONS ***" \
            1 " - Clean Install/Update Background Music" \
            2 " - Set Background Music Volume - Only after installed" \
            3 " - Remove/Disable Background Music" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) install_bgm  ;;
            2) vol_menu  ;;
            3) remove_bgm  ;;
            -) none  ;;
            *)  break ;;
        esac
    done
}

function install_bgm() {
        cd $HOME
		rm -rf RetroPie-BGM-Player/
		wget -N https://raw.githubusercontent.com/2play/RetroPie_BGM_Player/playbox_v2/install.sh
		chmod +x install.sh
		clear
		echo
		echo "After reboot, you can use from PlayBox Toolkit to set a music choice or ..."
		sleep 3
		echo "Copy your music files in the /roms/music folder"
		sleep 3
		./install.sh
}

function vol_menu() {
    ./$HOME/RetroPie-BGM-Player/bgm_control/general/bgm_setvolume.sh
}

function remove_bgm() {
	cd $HOME
	wget -N https://raw.githubusercontent.com/2play/RetroPie_BGM_Player/playbox_v2/uninstall.sh
	chmod +x uninstall.sh
	./uninstall.sh
}

main_menu