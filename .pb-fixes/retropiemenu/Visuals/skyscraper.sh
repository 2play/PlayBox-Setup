#!/bin/bash
# Skyscraper Install and Update script by 2Play!
# Skyscraper by Lars Muldjor
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 31.12.20

infobox=""
infobox="${infobox}Skyscraper Update, Install & How to  Run script by 2Play!\n\n"
infobox="${infobox}\n"
infobox="${infobox}This script will update Skyscraper engine on PlayBox to the latest release. You can use it to install on a clean new system or re-install on PlayBox in case something got corrupt.\n"
infobox="${infobox}Skyscraper is a powerful and versatile yet easy to use game scraper. Supports EmulationStation & AttractMode, 61+ systems. Written by Lars Muldjord.\n"
infobox="${infobox}\n"
infobox="${infobox}It's cli based so you need to read the ReadMe.md file came with PlayBox or officially on the git page.\n > To set frontend use -f EmulationStation or AttractMode \n > To set platform use -p (See list of the 61 supported systems)\n > To set scrape source use -s [WEB: openretro.org, WEB: thegamesdb.net, WEB: worldofspectrum.org, WEB: adb.arcadeitalia.net (Arcade DB by motoschifo), WEB: screenscraper.fr, LOCAL: localdb (scrapes exclusively from cached resources.), LOCAL: import (imports resources into the local cache.)]"
infobox="${infobox}\n"
infobox="${infobox}\n"


dialog --backtitle "Skyscraper" \
--title "Skyscraper Retropie Script by 2Play!" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " SKYSCRAPER MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which Skyscraper option you want to run?" 25 75 20 \
            - "*** SKYSCRAPER SELECTIONS ***" \
            1 " - Update Skyscraper by Lars Muldjord" \
            2 " - Install Skyscraper by Lars Muldjord - PlayBox" \
            3 " - How To Run Skyscraper..." \
            2>&1 > /dev/tty)

        case "$choice" in
            1) update_ss  ;;
            2) install_ss  ;;
            3) run_ss  ;;
            -) none  ;;
            *) break ;;
        esac
    done
}


function update_ss() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	cd ~/code/skysource/ && ./update_skyscraper.sh

}

function install_ss() {
	dialog --infobox "...Installing..." 3 22 ; sleep 2
	clear
	sudo apt-get update && sudo apt-get install qt5-default && cd /home/pi/code && sudo rm -rf skysource && mkdir skysource && cd skysource && curl https://raw.githubusercontent.com/muldjord/skyscraper/master/update_skyscraper.sh | bash

}

function run_ss() {
	dialog --infobox "...Starting..." 3 20 ; sleep 2
	clear
	echo '1. Go back to Emulation Station' 
	echo '2. Press F4 to EXIT EmulationStation or "START" button and Select QUIT'
	echo '3. At CLi Type "Skyscraper" or Use Arrow Up Key to select it from  my custom CLi history commands'
	read -n 1 -s -r -p "Press any key to go back..."

}

main_menu
