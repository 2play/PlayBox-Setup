#!/usr/bin/env bash
# Python BGM script by Rydra inspired from original concept script of Livewire
# The PlayBox Project
# Copyright (C)2018-2024 2Play! (S.R.)
# 09.2023

infobox= ""
infobox="${infobox}\n"
infobox="${infobox}Install Background Music\n\n"
infobox="${infobox}This script will install and setup background music for you.\n"
infobox="${infobox}	NOTE: Your system will reboot after removal or Install of Background Music\n"
infobox="${infobox}Just copy your mp3 files to the 'music' directory in your roms directory. Or use PlayBox Toolkit to enable one of the selections.\n"
infobox="${infobox}Once installed you can adjust the volume to your liking with this script as well.\n"
infobox="${infobox}There is also a 'Music On/Off' script to your default RetropieMenu so you can mute the music off or on at will.\n\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox} BGM Script by Rydra inspired from original concept script of Livewire & Custom by 2Play!\n"
infobox="${infobox}\n"

dialog --backtitle "Background Music Livewire/Rydra - 2Play!" \
--title "Background Music Script" \
--msgbox "${infobox}" 23 80

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " BACKGROUND MUSIC MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            - "*** BACKGROUND MUSIC SELECTIONS ***" \
            1 " - Remove/Disable Background Music " \
            2 " - Set Background Music Volume - Only after installed " \
            3 " - Clean Install Background Music " \
            2>&1 > /dev/tty)

        case "$choice" in
            1) remove_bgm  ;;
            2) vol_menu  ;;
            3) install_bgm  ;;
            -) none  ;;
            *)  break ;;
        esac
    done
}

function remove_bgm() {
	echo
	echo "STEP: Removing BGM..."
	sleep 3
	#mv ~/RetroPie/roms/music ~/RetroPie/roms/music.OFF
	curl -sSL https://raw.githubusercontent.com/2play/bgm-for-es/main/scripts/install-esbgm.py > install-esbgm.py
python3 install-esbgm.py --uninstall
	sleep 2
	echo
	echo "[OK] Rebooting... "
	sleep 3
	sudo reboot
	
}

function vol_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "You can choose the volume level one after another until you are happy with your settings." 25 75 20 \
            1 "Set Background Music volume to 100%" \
            2 "Set Background Music volume to 90%" \
            3 "Set Background Music volume to 80%" \
            4 "Set Background Music volume to 70%" \
            5 "Set Background Music volume to 60%" \
            6 "Set Background Music volume to 50%" \
            7 "Set Background Music volume to 40%" \
            8 "Set Background Music volume to 30%" \
            9 "Set Background Music volume to 20%" \
            10 "Set Background Music volume to 10%" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) 100_v  ;;
            2) 90_v  ;;
            3) 80_v  ;;
            4) 70_v  ;;
            5) 60_v  ;;
            6) 50_v  ;;
            7) 40_v  ;;
            8) 30_v  ;;
            9) 20_v  ;;
            10) 10_v  ;;
            *)  break ;;
        esac
    done
}

function 100_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 1.0/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}
function 90_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.90/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}
function 80_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.80/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}
function 70_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 70.0/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}
function 60_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 60.0/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}
function 50_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.50/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}
function 40_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.40/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}
function 30_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.30/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}
function 20_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.20/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}
function 10_v() {
        CUR_VAL=`grep "maxvolume =" /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py|awk '{print $3}'`
        export CUR_VAL
        perl -p -i -e 's/maxvolume = $ENV{CUR_VAL}/maxvolume = 0.10/g' /home/pi/.local/lib/python3*/site-packages/bgm/music_player.py
        pgrep -f "esbgm"|xargs sudo kill -9
        exec esbgm > /dev/null 2>&1 &
}

function install_bgm() {
        clear
		sleep 1
		echo
		echo "STEP 1: Checking BGM Status..."
		sleep 2
		ESBGM=/home/pi/.local/bin/esbgm
		if [[ -f "$ESBGM" ]]; then
        sleep 2
		echo -e "\n\n\n It looks like Background Music is already installed. Exiting...\n\n\n"
        sleep 3
        exit
        fi
		echo -e "\n\n\n It looks like Background Music is not installed...\n\n\n"
        sleep 3
		echo
		echo "STEP 2: Checking Requirements..."
		sleep 2
        PKG=pygame
        PKG_OK=$(pip3 list | grep $PKG)
        if [ "" == "$PKG_OK" ]; then
            echo -e "\n\n\n     No $PKG installed. Setting up $PKG.\n\n\n"
            sleep 2
            sudo apt update && sudo apt install libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev libfreetype6-dev libportmidi-dev libjpeg-dev python3-setuptools python3-dev python3-numpy && pip3 install pygame==2.5.0
			else
			echo -e "\n\n\n         $PKG seems to be installed...\n\nLet's install BGM!"
			sleep 2
        fi
		curl -sSL https://raw.githubusercontent.com/2play/bgm-for-es/playboxv2/scripts/install-esbgm.py | python3 -
		sed -i 's|~/RetroPie/music|~/RetroPie/roms/music|g' /home/pi/.local/lib/python3*/site-packages/bgm/config_default.yaml
		sudo ln -sfn /home/pi/.local/bin/esbgm /usr/local/bin/esbgm
		echo
		echo "STEP 3: Checking if an external USB Drive Roms exists..."
		sleep 2
		if [ -d ~/RetroPie/localroms ]; then
		echo
		echo "An external USB is enabled/connected..."
		echo
		sleep 2
		cd $HOME
		sed -i 's+~/RetroPie/roms+~/RetroPie/localroms+g' $HOME/.config/esbgm/config.yaml
			if [ -d ~/RetroPie/localroms/music.OFF ]; then mv ~/RetroPie/localroms/music.OFF /home/pi/RetroPie/localroms/music
			elif [ ! -d ~/RetroPie/localroms/music ]; then mkdir /home/pi/RetroPie/localroms/music
			fi
		else
			echo
			echo "You are not using an external USB roms drive..."
			echo
			sleep 2
			cd $HOME
			sed -i 's+~/RetroPie/localroms+~/RetroPie/roms+g' $HOME/.config/esbgm/config.yaml
			if [ -d ~/RetroPie/roms/music.OFF ]; then mv ~/RetroPie/roms/music.OFF ~/RetroPie/roms/music
			elif [ ! -d ~/RetroPie/roms/music ]; then mkdir ~/RetroPie/roms/music
			fi
		fi
		echo
		echo "After reboot, you can use from PlayBox Toolkit to set a music choice or"
		sleep 3
		echo "Select from PlayBox Toolkit a Music option or copy your music files in the /roms/music folder"
		sleep 3
		echo "[OK] Rebooting... "
		sudo reboot
}

main_menu