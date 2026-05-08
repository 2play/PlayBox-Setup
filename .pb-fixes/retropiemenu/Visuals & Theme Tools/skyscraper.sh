#!/bin/bash
# Skyscraper Install and Update script by 2Play!
# Skyscraper by Lars Muldjor
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 06.05.2026
BACKTITLE="PLAYBOX PROJECT"

infobox=""
infobox="${infobox}Skyscraper Update, Install & How to  Run script by 2Play!\n\n"
infobox="${infobox}\n"
infobox="${infobox}This script will update Skyscraper engine on PlayBox to the latest release. You can use it to install on a clean new system or re-install on PlayBox in case something got corrupt.\n"
infobox="${infobox}Skyscraper is a powerful and versatile yet easy to use game scraper. Supports EmulationStation & AttractMode, 80+ systems. Written by Lars Muldjord.\n"
infobox="${infobox}\n"
infobox="${infobox}It's cli based. Check options No3. And you can find full documentation at https://github.com/muldjord/skyscraper/tree/master/docs !"
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
            --menu "Skyscraper options to run..." 25 75 20 \
            - "*** SKYSCRAPER SELECTIONS ***" \
            ""      "" \
			1 " - Update Skyscraper " \
            2 " - How To Run Skyscraper..." \
            2>&1 > /dev/tty)

        case "$choice" in
            1) update_ss  ;;
            2) run_ss  ;;
            -) none  ;;
            *) break ;;
        esac
    done
}


function update_ss() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	cd ~/code/skysource/ && ./update_skyscraper.sh
	for f in /home/pi/.skyscraper/*.sh; do
    sudo ln -sf "$f" /usr/local/bin/$(basename "$f" .sh)
	done
}

function install_ss() {
	dialog --infobox "...Installing..." 3 22 ; sleep 2
	clear
	sudo apt update && sudo apt install build-essential qtbase5-dev qt5-qmake qtbase5-dev-tools -y && cd /home/pi/code && sudo rm -rf skysource && mkdir skysource && cd skysource && curl https://raw.githubusercontent.com/muldjord/skyscraper/master/update_skyscraper.sh | bash
	for f in /home/pi/.skyscraper/*.sh; do
    sudo ln -sf "$f" /usr/local/bin/$(basename "$f" .sh)
	done
}

function run_ss() {
	dialog --infobox "...Starting..." 3 20 ; sleep 2
	clear
	echo '1. EXIT EmulationStation to CLi or use SSH to connect to PlayBox.'
	echo '2a. At CLi Type "SkyscrapeBoxart" or Just "Sky" Press TAB then "B" TAB. Follow the guided steps to scrape a system with boxart...'
	echo '2b. At CLi Type "SkyscrapeMixart" or Just "Sky" Press TAB then "M" TAB. Follow the guided steps to scrape a system with mixart...'
	read -n 1 -s -r -p "Press any key to go back..."
}

main_menu
