#!/bin/bash
# All required fixes in case you break something 
# Fix retropiemenu, es_systems.cfg etc.
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# PlayBox ToolKit

pb_version="PlayBox ToolKit Version 2.0 Dated 06.01.2021"

infobox=""
infobox="${infobox}\n\n\n\n\n"
infobox="${infobox}        __________.__                 __________                
\n"
infobox="${infobox}        \______   \  | _____   ___.__.\______   \ ________  ___ 
\n"
infobox="${infobox}         |     ___/  | \__  \ <   |  | |    |  _//  _  \  \/  / 
\n"
infobox="${infobox}         |    |   |  |__/ __ \ \___  | |    |   (  <_>  >    <  
\n"
infobox="${infobox}         |____|   |____(____  )/ ____| |______  /\_____/__/\_ \ 
\n"
infobox="${infobox}                            \/ \/             \/             \/ \n"
infobox="${infobox}                                                              By 2Play!\n"
infobox="${infobox}\n\n\n"
infobox="${infobox}The ToolKit is part of the PlayBox Project I've started back in 2018.\nAutomation, Ease & Fixes as I intended.\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}\n"

dialog --backtitle "PLAYBOX PROJECT" \
--title "PLAYBOX PROJECT - TOOLKIT" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " PLAYBOX PROJECT - TOOLKIT " \
            --ok-label OK --cancel-label Exit \
            --menu "$pb_version" 25 75 20 \
            - "*** PLAYBOX TOOLKIT SELECTIONS ***" \
            - "" \
			1 " -  FIXES OPTIONS MENU" \
            2 " -  APPS & TWEAKS OPTIONS MENU" \
            3 " -  CLEANUP TOOLS OPTIONS MENU" \
            4 " -  SYSTEM TOOLS OPTIONS MENU" \
            5 " -  THANK YOU! - CREDITS" \
			- "" \
			6 " -  UPDATE YOUR PLAYBOX SETUP" \
			- "" \
            7 " -  POWER OFF" \
            8 " -  RESTART" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) fixes_pbt  ;;
            2) apps_pbt  ;;
            3) clean_pbt  ;;
            4) sys_pbt  ;;
            5) thankyou_pb  ;;
			6) update_pbs  ;;
			7) poff_pb  ;;
            8) restart_pb  ;;
            -) none ;;
            *)  break ;;
        esac
    done
	clear
}

function fixes_pbt() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "FIXES OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " FIXES OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Apply the fix(es) you need..." 25 75 20 \
            - "*** PLAYBOX FIXES SELECTIONS ***" \
			- "	" \
			1 " -  Fix The PlayBox RetropieMenu" \
            2 " -  Region Systems PlayBox Setup (US/EU-JP/ALL)" \
			3 " -  Repair JukeBox/PlayBox-Kodi/RPi-OS/PieGalaxy/Steam Systems" \
            4 " -  Repair PlayBox Background Music Mute File" \
            5 " -  Restore 2Play! Slideshow Screensaver" \
            6 " -  Reset All RetroPie Controllers" \
            7 " -  Fix-Reset-Clean RetroPie Setup git" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) fix_rpmenu  ;;
            2) fix_region  ;;
			3) fix_roms  ;;
            4) fix_bgm_py  ;;
            5) fix_slideshow  ;;
            6) fix_control  ;;
            7) git_rs  ;;
            -) none ;;
            *)  break ;;
        esac
    done
}

function fix_rpmenu() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	clear
	sleep 2
	mv -f $HOME/RetroPie/retropiemenu/raspiconfig.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu
	mv -f $HOME/RetroPie/retropiemenu/rpsetup.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu
	mv -f $HOME/RetroPie/retropiemenu/configedit.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Emulation
	mv -f $HOME/RetroPie/retropiemenu/retroarch.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Emulation
	mv -f $HOME/RetroPie/retropiemenu/retronetplay.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Emulation
	mv -f $HOME/RetroPie/retropiemenu/bluetooth.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Network
	mv -f $HOME/RetroPie/retropiemenu/showip.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Network
	mv -f $HOME/RetroPie/retropiemenu/wifi.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Network
	mv -f $HOME/RetroPie/retropiemenu/audiosettings.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/System
	mv -f $HOME/RetroPie/retropiemenu/filemanager.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/System
	mv -f $HOME/RetroPie/retropiemenu/runcommand.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/System
	mv -f $HOME/RetroPie/retropiemenu/esthemes.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Visuals
	mv -f $HOME/RetroPie/retropiemenu/splashscreen.rp $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Visuals
	mv -f $HOME/RetroPie/retropiemenu/hurstythemes.sh $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Visuals
	mv -f $HOME/RetroPie/retropiemenu/bezelproject.sh $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Visuals
	rsync -avh --delete $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/ $HOME/RetroPie/retropiemenu && find $HOME -name "*.rp" ! -name "raspiconfig.rp" ! -name "rpsetup.rp" | xargs sudo chown root:root && cp $HOME/PlayBox-Setup/.pb-fixes/retropie-gml/gamelist2play.xml /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
	sudo rm -rf /etc/emulationstation/themes/carbon/
	echo
	clear
	echo "We need to apply REGION script now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	fix_region
}


function fix_region() {
	clear
# Set PlayBox Systems Based On Region, by 2Play!
# 13.10.20

infobox=""
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}Systems & Theme Options Based on Region, by 2Play!\n\n"
infobox="${infobox}\n"
infobox="${infobox}This script will set some systems basis your region of preference.\n"
infobox="${infobox}- The US\JP Region will use Genesis, Sega 32X/CD, TG16/CD, Odyssey2 systems.\n"
infobox="${infobox}- The EU\JP Region will use Mega Drive, Mega 32X/CD, PC Engine/CD, VideoPac systems.\n"
infobox="${infobox}- The ALL Region will show all systems.\n"
infobox="${infobox}\n"
infobox="${infobox}- The extra 3 options as above but with clean Kodi (Lite Version) instead PlayBox (Full Version When Enabled)."
infobox="${infobox}\n"

dialog --backtitle "Region based ES Systems" \
--title "PLAYBOX SYSTEMS BASED ON REGION" \
--msgbox "${infobox}" 35 110

    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " REGION OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select the REGION setup you want to apply..." 25 75 20 \
            - "*** REGION SYSTEM OPTIONS with PLAYBOX ***" \
            1 " - US\JP: Genesis, SegaCD, TG16\CD, Odyssey2" \
            2 " - EU\JP: Mega Drive, MegaCD, PC Engine\CD, Videopac" \
            3 " - ALL:   All systems will be enabled" \
            - "" \
            - "*** REGION SYSTEM OPTIONS with KODI ***" \
            4 " - US\JP: As option 1 + Kodi" \
            5 " - EU\JP: As option 2 + Kodi" \
            6 " - ALL:   As option 3 + Kodi" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) us_es  ;;
            2) eu_es  ;;
            3) all_es  ;;
            4) us_esnpb  ;;
            5) eu_esnpb  ;;
            6) all_esnpb  ;;
            -) none ;;
            *) break ;;
        esac
    done
}

function us_es() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	sudo cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_systemsUS.cfg /etc/emulationstation/es_systems.cfg
if [ -d $HOME/addonusb ]; then
	mv -f ~/RetroPie/localroms/kodi ~/RetroPie/localroms/localroms/kodi.OFF
	mv -f ~/RetroPie/localroms/playbox.OFF ~/RetroPie/localroms/playbox
	mv -f ~/RetroPie/localroms/amiga1200 ~/RetroPie/localroms/amiga1200.OFF
	mv -f ~/RetroPie/localroms/amiga-aga.OFF ~/RetroPie/localroms/amiga-aga
	mv -f ~/RetroPie/localroms/wonderswancolor ~/RetroPie/localroms/wonderswancolor.OFF
	else
	mv -f ~/RetroPie/roms/kodi ~/RetroPie/roms/kodi.OFF
	mv -f ~/RetroPie/roms/playbox.OFF ~/RetroPie/roms/playbox
	mv -f ~/RetroPie/roms/amiga1200 ~/RetroPie/roms/amiga1200.OFF
	mv -f ~/RetroPie/roms/amiga-aga.OFF ~/RetroPie/roms/amiga-aga
	mv -f ~/RetroPie/roms/wonderswancolor ~/RetroPie/roms/wonderswancolor.OFF
fi
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 1
	sudo reboot
	echo
}

function eu_es() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	sudo cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_systemsEU.cfg /etc/emulationstation/es_systems.cfg
if [ -d $HOME/addonusb ]; then
	mv -f ~/RetroPie/localroms/kodi ~/RetroPie/localroms/kodi.OFF
	mv -f ~/RetroPie/localroms/playbox.OFF ~/RetroPie/localroms/playbox
	mv -f ~/RetroPie/localroms/amiga1200 ~/RetroPie/localroms/amiga1200.OFF
	mv -f ~/RetroPie/localroms/amiga-aga.OFF ~/RetroPie/localroms/amiga-aga
	mv -f ~/RetroPie/localroms/wonderswancolor ~/RetroPie/localroms/wonderswancolor.OFF
	else
	mv -f ~/RetroPie/roms/kodi ~/RetroPie/roms/kodi.OFF
	mv -f ~/RetroPie/roms/playbox.OFF ~/RetroPie/roms/playbox
	mv -f ~/RetroPie/roms/amiga1200 ~/RetroPie/roms/amiga1200.OFF
	mv -f ~/RetroPie/roms/amiga-aga.OFF ~/RetroPie/roms/amiga-aga
	mv -f ~/RetroPie/roms/wonderswancolor ~/RetroPie/roms/wonderswancolor.OFF
fi
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 1
	sudo reboot
	echo
}

function all_es() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	sudo cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_systems.cfg /etc/emulationstation
if [ -d $HOME/addonusb ]; then
	mv -f ~/RetroPie/localroms/kodi ~/RetroPie/localroms/kodi.OFF
	mv -f ~/RetroPie/localroms/playbox.OFF ~/RetroPie/localroms/playbox
	mv -f ~/RetroPie/localroms/amiga1200 ~/RetroPie/localroms/amiga1200.OFF
	mv -f ~/RetroPie/localroms/amiga-aga.OFF ~/RetroPie/localroms/amiga-aga
	mv -f ~/RetroPie/localroms/genesis.OFF ~/RetroPie/localroms/genesis
	mv -f ~/RetroPie/localroms/genesish.OFF ~/RetroPie/localroms/genesish
#	mv -f ~/RetroPie/localroms/genh.OFF ~/RetroPie/localroms/genh
	mv -f ~/RetroPie/localroms/tg16.OFF ~/RetroPie/localroms/tg16
	mv -f ~/RetroPie/localroms/tg16cd.OFF ~/RetroPie/localroms/tg16cd
	mv -f ~/RetroPie/localroms/odyssey2.OFF ~/RetroPie/localroms/odyssey2
	mv -f ~/RetroPie/localroms/megacd.OFF ~/RetroPie/localroms/megacd
	mv -f ~/RetroPie/localroms/megadrive.OFF ~/RetroPie/localroms/megadrive
	mv -f ~/RetroPie/localroms/megadriveh.OFF ~/RetroPie/localroms/megadriveh
#	mv -f ~/RetroPie/localroms/megh.OFF ~/RetroPie/localroms/megh
	mv -f ~/RetroPie/localroms/pcengine.OFF ~/RetroPie/localroms/pcengine
	mv -f ~/RetroPie/localroms/pcenginecd.OFF ~/RetroPie/localroms/pcenginecd
	mv -f ~/RetroPie/localroms/videopac.OFF ~/RetroPie/localroms/videopac
	mv -f ~/RetroPie/localroms/wonderswancolor ~/RetroPie/localroms/wonderswancolor.OFF
	else
	mv -f ~/RetroPie/roms/kodi ~/RetroPie/roms/kodi.OFF
	mv -f ~/RetroPie/roms/playbox.OFF ~/RetroPie/roms/playbox
	mv -f ~/RetroPie/roms/amiga1200 ~/RetroPie/roms/amiga1200.OFF
	mv -f ~/RetroPie/roms/amiga-aga.OFF ~/RetroPie/roms/amiga-aga
	mv -f ~/RetroPie/roms/genesis.OFF ~/RetroPie/roms/genesis
	mv -f ~/RetroPie/roms/genesish.OFF ~/RetroPie/roms/genesish
#	mv -f ~/RetroPie/roms/genh.OFF ~/RetroPie/roms/genh
	mv -f ~/RetroPie/roms/tg16.OFF ~/RetroPie/roms/tg16
	mv -f ~/RetroPie/roms/tg16cd.OFF ~/RetroPie/roms/tg16cd
	mv -f ~/RetroPie/roms/odyssey2.OFF ~/RetroPie/roms/odyssey2
	mv -f ~/RetroPie/roms/megacd.OFF ~/RetroPie/roms/megacd
	mv -f ~/RetroPie/roms/megadrive.OFF ~/RetroPie/roms/megadrive
	mv -f ~/RetroPie/roms/megadriveh.OFF ~/RetroPie/roms/megadriveh
#	mv -f ~/RetroPie/roms/megh.OFF ~/RetroPie/roms/megh
	mv -f ~/RetroPie/roms/pcengine.OFF ~/RetroPie/roms/pcengine
	mv -f ~/RetroPie/roms/pcenginecd.OFF ~/RetroPie/roms/pcenginecd
	mv -f ~/RetroPie/roms/videopac.OFF ~/RetroPie/roms/videopac
	mv -f ~/RetroPie/roms/wonderswancolor ~/RetroPie/roms/wonderswancolor.OFF
fi
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 1
	sudo reboot
	echo
}

function us_esnpb() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	sudo cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_systemsUS.cfg /etc/emulationstation/es_systems.cfg
if [ -d $HOME/addonusb ]; then
	mv -f ~/RetroPie/localroms/playbox ~/RetroPie/localroms/playbox.OFF
	mv -f ~/RetroPie/localroms/amiga-aga ~/RetroPie/localroms/amiga-aga.OFF
	mv -f ~/RetroPie/localroms/kodi.OFF ~/RetroPie/localroms/kodi
	mv -f ~/RetroPie/localroms/amiga1200.OFF ~/RetroPie/localroms/amiga1200
	mv -f ~/RetroPie/localroms/wonderswancolor ~/RetroPie/localroms/wonderswancolor.OFF
	else
	mv -f ~/RetroPie/roms/playbox ~/RetroPie/roms/playbox.OFF
	mv -f ~/RetroPie/roms/amiga-aga ~/RetroPie/roms/amiga-aga.OFF
	mv -f ~/RetroPie/roms/kodi.OFF ~/RetroPie/roms/kodi
	mv -f ~/RetroPie/roms/amiga1200.OFF ~/RetroPie/roms/amiga1200
	mv -f ~/RetroPie/roms/wonderswancolor ~/RetroPie/roms/wonderswancolor.OFF
fi
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 1
	sudo reboot
	echo
}

