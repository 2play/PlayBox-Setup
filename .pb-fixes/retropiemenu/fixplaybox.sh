#!/bin/bash
# All required fixes in case you break something 
# Fix retropiemenu, es_systems.cfg etc.
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# PlayBox ToolKit

pb_version="Version 2.0 Dated 05.10.2020"

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
            5 " -  CREDITS - THANK YOU!" \
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
			3 " -  Hide or Show a System" \
            4 " -  Repair JukeBox/PlayBox-Kodi/RPi-OS/PieGalaxy/Steam Systems" \
            5 " -  Repair PlayBox BGM Mute File" \
            6 " -  Restore 2Play! Original Music Selections" \
            7 " -  Restore 2Play! Original Slideshow Images Set" \
            8 " -  Reset All RetroPie Controllers" \
            9 " -  Fix-Reset-Clean RetroPie Setup git" \
           10 " -  4K TV Fix ON - Force 1080p Thoughout" \
           11 " -  4K TV Fix OFF - Disable 1080p Thoughout" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) fix_rpmenu  ;;
            2) fix_region  ;;
            3) fix_hd_sh_sys  ;;
			4) fix_roms  ;;
            5) fix_bgm_py  ;;
            6) fix_music  ;;
            7) fix_slideshow  ;;
            8) fix_control  ;;
            9) git_rs  ;;
           10) fs1080p  ;;
           11) fs1080p_off  ;;
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
#	sudo rm -rf /etc/emulationstation/themes/carbon/
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
# 25.06.2020

infobox=""
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}Systems & Theme Options Based on Region, by 2Play!\n\n"
infobox="${infobox}\n"
infobox="${infobox}This script will set some systems basis your region of preference.\n"
infobox="${infobox}- The US\JP Region will use Genesis, Sega 32X/CD, TG16/CD, Odyssey2 systems.\n"
infobox="${infobox}- The EU\JP Region will use Mega Drive, Mega 32X/CD, PC Engine/CD, VideoPac systems.\n"
infobox="${infobox}- The ALL Region will use all systems as per initial intention.\n"
infobox="${infobox}\n"
infobox="${infobox}- The extra 3 options as above but with clean Kodi (Lite Version) instead PlayBox (Full Version)."
infobox="${infobox}\n"

dialog --backtitle "Region based ES Systems" \
--title "PLAYBOX SYSTEMS BASED ON REGION" \
--msgbox "${infobox}" 35 110

    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " REGION MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select the REGION setup you want to apply..." 25 75 20 \
            - "*** REGION + PLAYBOX & 2Play! SYSTEMS ***" \
            1 " - US\JP: Genesis, SegaCD, TG16\CD, Odyssey2" \
            2 " - EU\JP: Mega Drive, MegaCD, PC Engine\CD, Videopac" \
            3 " - ALL:   All systems will be enabled" \
            - "" \
            - "*** REGION + KODI & MOST COMMON SYSTEMS ***" \
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

