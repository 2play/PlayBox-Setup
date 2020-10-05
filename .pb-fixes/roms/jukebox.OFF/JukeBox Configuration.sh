#!/bin/bash
# To create a new db after deletion, make sure you have placed your mp3 tagged files in the musicvolt directory
# JukeBox aka Fruitbox By Chundermike, Tweaked By 2Play

infobox= ""
infobox="${infobox}\n"
infobox="${infobox}JukeBox Configuration Utility\n\n"
infobox="${infobox}Tweaked by 2Play!.\n"
infobox="${infobox}The Fruitbox JukeBox software turns RetroPie into a jukebox music machine.\n"
infobox="${infobox}\n"
infobox="${infobox}This utility is used to quickly configure some of the common options for it.\n"
infobox="${infobox}\n"
infobox="${infobox}You can place your tag enabled MP3 files in the /roms/jukebox/musicvolt directory.\n"
infobox="${infobox}\n"
infobox="${infobox}Once you place your music files into this folder, launching the jukebox will scan the folder and create a jukebox database for them.\n"
infobox="${infobox}\n"
infobox="${infobox}You can also configure your gamepad to use the jukebox. (Note a keyboard is required during gamepad configuration only).\n"
infobox="${infobox}\n"
infobox="${infobox}Here are some of the command jukebox-to-gamepad assignments to setup.\n"
infobox="${infobox}\n"
infobox="${infobox}ButtonQuit       - define your single button to quit the jukebox\n"
infobox="${infobox}ButtonSelect     - define your button to play highlighted song\n"
infobox="${infobox}ButtonPause      - define your button to pause playing\n"
infobox="${infobox}ButtonSkip       - define your button to skip to next song\n"
infobox="${infobox}ButtonRandom     - define your button to randomly play a song\n"
infobox="${infobox}ButtonLeft       - define your d-pad direction for left\n"
infobox="${infobox}ButtonRight      - define your d-pad direction for right\n"
infobox="${infobox}ButtonUp         - define your d-pad direction for up\n"
infobox="${infobox}ButtonDown       - define your d-pad direction for down\n"
infobox="${infobox}ButtonLeftJump   - define your button for page left\n"
infobox="${infobox}ButtonRightJump  - define your button for page right\n"
infobox="${infobox}\n"
infobox="${infobox}***NOTE***\n"
infobox="${infobox}Whenever you add or remove MP3 files, you must remove the current jukebox database file too.  Then launch the jukebox and it will rescan your files and build a new music database.\n"

dialog --backtitle "JukeBox aka Fruitbox By Chundermike, Tweaked By 2Play" \
--title "JukeBox" \
--msgbox "${infobox}" 40 120



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 100 20 \
            1 "Delete current JukeBox music database (Will be refreshed upon next launch)" \
            2 "Configure gamepad button assignments" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) remove_database  ;;
            2) configure_gamepad  ;;
            *)  break ;;
        esac
    done
}


function remove_database() {
dialog --infobox "...processing..." 3 20 ; sleep 2

sudo rm /home/pi/RetroPie/roms/jukebox/musicvolt/*.db 2> /dev/null

}

function configure_gamepad() {
dialog --infobox "...processing..." 3 20 ; sleep 2

sudo /opt/retropie/emulators/jukebox/fruitbox --config-buttons

}

main_menu