function eu_esnpb() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	sudo cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_systemsEU.cfg /etc/emulationstation/es_systems.cfg
if [ -d $HOME/addonusb ]; then
	mv -f ~/RetroPie/localroms/playbox ~/RetroPie/localroms/playbox.OFF
	mv -f ~/RetroPie/localroms/amiga-aga ~/RetroPie/localroms/amiga-aga.OFF
	mv -f ~/RetroPie/localroms/kodi.OFF ~/RetroPie/localroms/kodi
	mv -f ~/RetroPie/localroms/amiga1200.OFF ~/RetroPie/localroms/amiga1200
	mv -f ~/RetroPie/localroms/wonderswancolor ~/RetroPie/localroms/wonderswancolor.OFF
	else
	mv -f ~/RetroPie/roms/playbox ~/RetroPie/roms/playbox.OFF
	mv -f ~/RetroPie/roms/amiga-aga ~/RetroPie/roms/amiga-aga.OFF
	mv -f ~/RetroPie/roms/kodi.OFF ~/RetroPie/roms/kodi
	mv -f ~/RetroPie/roms/amiga1200.OFF ~/RetroPie/roms/amiga1200
	mv -f ~/RetroPie/roms/wonderswancolor ~/RetroPie/roms/wonderswancolor.OFF
fi
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 1
	sudo reboot
	echo
}

function all_esnpb() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	sudo cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_systems.cfg /etc/emulationstation
if [ -d $HOME/addonusb ]; then
	mv -f ~/RetroPie/localroms/playbox ~/RetroPie/localroms/playbox.OFF
	mv -f ~/RetroPie/localroms/amiga-aga ~/RetroPie/localroms/amiga-aga.OFF
	mv -f ~/RetroPie/localroms/kodi.OFF ~/RetroPie/localroms/kodi
	mv -f ~/RetroPie/localroms/amiga1200.OFF ~/RetroPie/localroms/amiga1200
	mv -f ~/RetroPie/localroms/genesis.OFF ~/RetroPie/localroms/genesis
	mv -f ~/RetroPie/localroms/genesish.OFF ~/RetroPie/localroms/genesish
#	mv -f ~/RetroPie/localroms/genh.OFF ~/RetroPie/localroms/genh
	mv -f ~/RetroPie/localroms/tg16.OFF ~/RetroPie/localroms/tg16
	mv -f ~/RetroPie/localroms/tg16cd.OFF ~/RetroPie/localroms/tg16cd
	mv -f ~/RetroPie/localroms/odyssey2.OFF ~/RetroPie/localroms/odyssey2
	mv -f ~/RetroPie/localroms/megacd.OFF ~/RetroPie/localroms/megacd
	mv -f ~/RetroPie/localroms/megadrive.OFF ~/RetroPie/localroms/megadrive
	mv -f ~/RetroPie/localroms/megadriveh.OFF ~/RetroPie/localroms/megadriveh
#	mv -f ~/RetroPie/localroms/megh.OFF ~/RetroPie/localroms/megh
	mv -f ~/RetroPie/localroms/pcengine.OFF ~/RetroPie/localroms/pcengine
	mv -f ~/RetroPie/localroms/pcenginecd.OFF ~/RetroPie/localroms/pcenginecd
	mv -f ~/RetroPie/localroms/videopac.OFF ~/RetroPie/localroms/videopac
	mv -f ~/RetroPie/localroms/wonderswancolor ~/RetroPie/localroms/wonderswancolor.OFF
	else
	mv -f ~/RetroPie/roms/playbox ~/RetroPie/roms/playbox.OFF
	mv -f ~/RetroPie/roms/amiga-aga ~/RetroPie/roms/amiga-aga.OFF
	mv -f ~/RetroPie/roms/kodi.OFF ~/RetroPie/roms/kodi
	mv -f ~/RetroPie/roms/amiga1200.OFF ~/RetroPie/roms/amiga1200
	mv -f ~/RetroPie/roms/genesis.OFF ~/RetroPie/roms/genesis
	mv -f ~/RetroPie/roms/genesish.OFF ~/RetroPie/roms/genesish
#	mv -f ~/RetroPie/roms/genh.OFF ~/RetroPie/roms/genh
	mv -f ~/RetroPie/roms/segacd.OFF ~/RetroPie/roms/segacd
	mv -f ~/RetroPie/roms/tg16.OFF ~/RetroPie/roms/tg16
	mv -f ~/RetroPie/roms/tg16cd.OFF ~/RetroPie/roms/tg16cd
	mv -f ~/RetroPie/roms/odyssey2.OFF ~/RetroPie/roms/odyssey2
	mv -f ~/RetroPie/roms/megacd.OFF ~/RetroPie/roms/megacd
	mv -f ~/RetroPie/roms/megadrive.OFF ~/RetroPie/roms/megadrive
	mv -f ~/RetroPie/roms/megadriveh.OFF ~/RetroPie/roms/megadriveh
#	mv -f ~/RetroPie/roms/megh.OFF ~/RetroPie/roms/megh
	mv -f ~/RetroPie/roms/pcengine.OFF ~/RetroPie/roms/pcengine
	mv -f ~/RetroPie/roms/pcenginecd.OFF ~/RetroPie/roms/pcenginecd
	mv -f ~/RetroPie/roms/videopac.OFF ~/RetroPie/roms/videopac
	mv -f ~/RetroPie/roms/wonderswancolor ~/RetroPie/roms/wonderswancolor.OFF
fi
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 1
	sudo reboot
	echo
}
#	$HOME/PlayBox-Setup/.pb-fixes/_scripts/region.sh	


function fix_roms() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	clear
	if [ -d $HOME/addonusb ]; then
	echo
    echo "You have enabled the External USB Script..."
	echo "Using correct paths..."
    echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	rm -rf $HOME/RetroPie/localroms/jukebox && rm -rf $HOME/RetroPie/localroms/jukebox.OFF && rm -rf $HOME/RetroPie/localroms/kodi && rm -rf $HOME/RetroPie/localroms/playbox && rm -rf $HOME/RetroPie/localroms/raspbian && rm -rf $HOME/RetroPie/localroms/piegalaxy && rm -rf $HOME/RetroPie/localroms/steam
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/jukebox.OFF $HOME/RetroPie/localroms/ 
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/kodi $HOME/RetroPie/localroms/
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/playbox.OFF $HOME/RetroPie/localroms/
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/raspbian $HOME/RetroPie/localroms/
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/steam $HOME/RetroPie/localroms/
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/piegalaxy $HOME/RetroPie/localroms/
	echo
	clear
	echo "We need to apply REGION script now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	fix_region
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 3
	sudo reboot
	echo
	else
	echo
    echo "You have a RetroPie default setup (No External USB). Applying..."
    sleep 3
    echo
	rm -rf $HOME/RetroPie/roms/jukebox && rm -rf $HOME/RetroPie/roms/jukebox.OFF && rm -rf $HOME/RetroPie/roms/kodi && rm -rf $HOME/RetroPie/roms/playbox && rm -rf $HOME/RetroPie/roms/raspbian && rm -rf $HOME/RetroPie/roms/piegalaxy && rm -rf $HOME/RetroPie/roms/steam
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/jukebox.OFF $HOME/RetroPie/roms/
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/kodi $HOME/RetroPie/roms/
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/playbox.OFF $HOME/RetroPie/roms/
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/raspbian $HOME/RetroPie/roms/
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/steam $HOME/RetroPie/roms/
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/roms/piegalaxy $HOME/RetroPie/roms/exit
	echo
	clear
	echo "We need to apply REGION script now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	fix_region
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 3
	sudo reboot
	echo
	fi
}


function fix_bgm_py() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	if [ -d $HOME/addonusb ]; then
	cp $HOME/PlayBox-Setup/.pb-fixes/bgm/.livewire.py $HOME
	cd $HOME
	sed -i 's+/home/pi/RetroPie/roms+/home/pi/RetroPie/localroms+g' .livewire.py
	else
	cp $HOME/PlayBox-Setup/.pb-fixes/bgm/.livewire.py $HOME
	cd $HOME
	sed -i 's+/home/pi/RetroPie/localroms+/home/pi/RetroPie/roms+g' .livewire.py
	fi
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}


function fix_slideshow() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	clear
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/slideshow/image /opt/retropie/configs/all/emulationstation/slideshow/
	clear
	echo
	echo "[OK DONE!...]"
	sleep 3
}


function fix_control() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	rm /opt/retropie/configs/all/retroarch-joypads/*
	rm $HOME/.emulationstation/es_input.cfg
	cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_input.cfg $HOME/.emulationstation/
	clear
	echo
	echo "[OK DONE!...]"
	echo
	read -n 1 -s -r -p "Press any key to continue."
	echo
	echo "[OK System Will Restart now...]"
	sleep 3
	clear
	sudo reboot
}


function git_rs() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	cd RetroPie-Setup && git reset --hard && git clean -f -d
	clear
	echo
	echo "[OK DONE!...]"
	sleep 3
}



function apps_pbt() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "APPS & TWEAKS OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " APPS & TWEAKS OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Run the application you need..." 25 75 20 \
            - "*** PLAYBOX APPS & TWEAKS SELECTIONS ***" \
			- "	" \
			1 " -  Take HD ScreenShot" \
			2 " -  Gamelist Views - 2Play! Themes " \
		    3 " -  RetroArch Main Visual Options (Shaders, Smooth Filter etc)" \
			4 " -  Hide or Show a System" \
			5 " -  2Play! Music Selections" \
			6 " -  Skyscraper By Lars Muldjord" \
		    7 " -  Vulkan Pi4 Driver" \
		    8 " -  [Disabled] PiKISS By Jose Cerrejon" \
		    9 " -  Single Saves Directory By RPC80" \
		   10 " -  SD/USB Storage Benchmark" \
		   11 " -  OMXPlayer Volume Control Script" \
		   12 " -  Emulators Custom Compile From Source" \
		   13 " -  Emulator Tweaks Options" \
		   2>&1 > /dev/tty)

        case "$choice" in
            1) prntscr  ;;
			2) swap_theme_view ;;
			3) ra_options_tool  ;;
			4) hd_sh_sys  ;;
			5) music_2p  ;;
			6) skyscraper  ;;
			7) igalia_vk  ;;
			#8) pikiss_git  ;;
		    9) rpc80_saves  ;;
		   10) strg_bench  ;;
		   11) omxvol  ;;
		   12) emus_compile  ;;
		   13) emus_tks  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function prntscr() {
	dialog --infobox "...Taking..." 3 16 ; sleep 1
	clear
	now=$(date +"%m_%d_%Y--h%H-m%M-s%S")
	screenshot > ~/ScreenShots/printscreen$now.jpg
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}


function swap_theme_view() {
	clear
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " 2PLAY! THEME VIEWS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Which gamelist view would you like to apply on my themes?" 25 75 20 \
            - "*** 2PLAY! THEME VIEW SELECTIONS ***" \
			- "	" \
			1 "Single Window Art:  Image and then Video" \
			2 "Dual Window Art  :  Image Under Gamelist + Big Video" \
			3 "Dual Window Art  :  Full Gamelist, Image Next to Video" \
			- "	" \
			4 "ES Systems Browsing: Vertical" \
			5 "ES Systems Browsing: Horizontal" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) single_art  ;;
            2) dual_art_hz  ;;
			3) dual_art_vrt  ;;
			4) sys_verical  ;;
			5) sys_horizontal  ;;
			-) none ;;
			*)  break ;;
        esac
    done
}

function single_art() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd /etc/emulationstation/themes
	find ./2Play*/_2playart -name "ingame-global-bg.jpg"  -delete
	find ./2Play*/_2playart -type f -name 'ingame-global-bg2P.jpg' -execdir cp {} ingame-global-bg.jpg ';'
	find ./2Play*/ -maxdepth 1 -name "theme.xml"  -delete
	find ./2Play*/ -maxdepth 1 -type f -name 'theme2P.xml' -execdir cp {} theme.xml ';'
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	echo "[OK System Will Restart now...]"
	sleep 2
	sudo reboot
}

function dual_art_hz() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd /etc/emulationstation/themes
	find ./2Play*/_2playart -name "ingame-global-bg.jpg"  -delete
	find ./2Play*/_2playart -type f -name 'ingame-global-bg-ih.jpg' -execdir cp {} ingame-global-bg.jpg ';'
	find ./2Play*/ -maxdepth 1 -name "theme.xml"  -delete
	find ./2Play*/ -maxdepth 1 -type f -name 'themeDualv1.xml' -execdir cp {} theme.xml ';'
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	echo "[OK System Will Restart now...]"
	sleep 2
	sudo reboot
}

function dual_art_vrt() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd /etc/emulationstation/themes
	find ./2Play*/_2playart -name "ingame-global-bg.jpg"  -delete
	find ./2Play*/_2playart -type f -name 'ingame-global-bg2P.jpg' -execdir cp {} ingame-global-bg.jpg ';'
	find ./2Play*/ -maxdepth 1 -name "theme.xml"  -delete
	find ./2Play*/ -maxdepth 1 -type f -name 'themeDualv2.xml' -execdir cp {} theme.xml ';'
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	echo "[OK System Will Restart now...]"
	sleep 2
	sudo reboot
}

function sys_verical() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd /etc/emulationstation/themes
	find ./2Play*/ -maxdepth 1 -type f -name "theme*.xml" -exec sed -i 's|<type>horizontal</type>|<type>vertical</type>|g' {} 2>/dev/null \;
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	echo "[OK System Will Restart now...]"
	sleep 2
	sudo reboot
}

function sys_horizontal() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd /etc/emulationstation/themes
	find ./2Play*/ -maxdepth 1 -type f -name "theme*.xml" -exec sed -i 's|<type>vertical</type>|<type>horizontal</type>|g' {} 2>/dev/null \;
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	echo "[OK System Will Restart now...]"
	sleep 2
	sudo reboot
}


function ra_options_tool() {
# RetroArch Options Tool By 2Play!
# 02.01.2021
	
	clear
	local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " RETROARCH VISUAL OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select a RetroArch Options you would like to apply on PlayBox configuration." 25 75 20 \
            - "*** SHADERS SELECTIONS ***" \
            1 " - [WIP - New] Enable Retro Shader Created By ChrisKekridis for A System " \
            2 " - [WIP - New] Enable Retro Shader Created By ChrisKekridis for A System " \
            3 " - Disable All Shaders " \
            4 " - Enable All Shaders " \
			- "" \
			- "*** OVERLAY SELECTIONS ***" \
			5 " - Enable A System Preset Overlay " \
            6 " - Disable A System Preset Overlay " \
			7 " - Enable All System Preset Overlays " \
            8 " - Disable All System Preset Overlays " \
		    - "" \
			- "*** VIDEO SMOOTH SELECTIONS ***" \
		    9 " - Enable Video Smooth - Single System " \
           10 " - Disable Video Smooth - Single System " \
		   11 " - Enable Video Smooth - All Systems " \
           12 " - Disable Video Smooth - All Systems " \
		   2>&1 > /dev/tty)

        case "$choice" in
            #1) ck_shader_syson  ;;
            #2) ck_shader_sysoff  ;;
            3) disable_shaders  ;;
            4) enable_shaders  ;;
            5) sys_overlay_on  ;;
            6) sys_overlay_off  ;;
			7) all_overlay_on  ;;
			8) all_overlay_off  ;;
			9) v_smooth_sys_on  ;;
		   10) v_smooth_sys_off  ;;
		   11) all_v_smooth_on  ;;
		   12) all_v_smooth_off  ;;
			-) none  ;;
            *)  break ;;
        esac
    done
}