function fix_hd_sh_sys() {
	clear
# Hide a System or RetroPie Menu Script by 2Play!
# 01.07.20

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

function fix_music() {
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MUSIC SELECTION MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select the type of music you would like to apply." 25 75 20 \
            - "*** PLAYBOX 2Play! MUSIC SELECTIONS ***" \
			- "" \
            1 "I want to listen to 2Play!'s Selection" \
            2 "I want to listen to nice Royalty Free Tracks" \
            3 "I want to listen to a mix of both!" \
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
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/music/synthpop/* $HOME/RetroPie/localroms/music
	else
	rm -rf $HOME/RetroPie/roms/music/*
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/music/synthpop/* $HOME/RetroPie/roms/music
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
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/music/royalfree/* $HOME/RetroPie/localroms/music
	else
	rm -rf $HOME/RetroPie/roms/music/*
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/music/royalfree/* $HOME/RetroPie/roms/music
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
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/music/synthpop/* $HOME/RetroPie/localroms/music && rsync -avh $HOME/PlayBox-Setup/.pb-fixes/music/royalfree/* $HOME/RetroPie/localroms/music
	else
	rm -rf $HOME/RetroPie/roms/music/*
	rsync -avh $HOME/PlayBox-Setup/.pb-fixes/music/synthpop/* $HOME/RetroPie/roms/music && rsync -avh $HOME/PlayBox-Setup/.pb-fixes/music/royalfree/* $HOME/RetroPie/roms/music
	fi
	echo
	echo "[OK System Will Restart now...]"
	sleep 3
	clear
	sudo reboot
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

function fs1080p() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	clear
	echo
	echo "Let's force 1080p on your 4K TV. It takes a second and your system will reboot."
	sleep 3
	sudo sed -i 's/#hdmi_ignore_edid=0xa5000080/hdmi_ignore_edid=0xa5000080/g; s/#hdmi_group=1/hdmi_group=1/g; s/#hdmi_mode=76/hdmi_mode=76/g;' /boot/config.txt && sudo reboot
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
}

function fs1080p_off() {
	dialog --infobox "...Applying..." 3 20 ; sleep 1
	clear
	echo
	echo "Let's disable forced 1080p on your 4K TV. It takes a second and your system will reboot."
	sleep 3
	sudo sed -i 's/hdmi_ignore_edid=0xa5000080/#hdmi_ignore_edid=0xa5000080/g; s/hdmi_group=1/#hdmi_group=1/g; s/hdmi_mode=76/#hdmi_mode=76/g;' /boot/config.txt && sudo reboot
	clear
	echo
	echo "[OK DONE!...]"
	sleep 2
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
			2 " -  Skyscraper By Lars Muldjord" \
			3 " -  Single Saves Directory By RPC80" \
			4 " -  Vulkan Igalia Driver" \
			5 " -  OMXPlayer Volume Control Script" \
			6 " -  SD/USB Storage Benchmark" \
			7 " -  Enable-Disable Marquees Setup" \
			8 " -  Amiberry Compile and Update From GitHub" \
			9 " -  Swap Gamelist View on 2Play! Themes " \
		   10 " -  PiKISS By Jose Cerrejon" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) prntscr  ;;
			2) skyscraper  ;;
			3) rpc80_saves  ;;
			4) igalia_vk  ;;
			5) omxvol  ;;
			6) strg_bench  ;;
			7) pimarquees  ;;
			8) amiberry_git  ;;
			9) swap_theme_view ;;
		   10) pikiss_git  ;;
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
	  #find \( -name all -prune -name amiga -prune \) -o -name "/opt/retropie/configs/${system_name}/retroarch.cfg" -exec sed -i '/savefile_directory/d' {} 2>/dev/null \;
	  #find \( -name all -prune -name amiga -prune \) -o -name "/opt/retropie/configs/${system_name}/retroarch.cfg" -exec sed -i '/savestate_directory/d' {} 2>/dev/null \;
	  
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



function igalia_vk() {
# Install Pi Igalia Mesa Vulkan Driver
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 23.07.20
	dialog --backtitle "PlayBox Toolkit" \
	--title "IGALIA VULKAN OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " IGALIA VULKAN OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's do some Vulkan work..." 25 75 20 \
            - "*** IGALIA VULKAN OPTIONS MENU ***" \
           1 " -  Install/Update All [Driver, Extras, RetroArch]" \
           2 " -  Update Vulkan Driver" \
           3 " -  Install/Update Vulkan Demos" \
		   4 " -  Install/Update Vulkan Enabled RetroArch" \
           5 " -  CleanUp Source Folders" \
            2>&1 > /dev/tty)

        case "$choice" in
           1) igalia_all  ;;
           2) igalia_up  ;;
		   3) igalia_dm  ;;
		   4) igalia_ra  ;;
           5) igalia_cl  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function igalia_all() {
# Install Pi Igalia Mesa Vulkan Driver
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 23.07.20
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
sudo apt-get remove meson && sudo apt-get autoremove --purge -y && sudo apt-get clean
sudo pip3 install meson
sudo pip3 install mako
sudo apt-get install -y cmake
echo ""
echo "STEP 4. Compiling Driver... "
echo ""
cd $HOME/code/
sudo rm -rf mesa* 
git clone https://gitlab.freedesktop.org/apinheiro/mesa.git mesa
cd mesa
git checkout wip/igalia/v3dv
#CFLAGS="-O3 -march=armv8-a+crc+simd -mtune=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard" CXXFLAGS="-O3 -march=armv8-a+crc+simd -mtune=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard" meson --prefix /usr -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=release build
meson --prefix /usr --libdir lib -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=debug _build
ninja -C _build -j4
sudo ninja -C _build install
echo ""
#echo "STEP 5. Set EVVVAR to ensure that a Vulkan program finds the driver... "
#echo ""
#export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/broadcom_icd.armv7l.json
#echo ""
echo "Compile RetroArch with Vulkan Support... "
echo ""
cd $HOME/code/
git clone https://github.com/libretro/RetroArch.git retroarch
apt-get build-dep retroarch
cd retroarch
./configure --disable-opengl1 --enable-opengles3 --enable-opengles --disable-videocore --enable-udev --enable-kms --enable-x11 --enable-egl --enable-vulkan --disable-sdl --enable-sdl2 --disable-pulse --disable-oss --disable-al --disable-jack --disable-qt
make clean
make -j4
sudo mv /opt/retropie/emulators/retroarch/bin/retroarch /opt/retropie/emulators/retroarch/bin/retroarch.BAK
sudo cp retroarch /opt/retropie/emulators/retroarch/bin/
sudo chmod	755 /opt/retropie/emulators/retroarch/bin/retroarch
echo ""
echo "Demos & Finalizing... "
echo ""
cd $HOME/code/
while true; do
echo ""
read -p 'Whould you like to install few test demos [y] or Reboot [n or r]? ' yn
	case $yn in
	[Yy]* ) if [ ! -d sascha-willems ]; then sudo apt-get install libassimp-dev; cd code; git clone --recursive https://github.com/SaschaWillems/Vulkan.git  sascha-willems; cd sascha-willems; python3 download_assets.py; mkdir build; cd build; cmake -DCMAKE_BUILD_TYPE=Debug  ..; make -j4; mv -v build/bin/* bin/; chmod 755 bin/benchmark-all.py; else echo ""; echo "Directory exists so most probably you compiled before!!!"; fi; echo ""; echo "Driver By Igalia, Script By 2Play!"; echo ""; echo -e 'You can invoke a Vulkan demo to test from the OS desktop.\n- Go to [/home/pi/code/sascha-willems/bin/] and test in there...\nYou can check your driver versions by typing in a Terminal on your OS desktop [glinfo -B]...'; echo ""; read -n 1 -s -r -p "Press any key to reboot"; echo ""; echo "[OK System Will Restart now...]"; clear; sudo reboot;;
    [NnRr]* ) echo ""; echo "Driver By Igalia, Script By 2Play!"; echo ""; echo -e 'You can invoke a Vulkan demo to test from the OS desktop.\n- Start a terminal\n- Go to [/home/pi/code/sascha-willems/bin/] and test in there...\nYou can check your driver versions by typing in a Terminal on your OS desktop [glinfo -B]...'; echo ""; read -n 1 -s -r -p "Press any key to reboot"; echo ""; echo "[OK System Will Restart now...]"; clear; sudo reboot;;
    * ) echo ""; echo "Please answer yes or no.";;
    esac
done
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function igalia_up() {
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
sudo apt-get remove meson && sudo apt-get autoremove --purge -y && sudo apt-get clean
sudo pip3 install meson
sudo pip3 install mako
sudo apt-get install -y cmake
echo ""
echo "STEP 4. Compiling Driver... "
echo ""
cd $HOME/code/
sudo rm -rf mesa* 
git clone https://gitlab.freedesktop.org/apinheiro/mesa.git mesa
cd mesa
git checkout wip/igalia/v3dv
#CFLAGS="-O3 -march=armv8-a+crc+simd -mtune=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard" CXXFLAGS="-O3 -march=armv8-a+crc+simd -mtune=cortex-a72 -mfpu=neon-fp-armv8 -mfloat-abi=hard" meson --prefix /usr -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=release build
meson --prefix /usr --libdir lib -Dplatforms=x11,drm -Dvulkan-drivers=broadcom -Ddri-drivers= -Dgallium-drivers=v3d,kmsro,vc4 -Dbuildtype=debug _build
ninja -C _build -j4
sudo ninja -C _build install
	echo ""
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
	echo ""
	echo "Driver By Igalia, Script By 2Play!"
	echo ""
	echo -e 'You can invoke a Vulkan demo to test from the OS desktop.\n- Start a terminal\n- Go to [/home/pi/code/sascha-willems/bin/] and test in there...\nYou can check your driver versions by typing in a Terminal on your OS desktop [glinfo -B]...'
	echo ""
	read -n 1 -s -r -p "Press any key to reboot"
	echo ""
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

function igalia_dm() {
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

function igalia_ra() {
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
	apt-get build-dep retroarch
	cd retroarch
	./configure --disable-opengl1 --enable-opengles3 --enable-opengles --disable-videocore --enable-udev --enable-kms --enable-x11 --enable-egl --enable-vulkan --disable-sdl --enable-sdl2 --disable-pulse --disable-oss --disable-al --disable-jack --disable-qt
	make clean
	make -j4
	sudo mv /opt/retropie/emulators/retroarch/bin/retroarch /opt/retropie/emulators/retroarch/bin/retroarch.BAK
	sudo cp retroarch /opt/retropie/emulators/retroarch/bin/
	sudo chmod	755 /opt/retropie/emulators/retroarch/bin/retroarch
	else
	rm -rf retroarch
	igalia_ra
	fi
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
}

function igalia_cl() {
	echo ""
	echo " This will free up about 3.5GB of space..."
	echo ""
	sleep 2
	cd code/
	rm -rf retroarch && rm -rf mesa && rm -rf sascha-willems
	clear
	echo
	echo "[OK DONE!...]"
	sleep 1
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

function strg_bench() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	sudo /home/pi/PlayBox-Setup/.pb-fixes/_scripts/storage_bench.sh
}

function pimarquees() {
	clear
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " Marquees " \
            --ok-label OK --cancel-label Exit \
            --menu "Which fix or action would you like to apply?" 25 75 20 \
            1 "Enable :  Marquees" \
            2 "Disable:  Marquees" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) marquees_on  ;;
            2) marquees_off  ;;
            *)  break ;;
        esac
    done
}

function marquees_on() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	echo
	echo "Ok PiMarquee will be enabled and then reboot..."
	sleep 3
	if grep "#/home/pi/scripts/themerandom.sh" /opt/retropie/configs/all/autostart.sh; then
	sed -i 's/#//' /opt/retropie/configs/all/autostart.sh
	sed -i 's\/home/pi/scripts/themerandom.sh\#/home/pi/scripts/themerandom.sh\' /opt/retropie/configs/all/autostart.sh
	else
	sed -i 's/#//' /opt/retropie/configs/all/autostart.sh
	fi
	echo
	echo "[OK System Will Restart now...]"
	sudo reboot
}

function marquees_off() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	echo "Ok PiMarquee will be disabled and then reboot..."
	sleep 3
	if grep "#/home/pi/scripts/themerandom.sh" /opt/retropie/configs/all/autostart.sh; then
	sed -i 's|fbset|#fbset|' /opt/retropie/configs/all/autostart.sh
	sed -i 's|isdual|#isdual|' /opt/retropie/configs/all/autostart.sh
	sed -i 's|if|#if|' /opt/retropie/configs/all/autostart.sh
	sed -i 's|/usr|#/usr|' /opt/retropie/configs/all/autostart.sh
	sed -i 's|fi|#fi|' /opt/retropie/configs/all/autostart.sh
	fi
	echo
	echo "[OK System Will Restart now...]"
	sudo reboot
}
function amiberry_git() {
	clear
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " Amiberry GitHub Source " \
            --ok-label OK --cancel-label Exit \
            --menu "Which amiberry binary you want to compile & install?" 25 75 20 \
            1 "Amiberry :  Pi4" \
			2 "Amiberry :  Pi4 SDL2" \
			3 "Amiberry :  Pi4 x64" \
			- "" \
            - "*** If you compiled 1 & 2 use below to swap between them! ***" \
			4 "Amiberry :  Pi4 - Swap To This Binary" \
			5 "Amiberry :  Pi4 SDL2 - Swap To This Binary" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) amiberry_pi4  ;;
            2) amiberry_pi4sdl2  ;;
			3) amiberry_pi4x64  ;;
			4) amiberry_pi4swap  ;;
			5) amiberry_pi4sdl2swap  ;;
            *)  break ;;
        esac
    done
}

function amiberry_pi4() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd $HOME && cd code && cd amiberry
	make clean
	git pull
	make -j2 PLATFORM=rpi4
	#make -j2 PLATFORM=rpi3
	#make PLATFORM=rpi1
	clear
	sudo cp amiberry /opt/retropie/emulators/amiberry/amiberryrpi4
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
	cd $HOME && cd code && cd amiberry
	make clean
	git pull
	make -j2 PLATFORM=rpi4-sdl2
	#make -j2 PLATFORM=rpi3-sdl2
	#make PLATFORM=rpi1-sdl2
	clear
	sudo cp amiberry /opt/retropie/emulators/amiberry/amiberryrpi4SDL2
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
	cd $HOME && cd code && cd amiberry
	make clean
	git pull
	make -j2 PLATFORM=pi64
	clear
	sudo cp amiberry /opt/retropie/emulators/amiberry/amiberryrpi4x64
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

function swap_theme_view() {
	clear
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " Amiberry GitHub Source " \
            --ok-label OK --cancel-label Exit \
            --menu "Which gamelist view would you like to apply on my themes?" 25 75 20 \
            1 "Single Window Art:  Image and then Video" \
			2 "Dual Window Art  :  Image Under Gamelist + Big Video" \
			3 "Dual Window Art  :  Full Gamelist, Image Next to Video" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) single_art  ;;
            2) dual_art_hz  ;;
			3) dual_art_vrt  ;;
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
	sed -i '1i***Welcome to PlayBox, 2Play!***\nsudo raspi-config\nSkyscraper\nstartx\nsudo reboot\nsudo halt\nsudo ~/RetroPie-Setup/retropie_setup.sh\nemulationstation\n2p-FixPlayBox' .bash_history
	sed -i '10,1000d' .bash_history
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
	echo "Screen will go black, pi's green activity led will be on while filsystem check. Once completed your system will reboot as normal."
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
            6 " - Current Bootloader Version & Configuration" \
			7 " - Verify Firmware Version" \
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
                  Size	Used	Avail 	Used%
Boot Partition  : `df -h | grep '/dev/mmcblk0p1' | awk '{print $2,"	"$3,"	"$4," 	"$5}'`
Root Partition  : `df -h | grep '/dev/root' | awk '{print " "$2,"	"$3,"	"$4," 	"$5}'`
USB  Partition  : `df -h | grep '/dev/sda1' | awk '{print " "$2,"	"$3,"	"$4," 	"$5}'`
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
	git merge '@{u}'
	sleep 2
	echo
	find -name "*.sh" ! -name "joystick_selection.sh" -print0 | xargs -0 chmod 755
	find -name "*.py" -print0 | xargs -0 chmod 755
	find -name "*.rp" ! -name "raspiconfig.rp" ! -name "rpsetup.rp" | xargs sudo chown root:root
	rm $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Emulation/joystick_selection.sh
	ln -s /opt/retropie/supplementary/joystick-selection/joystick_selection.sh .pb-fixes/retropiemenu/Emulation/joystick_selection.sh
	rm -rf /home/pi/PlayBox-Setup/.pb-fixes/music/synthpop
	ln -s $HOME/Music/synthpop /home/pi/PlayBox-Setup/.pb-fixes/music/synthpop
	rm -rf /home/pi/PlayBox-Setup/.pb-fixes/music/royalfree
	ln -s $HOME/Music/royalfree /home/pi/PlayBox-Setup/.pb-fixes/music/royalfree
	cd $HOME
	exit
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