function ck_shader_syson() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	clear
	echo 
	echo " I will display a list of all systems that you can apply a shader... "
	echo " Keep in mind ONLY RetroArch cores can use shaders. "
	echo
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>		Display next k lines of text [current screen size]"
	echo " <return>		Display next k lines of text [1]*"
	echo " d			Scroll k lines [current scroll size, initially 11]*"
	echo " q			Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo ***PLEASE TYPE THE SYSTEM NAME AS SHOWS IN THE CONFIGS FOLDER***
	echo 
	echo Example: nes
	echo NOT Nes or NES etc...
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	cd /opt/retropie/configs/
	echo
	#ls -d */ | column | more
	find \( -name all -prune -o -name amiga -prune -o -name ports -prune \) -o -name "retroarch.cfg" -printf "%h\n" | sort -h | column | more
	echo
	read -p 'So which system would you like to enable the retro shader?: ' sname
	echo
	if [ -f $sname/retroarch.cfg ]; then 
	find $sname -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g' {} 2>/dev/null \;
	clear
	echo
	while true; do
		echo ""
		read -p 'Whould you like to change another system [y] or [n]? ' yn
		case $yn in
		[Yy]*) ck_shader_syson;;
		[Nn]*) return;;
		* ) echo ""; echo "Please answer yes or no.";;
		esac
	done
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	clear
	echo
	sleep 2
	fi
}

function ck_shader_sysoff() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	clear
	echo 
	echo " I will display a list of all systems that you can apply a shader... "
	echo " Keep in mind ONLY RetroArch cores can use shaders. "
	echo
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>		Display next k lines of text [current screen size]"
	echo " <return>		Display next k lines of text [1]*"
	echo " d			Scroll k lines [current scroll size, initially 11]*"
	echo " q			Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo ***PLEASE TYPE THE SYSTEM NAME AS SHOWS IN THE CONFIGS FOLDER***
	echo 
	echo Example: nes
	echo NOT Nes or NES etc...
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	cd /opt/retropie/configs/
	echo
	#ls -d */ | column | more
	find \( -name all -prune -o -name amiga -prune -o -name ports -prune \) -o -name "retroarch.cfg" -printf "%h\n" | sort -h | column | more
	echo
	read -p 'So which system would you like to enable the retro shader?: ' sname
	echo
	if [ -f $sname/retroarch.cfg ]; then 
	find $sname -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g' {} 2>/dev/null \;
	clear
	echo
	while true; do
		echo ""
		read -p 'Whould you like to change another system [y] or [n]? ' yn
		case $yn in
		[Yy]*) ck_shader_sysoff;;
		[Nn]*) return;;
		* ) echo ""; echo "Please answer yes or no.";;
		esac
	done
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	clear
	echo
	sleep 2
	fi
}

function disable_shaders() {
	dialog --infobox "...Removing..." 3 20 ; sleep 2
	mv /opt/retropie/configs/all/retroarch/shaders/ /opt/retropie/configs/all/retroarch/shaders.OFF/
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function enable_shaders() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	mv /opt/retropie/configs/all/retroarch/shaders.OFF/ /opt/retropie/configs/all/retroarch/shaders/
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function sys_overlay_on() {
	clear
	echo 
	echo " I will display a list of all systems that you can apply an overlay... "
	echo " Keep in mind ONLY RetroArch cores can use overlays. "
	echo " An overlay preset required in the corresponding retroarch.cfg line #6 ... "
	echo
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>		Display next k lines of text [current screen size]"
	echo " <return>		Display next k lines of text [1]*"
	echo " d			Scroll k lines [current scroll size, initially 11]*"
	echo " q			Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo ***PLEASE TYPE THE SYSTEM NAME AS SHOWS IN THE CONFIGS FOLDER***
	echo 
	echo Example: nes
	echo NOT Nes or NES etc...
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	cd /opt/retropie/configs/ 
	echo
	#ls -d */ | column | more
	find \( -name all -prune -o -name amiberry -prune -o -name ports -prune \) -o -name "retroarch.cfg" -printf "%h\n" | sort -h | column | more
	echo
	read -p 'So which system would you like to enable the overlay options?: ' sname
	echo
	if [ -f $sname/retroarch.cfg ]; then 
	find $sname -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width|custom_viewport_width|g; s|.*#custom_viewport_height|custom_viewport_height|g; s|.*#custom_viewport_x|custom_viewport_x|g; s|.*#custom_viewport_y|custom_viewport_y|g' {} 2>/dev/null \;
	clear
	echo
	while true; do
		echo ""
		read -p 'Whould you like to change another system [y] or [n]? ' yn
		case $yn in
		[Yy]*) sys_overlay_on;;
		[Nn]*) return;;
		* ) echo ""; echo "Please answer yes or no.";;
		esac
	done
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	clear
	echo
	echo "This system does not contain a retroarch.cfg file... Script will go stop!"
	echo
	sleep 2
	fi
}

function sys_overlay_off() {
	clear
	echo 
	echo " I will display a list of all systems that you can apply an overlay... "
	echo " Keep in mind ONLY RetroArch cores can use overlays. "
	echo " An overlay preset required in the corresponding retroarch.cfg line #6 ... "
	echo
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>		Display next k lines of text [current screen size]"
	echo " <return>		Display next k lines of text [1]*"
	echo " d			Scroll k lines [current scroll size, initially 11]*"
	echo " q			Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo ***PLEASE TYPE THE SYSTEM NAME AS SHOWS IN THE CONFIGS FOLDER***
	echo 
	echo Example: nes
	echo NOT Nes or NES etc...
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	cd /opt/retropie/configs/ 
	echo
	#ls -d */ | column | more
	find \( -name all -prune -o -name amiberry -prune -o -name ports -prune \) -o -name "retroarch.cfg" -printf "%h\n" | sort -h | column | more
	echo
	read -p 'So which system would you like to disable the overlay options?: ' sname
	echo
	if [ -f $sname/retroarch.cfg ]; then 
	find $sname -name "retroarch.cfg" -exec sed -i 's|^input_overlay_enable|#input_overlay_enable|g; s|^input_overlay|#input_overlay|g; s|^aspect_ratio_index|#aspect_ratio_index|g; s|^custom_viewport_width|#custom_viewport_width|g; s|^custom_viewport_height|#custom_viewport_height|g; s|^custom_viewport_x|#custom_viewport_x|g; s|^custom_viewport_y|#custom_viewport_y|g' {} 2>/dev/null \;
	clear
	echo
	while true; do
		echo ""
		read -p 'Whould you like to change another system [y] or [n]? ' yn
		case $yn in
		[Yy]*) sys_overlay_off;;
		[Nn]*) return;;
		* ) echo ""; echo "Please answer yes or no.";;
		esac
	done
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	clear
	echo
	echo "This system does not contain a retroarch.cfg file... Script will go stop!"
	echo
	sleep 2
	fi
}

function all_overlay_on() {
	clear
	echo
	cd /opt/retropie/configs/ 
	find . -type d \( -name all -o -name amiberry \) -prune -false -o -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width|custom_viewport_width|g; s|.*#custom_viewport_height|custom_viewport_height|g; s|.*#custom_viewport_x|custom_viewport_x|g; s|.*#custom_viewport_y|custom_viewport_y|g' {} 2>/dev/null \;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function all_overlay_off() {
	clear
	echo
	cd /opt/retropie/configs/ 
	find . -type d \( -name all -o -name amiberry \) -prune -false -o -name "retroarch.cfg" -exec sed -i 's|^input_overlay_enable|#input_overlay_enable|g; s|^input_overlay|#input_overlay|g; s|^aspect_ratio_index|#aspect_ratio_index|g; s|^custom_viewport_width|#custom_viewport_width|g; s|^custom_viewport_height|#custom_viewport_height|g; s|^custom_viewport_x|#custom_viewport_x|g; s|^custom_viewport_y|#custom_viewport_y|g' {} 2>/dev/null \;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function v_smooth_sys_on() {
	clear
	echo 
	echo " I will display a list of all systems in configs folder... "
	echo " Keep in mind ONLY RetroArch cores can use video smooth option. "
	echo " By default is disabled!"
	echo " * TIP *: Disable shader(s) or just for this system."
	echo
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>		Display next k lines of text [current screen size]"
	echo " <return>		Display next k lines of text [1]*"
	echo " d			Scroll k lines [current scroll size, initially 11]*"
	echo " q			Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo ***PLEASE TYPE THE SYSTEM NAME AS SHOWS IN THE CONFIGS FOLDER***
	echo 
	echo Example: nes
	echo NOT Nes or NES etc...
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	cd /opt/retropie/configs/ 
	echo
	ls -d */ | column | more
	echo
	read -p 'So which system would you like to enable the video smooth option?: ' sname
	echo
	if [ -f $sname/retroarch.cfg ]; then 
	find $sname -name "retroarch.cfg" -exec sed -i 's|.*#video_smooth|video_smooth|g;' {} 2>/dev/null \;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	clear
	echo
	echo "This systems does not contain a retroarch.cfg file... Script will go stop!"
	echo
	sleep 2
	fi
}

function v_smooth_sys_off() {
	clear
	echo 
	echo " I will display a list of all systems in configs folder... "
	echo " Keep in mind ONLY RetroArch cores can use video smooth option. "
	echo " * TIP *: Enable your shader(s) or for this system back if you prefer. "
	echo
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>		Display next k lines of text [current screen size]"
	echo " <return>		Display next k lines of text [1]*"
	echo " d			Scroll k lines [current scroll size, initially 11]*"
	echo " q			Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo ***PLEASE TYPE THE SYSTEM NAME AS SHOWS IN THE CONFIGS FOLDER***
	echo 
	echo Example: nes
	echo NOT Nes or NES etc...
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	cd /opt/retropie/configs/ 
	echo
	ls -d */ | column | more
	echo
	read -p 'So which system would you like to disable the video smooth option?: ' sname
	echo
	if [ -f $sname/retroarch.cfg ]; then 
	find $sname -name "retroarch.cfg" -exec sed -i 's|^video_smooth|#video_smooth|g;' {} 2>/dev/null \;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	clear
	echo
	echo "This systems does not contain a retroarch.cfg file... Script will go stop!"
	echo
	sleep 2
	fi
}

function all_v_smooth_on() {
	clear
	echo
	cd /opt/retropie/configs/ 
	find . -type d \( -name all -o -name amiga \) -prune -false -o -name "retroarch.cfg" -exec sed -i 's|.*#video_smooth|video_smooth|g' {} 2>/dev/null \;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function all_v_smooth_off() {
	clear
	echo
	cd /opt/retropie/configs/ 
	find . -type d \( -name all -o -name amiga \) -prune -false -o -name "retroarch.cfg" -exec sed -i 's|^video_smooth|#video_smooth|g' {} 2>/dev/null \;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}


function hd_sh_sys() {
	clear
# Hide a System or RetroPie Menu Script by 2Play!
# 07.12.20

infobox=""
infobox="${infobox}\n"
infobox="${infobox}*** Hide RetroPie/Options Menu or any System Script. ***\n\n"
infobox="${infobox}You can hide any system in the roms directory.\nSome are visible due to the .sh file in there.\nYou can use this script or simply add manually .OFF to the .sh For example .sh.OFF\n\n"
infobox="${infobox}You will see a list of the systems and instructions. The script relies on your correct input!\n\n"
infobox="${infobox}*** For SYMBOLIC LINK SYSTEMs *** such as:\nGenesis, genesih, odyssey2, sega32x, segacd, tg16, tg16cd & PlayBox or Kodi.\nUSE the REGION SCRIPT for these.\n"
infobox="${infobox}\n"
infobox="${infobox}\n"

dialog --backtitle " - Hide A System from EmulationStation Systems Menu" \
--title " HIDE/SHOW A SYSTEM SCRIPT " \
--msgbox "${infobox}" 35 110

    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " HIDE/SHOW A SYSTEM MENU " \
            --ok-label OK --cancel-label Back \
            --menu "OK Let's decide what would you like to hide/show..." 25 75 20 \
            - "*** HIDE RETROPIE SYSTEM SELECTIONS ***" \
            1 " - Hide RetroPie/Options Menu" \
            2 " - Show RetroPie/Options Menu" \
            - "" \
            - "*** HIDE A SPECIFIC SYSTEM SELECTIONS ***" \
		    3 " - Hide A System..." \
            4 " - Show A System..." \
            - "" \
            5 " - Show/Restore ALL HIDDEN Systems" \
		   2>&1 > /dev/tty)

        case "$choice" in
            1) hide_rpm  ;;
            2) show_rpm  ;;
            3) hide_sys  ;;
            4) show_sys  ;;
            5) show_all  ;;
            -) none ;;
            *) break ;;
        esac
    done
}

function hide_rpm() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	mv -f ~/RetroPie/retropiemenu ~/RetroPie/retropiemenu.OFF
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 1
	sudo reboot
	echo
}

function show_rpm() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	mv -f ~/RetroPie/retropiemenu.OFF ~/RetroPie/retropiemenu
	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 1
	sudo reboot
	echo
}

function hide_sys() {
	dialog --infobox "...Hold on..." 3 18 ; sleep 2
	clear
	echo 
	echo " I will display a list of all Rom folders..."
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>		Display next k lines of text [current screen size]"
	echo " <return>		Display next k lines of text [1]*"
	echo " d			Scroll k lines [current scroll size, initially 11]*"
	echo " q			Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo ***PLEASE TYPE THE SYSTEM NAME AS IS IN THE ROMS LIST***
	echo 
	echo Example: arcade
	echo NOT Arcade or ARCADE etc...
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	cd $HOME/RetroPie/roms
	ls | column | more -d
	echo
	read -p 'So which system would you like to hide: ' sname
	echo
if [ -d $HOME/addonusb ]; then 
	mv -f ~/RetroPie/localroms/$sname ~/RetroPie/localroms/$sname.OFF && mv -f ~/RetroPie/addonusb/roms/$sname ~/RetroPie/addonusb/roms/$sname.OFF
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to continue... Once you are done, go to main menu and reboot!"
	sleep 1
	else
	mv -f ~/RetroPie/roms/$sname ~/RetroPie/roms/$sname.OFF
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to continue... Once you are done, go to main menu and reboot!"
	sleep 1
fi
}

function show_sys() {
	dialog --infobox "...Hold on..." 3 18 ; sleep 2
clear
	echo 
	echo " I will display a list of all Rom folders..."
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>		Display next k lines of text [current screen size]"
	echo " <return>		Display next k lines of text [1]*"
	echo " d			Scroll k lines [current scroll size, initially 11]*"
	echo " q			Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo ***PLEASE TYPE THE SYSTEM NAME AS IS IN THE ROMS LIST***
	echo 
	echo Example: arcade
	echo NOT Arcade or ARCADE etc...
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	cd $HOME/RetroPie/roms
	ls | column | more -d
	echo
	read -p 'So which system would you like to show: ' sname
	echo
if [ -d $HOME/addonusb ]; then
	mv -f ~/RetroPie/localroms/$sname.OFF ~/RetroPie/localroms/$sname && mv -f ~/RetroPie/addonusb/roms/$sname.OFF ~/RetroPie/addonusb/roms/$sname
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to continue... Once you are done, go to main menu and reboot!"
	sleep 1
	else
	mv -f ~/RetroPie/roms/$sname.OFF ~/RetroPie/roms/$sname
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to continue... Once you are done, go to main menu and reboot!"
	sleep 1
fi
}

function show_all() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	cd ~/RetroPie/roms/
	rename -v 's/\.OFF$//i' *
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}


function music_2p() {
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MUSIC SELECTION MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select the type of music you would like to apply." 25 75 20 \
            - "*** PLAYBOX 2Play! MUSIC SELECTIONS ***" \
			- "" \
            1 "I want to listen to 2Play!'s Selection" \
            2 "I want to listen to nice Royalty Free Tracks" \
            3 "I want to listen to a custom mix!" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) Synthpop  ;;
            2) RoyalFree  ;;
            3) Mix  ;;
            -) none ;;
            *)  break ;;
        esac
    done
}

function Synthpop() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	clear
	if [ -d $HOME/addonusb ]; then
	echo
    echo "You have enabled the External USB Script..."
	echo "Using correct paths..."
    echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	rm -rf $HOME/RetroPie/localroms/music/* && rm -rf $HOME/addonusb/roms/music/*
	rsync -avh $HOME/Music/synthpop/* $HOME/RetroPie/localroms/music
	else
	rm -rf $HOME/RetroPie/roms/music/*
	rsync -avh $HOME/Music/synthpop/* $HOME/RetroPie/roms/music
	fi
	echo
	echo "[OK System Will Restart now...]"
	sleep 3
	clear
	sudo reboot
}

function RoyalFree() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	clear
	if [ -d $HOME/addonusb ]; then
	echo
    echo "You have enabled the External USB Script..."
	echo "Using correct paths..."
    echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	rm -rf $HOME/RetroPie/localroms/music/* && rm -rf $HOME/addonusb/roms/music/*
	rsync -avh $HOME/Music/royalfree/* $HOME/RetroPie/localroms/music
	else
	rm -rf $HOME/RetroPie/roms/music/*
	rsync -avh $HOME/Music/royalfree/* $HOME/RetroPie/roms/music
	fi
	echo
	echo "[OK System Will Restart now...]"
	sleep 3
	clear
	sudo reboot
}

function Mix() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	clear
	if [ -d $HOME/addonusb ]; then
	echo
    echo "You have enabled the External USB Script..."
	echo "Using correct paths..."
    echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	rm -rf $HOME/RetroPie/localroms/music/* && rm -rf $HOME/addonusb/roms/music/*
	rsync -avh $HOME/Music/custom/* $HOME/RetroPie/localroms/music
	else
	rm -rf $HOME/RetroPie/roms/music/*
	rsync -avh $HOME/Music/custom/* $HOME/RetroPie/roms/music
	fi
	echo
	echo "[OK System Will Restart now...]"
	sleep 3
	clear
	sudo reboot
}


function skyscraper() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	echo
	echo "*** You need a keyboard connected! ***"
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	Skyscraper
}



function igalia_vk() {
# Install Pi4 Igalia Mesa Vulkan (v3dv-conformance-1.0) Driver https://blogs.igalia.com/apinheiro/
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 04.01.2021
	dialog --backtitle "PlayBox Toolkit" \
	--title "RASPBERRRY PI4 VULKAN OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " RASPBERRRY PI4 VULKAN OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's do some Vulkan work..." 25 75 20 \
            - "*** RASPBERRRY PI4 VULKAN SELECTIONS ***" \
			- "" \
           1 " -  [DISABLED] Install/Update All [Driver, Extras, RetroArch]" \
           2 " -  [UPDATE_WIP] Update Vulkan Driver Based On MESA 20.3" \
           3 " -  [DISABLED] Update Vulkan Demos" \
		   4 " -  Update Vulkan Enabled RetroArch" \
           5 " -  CleanUp Above Source Folders - To Save Space" \
            2>&1 > /dev/tty)

        case "$choice" in
           #1) igalia_all  ;;
           2) mesa_up  ;;
		   #3) igalia_dm  ;;
		   4) vulkan_ra  ;;
           5) sources_cl  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function igalia_all() {
# Install Pi Igalia Mesa Vulkan Driver
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 04.01.2021
clear
cd $HOME
if [ ! -d code ]; then
mkdir code && cd code/
else
cd code/
fi
echo ""
echo "STEP 1. Installing Dependencies... "
echo ""
sudo apt-get install -y libxcb-randr0-dev libxrandr-dev libxcb-xinerama0-dev libxinerama-dev libxcursor-dev libxcb-cursor-dev libxkbcommon-dev xutils-dev xutils-dev libpthread-stubs0-dev libpciaccess-dev libffi-dev x11proto-xext-dev libxcb1-dev libxcb-*dev bison flex libssl-dev libgnutls28-dev x11proto-dri2-dev x11proto-dri3-dev libx11-dev libxcb-glx0-dev libx11-xcb-dev libxext-dev libxdamage-dev libxfixes-dev libva-dev x11proto-randr-dev x11proto-present-dev libclc-dev libelf-dev git build-essential mesa-utils libvulkan-dev ninja-build libvulkan1 python-mako libdrm-dev libxshmfence-dev libxxf86vm-dev python3-mako 
echo ""
echo "STEP 2. Bring OS Up to date... "
echo ""
sudo apt update && sudo apt upgrade -y
echo ""
echo "STEP 3. Install required compiling SW... "
echo ""
sudo apt-get remove meson -y && sudo apt-get autoremove --purge -y && sudo apt-get clean
sudo pip3 install meson
sudo pip3 install mako
sudo apt-get install -y cmake
echo ""
echo "STEP 4. Compiling Driver... "
echo ""
cd $HOME/code/
sudo sed -i 's|#deb-src|deb-src|g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get build-dep mesa -y
sudo sed -i 's|^deb-src|#deb-src|g' /etc/apt/sources.list
sudo rm -rf mesa* 
git clone --branch=20.3 https://gitlab.freedesktop.org/mesa/mesa.git
#git clone https://gitlab.freedesktop.org/apinheiro/mesa.git 
cd mesa
#git checkout wip/igalia/v3dv-conformance-1.0
#CFLAGS="-O3 -march=armv8-a+crc+simd -mtune=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard" CXXFLAGS="-O3 -march=armv8-a+crc+simd -mtune=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard" meson --prefix /usr -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=release build
#meson --prefix /usr --libdir lib -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=debug _build
sed -i "s|'auto', 'x11', 'wayland', 'haiku', 'android', 'windows',|'auto', 'x11', 'wayland', 'drm', 'surfaceless', 'haiku', 'android', 'windows',|" meson_options.txt; 
meson --libdir lib -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=debug -Dprefix=/usr _build
ninja -C _build -j4
sudo ninja -C _build install
echo ""
cd $HOME/code/
#Download & Install MESA DRM
#git clone git://anongit.freedesktop.org/mesa/drm
git clone https://gitlab.freedesktop.org/mesa/drm
cd drm
#RPI4 Specific
meson build --prefix=/usr -Dintel=false -Dradeon=false -Damdgpu=false -Dexynos=false -Dnouveau=false -Dvmwgfx=false -Domap=false -Dfreedreno=false -Dtegra=false -Detnaviv=false -Dvc4=true
ninja -C build
sudo -E ninja -C build install
sudo cp /usr/lib/arm-linux-gnueabihf/libkms.so.1.0.0 /opt/retropie/supplementary/mesa-drm
sudo cp /usr/lib/arm-linux-gnueabihf/libdrm.so.2.4.0 /opt/retropie/supplementary/mesa-drm
cd /opt/retropie/supplementary/mesa-drm
sudo ln -sf libdrm.so.2.4.0 libdrm.so.2
cd $HOME/code/
echo ""
#echo "STEP 5. Set EVVVAR to ensure that a Vulkan program finds the driver... "
#echo ""
#export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/broadcom_icd.armv7l.json
#echo ""
echo "Compile RetroArch with Vulkan Support... "
echo ""
cd $HOME/code/
git clone https://github.com/libretro/RetroArch.git retroarch
sudo sed -i 's|#deb-src|deb-src|g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get build-dep retroarch -y
sudo sed -i 's|^deb-src|#deb-src|g' /etc/apt/sources.list
cd retroarch
./configure --disable-opengl1 --enable-opengles3 --enable-opengles --disable-videocore --enable-udev --enable-kms --enable-x11 --enable-egl --enable-vulkan --disable-sdl --enable-sdl2 --disable-pulse --disable-oss --disable-al --disable-jack --disable-qt
make clean
make -j4
mv retroarch retroarchNEW
sudo cp retroarchNEW /opt/retropie/emulators/retroarch/bin/
cd /opt/retropie/emulators/retroarch/bin
sudo ln -sf retroarchNEW retroarch
#sudo mv /opt/retropie/emulators/retroarch/bin/retroarch /opt/retropie/emulators/retroarch/bin/retroarch.BAK
cd $HOME
echo ""
echo "Demos & Finalizing... "
echo ""
cd $HOME/code/
while true; do
echo ""
read -p 'Whould you like to install few test demos [y] or Reboot [n or r]? ' yn
	case $yn in
	[Yy]* ) if [ ! -d sascha-willems ]; then sudo apt-get install libassimp-dev; cd code; git clone --recursive https://github.com/SaschaWillems/Vulkan.git  sascha-willems; cd sascha-willems; python3 download_assets.py; mkdir build; cd build; cmake -DCMAKE_BUILD_TYPE=Debug  ..; make -j4; mv -v build/bin/* bin/; chmod 755 bin/benchmark-all.py; else echo ""; echo "Directory exists so most probably you compiled before!!!"; fi; echo ""; echo "Script By 2Play!"; echo ""; echo -e 'You can invoke a Vulkan demo to test from the OS desktop.\n- Go to [/home/pi/code/sascha-willems/bin/] and test in there...\nYou can check your driver versions by typing in a Terminal on your OS desktop [glinfo -B]...'; echo ""; read -n 1 -s -r -p "Press any key to reboot"; echo ""; echo "[OK System Will Restart now...]"; clear; sudo reboot;;
    [NnRr]* ) echo ""; echo "Script By 2Play!"; echo ""; echo -e 'You can invoke a Vulkan demo to test from the OS desktop.\n- Start a terminal\n- Go to [/home/pi/code/sascha-willems/bin/] and test in there...\nYou can check your driver versions by typing in a Terminal on your OS desktop [glinfo -B]...'; echo ""; read -n 1 -s -r -p "Press any key to reboot"; echo ""; echo "[OK System Will Restart now...]"; clear; sudo reboot;;
    * ) echo ""; echo "Please answer yes or no.";;
    esac
done
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function mesa_up() {
clear
cd $HOME
if [ ! -d code ]; then
mkdir code && cd code/
else
cd code/
fi
echo ""
echo "STEP 1. Installing Dependencies... "
echo ""
sudo apt-get install -y libxcb-randr0-dev libxrandr-dev libxcb-xinerama0-dev libxinerama-dev libxcursor-dev libxcb-cursor-dev libxkbcommon-dev xutils-dev xutils-dev libpthread-stubs0-dev libpciaccess-dev libffi-dev x11proto-xext-dev libxcb1-dev libxcb-*dev bison flex libssl-dev libgnutls28-dev x11proto-dri2-dev x11proto-dri3-dev libx11-dev libxcb-glx0-dev libx11-xcb-dev libxext-dev libxdamage-dev libxfixes-dev libva-dev x11proto-randr-dev x11proto-present-dev libclc-dev libelf-dev git build-essential mesa-utils libvulkan-dev ninja-build libvulkan1 python-mako libdrm-dev libxshmfence-dev libxxf86vm-dev python3-mako 
echo ""
echo "STEP 2. Bring OS Up to date... "
echo ""
sudo apt update && sudo apt upgrade -y
echo ""
echo "STEP 3. Install required compiling SW... "
echo ""
sudo apt-get remove meson -y && sudo apt-get autoremove --purge -y && sudo apt-get clean
sudo pip3 install meson
sudo pip3 install mako
sudo apt-get install -y cmake
echo ""
echo "STEP 4. Compiling Driver... "
echo ""
cd $HOME/code/
sudo sed -i 's|#deb-src|deb-src|g' /etc/apt/sources.list
sudo apt-get update
sudo apt-get build-dep mesa -y
sudo sed -i 's|^deb-src|#deb-src|g' /etc/apt/sources.list
sudo rm -rf mesa* 
git clone --branch=20.3 https://gitlab.freedesktop.org/mesa/mesa.git
#git clone https://gitlab.freedesktop.org/apinheiro/mesa.git 
cd mesa
#git checkout wip/igalia/v3dv-conformance-1.0
#CFLAGS="-O3 -march=armv8-a+crc+simd -mtune=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard" CXXFLAGS="-O3 -march=armv8-a+crc+simd -mtune=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard" meson --prefix /usr -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=release build
#meson --prefix /usr --libdir lib -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=debug _build
sed -i "s|'auto', 'x11', 'wayland', 'haiku', 'android', 'windows',|'auto', 'x11', 'wayland', 'drm', 'surfaceless', 'haiku', 'android', 'windows',|" meson_options.txt; 
meson --libdir lib -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=debug -Dprefix=/usr _build
ninja -C _build -j4
sudo ninja -C _build install
echo ""
cd $HOME/code/
#Download & Install MESA DRM
#git clone git://anongit.freedesktop.org/mesa/drm
git clone https://gitlab.freedesktop.org/mesa/drm
cd drm
#RPI4 Specific
meson build --prefix=/usr -Dintel=false -Dradeon=false -Damdgpu=false -Dexynos=false -Dnouveau=false -Dvmwgfx=false -Domap=false -Dfreedreno=false -Dtegra=false -Detnaviv=false -Dvc4=true
ninja -C build
sudo -E ninja -C build install
sudo cp /usr/lib/arm-linux-gnueabihf/libkms.so.1.0.0 /opt/retropie/supplementary/mesa-drm
sudo cp /usr/lib/arm-linux-gnueabihf/libdrm.so.2.4.0 /opt/retropie/supplementary/mesa-drm
cd /opt/retropie/supplementary/mesa-drm
sudo ln -sf libdrm.so.2.4.0 libdrm.so.2
cd $HOME/code/
echo ""
clear
echo
echo "[OK DONE!...]"
sleep 1
echo ""
echo "Script By 2Play!"
echo ""
echo -e 'You can invoke a Vulkan demo to test from the OS desktop.\n- Start a terminal\n- Go to [/home/pi/code/sascha-willems/bin/] and test in there...\nYou can check your driver versions by typing in a Terminal on your OS desktop [glinfo -B | less]...'
echo ""
read -n 1 -s -r -p "Press any key to reboot"
echo ""
echo "[OK System Will Restart now...]"
clear
sudo reboot
}

function igalia_dm() {
clear
cd $HOME
if [ ! -d code ]; then
mkdir code && cd code/
else
cd code/
fi
echo ""
echo "Vulkan Demos... "
echo ""
cd $HOME/code/
if [ ! -d sascha-willems ]; then
sudo apt-get install libassimp-dev
git clone --recursive https://github.com/SaschaWillems/Vulkan.git  sascha-willems
cd sascha-willems
python3 download_assets.py
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Debug  ..
make -j4
mv -v build/bin/* bin/
chmod 755 bin/benchmark-all.py
else
echo ""
echo "Directory exists so most probably you compiled before!!!"
fi
echo ""
echo -e 'You can invoke a Vulkan demo to test from the OS desktop.\n- Go to [/home/pi/code/sascha-willems/bin/] and test in there...\nYou can check your driver versions by typing in a Terminal on your OS desktop [glinfo -B]...'
echo ""
read -n 1 -s -r -p "Press any key to continue"
clear
echo
echo "[OK DONE!...]"
sleep 1
}

function vulkan_ra() {
clear
echo ""
echo "Compile RetroArch with Vulkan Support... "
echo ""
cd $HOME
if [ ! -d code ]; then
mkdir code && cd code/
else
cd code/
fi
	if [ ! -d retroarch ]; then
	git clone https://github.com/libretro/RetroArch.git retroarch
	sudo sed -i 's|#deb-src|deb-src|g' /etc/apt/sources.list
	sudo apt-get update &
	sudo apt-get build-dep retroarch -y
	sudo sed -i 's|^deb-src|#deb-src|g' /etc/apt/sources.list
	cd retroarch
	./configure --disable-opengl1 --enable-opengles3 --enable-opengles --disable-videocore --enable-udev --enable-kms --enable-x11 --enable-egl --enable-vulkan --disable-sdl --enable-sdl2 --disable-pulse --disable-oss --disable-al --disable-jack --disable-qt
	make clean
	make -j4
	mv retroarch retroarchNEW
	sudo cp retroarchNEW /opt/retropie/emulators/retroarch/bin/
	cd /opt/retropie/emulators/retroarch/bin
	sudo rm retroarch
	sudo ln -sf retroarchNEW retroarch
	#sudo mv /opt/retropie/emulators/retroarch/bin/retroarch /opt/retropie/emulators/retroarch/bin/retroarch.BAK
	else
	rm -rf retroarch
	igalia_ra
	fi
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function sources_cl() {
	clear
	echo ""
	echo " This will free up to 3.5GB of space..."
	echo ""
	sleep 2
	cd $HOME/code/
	rm -rf retroarch && rm -rf mesa && rm -rf sascha-willems && rm -rf drm
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}


function pikiss_git() {
	clear
	cd $HOME/piKiss/
	echo "Let's pull latest PiKISS updates..."
	echo
	sleep 1
	git fetch
	git reset --hard HEAD
	git merge '@{u}'
	sleep 2 && cd $HOME
	$HOME/piKiss/piKiss.sh
}


function rpc80_saves() {
# Based on RPC80 Single Saves Folder Script
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 23.07.20
	dialog --backtitle "PlayBox Toolkit" \
	--title "RPC80 SINGLE SAVES DIR OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " RPC80 SINGLE SAVES DIR OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Based on original RPC80 Saves Script. Let's do it..." 25 75 20 \
            - "*** RPC80 SINGLE SAVES DIR OPTIONS MENU ***" \
           1 " -  Enable Single Saves Directory" \
           2 " -  Revert Single Saves Directory" \
           2>&1 > /dev/tty)

        case "$choice" in
           1) rpc80_svon  ;;
           2) rpc80_svoff  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}
		
function rpc80_svon() {
clear
################################################################################
# RPC80 SaveFile Script                                                        #
################################################################################
# Author: RPC80                                                                #
# Date: 2018.05.11                                                             #
# Changes by 2Play! 														   # 
# Date: 2020.07.23															   #
################################################################################
# Purpose: Creates a save directory at ~/RetroPie/saves                        #
# and configures all retroarch emulators with their own config files           #
# to store savefiles at ~/RetroPie/saves/{system_name}                         #
# and savestate files at ~/Retropie/saves/{system_name}/states                 #
################################################################################

CONFIGS_DIR=/opt/retropie/configs
CONFIG_FILENAME=retroarch.cfg
SAVES_DIR=~/RetroPie/saves
ROMS_DIR=~/RetroPie/roms

SAVE_FILE_CONFIG="savefile_directory = \"~/RetroPie/saves"
SAVE_STATE_CONFIG="savestate_directory = \"~/RetroPie/saves"

echo "
  ____  ____   ____ ___   ___
 |  _ \|  _ \ / ___( _ ) / _ \\
 | |_) | |_) | |   / _ \| | | |
 |  _ <|  __/| |__| (_) | |_| |
 |_| \_\_|    \____\___/ \___/

"

  # Loop through the configs directory
  for d in ${CONFIGS_DIR}//*; do

      # Get the system/emulator name
      system_name=${d##*/}

      # Skip `all` & `amiga` & symbolic link config folders
      if [[ ${system_name} == 'all' || ${system_name} == 'amiga' || ${system_name} == 'genh' || ${system_name} == 'megh' || ${system_name} == 'moto' || ${system_name} == 'neogeocd' || ${system_name} == 'pce-cd' || ${system_name} == 'snesmsu1' || ${system_name} == 'tg-cd' ]]; then
	    echo "Skipping ${system_name} folder configs"
        continue
      fi

      echo "Checking System Configs for '${system_name}' ..."
      config_file=${CONFIGS_DIR}/${system_name}/${CONFIG_FILENAME}

      if [[ -f ${config_file} ]]; then
        echo "Found config file: ${config_file}"
      else
        echo "No config file found for ${system_name}"
        continue
      fi

      # Create save file directories
      if [ ! -d $SAVES_DIR ]; then
        echo "Creating master saves file directory ${SAVES_DIR} ..."
        mkdir $SAVES_DIR
        if [ $? -ne 0 ] ; then
          echo "[ERROR] Failed to create save file directory: ${SAVE_DIR}"
          exit 1
        else
          echo "[OK] Created save file directory ${SAVES_DIR}"
        fi
      fi
      echo "Creating save file directory for ${system_name} ..."
      mkdir -p ${SAVES_DIR}/${system_name}
      if [ $? -ne 0 ] ; then
        echo "[ERROR] Failed to create save file directory: ${SAVES_DIR}/${system_name}"
        exit 1
      else
        echo "[OK] Created save file directory ${SAVES_DIR}/${system_name}"
      fi
      mkdir -p ${SAVES_DIR}/${system_name}/states
      if [ $? -ne 0 ] ; then
        echo "[ERROR] Failed to create save file directory: ${SAVES_DIR}/${system_name}/states"
        exit 1
      else
        echo "[OK] Created save file directory ${SAVES_DIR}/${system_name}/states"
      fi

      # Check if savefile & savestate config exists
      if grep -E 'savefile_directory|savestate_directory' "${config_file}"; then
        echo "Overwriting configs..."
        sed -i "s|savefile_directory.*|${SAVE_FILE_CONFIG}/${system_name}\"|" "${config_file}"
		sed -i "s|savestate_directory.*|${SAVE_STATE_CONFIG}/${system_name}/states\"|" "${config_file}"
      else
        echo "Writing save configs...!"
		sed -i '/#include "/i \
savefile_directory = \"~/RetroPie/saves/'${system_name}'\" \
savestate_directory = \"~/RetroPie/saves/'${system_name}'/states\" \
<->' "${config_file}"
	  fi
	  
	  # Move existing saves to the master saves rom directory
	  if [[ ! -d daphne ]]; then
	  find "${ROMS_DIR}/${system_name}" -regextype posix-egrep -regex ".*\.(srm|auto|fs|hi)$" -type f -print0 | xargs -0 mv -t "${SAVES_DIR}/${system_name}/"
	  find "${ROMS_DIR}/${system_name}/states" -regextype posix-egrep -regex ".*\.(state[0-9]|state.auto|state)$" -type f -print0 | xargs -0 mv -t "${SAVES_DIR}/${system_name}/states/"
	  fi	
	  
  done
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function rpc80_svoff() {
	dialog --infobox "...Reverting..." 3 20	; sleep 1
	clear
# Check for the existence of the saves directory
  if [ ! -d "$SAVES_DIR" ]; then
    echo "No save file directory. Exiting."
    break
	#continue
  fi

  # Loop through the configs directory
  for d in ${CONFIGS_DIR}//*; do

    # Get the system/emulator name
    system_name=${d##*/}
	
    # Check for existing config file
    config_file=${CONFIGS_DIR}/${system_name}/${CONFIG_FILENAME}

      if [[ -f ${config_file} ]]; then
        echo "Found config file: ${config_file}"
      else
        echo "No config file found for ${system_name}"
        continue
      fi

	  # Check if savefile & savestate config exists
      if grep -E 'savefile_directory|savestate_directory' "${config_file}"; then
      echo "Removing config entries..."
      #sed -i "s|savefile_directory.*||" "${config_file}"
	  #sed -i "s|savestate_directory.*||" "${config_file}"
	  sed -i '/savefile_directory.*/d' "${config_file}"
	  sed -i '/savestate_directory.*/d' "${config_file}"
	  sed -i '/<->.*/d' "${config_file}"
	  fi
	  #find . -type d \( -name all -o -name amiga \) -prune -false -o -name "/opt/retropie/configs/${system_name}/retroarch.cfg" -exec sed -i '/savefile_directory/d' {} 2>/dev/null \;
	  #find . -type d \( -name all -o -name amiga \) -prune -false -o -name "/opt/retropie/configs/${system_name}/retroarch.cfg" -exec sed -i '/savestate_directory/d' {} 2>/dev/null \;
	  
    # Move existing saves to the systems roms directory
      if [[ ! -d daphne ]]; then
	  find "${SAVES_DIR}/${system_name}" -regextype posix-egrep -regex ".*\.(srm|auto|fs|hi)$" -type f -print0 | xargs -0 mv -t "${ROMS_DIR}/${system_name}/"
	  find "${SAVES_DIR}/${system_name}/states" -regextype posix-egrep -regex ".*\.(state[1-9]|state.auto|state)$" -type f -print0 | xargs -0 mv -t "${ROMS_DIR}/${system_name}/states/"
	  find "${SAVES_DIR}/${system_name}/states" -regextype posix-egrep -regex ".*\.(state[1-9]|state.auto|state)$" -type f -print0 | xargs -0 mv -t "/opt/retropie/configs/all/retroarch/states/"
	  fi
	  
  done
	# Delete system saves saves directory
	rm -rf ~/RetroPie/saves/
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1	
}


function strg_bench() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	sudo /home/pi/PlayBox-Setup/.pb-fixes/_scripts/storage_bench.sh
}


function omxvol() {
	clear
# OMXPlayer Volume Control By 2Play! 
# 23.07.20

    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " OMXPlayer VOLUME MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Please Set OMXPlayer Volume:" 25 75 20 \
            - "*** OMXPlayer VOLUME CONTROL SELECTIONS ***" \
            - "" \
			1 " - Set to 90%" \
			2 " - Set to 85%" \
			3 " - Set to 80%" \
			4 " - Set to 75%" \
            5 " - Set to 70%" \
            6 " - Set to 60%" \
            7 " - Set to 50%" \
            8 " - Set to 25%" \
            9 " - Set to 100% (Default - Reset)" \
            10 " - Set to 0% (Mute)" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) omx90  ;;
			2) omx85  ;;
			3) omx80  ;;
			4) omx75  ;;
            5) omx70  ;;
            6) omx60  ;;
            7) omx50  ;;
            8) omx25  ;;
            9) omx100  ;;
           10) omx0  ;;
            -) none ;;
            *)  break ;;
        esac
    done
}

function omx90() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g; s/$OMXPLAYER_BIN/$OMXPLAYER_BIN --vol -600/g' /usr/bin/omxplayer
}

function omx85() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g; s/$OMXPLAYER_BIN/$OMXPLAYER_BIN --vol -900/g' /usr/bin/omxplayer
}

function omx80() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g; s/$OMXPLAYER_BIN/$OMXPLAYER_BIN --vol -1200/g' /usr/bin/omxplayer
}

function omx75() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g; s/$OMXPLAYER_BIN/$OMXPLAYER_BIN --vol -1500/g' /usr/bin/omxplayer
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function omx70() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g; s/$OMXPLAYER_BIN/$OMXPLAYER_BIN --vol -1750/g' /usr/bin/omxplayer
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function omx60() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g; s/$OMXPLAYER_BIN/$OMXPLAYER_BIN --vol -2400/g' /usr/bin/omxplayer
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function omx50() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g; s/$OMXPLAYER_BIN/$OMXPLAYER_BIN --vol -3000/g' /usr/bin/omxplayer
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function omx25() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g; s/$OMXPLAYER_BIN/$OMXPLAYER_BIN --vol -4500/g' /usr/bin/omxplayer
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function omx100() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g' /usr/bin/omxplayer
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function omx0() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	 sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g; s/$OMXPLAYER_BIN/$OMXPLAYER_BIN --vol -6000/g' /usr/bin/omxplayer
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}
#	$HOME/PlayBox-Setup/.pb-fixes/_scripts/omxvol.sh


function emus_compile() {
# Emulators Custom Compile By 2Play! 
# 04.01.21
	clear
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " EMULATORS COMPILE MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Choose the custom emulator you want to compile and apply..." 25 75 20 \
            - "*** EMULATORS COMPILE MENU SELECTIONS ***" \
			- "	" \
			1 "Amiberry Pi Compile and Update From GitHub" \
			2 "PPSSPP Pi Compile and Update From GitHub" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) amiberry_git  ;;
            2) ppsspp_git  ;;
			-) none ;;
			*)  break ;;
        esac
    done
}

function amiberry_git() {
	clear
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " AMIBERRY SOURCE UPDATE MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which amiberry binary you want to compile & install?" 25 75 20 \
            - "*** AMIBERRY SOURCE UPDATE SELECTIONS ***" \
			1 "Amiberry :  Pi4" \
			2 "Amiberry :  Pi4 SDL2" \
			3 "Amiberry :  Pi4 x64" \
			- "" \
            - "*** If you compiled 1 & 2 use below to swap between them! ***" \
			4 "Amiberry :  Pi4      - Swap To This Binary" \
			5 "Amiberry :  Pi4 SDL2 - Swap To This Binary" \
			- "" \
			- "*** Restore Last Known Stable Amiberry! ***" \
			6 "Amiberry :  Latest Knows Stable Binary" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) amiberry_pi4  ;;
            2) amiberry_pi4sdl2  ;;
			3) amiberry_pi4x64  ;;
			4) amiberry_pi4swap  ;;
			5) amiberry_pi4sdl2swap  ;;
			6) amiberry_stable  ;;
			-) none ;;
            *)  break ;;
        esac
    done
}

function amiberry_pi4() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd $HOME && cd code
	rm -rf amiberry*
	git clone https://github.com/midwan/amiberry.git
	#git clone --branch=dev https://github.com/midwan/amiberry.git amiberry_dev
	#cd amiberry_dev
	cd amiberry
	make clean
	git pull
	make -j4 PLATFORM=rpi4
	#make -j4 PLATFORM=rpi3
	#make PLATFORM=rpi1
	clear
	sudo cp amiberry /opt/retropie/emulators/amiberry/amiberryrpi4
	rm -rf amiberry*
	cd /opt/retropie/emulators/amiberry/
	sudo chmod 755 amiberryrpi4
	sudo ln -sfn amiberryrpi4 amiberry
	cd $HOME
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function amiberry_pi4sdl2() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd $HOME && cd code
	rm -rf amiberry*
	git clone https://github.com/midwan/amiberry.git
	#git clone --branch=dev https://github.com/midwan/amiberry.git amiberry_dev
	#cd amiberry_dev
	cd amiberry
	make clean
	git pull
	make -j4 PLATFORM=rpi4-sdl2
	#make -j4 PLATFORM=rpi3-sdl2
	#make PLATFORM=rpi1-sdl2
	clear
	sudo cp amiberry /opt/retropie/emulators/amiberry/amiberryrpi4SDL2
	rm -rf amiberry*
	cd /opt/retropie/emulators/amiberry/
	sudo chmod 755 amiberryrpi4SDL2
	sudo ln -sfn amiberryrpi4SDL2 amiberry
	
	cd $HOME
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function amiberry_pi4x64() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd $HOME && cd code
	rm -rf amiberry*
	git clone https://github.com/midwan/amiberry.git
	#git clone --branch=dev https://github.com/midwan/amiberry.git amiberry_dev
	#cd amiberry_dev
	cd amiberry
	make clean
	git pull
	make -j4 PLATFORM=pi64
	clear
	sudo cp amiberry /opt/retropie/emulators/amiberry/amiberryrpi4x64
	rm -rf amiberry*
	cd /opt/retropie/emulators/amiberry/
	sudo chmod 755 amiberryrpi4x64
	sudo ln -sfn amiberryrpi4x64 amiberry
	cd $HOME
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function amiberry_pi4swap() {
	clear
	cd /opt/retropie/emulators/amiberry/
	sudo ln -sfn amiberryrpi4 amiberry
	cd $HOME
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function amiberry_pi4sdl2swap() {
	clear
	cd /opt/retropie/emulators/amiberry/
	sudo ln -sfn amiberryrpi4SDL2 amiberry
	cd $HOME
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function amiberry_stable() {
	clear
	cd /opt/retropie/emulators/amiberry/
	sudo ln -sfn amiberry-rpi4-3.2b05.08.20 amiberry
	cd $HOME
	echo
	echo "[OK DONE!...]"
	sleep 1
}


function ppsspp_git() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd $HOME && cd code
	git clone --recurse-submodules https://github.com/hrydgard/ppsspp.git
	cd ppsspp
	./b.sh --rpi	
	echo "[COMPILE COMPLETE!...]"
	sudo cp build/PPSSPPSDL /opt/retropie/emulators/ppsspp/PPSSPPSDL
	rm -rf ppsspp
	cd $HOME
	echo
	echo "[OK DONE!...]"
	sleep 1
}


function emus_tks() {
clear
# Emulators Extra Tweaks/Automations By 2Play! 
# 06.12.20
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " EMULATOR TWEAKS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Apply the tweak(s) you need..." 25 75 20 \
            - "*** EMULATOR TWEAKS SELECTIONS ***" \
			- "	" \
			1 " -  Virtual Boy Core: 3D Anaglyph Display Options " \
			2 " -  GameBoy Core: Original or Enhanced GameBoy Display Options " \
			3 " -  PPSSPP: Standalone Emulator EXIT To ES or Menu " \
			4 " -  N64 Lr-Core: Set Native Resolution to LowRes or HiRes " \
			5 " -  Lr-PUAE Amiga Model Selection Options  " \
			2>&1 > /dev/tty)

        case "$choice" in
            1) vboy_3d  ;;
            2) gboy_enh  ;;
			3) ppsspp_exit  ;;
            4) n64_res  ;;
			5) amiga_models  ;;
			-) none ;;
            *)  break ;;
        esac
    done
}

function vboy_3d() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "VIRTUALBOY CORE OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " VIRTUALBOY CORE OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's apply your favorable choice..." 25 75 20 \
            - "*** VIRTUALBOY CORE SELECTIONS ***" \
			- "	" \
           1 " -  Disable PlayBox 3D Anaglyph Display Options " \
           2 " -  Enable PlayBox 3D Anaglyph Display Options " \
           2>&1 > /dev/tty)

        case "$choice" in
           1) vb_3d_off  ;;
           2) vb_3d_on  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function vb_3d_off() {
	clear
	cd /opt/retropie/configs/virtualboy
	sed -i "s|^vb_anaglyph_preset|#vb_anaglyph_preset|" retroarch-core-options.cfg;
	sed -i "s|^vb_3dmode|#vb_3dmode|" retroarch-core-options.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function vb_3d_on() {
	clear
	cd /opt/retropie/configs/virtualboy
	sed -i "s|^vb_anaglyph_preset|vb_anaglyph_preset|" retroarch-core-options.cfg;
	sed -i "s|^vb_3dmode|vb_3dmode|" retroarch-core-options.cfg;
	sed -i "s|#vb_anaglyph_preset|vb_anaglyph_preset|" retroarch-core-options.cfg;
	sed -i "s|#vb_3dmode|vb_3dmode|" retroarch-core-options.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function gboy_enh() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "GAMEBOY CORE OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " GAMEBOY CORE OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's apply your favorable choice..." 25 75 20 \
            - "*** GAMEBOY CORE SELECTIONS ***" \
			- "	" \
           1 " -  Enable GameBoy Original (B/W) Display Graphics " \
           2 " -  Enable GameBoy Enhanced (CLR) Display Graphics " \
           2>&1 > /dev/tty)

        case "$choice" in
           1) gb_bw_on  ;;
           2) gb_clr_on  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function gb_bw_on() {
	clear
	cd /opt/retropie/configs/gb
	sed -i 's|sameboy_model = "Super Game Boy"|sameboy_model = "Auto"|' retroarch-core-options.cfg;
	sed -i "s|gb_sameboy.cfg|gb.cfg|" retroarch.cfg;
	sed -i 's|custom_viewport_width = "1243"|custom_viewport_width = "665"|' retroarch.cfg;
	sed -i 's|custom_viewport_height = "1080"|custom_viewport_height = "610"|' retroarch.cfg;
	sed -i 's|custom_viewport_x = "339"|custom_viewport_x = "629"|' retroarch.cfg;
	sed -i 's|custom_viewport_y = "0"|custom_viewport_y = "235"|' retroarch.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function gb_clr_on() {
	clear
	cd /opt/retropie/configs/gb
	sed -i 's|sameboy_model = "Auto"|sameboy_model = "Super Game Boy"|' retroarch-core-options.cfg;
	sed -i "s|gb.cfg|gb_sameboy.cfg|" retroarch.cfg;
	sed -i 's|custom_viewport_width = "665"|custom_viewport_width = "1243"|' retroarch.cfg;
	sed -i 's|custom_viewport_height = "610"|custom_viewport_height = "1080"|' retroarch.cfg;
	sed -i 's|custom_viewport_x = "629"|custom_viewport_x = "339"|' retroarch.cfg;
	sed -i 's|custom_viewport_y = "235"|custom_viewport_y = "0"|' retroarch.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function ppsspp_exit() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "PPSSPP STANDALONE EMULATOR OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " PPSSPP STANDALONE EMULATOR OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's apply your favorable choice..." 25 75 20 \
            - "*** PPSSPP STANDALONE EMULATOR SELECTIONS ***" \
			- "	" \
           1 " -  Enable PPSSPP EXIT to ES Instead The Emulator Menu " \
           2 " -  Disable PPSSPP EXIT to ES And Show The Emulator Menu " \
           2>&1 > /dev/tty)

        case "$choice" in
           1) ppsspp_ex_on  ;;
           2) ppsspp_ex_off  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function ppsspp_ex_on() {
	clear
	cd /opt/retropie/configs/psp
	sed -i 's|--fullscreen %ROM%|--fullscreen --escape-exit %ROM%|' emulators.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function ppsspp_ex_off() {
	clear
	cd /opt/retropie/configs/psp
	sed -i 's|--fullscreen --escape-exit %ROM%|--fullscreen %ROM%|' emulators.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function n64_res() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "N64 CORE LOW OR HIGH RESOLUTION OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " N64 CORE LOW OR HIGH RESOLUTION OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's apply your favorable choice..." 25 75 20 \
            - "*** N64 CORE LOW OR HIGH RESOLUTION OPTIONS MENU SELECTIONS ***" \
			- "	" \
           1 " -  Set Native Low-Res (320x240) To N64 Lr-Core " \
           2 " -  Set Native Hi-Res (640x480) To N64 Lr-Core " \
           2>&1 > /dev/tty)

        case "$choice" in
           1) n64_lr_on  ;;
           2) n64_hr_on  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function n64_lr_on() {
	clear
	cd /opt/retropie/configs/n64
	sed -i 's|mupen64plus-43screensize = "640x480"|mupen64plus-43screensize = "320x240"|' retroarch-core-options.cfg;
	sed -i 's|mupen64plus-next-43screensize = "640x480"|mupen64plus-next-43screensize = "320x240"|' retroarch-core-options.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function n64_hr_on() {
	clear
	cd /opt/retropie/configs/n64
	sed -i 's|mupen64plus-43screensize = "320x240"|mupen64plus-43screensize = "640x480"|' retroarch-core-options.cfg;
	sed -i 's|mupen64plus-next-43screensize = "320x240"|mupen64plus-next-43screensize = "640x480"|' retroarch-core-options.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}


function amiga_models() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "AMIGA MODELS OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " AMIGA MODELS OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select The Amiga Model You Want to Use For..." 25 75 20 \
            - "*** AMIGA AGA SYSTEM MODEL OPTIONS MENU SELECTIONS ***" \
			- "	" \
           1 " -  Set Amiga 1200 (2MB Chip RAM + 8MB Fast RAM) " \
           2 " -  Set Amiga 4000/040 (2MB Chip RAM + 8MB Fast RAM) " \
		   - "	" \
		   - "*** AMIGA MAIN SYSTEM OPTIONS MENU SELECTIONS ***" \
			- "	" \
           3 " -  Set Amiga Main System To AUTO (If You Place All Roms in Amiga Roms Folder " \
           4 " -  Set Amiga 500+ (1MB Chip RAM) " \
           2>&1 > /dev/tty)

        case "$choice" in
           1) A1200_on  ;;
           2) A4040_on  ;;
		   3) A_Auto_on  ;;
           4) A_500+_on  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function A1200_on() {
	clear
	cd /opt/retropie/configs/amiga1200
	sed -i 's|puae_model = "A4040"|puae_model = "A1200"|' retroarch-core-options.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function A4040_on() {
	clear
	cd /opt/retropie/configs/amiga1200
	sed -i 's|puae_model = "A1200"|puae_model = "A4040"|' retroarch-core-options.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function A_Auto_on() {
	clear
	cd /opt/retropie/configs/amiga
	sed -i 's|puae_model = "A500+"|puae_model = "Auto"|' retroarch-core-options.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function A_500+_on() {
	clear
	cd /opt/retropie/configs/amiga
	sed -i 's|puae_model = "Auto"|puae_model = "A500+"|' retroarch-core-options.cfg;
	cd $HOME
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}


function clean_pbt() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "CLEANUP TOOLS OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " CLEANUP TOOLS OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's do some cleanup..." 25 75 20 \
            - "*** PLAYBOX CLEANUP TOOLS SELECTIONS ***" \
			- "	" \
           1 " -  Clean all save, hi, dat etc files in roms folder" \
           2 " -  Clean LastPlayed & PlayCount or Favorites Options" \
           3 " -  Remove ES Auto-gen Gamelists" \
		   4 " -  Clean & Set 2Play! Top CLi Commands History" \
           5 " -  Clean Filesystem Cache" \
            2>&1 > /dev/tty)

        case "$choice" in
           1) cl_saves  ;;
           2) cl_xml  ;;
		   3) cl_es_gamelist  ;;
		   4) cl_cli_hist  ;;
           5) cl_cache  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function cl_saves() {
	dialog --infobox "...Cleaning..." 3 20 ; sleep 1
	clear
	find $HOME/RetroPie/roms/ -regextype posix-egrep -regex ".*\.(srm|auto|state.auto|fs|ldci|hi)$" -type f -delete
	find $HOME/RetroPie/roms/daphne/ -regextype posix-egrep -regex ".*\.(srm|auto|state.auto|fs|hi|ldci|dat)$" -type f -delete
	find $HOME/RetroPie/saves/ -regextype posix-egrep -regex ".*\.(srm|auto|state.auto|fs|hi|ldci|dat)$" -type f -delete
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}


function cl_xml() {
	clear
	#echo "We need to exit ES..."
	#echo "Once you are done manually reboot system..."
	#echo
	#read -n 1 -s -r -p "Press any key to continue..." 
	#ps -ef | awk '/emulation/ {print $2}' | xargs kill
	#sudo killall emulationstation
	#clear
# Clear AutoLastPlayed & PlayCount or Favorites Script
# Original code by tanstaafl
# Updated code and Multi script by 2Play!
# 03.07.20

infobox=""
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}Clear AutoLastPlayed & PlayCount or Favorites Script\n\n"
infobox="${infobox}\n"
infobox="${infobox}You can automatically clear the AutoLastPlayed & PlayCount or Favorites tag from all your gamelist.xml's\n"
infobox="${infobox}\n\n"
infobox="${infobox}Option 1:\n - Clear AutoLastPlayed & PlayCount in Gamelists"
infobox="${infobox}\n\n"
infobox="${infobox}Option 2:\n - Clear Favorites in Gamelists"
infobox="${infobox}\n"
infobox="${infobox}\n"

dialog --backtitle "PlayBox Toolkit" \
--title "GAMELIST TAGS & FAVS CLEAN UP MENU" \
--msgbox "${infobox}" 35 110

    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " GAMELIST TAGS & FAVS CLEAN UP MENU " \
            --ok-label OK --cancel-label Back \
            --menu "What action would you like to perform?" 25 75 20 \
            - "*** CLEANUP AUTO-LISTS SELECTIONS ***" \
            1 " - Clear AutoLastPlayed & PlayCount" \
            - "" \
            - "*** CLEANUP FAVORITES SELECTIONS ***" \
            2 " - Clear Favorites" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) clear_ALP_PC  ;;
            2) clear_FAV  ;;
            -)  none ;;
            *) break ;;
        esac
    done
}

function clear_ALP_PC() {
	dialog --infobox "...Clearing..." 3 20 ; sleep 2
clear
if [ -d $HOME/addonusb ]; then
echo 
echo "The External USB is enabled..."
echo
sleep 2
echo
	for f in $HOME/addonusb/roms/**/gamelist.xml
	do
	echo "file: $f"
	grep -e lastplayed -e playcount -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo
	echo "[OK DONE!...]"
	sleep 2
	for f in $HOME/addonusb/roms/ports/**/gamelist.xml
	do
	echo "file: $f"
	grep -e lastplayed -e playcount -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo
	echo "[OK DONE!...]"
	sleep 2
	for f in $HOME/RetroPie/localroms/**/gamelist.xml
	do
	echo "file: $f"
	grep -e lastplayed -e playcount -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo "[OK DONE!...]"
	sleep 2
	for f in $HOME/RetroPie/localroms/ports/**/gamelist.xml
	do
	echo "file: $f"
	grep -e lastplayed -e playcount -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo
	echo "[OK DONE!...]"
	sleep 2	
else
echo 
echo "The External USB is disabled..."
echo
sleep 2
echo
	for f in $HOME/RetroPie/roms/**/gamelist.xml
	do
	echo "file: $f"
	grep -e lastplayed -e playcount -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo "[OK DONE!...]"
	sleep 2
	for f in $HOME/RetroPie/roms/ports/**/gamelist.xml
	do
	echo "file: $f"
	grep -e lastplayed -e playcount -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo
	echo "[OK DONE!...]"
	sleep 2
	for f in /opt/retropie/configs/all/emulationstation/gamelists/**/gamelist.xml
	do
	echo "file: $f"
	grep -e lastplayed -e playcount -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo
	echo "[OK DONE!...]"
	sleep 2
fi
clear
echo
read -n 1 -s -r -p "Press any key to reboot"
echo
echo "[OK System Will Restart now...]"
clear
sudo reboot
}

function clear_FAV() {
	dialog --infobox "...Clearing..." 3 20 ; sleep 2
clear
if [ -d $HOME/addonusb ]; then
echo 
echo "The External USB is enabled..."
echo
sleep 2
echo
	for f in $HOME/addonusb/roms/**/gamelist.xml
	do
	echo "file: $f"
	grep -e "favorite>" -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo "[OK DONE!...]"
	sleep 2
	for f in $HOME/addonusb/roms/ports/**/gamelist.xml
	do
	echo "file: $f"
	grep -e "favorite>" -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo
	echo "[OK DONE!...]"
	sleep 2
	for f in $HOME/RetroPie/localroms/**/gamelist.xml
	do
	echo "file: $f"
	grep -e "favorite>" -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo "[OK DONE!...]"
	sleep 2
	for f in $HOME/RetroPie/localroms/ports/**/gamelist.xml
	do
	echo "file: $f"
	grep -e "favorite>" -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo
	echo "[OK DONE!...]"
	sleep 2	
else
echo 
echo "The External USB is disabled..."
echo
sleep 2
echo
	for f in $HOME/RetroPie/roms/**/gamelist.xml
	do
	echo "file: $f"
	grep -e "favorite>" -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo "[OK DONE!...]"
	sleep 2
	for f in $HOME/RetroPie/roms/ports/**/gamelist.xml
	do
	echo "file: $f"
	grep -e "favorite>" -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo
	echo "[OK DONE!...]"
	sleep 2
	for f in /opt/retropie/configs/all/emulationstation/gamelists/**/gamelist.xml
	do
	echo "file: $f"
	grep -e "favorite>" -v $f > "$f.tmp"
	mv -f "$f.tmp" $f
	done
	echo
	echo "[OK DONE!...]"
	sleep 2
fi
clear
echo
read -n 1 -s -r -p "Press any key to reboot"
echo
echo "[OK System Will Restart now...]"
clear
sudo reboot
}

function cl_es_gamelist() {
	dialog --infobox "...Please Wait..." 3 22 ; sleep 1
	clear
	#echo "We need to exit ES..."
	#echo "Once you are done manually reboot system..."
	#echo
	#read -n 1 -s -r -p "Press any key to continue..." 
	#ps -ef | awk '/emulation/ {print $2}' | xargs kill
	#clear
	echo
	echo " This script will remove all the auto generated EmulationStation gamelists."
	echo
	echo " They are located in this path /opt/retropie/configs/all/emulationstation/gamelists/"
	echo
	echo " EXCEPT the retropie/options one that handles the retropiemenu."
	echo
	sleep 3
	find /opt/retropie/configs/all/emulationstation/gamelists/ -type f -name '*.xml' ! -path "/opt/retropie/configs/all/emulationstation/gamelists/retropie/*" -exec rm {} \;
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}


function cl_cli_hist() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	#cat /dev/null > ~/.bash_history
	history -cw && clear
	#cp $HOME/PlayBox-Setup/.pb-fixes/cli/.bash_history $HOME/
	cd $HOME
	sed -i '1i***Welcome to PlayBox, 2Play!***\nsudo raspi-config\nSkyscraper\nstartx\nsudo ~/RetroPie-Setup/retropie_setup.sh\nemulationstation\n2p-FixPlayBox' .bash_history
	sed -i '8,1000d' .bash_history
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}


function cl_cache() {
	dialog --infobox "...Cleaning..." 3 20 ; sleep 1
	clear
	sudo apt-get clean
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}



function sys_pbt() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "SYSTEMS OPTIONS MENU" \
	
    local choice
    
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " SYSTEM OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Get to know your System..." 25 75 20 \
            - "*** PLAYBOX SYSTEM TOOLS SELECTIONS ***" \
			- "	" \
		   1 " -  Force A Filesystem Check At Next Boot " \
           2 " -  Show Partitions & Space Info" \
		   3 " -  Show Folders Size [home/pi]" \
           4 " -  Show System Free Memory Info" \
           5 " -  Show OS Version & Info" \
           6 " -  System & FW Update Options" \
           7 " -  System Full Info" \
		   8 " -  Monitor In Real Time Board Temperature" \
		   9 " -  Show CPU Cores Status" \
		  10 " -  Ratio Video Tool Options" \
		   2>&1 > /dev/tty)

        case "$choice" in
           1) fschk_bt  ;;
           2) partitions  ;;
		   3) fold_sz  ;;
           4) freemem  ;;
           5) os_info  ;;
           6) os_update  ;;
           7) sysinfo  ;;
		   8) temp_rt  ;;
		   9) cores_status  ;;
		  10) ratio_vt  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function fschk_bt() {
	dialog --infobox "...Please Wait..." 3 22 ; sleep 1
	clear
	echo
	echo "Please be patient..."
	echo "Screen will go black, Pi's green activity led will be on while filsystem check. Once completed your system will reboot as normal."
	sleep 5
	sudo touch /forcefsck && sudo reboot
}


function partitions() {
	dialog --infobox "...Checking..." 3 20 ; sleep 1
	clear
	df -h
	echo
	read -n 1 -s -r -p "Press any key to continue"
}


function fold_sz() {
	dialog --infobox "...Checking..." 3 20 ; sleep 1
	clear
	#With Subfolders
	du -h | sort -hr | column | more -d
	#Only Top Folder Names
	#du -h --max-depth=1 | sort -hr | column | more -d
	echo
	read -n 1 -s -r -p "Press any key to continue"
}


function freemem() {
	dialog --infobox "...Checking..." 3 20 ; sleep 1
	clear
	free mem
	echo
	read -n 1 -s -r -p "Press any key to continue"
}


function os_info() {
	dialog --infobox "...Checking..." 3 20 ; sleep 2
	clear
	uname -snrmo
	lsb_release -ds
	echo
	read -n 1 -s -r -p "Press any key to continue..."
}


function os_update() {
	clear
# SYSTEM Update Options Script by 2Play!
# 30.08.20

infobox=""
infobox="${infobox}\n"
infobox="${infobox}MULTIPLE OPTIONS:\n\nOption 1 is preferred for complete OS update/upgrade.\nOption 2 is classic update & upgrade.\n\n"
infobox="${infobox}Firmware-Kernel Upgrade is optional to apply and will upgrade to a beta/experminental firmware and kernel. It has it's pros n cons.\nIf it breaks things you can use option 4 to revert back to the last stable supported kernel (tested on non Pi4 boards).\n\nFor Pi4 there are options in #📜guides-tips discord section if you want to downgrade\n\n*** So always take a backup before your do a Firmware-Kernel Upgrade!!!***\n\n                       YOU HAVE BEEN WARNED."
infobox="${infobox}\n                  IT WILL REBOOT AFTER UPDATING."
infobox="${infobox}\n"


dialog --backtitle "PlayBox Toolkit" \
--title "OS & FIRMWARE UPDATE MENU" \
--msgbox "${infobox}" 35 110

    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " OS & FIRMWARE UPDATE MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's update & upgrade your system!" 25 75 20 \
            - "*** OS UPDATING SELECTIONS ***" \
            1 " - OS Package List Update & Distro System Upgrade" \
            2 " - OS Package List Update & Full Upgrade" \
            - "" \
            - "*** FIRMWARE UPDATING SELECTIONS ***" \
            3 " - Pi Firmware Check or Upgrade" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) update_distro  ;;
            2) update_os  ;;
            3) fw_pi  ;;
            -) none ;;
            *) break ;;
        esac
    done
}

#dist-upgrade in addition to performing the function of upgrade, also intelligently handles changing dependencies with new versions of packages; apt-get has a "smart" conflict resolution system,and it will attempt to upgrade the most important packages at the expense of less important ones if necessary. The dist-upgrade command may therefore remove some packages. The /etc/apt/sources.list file contains a list of locations from which to retrieve desired package files. See also apt_preferences(5) for a mechanism for overriding the general settings for individual packages.
function update_distro() {
	dialog --infobox "...Please wait until updates completed!..." 3 47 ; sleep 2
	clear
	sudo apt-get update -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove --purge && sudo apt-get clean
	clean
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK] Rebooting Raspberry Pi ... "
	sudo reboot
}

#full-upgrade performs the function of upgrade but will remove currently installed packages if this is needed to upgrade the system as a whole.
function update_os() {
	dialog --infobox "...Please wait until updates completed!..." 3 47 ; sleep 2
	clear
	sudo apt-get update -y && sudo apt full-upgrade -y && sudo apt-get autoremove --purge && sudo apt-get clean
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK] Rebooting Raspberry Pi ... "
	sudo reboot
}


function fw_pi() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "FIRMWARE OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " FIRMWARE OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's check or upgrade your firmware!" 25 75 20 \
            - "*** Pi4 FIRMWARE OPTIONS ***" \
            1 " - Set To STABLE Firmware" \
            2 " - Set To CRITICAL Firmware" \
			3 " - Set To BETA Firmware" \
            - "" \
            - "*** EXPERIMENTAL FIRMWARE (RPI-UPDATE) SELECTIONS ***" \
            4 " - Experimental Firmware & Kernel Upgrade - All RPi Boards" \
            5 " - Revert to Last STABLE Firmware For NON Pi4 Boards" \
            - "" \
            - "*** Pi4 FIRMWARE VERSION/INFO & UPDATE ***" \
            6 " - Show Current Bootloader Version & Configuration" \
			7 " - Verify If A New Available Firmware Version" \
			8 " - Update Official/Published Firmware" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) fw_st  ;;
            2) fw_ct  ;;
            3) fw_bt  ;;
            4) fw_exp  ;;
            5) fw_down  ;;
			6) fw_pi4  ;;
			7) fwe_pi4  ;;
			8) fwup_pi4  ;;
            -) none ;;
            *) break ;;
        esac
    done
}
	
function fw_st() {
	dialog --infobox "...Please wait!..." 3 23 ; sleep 2
	clear
	sudo sed -i -e '/STATUS/s/beta/stable/g; /STATUS/s/critical/stable/g' /etc/default/rpi-eeprom-update
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function fw_ct() {
	dialog --infobox "...Please wait!..." 3 23 ; sleep 2
	clear
	sudo sed -i -e '/STATUS/s/beta/critical/g; /STATUS/s/stable/critical/g' /etc/default/rpi-eeprom-update
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function fw_bt() {
	dialog --infobox "...Please wait!..." 3 23 ; sleep 2
	clear
	sudo sed -i -e '/STATUS/s/stable/beta/g; /STATUS/s/critical/beta/g' /etc/default/rpi-eeprom-update
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function fw_exp() {
	dialog --infobox "...Please wait until updates completed!..." 3 47 ; sleep 2
	clear
	sudo sudo apt update -y && sudo apt upgrade -y && sudo rpi-update
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

function fw_down() {
	dialog --infobox "...Please wait until updates completed!..." 3 47 ; sleep 2
	clear
	sudo apt-get update -y; sudo apt-get install --reinstall raspberrypi-bootloader raspberrypi-kernel
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

function fw_pi4() {
	dialog --infobox "...Checking..." 3 19 ; sleep 2
	clear
	echo
	echo "- Bootloader Current Version:"
	vcgencmd bootloader_version
	echo
	echo "- Bootloader Current Configuration:"
	vcgencmd bootloader_config
	echo
	read -n 1 -s -r -p "Press any key to continue..."
}

function fwe_pi4() {
	dialog --infobox "...Checking..." 3 19 ; sleep 2
	clear
	echo "Let's make sure you have latest update..."
	sleep 2
	sudo apt update && sudo apt upgrade -y
	sleep 2
	echo
	echo
	sudo rpi-eeprom-update
	echo
	read -n 1 -s -r -p "Press any key to continue..."
}

function fwup_pi4() {
	dialog --infobox "...Setting..." 3 18 ; sleep 2
	clear
	echo "Let's make sure you have latest update..."
	sleep 2
	sudo apt update && sudo apt upgrade -y
	sleep 2
	echo
	echo
	sudo rpi-eeprom-update -a
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}
#	$HOME/PlayBox-Setup/.pb-fixes/retropiemenu/System/update.sh	
#	sleep 3


function sysinfo() {
	dialog --infobox "...Please Wait..." 3 22 ; sleep 1
# 11.07.2020
	clear
let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((${upSeconds}%60))
let mins=$((${upSeconds}/60%60))
let hours=$((${upSeconds}/3600%24))
let days=$((${upSeconds}/86400))
UPTIME=`printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs"`

echo "
        $(tput setaf 1)__________.__                 $(tput setaf 7)__________
        $(tput setaf 1)\______   \  | _____   ___.__.$(tput setaf 7)\______   \ ________  ___
        $(tput setaf 1) |     ___/  | \__  \ <   |  | $(tput setaf 7)|    |  _//  _  \  \/  /
        $(tput setaf 1) |    |   |  |__/ __ \ \___  | $(tput setaf 7)|    |   (  <_>  >    <
        $(tput setaf 1) |____|   |____(____  )/ ____| $(tput setaf 7)|______  /\_____/__/\_ \ 
        $(tput setaf 1)                    \/ \/      $(tput setaf 7)       \/             \/
                                                      By $(tput setaf 1)2$(tput setaf 7)Play!
		$(tput setaf 2)
`uname -srmo` - `lsb_release -ds`

`date +"%A, %e %B %Y, %r"`
Uptime    : ${UPTIME}
Last Login: `exec -- last | head -1`
$(tput setaf 7)
...SYSTEM INFO...$(tput setaf 3)
                            Size 	Used	Avail 	Used%
SD Boot         Partition: `df -h | grep '/dev/mmcblk0p1' | awk '{print " "$2,"	"$3," 	"$4," 	 "$5}'`
SD/USB Root     Partition: `df -h | grep '/dev/root' 	 | awk '{print " "$2,"	"$3,"	"$4," 	 "$5}'`
Ext-USB/USBBoot Partition: `df -h | grep '/dev/sda1' 	 | awk '{print " "$2,"	"$3,"	"$4," 	 "$5}'`
$(tput setaf 1)
$(tput setaf 7)`grep Model /proc/cpuinfo`

$(tput setaf 1)SoC Temperature : `exec -- /home/pi/PlayBox-Setup/.pb-fixes/_scripts/temperature.sh`
CPU `grep Hardware /proc/cpuinfo` - `lscpu | grep "Model name"`
CPU Max Speed   : `lscpu | grep max`
GPU Version     : `exec -- /opt/vc/bin/vcgencmd version`
$(tput setaf 6)
Memory            : `cat /proc/meminfo | grep MemFree | awk '{printf( "%.2f\n", $2 / 1024 )}'`MB (Free) / `cat /proc/meminfo | grep MemTotal | awk '{printf( "%.2f\n", $2 / 1024 )}'`MB (Total)
Running Processes : `ps ax | wc -l | tr -d " "`
Local & Public IP : `hostname -I`and `curl -4 icanhazip.com 2>/dev/null | awk '{print $NF; exit}'`
$(tput setaf 7)"
echo
read -n 1 -s -r -p "Press any key to continue"
#$HOME/PlayBox-Setup/.pb-fixes/_scripts/2play_sysinfo.sh
}


function temp_rt() {
	dialog --infobox "...[Press <CTRL+C> to Exit]..." 3 36 ; sleep 5
	clear
	watch -t $HOME/PlayBox-Setup/.pb-fixes/_scripts/temperature.sh 
}


function cores_status() {
	dialog --infobox "...Checking..." 3 20 ; sleep 1
	clear
	cat /sys/devices/system/cpu/online
	echo
	read -n 1 -s -r -p "Press any key to continue"
}


function ratio_vt() {
#VIDEO+ RATIO & RESOLUTION By 2Play!
# 08.10.2020

infobox=""
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}You can choose between various forced screen resolutions and ratio.\n\n"
infobox="${infobox}To match your monitor or screen native resolution you can run CEA or DMT option and apply as needed.\nIf you need a new setting just post on my discord #🙋questions-and-answers channel... \n\n"
infobox="${infobox}*** Keep in mind that any resolution other than 1080p will require relative overlays (if used) or themes. ***\n"
infobox="${infobox}\n"

dialog --backtitle "VIDEO+ RATIO & RESOLUTION" \
--title "VIDEO+ RATIO & RESOLUTION" \
--msgbox "${infobox}" 35 110

# Config file path
CONFIG_PATH=/boot/config.txt

# HDMI settings description
HDMI_DESCRIPTION="#uncomment to enable custom HDMI group settings"

declare -a HDMI_SETTINGS_CEA=(
  "hdmi_group=1"
)
declare -a HDMI_SETTINGS_DMT=(
  "hdmi_group=2"
)

    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " VIDEO RATIO & RESOLUTION MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Choose your Custom System Ratio Resolution:" 25 75 20 \
            - "*** GENERAL SELECTIONS ***" \
           V1 " - LIST CONNECTED DISPLAY DEVICES " \
		   V2 " - SHOW YOUR HDMI 0&1 STATUS (Resolution etc.) " \
		   A1 " - SHOW YOUR SUPPORTED (HDMI 0&1) AUDIO INFORMATION " \
		  CEA " - SHOW YOUR SUPPORTED MODES (HDMI 0&1) FOR THIS GROUP " \
		  DMT " - SHOW YOUR SUPPORTED MODES (HDMI 0&1) FOR THIS GROUP " \
			- "" \
			- "*** HDMI PORT [4:3] SELECTIONS ***" \
        1:CEA " - VGA     640x480   60Hz   [4:3] " \
		2:CEA " - 480p    720x480   60Hz   [4:3] " \
		3:CEA " - 576p    720x576   50Hz   [4:3] " \
        4:DMT " - SVGA    800x600   60Hz   [4:3] " \
        5:DMT " - XGA    1024x768   60Hz   [4:3] " \
		6:DMT " - SXGA   1280x960   60Hz   [4:3] " \
            - "" \
            - "*** HDMI PORT [16:9] SELECTIONS ***" \
		7:CEA " - 480p    720x480   60Hz  [16:9] " \
		8:CEA " - 576p    720x576   50Hz  [16:9] " \
		9:CEA " - 720p   1280x720   60Hz  [16:9] " \
	   10:CEA " - 720p   1280x720   50Hz  [16:9] " \
	   11:CEA " - 1080p 1920x1080   60Hz  [16:9] " \
	   12:CEA " - 1080p 1920x1080   50Hz  [16:9] " \
	   13:CEA " - 2160p 3840x2160   60Hz  [16:9] " \
	   14:DMT " - 720p   1280x720   60Hz  [16:9] " \
       15:DMT " - 1080p 1920x1080   60Hz  [16:9] " \
	        - "" \
            - "*** HDMI PORT [x:x] SELECTIONS ***" \
       16:DMT " - SXGA   1280x1024  60Hz   [5:4] " \
       17:DMT " - WXGA+  1440x900   60Hz [16:10] " \
	   18:DMT " - WSXGA+ 1680x1050  60Hz [16:10] " \
	   19:CEA " - 1080p  1920x1080  60Hz [64:27] " \
	   20:CEA " - 1080p  1920x1080  50Hz [64:27] " \
	   21:DMT " - CUSTOM .NOTxSET.  60Hz [xx:xx] " \
	        - "" \
            - "*** SDTV - COMPOSITE VIDEO PORT SELECTIONS ***" \
            - "*** Default values are: NTSC & [4:3] No Change ***" \
       22:STD " - Composite Video Port Mode   JP NTSC " \
       23:STD " - Composite Video Port Mode   PAL " \
       24:STD " - Composite Video Port Mode   Brazil PAL " \
       25:STR " - Composite Video Port Ratio  [14:9] " \
       26:STR " - Composite Video Port Ratio  [16:9] " \
            - "" \
            - "*** DISABLE HDMI SELECTIONS ***" \
       27:ALL " - Disable Any CEA/DMT HDMI or STDTV Setting Applied " \
            2>&1 > /dev/tty)
			
        case "$choice" in
           V1) list_dvc ;;
		   V2) hdmi_stat ;;
		   A1) audio_inf ;;
		  CEA) sup_cea ;;
		  DMT) sup_dmt ;;
		1:CEA) enable_vr 1 ;;
        2:CEA) enable_vr 2 ;;
		3:CEA) enable_vr 17 ;;
		4:DMT) enable_vrd 9 ;;
        5:DMT) enable_vrd 16 ;;
        6:DMT) enable_vrd 32 ;;
        7:CEA) enable_vr 3 ;;
		8:CEA) enable_vr 18 ;;
		9:CEA) enable_vr 4 ;;
       10:CEA) enable_vr 19 ;;
       11:CEA) enable_vr 16 ;;
	   12:CEA) enable_vr 31 ;;
	   13:CEA) enable_vr 97 ;;
       14:DMT) enable_vrd 85 ;;
       15:DMT) enable_vrd 82 ;;
	   16:DMT) enable_vrd 35 ;;
	   17:DMT) enable_vrd 47 ;;
	   18:DMT) enable_vrd 58 ;;
	   19:CEA) enable_vr 76 ;;
	   20:CEA) enable_vr 75 ;;
	   21:DMT) enable_vrdcX 87 ;;
       22:STD) enable_sdtvm 1 ;;
       23:STD) enable_sdtvm 2 ;;
       24:STD) enable_sdtvm 3 ;;
       25:STR) enable_sdtvr 2 ;;
       26:STR) enable_sdtvr 3 ;;
       27:ALL) disable_vrALL ;;
	        -) none ;;
            *) break ;;
        esac
    done
}

# List all attached devices
function list_dvc() {
	clear
	tvservice -l
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
}

# Show HDMI Status
function hdmi_stat() {
	clear
	echo
	echo "HDMI 0:"
	echo
	tvservice -s
	echo
	echo "*******************************************"
	echo
	echo "HDMI 1:"
	echo
	tvservice -v 7 -s
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
}

# Show Supported Audio Information
function audio_inf() {
	clear
	echo
	echo "HDMI 0:"
	echo
	tvservice -a
	echo
	echo "*******************************************"
	echo
	echo "HDMI 1:"
	echo
	tvservice -v 7 -a
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
}

# Supported CEA Modes
function sup_cea() {
	clear
	echo
	echo "HDMI 0:"
	echo
	tvservice --modes=CEA
	echo
	echo "*******************************************"
	echo
	echo "HDMI 1:"
	echo
	tvservice -v 7 --modes=CEA
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
}

# Supported DMT Modes
function sup_dmt() {
	clear
	echo
	echo "HDMI 0:"
	echo
	tvservice --modes=DMT
	echo
	echo "*******************************************"
	echo
	echo "HDMI 1:"
	echo
	tvservice -v 7 --modes=DMT
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
}

# Enables a custom standard CEA ratio & resolution.
function enable_vr() {
  #dialog --infobox "...Applying..." 3 20 ; sleep 2
  sudo sed -i "s|^hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
  sudo sed -i "s|^hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
  sudo sed -i "s|^hdmi_cvt=|#hdmi_cvtX=|" "${CONFIG_PATH}";
  sudo sed -i "s|#hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
  sudo sed -i "s|#hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
  sudo sed -i "s|#hdmi_cvt=|#hdmi_cvtX=|" "${CONFIG_PATH}";
  sudo sed -i "s|^sdtv_mode=|#sdtv_mode=|" "${CONFIG_PATH}";
  sudo sed -i "s|^sdtv_aspect=|#sdtv_aspect=|" "${CONFIG_PATH}";
  	  for val in ${HDMI_SETTINGS_CEA[@]}; do
		if grep -q "#${val}" ${CONFIG_PATH}; then
		  sudo sed -i "s|#${val}|${val}|" "${CONFIG_PATH}";
		fi
	  done
	  for val in ${HDMI_SETTINGS_DMT[@]}; do
		sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
	  done
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

# Enables a custom standard DMT ratio & resolution.
function enable_vrd() {
  #dialog --infobox "...Applying..." 3 20 ; sleep 2
  sudo sed -i "s|^hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
  sudo sed -i "s|^hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
  sudo sed -i "s|^hdmi_cvt=|#hdmi_cvtX=|" "${CONFIG_PATH}";
  sudo sed -i "s|#hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
  sudo sed -i "s|#hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
  sudo sed -i "s|#hdmi_cvt=|#hdmi_cvtX=|" "${CONFIG_PATH}";
  sudo sed -i "s|^sdtv_mode=|#sdtv_mode=|" "${CONFIG_PATH}";
  sudo sed -i "s|^sdtv_aspect=|#sdtv_aspect=|" "${CONFIG_PATH}";
  	  for val in ${HDMI_SETTINGS_DMT[@]}; do
		if grep -q "#${val}" ${CONFIG_PATH}; then
		  sudo sed -i "s|#${val}|${val}|" "${CONFIG_PATH}";
		fi
	  done
	  for val in ${HDMI_SETTINGS_CEA[@]}; do
		sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
	  done
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

# Defines the TV standard used for composite video output over the yellow RCA jack to NTSC or PAL.
function enable_sdtvm() {
  #dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo sed -i "s|^hdmi_mode=|#hdmi_mode=|" "${CONFIG_PATH}";
	sudo sed -i "s|^hdmi_ignore_edid=0xa5000080|#hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
	sudo sed -i "s|^hdmi_cvt=|#hdmi_cvtX=|" "${CONFIG_PATH}";
	  for val in ${HDMI_SETTINGS_CEA[@]}; do
		sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
	  done
	  for val in ${HDMI_SETTINGS_DMT[@]}; do
		sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
	  done
	sudo sed -i "s|^sdtv_mode=.*|sdtv_mode=$1|" "${CONFIG_PATH}";
	sudo sed -i "s|#sdtv_mode=.*|sdtv_mode=$1|" "${CONFIG_PATH}";
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

# Defines the TV standard used for composite video output over the yellow RCA jack to forced ratio either (Default) 4:3 or 16:9.
function enable_sdtvr() {
  #dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo sed -i "s|^hdmi_mode=|#hdmi_mode=|" "${CONFIG_PATH}";
	sudo sed -i "s|^hdmi_ignore_edid=0xa5000080|#hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
	sudo sed -i "s|^hdmi_cvt=|#hdmi_cvtX=|" "${CONFIG_PATH}";
	  for val in ${HDMI_SETTINGS_CEA[@]}; do
		sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
	  done
	  for val in ${HDMI_SETTINGS_DMT[@]}; do
		sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
	  done
	sudo sed -i "s|^sdtv_aspect=.*|sdtv_aspect=$1|" "${CONFIG_PATH}";
	sudo sed -i "s|#sdtv_aspect=.*|sdtv_aspect=$1|" "${CONFIG_PATH}";
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

# Enables a custom non standard DMT ratio & resolution option X Example cvt9 in config.txt
function enable_vrdcX() {
  #dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo sed -i "s|^hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
	sudo sed -i "s|^hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
	sudo sed -i "s|^hdmi_cvtX=|hdmi_cvt=|" "${CONFIG_PATH}";
	sudo sed -i "s|#hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
	sudo sed -i "s|#hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
	sudo sed -i "s|#hdmi_cvtX=|hdmi_cvt=|" "${CONFIG_PATH}";
	sudo sed -i "s|^sdtv_mode=|#sdtv_mode=|" "${CONFIG_PATH}";
	sudo sed -i "s|^sdtv_aspect=|#sdtv_aspect=|" "${CONFIG_PATH}";
	  for val in ${HDMI_SETTINGS_DMT[@]}; do
		if grep -q "#${val}" ${CONFIG_PATH}; then
		  sudo sed -i "s|#${val}|${val}|" "${CONFIG_PATH}";
		fi
	  done
	  for val in ${HDMI_SETTINGS_CEA[@]}; do
		sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
	  done
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

# Disables ALL custom CEA & DMT or STDTV resolutions & ratio
function disable_vrALL() {
  #dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo sed -i "s|^hdmi_mode=|#hdmi_mode=|" "${CONFIG_PATH}";
	sudo sed -i "s|^hdmi_ignore_edid=0xa5000080|#hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
	sudo sed -i "s|^hdmi_cvt=|#hdmi_cvtX=|" "${CONFIG_PATH}";
	sudo sed -i "s|^sdtv_mode=|#sdtv_mode=|" "${CONFIG_PATH}";
    sudo sed -i "s|^sdtv_aspect=|#sdtv_aspect=|" "${CONFIG_PATH}";
	  for val in ${HDMI_SETTINGS_CEA[@]}; do
		sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
	  done
	  for val in ${HDMI_SETTINGS_DMT[@]}; do
		sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
	  done
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo
	read -n 1 -s -r -p "Press any key to reboot"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}


function thankyou_pb() {
	#dialog --infobox "...Please Wait..." 3 22 ; sleep 1
	clear
	$HOME/PlayBox-Setup/.pb-fixes/_scripts/thankyou.sh
}


function update_pbs() {
	#dialog --infobox "...Updating..." 3 20 ; sleep 1
	clear
	cd $HOME/PlayBox-Setup
	chmod 755 .pb-fixes/retropiemenu/fixplaybox.sh
	echo
	echo "Let's pull latest PlayBox-Setup updates..."
	echo
	sleep 1
	git fetch
	git reset --hard HEAD
	#git reset --hard && git clean -f -d
	git merge '@{u}'
	sleep 2
	echo
	find -name "*.sh" ! -name "joystick_selection.sh" -print0 | xargs -0 chmod 755
	find -name "*.py" -print0 | xargs -0 chmod 755
	find -name "*.rp" ! -name "raspiconfig.rp" ! -name "rpsetup.rp" | xargs sudo chown root:root
	rm $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Emulation/joystick_selection.sh
	ln -s /opt/retropie/supplementary/joystick-selection/joystick_selection.sh .pb-fixes/retropiemenu/Emulation/joystick_selection.sh
	rm -rf /home/pi/PlayBox-Setup/.pb-fixes/music
	/home/pi/PlayBox-Setup/.pb-fixes/_scripts/post-fixes.sh
	cd $HOME
	fix_rpmenu
	#printf "Sleeping 3 seconds before reloading PlayBox ToolKit\n" &&
	#sleep 3 &&
	#exec 2p-FixPlayBox
}


function poff_pb() {
	dialog --infobox "...Shutting Down..." 3 23 ; sleep 1
	clear
	echo
	echo "[OK System Will Shutdown now...]"
	clear
	sudo shutdown -P now
}

function restart_pb() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}


function template() {
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

main_menu
