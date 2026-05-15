#!/bin/bash
# Fixes, improvements, tweaks etc. 
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)+
# PlayBox ToolKit
BACKTITLE="PLAYBOX PROJECT"
pb_version="PlayBox ToolKit Version 2.0 Dated 15.05.2026"

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

dialog \
--backtitle "PLAYBOX PROJECT" \
--title " PLAYBOX PROJECT - TOOLKIT " \
--msgbox "${infobox}" 35 110


function main_menu() {
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " PLAYBOX PROJECT - TOOLKIT " \
            --ok-label OK --cancel-label Exit \
            --menu "$pb_version" 25 75 20 \
            - "*** PLAYBOX TOOLKIT - SELECTIONS ***" \
            ""      "" \
			1 " - FIXES & SETTINGS - OPTIONS MENU " \
            2 " - TOOLS & TWEAKS   - OPTIONS MENU " \
            3 " - CLEANUP TOOLS    - OPTIONS MENU " \
            4 " - SYSTEM TOOLS     - OPTIONS MENU " \
            5 " - THANK YOU! - CREDITS " \
			""      "" \
			6 " - UPDATE MY PLAYBOX TOOLKIT/SETUP! " \
			""      "" \
            7 " - POWEROFF MY SYSTEM " \
            8 " - RESTART  MY SYSTEM" \
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
			""      "" \
			1 " - Fix The PlayBox RetropieMenu " \
            2 " - Select PlayBox Systems REGION Group (US/EU-JP/ALL) " \
			3 " - Repair PlayBox Background Music Mute File [OFF] " \
            4 " - Repair 2Play!'s ES Slideshow Screensaver " \
			5 " - Reset All Controllers Configuration " \
			6 " - Fix RetroPie-Setup Git Update Error " \
			7 " - Update All 2Play!'s PlayBox THEMES " \
			8 " - Set Default Audio-Out: 3.5mm Jack or HDMI " \
            2>&1 > /dev/tty)

        case "$choice" in
            1) fix_rpmenu  ;;
            2) fix_region  ;;
			#3) fix_bgm_py  ;;
            4) fix_slideshow  ;;
            5) fix_control  ;;
			6) git_rs  ;;
			7) themes_rs  ;;
			8) def_audio_out  ;;
            -) none ;;
            *)  break ;;
        esac
    done
}


function fix_rpmenu() {
    dialog --infobox "...Fixing..." 3 17 ; sleep 1
    clear
	targetPBS="$HOME/PlayBox-Setup/"

    if [[ -d "$HOME/RetroPie/retropiemenu.OFF" ]]; then
        echo "RetroPieMenu is disabled. Nothing to do!"
        read -n 1 -s -r -p "Press any key to continue..."
        fix_region
		return
    fi

    echo "Cleaning RetroPie menu..."
    sudo RetroPie-Setup/retropie_packages.sh retropiemenu
	sudo rm -rf "$HOME/RetroPie/retropiemenu"/*
	sudo rm -rf "$HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Emulation"
	
	safe_remove "$HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Emulation Tools/joystick_selection.sh"
	ln -sfn /opt/retropie/supplementary/joystick-selection/joystick_selection.sh \
	"$HOME/PlayBox-Setup/.pb-fixes/retropiemenu/Controller Tools/joystick_selection.sh"
	
	#pausepress
	
	# Shell, Python, .rp scripts
	permsPBS() {
	for dir in "$HOME/PlayBox-Setup" "$HOME/RetroPie/retropiemenu"; do
    find "$dir" -type f -name "*.sh" ! -name "joystick_selection.sh" -print0 | xargs -0 -r chmod 755
    find "$dir" -type f -name "*.py" -print0 | xargs -0 -r chmod 755
    find "$dir" -type f -iname "*.rp" -print0 | xargs -0 -r sudo chown root:root
	done
	}

	permsPBS
	#find $targetPBS -type f -iname "*.rp" ! -iname "raspiconfig.rp" -print0 | xargs -0 sudo chown root:root
	
	#pausepress
    echo "Syncing fixed menu..."
    #find "$HOME/PlayBox-Setup/" -name "*.sh" -exec dos2unix {} \;
	#find "$HOME/RetroPie/retropiemenu/" -name "*.sh" -exec dos2unix {} \;
	rsync -avh --delete "$HOME/PlayBox-Setup/.pb-fixes/retropiemenu/" "$HOME/RetroPie/retropiemenu/" \
	&& find $HOME -iname "*.rp" -print0 | xargs -0 sudo chown root:root \
	&& cp $HOME/PlayBox-Setup/.pb-fixes/retropie-gml/gamelist2play.xml /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
	    
	#pausepress
	permsPBS

	#pausepress
	move_items   # helper function with array loop
	
    #sudo rm -rf /etc/emulationstation/themes/carbon/
	
	#pausepress
	
	echo "Now Select Your Preferred Systems Group REGION... Default is ALL Systems!"
	sudo cp -f "/etc/emulationstation/es_systems.cfgFULL" "/etc/emulationstation/es_systems.cfg"
	fix_region
}

function move_items() {
	declare -A moves=(
      ["raspiconfig.rp"]="DISCARD"
      ["rpsetup.rp"]=""
      ["configedit.rp"]="Emulation Tools"
      ["retroarch.rp"]="Emulation Tools"
      ["retronetplay.rp"]="Emulation Tools"
      ["bluetooth.rp"]="Network Tools"
      ["showip.rp"]="Network Tools"
      ["wifi.rp"]="DISCARD"
      ["audiosettings.rp"]="DISCARD"
      ["filemanager.rp"]="System Tools"
      ["runcommand.rp"]="System Tools"
      ["esthemes.rp"]="Visuals & Theme Tools"
      ["splashscreen.rp"]="DISCARD"
      ["hurstythemes.sh"]="Visuals & Theme Tools"
      ["bezelproject.sh"]="Visuals & Theme Tools"
    )

for f in "${!moves[@]}"; do
        src="$HOME/RetroPie/retropiemenu/$f"
        dest="${moves[$f]}"
        #target="$HOME/RetroPie/retropiemenu/$dest/$f"

        if [[ -e "$src" ]]; then
            if [[ "$dest" == "DISCARD" ]]; then
                echo "[INFO] Removing $src"
                sudo rm -f "$src"
                #if [[ -e "$target" ]]; then
                #    echo "[INFO] Also removing $target"
                #    sudo rm -f "$target"
			elif [[ -n "$dest" ]]; then
                mkdir -p "$HOME/RetroPie/retropiemenu/$dest"
                echo "[INFO] Moving $src → $HOME/RetroPie/retropiemenu/$dest/"
                mv -f "$src" "$HOME/RetroPie/retropiemenu/$dest/"
            fi
        fi
    done
}


function fix_region() {
	clear
# Set PlayBox Systems Based On Region Groups, by 2Play!
# Simple Region Script 04.26

infobox=""
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}Systems & Theme Options Based on Region Groups, by 2Play!\n\n"
infobox="${infobox}\n"
infobox="${infobox}This script will set systems basis your region of preference.\n"
infobox="${infobox}- The US\JP Region will show Genesis, Sega 32X/CD, TG16/CD, Odyssey2.\n"
infobox="${infobox}- The EU\JP Region will show Mega Drive, Mega 32X/CD, PC Engine/CD, VideoPac.\n"
infobox="${infobox}- The ALL Region will show all systems.\n"
infobox="${infobox}\n"
infobox="${infobox}\n"

dialog --backtitle "Region based ES Systems" \
--title "PLAYBOX SYSTEMS BASED ON REGION" \
--msgbox "${infobox}" 35 110

    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " REGION OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select the REGION setup you want to apply..." 25 75 20 \
            - "*** SHOW REGION SYSTEMS SETUP ***" \
            0 " - Show Which Region Is Active " \
			""      "" \
            - "*** REGION SYSTEM OPTIONS with PLAYBOX ***" \
            1 " - US\JP: Genesis, SegaCD, TG16\CD, Odyssey2 " \
            2 " - EU\JP: Mega Drive, MegaCD, PC Engine\CD, Videopac " \
            3 " - ALL:   All systems will be shown " \
            2>&1 > /dev/tty)

        case "$choice" in
            0) show_region_status ;;
            1) set_region_es US   ;;
			2) set_region_es EU   ;;
			3) set_region_es ALL  ;;
            #4) us_esnpb  ;;
            #5) eu_esnpb  ;;
            #6) all_esnpb  ;;
            -) none ;;
            *) break ;;
        esac
    done
}


function show_region_status() {
    clear
	local current="/etc/emulationstation/es_systems.cfg"
    local us="/etc/emulationstation/es_systemsUS.cfg"
    local eu="/etc/emulationstation/es_systemsEU.cfg"
    local all="/etc/emulationstation/es_systems.cfgFULL"
    local orig="/etc/emulationstation/es_systems.cfgORIG"
	
	if [ ! -f "$current" ]; then
        echo "No es_systems.cfg found!"
		pausepress
        #return 1
    fi

    if [ -L "$current" ]; then
        # It's a symlink, check target
        local target=$(readlink -f "$current")
		ensure_lolcat
        case "$target" in
            "$us")   echo "Current Region: US/JP" | lolcat ;;
            "$eu")   echo "Current Region: EU/JP" | lolcat ;;
            "$all")  echo "Current Region: ALL" | lolcat  ;;
            "$orig") echo "Current Region: ORIG" | lolcat ;;
            *)       echo "Current Region: Unknown/Custom (symlink to $target)" ;;
        esac
		pausepress
    else
		ensure_lolcat
        # Not a symlink, compare contents
        if cmp -s "$current" "$us"; then
            echo "Current Region: US/JP (file copy)" | lolcat
			pausepress
        elif cmp -s "$current" "$eu"; then
            echo "Current Region: EU/JP (file copy)" | lolcat
			pausepress
        elif cmp -s "$current" "$all"; then
            echo "Current Region: ALL (file copy)" | lolcat
			pausepress
        elif cmp -s "$current" "$orig"; then
            echo "Current Region: ORIG (file copy)" | lolcat
			pausepress
        else
            echo "Current Region: INVALID - Please Select One (does not match US/EU/ALL/ORIG configs)"
            pausepress
			return 1
        fi
    fi

			  
}

function set_region_es() {
    local region="$1"   # "US", "EU", or "ALL"
    local cfgfile=""

    case "$region" in
        US)  cfgfile="/etc/emulationstation/es_systemsUS.cfg"   ;;
        EU)  cfgfile="/etc/emulationstation/es_systemsEU.cfg"   ;;
        ALL) cfgfile="/etc/emulationstation/es_systems.cfgFULL" ;;
    esac

    dialog --infobox "...Updating to $region REGION..." 3 40 ; sleep 2
    clear

    if [ -f "$cfgfile" ]; then
        #sudo ln -sfn "$cfgfile" /etc/emulationstation/es_systems.cfg
		sudo cp -f "$cfgfile" /etc/emulationstation/es_systems.cfg
        echo "Region set to $region."
		pausepress
        restart_es
    else
        echo "Config file for $region not found!"
    fi
}

function us_esnpb() {
    dialog --infobox "...Updating..." 3 20 ; sleep 2
    clear

    sudo cp "$HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_systemsUS.cfg" /etc/emulationstation/es_systems.cfg

    local base="$HOME/RetroPie/roms"
    [[ -d "$HOME/addonusb" ]] && base="$HOME/RetroPie/localroms"

    declare -A moves=(
      ["playbox"]="playbox.OFF"
      ["amiga4000"]="amiga4000.OFF"
      ["kodi.OFF"]="kodi"
      ["amiga1200.OFF"]="amiga1200"
      ["wonderswancolor"]="wonderswancolor.OFF"
    )

    for src in "${!moves[@]}"; do
        [[ -e "$base/$src" ]] && {
            echo "Renaming $src → ${moves[$src]}"
            mv -f "$base/$src" "$base/${moves[$src]}"
        }
    done

    restart_es
}


function eu_esnpb() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	sudo cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_systemsEU.cfg /etc/emulationstation/es_systems.cfg

    local base="$HOME/RetroPie/roms"
    [[ -d "$HOME/addonusb" ]] && base="$HOME/RetroPie/localroms"

    declare -A moves=(
      ["playbox"]="playbox.OFF"
      ["amiga4000"]="amiga4000.OFF"
      ["kodi.OFF"]="kodi"
      ["amiga1200.OFF"]="amiga1200"
      ["wonderswancolor"]="wonderswancolor.OFF"
    )

    for src in "${!moves[@]}"; do
        [[ -e "$base/$src" ]] && {
            echo "Renaming $src → ${moves[$src]}"
            mv -f "$base/$src" "$base/${moves[$src]}"
        }
    done

    restart_es
}

function all_esnpb() {
	dialog --infobox "...Updating..." 3 20 ; sleep 2
	clear
	sudo cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_systems.cfg /etc/emulationstation

    local base="$HOME/RetroPie/roms"
    [[ -d "$HOME/addonusb" ]] && base="$HOME/RetroPie/localroms"

    declare -A moves=(
      ["playbox"]="playbox.OFF"
      ["amiga4000"]="amiga4000.OFF"
      ["kodi.OFF"]="kodi"
      ["amiga1200.OFF"]="amiga1200"
      ["genesis.OFF"]="genesis"
      ["genesish.OFF"]="genesish"
      ["tg16.OFF"]="tg16"
      ["tg16cd.OFF"]="tg16cd"
      ["odyssey2.OFF"]="odyssey2"
      ["megacd.OFF"]="megacd"
      ["megadrive.OFF"]="megadrive"
      ["megadriveh.OFF"]="megadriveh"
      ["megh.OFF"]="megh"
      ["pcengine.OFF"]="pcengine"
      ["pcenginecd.OFF"]="pcenginecd"
      ["videopac.OFF"]="videopac"
      ["wonderswancolor"]="wonderswancolor.OFF"
    )

    for src in "${!moves[@]}"; do
        [[ -e "$base/$src" ]] && {
            echo "Renaming $src → ${moves[$src]}"
            mv -f "$base/$src" "$base/${moves[$src]}"
        }
    done

	restart_es
}


function fix_bgm_py() {
    dialog --infobox "...Fixing..." 3 17 ; sleep 1
    clear

    local cfg="$HOME/PlayBox-Setup/.pb-fixes/bgm/config.yaml"

    # Older livewire bgm config
    #cp $HOME/PlayBox-Setup/.pb-fixes/bgm/.livewire.py $HOME
		
	# Main esbgm config
    [[ -d "$HOME/.config/esbgm" ]] && cp "$cfg" "$HOME/.config/esbgm/"

    # Copy into new setups if those dirs exist
    for target in "$HOME"/.local/lib/python3.*/site-packages/bgm \
                  "$HOME"/myenv/lib/python3.*/site-packages/bgm; do
        for dir in $target; do
            [[ -d "$dir" ]] && cp "$cfg" "$dir/"
        done
    done

    done_message
}


function fix_slideshow() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	clear
	rsync -avh --delete $HOME/PlayBox-Setup/.pb-fixes/slideshow/image /opt/retropie/configs/all/emulationstation/slideshow/
	done_message
}


function fix_roms() {
    dialog --infobox "...Fixing..." 3 17 ; sleep 1
    clear

    local base="$HOME/RetroPie/roms"
    if [[ -d "$HOME/addonusb" ]]; then
        echo "External USB Script enabled — using localroms..."
        base="$HOME/RetroPie/localroms"
        read -n 1 -s -r -p "Press any key to continue..."
    else
        echo "Default RetroPie setup — using roms..."
        sleep 3
    fi
    echo

    # Clean out old dirs
    for dir in jukebox jukebox.OFF kodi playbox playbox.OFF raspbian piegalaxy steam; do
        rm -rf "$base/$dir"
    done

    # Sync replacements
    for src in jukebox.OFF kodi playbox.OFF raspbian steam piegalaxy; do
        rsync -avh "$HOME/PlayBox-Setup/.pb-fixes/roms/$src" "$base/"
    done

    echo
    clear
    echo "We need to apply REGION script now..."
    echo
    fix_region
}



function fix_control() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	rm /opt/retropie/configs/all/retroarch-joypads/*
	rm $HOME/.emulationstation/es_input.cfg
	cp $HOME/PlayBox-Setup/.pb-fixes/es_cfg/es_input.cfg $HOME/.emulationstation/
	done_message
	restart_es
}


function git_rs() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	cd RetroPie-Setup && git reset --hard && git clean -f -d
	done_message
}


function themes_rs() {
    dialog --infobox "...Fixing..." 3 17 ; sleep 1
    clear

    local repo="https://github.com/2play/2Play-v2-Themes.git"
    local tmpdir="$HOME/code/2Play-v2-Themes"
    local target="/etc/emulationstation/themes"

    # Ensure ownership
    sudo chown -R pi:pi "$target"

    # Clone fresh copy
    git -C "$HOME/code" clone --depth 1 "$repo"

    # Sync into themes dir, excluding .git
    rsync -urv --delete --exclude '.git' "$tmpdir/" "$target/"

    # Remove stray files (only non-directories at top level)
    find "$target" -maxdepth 1 -type f -delete

    # Cleanup
    rm -rf "$tmpdir"

    echo
    local count=$(find "$target" -mindepth 1 -maxdepth 1 -type d | wc -l)
	echo "[OK DONE! Synced $count theme directories]"
	pausepress
	
	restart_es
}


function def_audio_out() {
# The PlayBox Project 04.2026
	--title "DEFAULT AUDIO OUT OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " DEFAULT AUDIO OUT OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's set your default Audio Out device..." 25 75 20 \
            - "*** DEFAULT AUDIO OUT SELECTIONS ***" \
			""      "" \
           1 " - Set Default Audio Out: HDMI " \
           2 " - Set Default Audio Out: 3.5mm Jack " \
           2>&1 > /dev/tty)

        case "$choice" in
           1) hdmi_sound_out  ;;
           2) jack_sound_out  ;;
		   -) none ;;
           *)  break ;;
        esac
    done
}

function hdmi_sound_out() {
	clear
	$HOME/PlayBox-Setup/.pb-fixes/_scripts/sound_card_toggle.sh hdmi
	sleep 1
	restart_pb
}

function jack_sound_out() {
	clear
	$HOME/PlayBox-Setup/.pb-fixes/_scripts/sound_card_toggle.sh usb
	sleep 1
	restart_pb
}



function apps_pbt() {
# The PlayBox Project 04.2026
	dialog --backtitle "PlayBox Toolkit" \
	--title "APPS & TWEAKS OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " TOOLS & TWEAKS - OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Run the application you need..." 25 75 20 \
            - "*** PLAYBOX TOOLS & TWEAKS SELECTIONS ***" \
			""      "" \
			1 " - Take An HD ScreenShot " \
			""      "" \
			2 " - Change ES Gamelist View - 2Play!'s Themes Only " \
		    3 " - RetroArch Audio & Visual Options " \
			4 " - Hide or Show an ES System " \
			""      "" \
			5 " - 2Play!'s PlayBox ES Music Selections " \
			""      "" \
			6 " - Skyscraper - Scraper Tool By Lars Muldjord " \
			7 " - MESA Driver & Vulkan RetroArch Tool" \
			8 " - PiKISS By Jose Cerrejon [OFF] " \
		    9 " - Single Saves Directory Tool By RPC80 " \
		   10 " - SD/USB Storage Benchmark Tool " \
		   ""      "" \
		   11 " - Emulators: Custom Compiles From Source Tool " \
		   12 " - Emulators: Tweaks & Options " \
		   ""      "" \
		   13 " - Safe Shutdown Case Scripts Tool [OFF] " \
		   14 " - Swap Desktop Enviroments Tool (If More Than MATE Installed) [OFF] " \
		   2>&1 > /dev/tty)

        case "$choice" in
            1) prntscr  ;;
			2) swap_theme_view ;;
			3) ra_options_tool  ;;
			4) hd_sh_sys  ;;
			5) music_2p  ;;
			6) skyscraper  ;;
			7) mesa_vk  ;;
			#8) pikiss_git  ;;
		    9) rpc80_saves  ;;
		   10) strg_bench  ;;
		   11) emus_compile  ;;
		   12) emus_tks  ;;
		   13) safe_shut  ;;
		   14) desk_env  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}


function prntscr() {
	dialog --infobox "...Taking..." 3 16 ; sleep 1
	clear
	card=$(ls /dev/dri/card* | head -n1)
	now=$(date +"%m_%d_%Y--h%H-m%M-s%S")
	#screenshot > $HOME/ScreenShots/printscreen$now.jpg
	#X=$( pidof Xorg )
	#if [ ${#X} -gt 0 ]
	#then
	#		DISPLAY=:0 scrot $HOME/ScreenShots/printscreen$now.jpg
	#else
	#		fbgrab $HOME/ScreenShots/printscreen$now.jpg
	#fi
	#sudo kmsgrab $HOME/ScreenShots/printscreen$now.png;	convert $HOME/ScreenShots/printscreen*.png $HOME/ScreenShots/printscreen$now.jpg; 	rm -f $HOME/ScreenShots/*.png
	#sudo ffmpeg -device /dev/dri/card0 -re -f kmsgrab -i - -vf 'hwmap=derive_device=vaapi,hwdownload,format=bgr0' -v:frames 1 $HOME/ScreenShots/printscreen$now.png; convert $HOME/ScreenShots/printscreen*.png $HOME/ScreenShots/printscreen$now.jpg; rm -f $HOME/ScreenShots/*.png
	sudo ffmpeg -device "$card" -re -f kmsgrab -i - -vf 'hwmap=derive_device=vaapi,hwdownload,format=bgr0' -v:frames 1 $HOME/ScreenShots/printscreen$now.png
	done_message
}


function swap_theme_view() {
# New Theme Style Swap 2Play!, 04.2026
	clear
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " 2PLAY! THEME VIEWS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Which gamelist view would you like to apply on my themes?" 25 75 20 \
            - "*** 2PLAY! THEME VIEW SELECTIONS ***" \
			""      "" \
			1 "Single Window Art:  Image then Video " \
			2 "Dual   Window Art:  Image Under The Gamelist + Big Video " \
			3 "Dual   Window Art:  Long Gamelist, Image Next to Video " \
			""      "" \
			4 "ES Systems Browsing: Vertical " \
			5 "ES Systems Browsing: Horizontal " \
			2>&1 > /dev/tty)

        case "$choice" in
            1) swap_theme_variant "ingame-global-bg2P.jpg" "theme2P.xml"       ;; # Single Window
			2) swap_theme_variant "ingame-global-bg-ih.jpg" "themeDualv1.xml"  ;; # Dual Art Separate
			3) swap_theme_variant "ingame-global-bg2P.jpg" "themeDualv2.xml"   ;; # Dual Art Next
			4) sys_vertical   ;; # Scroll V
			5) sys_horizontal ;; # Scroll H
			-) none ;;
			*)  break ;;
        esac
    done
}


function swap_theme_variant() {
    local bgfile="$1"   # e.g. ingame-global-bg2P.jpg, ingame-global-bg-ih.jpg
    local themefile="$2" # e.g. theme2P.xml, themeDualv1.xml, themeDualv2.xml

    dialog --infobox "...Starting..." 3 20 ; sleep 1
    clear
    cd /etc/emulationstation/themes

    # Replace background
    find ./2Play*/_2playart -name "ingame-global-bg.jpg" -delete
    find ./2Play*/_2playart -type f -name "$bgfile" -execdir cp {} ingame-global-bg.jpg ';'

    # Replace theme.xml
    find ./2Play*/ -maxdepth 1 -name "theme.xml" -delete
    find ./2Play*/ -maxdepth 1 -type f -name "$themefile" -execdir cp {} theme.xml ';'

    echo
    echo "[OK DONE!...]"
    restart_es
}

function sys_verical() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd /etc/emulationstation/themes
	find ./2Play*/ -maxdepth 1 -type f -name "theme*.xml" -exec sed -i 's|<type>horizontal</type>|<type>vertical</type>|g' {} 2>/dev/null \;
	echo
	done_message
	restart_es
}

function sys_horizontal() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd /etc/emulationstation/themes
	find ./2Play*/ -maxdepth 1 -type f -name "theme*.xml" -exec sed -i 's|<type>vertical</type>|<type>horizontal</type>|g' {} 2>/dev/null \;
	echo
	done_message
	restart_es
}


function ra_options_tool() {
# RetroArch Options Tool By 2Play!
# 04.2026
	
	clear
	local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " RETROARCH AUDIO & VISUAL OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select a RetroArch Option you would like to apply on PlayBox." 25 75 20 \
            - "*** STATUS DASHBOARD ***" \
            0 " - See Current Status Of All Below Settings " \
            ""      "" \
			- "*** AUDIO SETTINGS SELECTIONS ***" \
            1 " - RetroArch Volume Increase By 25% " \
            2 " - RetroArch Volume Increase By 50% " \
            3 " - RetroArch Volume Increase By 80% " \
            4 " - RetroArch Volume Increase By 100% " \
			5 " - Set The Default RetroArch Level " \
			""      "" \
			- "*** SHADERS SELECTIONS ***" \
            6 " - Disable The Global Retro Shader " \
            7 " - Enable The Global Retro Shader " \
			""      "" \
			- "*** OVERLAY SELECTIONS ***" \
		    8 " - Enable A System Preset Overlay " \
            9 " - Disable A System Preset Overlay " \
		   10 " - Enable All System Preset Overlays " \
           11 " - Disable All System Preset Overlays " \
			""      "" \
			- "*** OVERLAY SPECIALS ON PLAYBOX v2 OR PER-ROM SELECTIONS ***" \
		   12 " - Enable Arcade Cabinet Overlay (Arcade) " \
		   13 " - Disable Arcade Cabinet & Enable Per-Rom Overlay " \
		   14 " - Enable Atomiswave Cabinet Overlay  " \
		   15 " - Disable Atomiswave Cabinet & Enable Per-Rom Overlay " \
		   16 " - Enable Naomi Cabinet Overlay  " \
		   17 " - Disable Naomi Cabinet & Enable Per-Rom Overlay " \
			""      "" \
			- "*** VIDEO SMOOTH SELECTIONS ***" \
		   18 " - Enable Video Smooth Option  - Specific System " \
           19 " - Disable Video Smooth Option - Specific System " \
		   20 " - Enable Video Smooth Option  - All Systems " \
           21 " - Disable Video Smooth Option - All Systems " \
           2>&1 > /dev/tty)

        case "$choice" in
            0) show_status_dashboard  ;;
            1) ra_set_option audio_volume "3.000000"   ;;  # 25%
			2) ra_set_option audio_volume "6.000000"   ;;  # 50%
			3) ra_set_option audio_volume "10.000000"  ;;  # 80%
			4) ra_set_option audio_volume "12.000000"  ;;  # 100%
			5) ra_set_option audio_volume "0.000000"   ;;  # Default
			#6) disable_shaders  ;;
            #7) enable_shaders  ;;
		    6) toggle_global_shader disable ;;
			7) toggle_global_shader enable  ;;
		    8)  toggle_sys_overlay on   ;;
			9)  toggle_sys_overlay off  ;;
			10) toggle_all_overlays on  ;;
			11) toggle_all_overlays off ;;
			12) toggle_cab_overlay arcade "FinalBurn Neo" on 936 729 487 72 "" ;;
			13) toggle_cab_overlay arcade "FinalBurn Neo" off ;;
			14) toggle_cab_overlay atomiswave "Flycast" on 1205 865 360 115 "" ;;
			15) toggle_cab_overlay atomiswave "Flycast" off ;;
			16) toggle_cab_overlay naomi "Flycast" on 1055 787 436 123 "/opt/retropie/emulators/retroarch/overlays/SystemBezels/_generic_naomi_dx.cfg" ;;
			17) toggle_cab_overlay naomi "Flycast" off ;;
			18) toggle_video_smooth system on   ;;
			19) toggle_video_smooth system off  ;;
			20) toggle_video_smooth all on      ;;
			21) toggle_video_smooth all off     ;;
			-) none  ;;
            *)  break ;;
        esac
    done
}


function show_status_dashboard() {
    clear
	echo "================= SYSTEM STATUS DASHBOARD ================="
    echo

    # Volume
    local vol=$(grep -m1 'audio_volume' /opt/retropie/configs/all/retroarch.cfg | cut -d'"' -f2)
    echo "Audio Volume: ${vol}"

    # Shader status
    if [ -f /opt/retropie/configs/all/retroarch/config/global.glslp.OFF ] || \
       [ -f /opt/retropie/configs/all/retroarch/config/global.slangp.OFF ]; then
        echo "Global Shader: DISABLED"
    else
        echo "Global Shader: ENABLED"
    fi

    # Overlay status (global)
    if [ -d /opt/retropie/configs/all/retroarch/overlay.OFF ]; then
        echo "Global Overlays: DISABLED"
    else
        echo "Global Overlays: ENABLED"
    fi

    # Cabinet overlays
    if [ -d "/opt/retropie/configs/all/retroarch/config/FinalBurn Neo.OFF" ]; then
        echo "Arcade Cabinet Overlay: ENABLED"
    else
        echo "Arcade Cabinet Overlay: DISABLED"
    fi
    if [ -d "/opt/retropie/configs/all/retroarch/config/Flycast.OFF" ]; then
        echo "Atomiswave/Naomi Cabinet Overlay: ENABLED"
    else
        echo "Atomiswave/Naomi Cabinet Overlay: DISABLED"
    fi

    # Video smooth (global check)
    if grep -q '^video_smooth' /opt/retropie/configs/all/retroarch.cfg; then
        echo "Video Smooth (Global): ENABLED"
    else
        echo "Video Smooth (Global): DISABLED"
    fi

    echo "==========================================================="
	pausepress
}


# === RetroArch Config Setter ===
# Usage: ra_set_option key value
# Example: ra_set_option audio_volume "6.000000"

function ra_set_option() {
    local key="$1"
    local value="$2"
    dialog --infobox "...Applying $key..." 3 30 ; sleep 1

    for cfg in /opt/retropie/configs/all/retroarch.cfg \
               /opt/retropie/configs/all/retroarch/retroarch.cfg; do

        # If key exists uncommented, replace it
        if grep -qE "^[[:space:]]*$key = " "$cfg"; then
            sudo sed -i "s|^[[:space:]]*$key = \".*\"|$key = \"$value\"|" "$cfg"

        # If key exists commented, insert new active line right below
        elif grep -qE "^[[:space:]]*# *$key" "$cfg"; then
            sudo sed -i "/^[[:space:]]*# *$key/a$key = \"$value\"" "$cfg"

        else
            # Append fresh active line if missing entirely
            echo "$key = \"$value\"" | sudo tee -a "$cfg" > /dev/null
        fi
    done

    done_message
}




function disable_shaders() {
	dialog --infobox "...Removing..." 3 20 ; sleep 2
	mv /opt/retropie/configs/all/retroarch/shaders/ /opt/retropie/configs/all/retroarch/shaders.OFF/
	done_message
}

function enable_shaders() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	mv /opt/retropie/configs/all/retroarch/shaders.OFF/ /opt/retropie/configs/all/retroarch/shaders/
	done_message
}


function toggle_global_shader() {
    local action="$1"   # "enable" or "disable"
    local cfgdir="/opt/retropie/configs/all/retroarch/config"

    dialog --infobox "...${action^}ing..." 3 20 ; sleep 2
    clear
    cd "$cfgdir"

    case "$action" in
        disable)
            for f in global.glslp global.slangp; do
                [ -f "$f" ] && mv "$f" "$f.OFF"
            done
            ;;
        enable)
            # Restore if OFF files exist
            for f in global.glslp global.slangp; do
                [ -f "$f.OFF" ] && mv "$f.OFF" "$f"
                # If missing entirely, fetch fresh copy
                [ ! -f "$f" ] && wget "https://raw.githubusercontent.com/2play/PBv2-PostFixes/clean-vanilla-x86/opt/retropie/configs/all/retroarch/config/$f"
            done
            ;;
    esac

    echo "[OK DONE!...]"
    sleep 1
}


function toggle_sys_overlay() {
    local action="$1"   # "on" or "off"
    local sname

    clear
    echo "RetroArch overlays can only be applied to cores with retroarch.cfg."
    echo "Type the system name exactly as shown in /opt/retropie/configs/"
    echo
    read -n 1 -s -r -p "Press any key to continue..."
    cd /opt/retropie/configs/

    find \( -name all -prune -o -name amiberry -prune -o -name ports -prune \) \
         -o -name "retroarch.cfg" -printf "%h\n" | sort -h | column | more

    echo
    read -p "Which system would you like to ${action} overlays?: " sname
    echo

    if [ -f "$sname/retroarch.cfg" ]; then
        case "$action" in
            on)
                sed -i 's|.*#input_overlay_enable|input_overlay_enable|g;
                        s|.*#input_overlay|input_overlay|g;
                        s|.*#aspect_ratio_index|aspect_ratio_index|g;
                        s|.*#custom_viewport_width|custom_viewport_width|g;
                        s|.*#custom_viewport_height|custom_viewport_height|g;
                        s|.*#custom_viewport_x|custom_viewport_x|g;
                        s|.*#custom_viewport_y|custom_viewport_y|g' "$sname/retroarch.cfg"
                ;;
            off)
                sed -i 's|^input_overlay_enable|#input_overlay_enable|g;
                        s|^input_overlay|#input_overlay|g;
                        s|^aspect_ratio_index|#aspect_ratio_index|g;
                        s|^custom_viewport_width|#custom_viewport_width|g;
                        s|^custom_viewport_height|#custom_viewport_height|g;
                        s|^custom_viewport_x|#custom_viewport_x|g;
                        s|^custom_viewport_y|#custom_viewport_y|g' "$sname/retroarch.cfg"
                ;;
        esac
        echo "[OK DONE!...]"
    else
        echo "This system does not contain a retroarch.cfg file."
    fi
    sleep 1
}


function toggle_all_overlays() {
    local action="$1"   # "on" or "off"
    local base="/opt/retropie/configs/all/retroarch"

    case "$action" in
        on)
            if [ -d "$base/overlay.OFF" ]; then
                mv "$base/overlay.OFF"/* "$base/overlay/"
                mv "$base/overlay.OFF"/.[!.]* "$base/overlay/" 2>/dev/null || true
                rm -rf "$base/overlay.OFF"
            fi
            ;;
        off)
            mv "$base/overlay" "$base/overlay.OFF"
            ;;
    esac
    echo "[OK DONE!...]"
    sleep 1
}


function toggle_cab_overlay() {
    local system="$1"    # arcade, atomiswave, naomi
    local core="$2"      # "FinalBurn Neo" or "Flycast"
    local action="$3"    # "on" or "off"
    local width="$4"
    local height="$5"
    local x="$6"
    local y="$7"
    local overlay="$8"   # optional overlay path

    cd /opt/retropie/configs/

    case "$action" in
        on)
            mv "/opt/retropie/configs/all/retroarch/config/${core}/" \
               "/opt/retropie/configs/all/retroarch/config/${core}.OFF/" 2>/dev/null || true
            find "$system" -name "retroarch.cfg" -exec sed -i \
                "s|.*#input_overlay_enable|input_overlay_enable|g;
                 s|.*#input_overlay.*|input_overlay = \"${overlay}\"|g;
                 s|.*#aspect_ratio_index|aspect_ratio_index|g;
                 s|.*#custom_viewport_width.*|custom_viewport_width = \"${width}\"|g;
                 s|.*#custom_viewport_height.*|custom_viewport_height = \"${height}\"|g;
                 s|.*#custom_viewport_x.*|custom_viewport_x = \"${x}\"|g;
                 s|.*#custom_viewport_y.*|custom_viewport_y = \"${y}\"|g" {} \;
            ;;
        off)
            mv "/opt/retropie/configs/all/retroarch/config/${core}.OFF/" \
               "/opt/retropie/configs/all/retroarch/config/${core}/" 2>/dev/null || true
            find "$system" -name "retroarch.cfg" -exec sed -i \
                "s|.*input_overlay_enable.*|#input_overlay_enable|g;
                 s|.*input_overlay.*|#input_overlay|g;
                 s|^aspect_ratio_index|#aspect_ratio_index|g;
                 s|^custom_viewport_width|#custom_viewport_width|g;
                 s|^custom_viewport_height|#custom_viewport_height|g;
                 s|^custom_viewport_x|#custom_viewport_x|g;
                 s|^custom_viewport_y|#custom_viewport_y|g" {} \;
            ;;
    esac
    done_message
}


function toggle_video_smooth() {
    local scope="$1"   # "system" or "all"
    local action="$2"  # "on" or "off"
    local sname=""

    cd /opt/retropie/configs/

    if [ "$scope" = "system" ]; then
        echo "RetroArch video smooth can only be applied to cores with retroarch.cfg."
        echo "Type the system name exactly as shown in configs folder."
        echo
        read -p "Which system would you like to ${action} video smooth?: " sname
        if [ -f "$sname/retroarch.cfg" ]; then
            case "$action" in
                on)  sed -i 's|.*#video_smooth|video_smooth|g' "$sname/retroarch.cfg" ;;
                off) sed -i 's|^video_smooth|#video_smooth|g' "$sname/retroarch.cfg" ;;
            esac
            echo "[OK DONE!...]"
        else
            echo "This system does not contain a retroarch.cfg file."
        fi
    else
        # Apply to all systems except excluded ones
        case "$action" in
            on)  find . -type d \( -name all -o -name amiga \) -prune -false -o \
                     -name "retroarch.cfg" -exec sed -i 's|.*#video_smooth|video_smooth|g' {} \; ;;
            off) find . -type d \( -name all -o -name amiga \) -prune -false -o \
                     -name "retroarch.cfg" -exec sed -i 's|^video_smooth|#video_smooth|g' {} \; ;;
        esac
    fi
	done_message
}


function hd_sh_sys() {
	clear
# Hide a System or RetroPie Menu Script by 2Play!
# 04.2026

infobox=""
infobox="${infobox}\n"
infobox="${infobox}*** Hide the RetroPie/Options Menu or any System. ***\n\n"
infobox="${infobox}You can hide any system in the roms directory.\nSome are visible due to the .sh file in there.\nYou can use this tool or simply add manually .OFF to the .sh For example .sh.OFF\n\n"
infobox="${infobox}You will see a list of the systems and instructions. The tool relies on your correct input!\n\n"
infobox="${infobox}*** For REGION related system groups *** such as:\nGenesis, genesih, odyssey2, sega32x, segacd, tg16, tg16cd & PlayBox or Kodi.\nUSE the REGION tool for these.\n"
infobox="${infobox}\n"
infobox="${infobox}\n"

dialog --backtitle " - Hide A System from EmulationStation Systems" \
--title " HIDE/SHOW A SYSTEM TOOL " \
--msgbox "${infobox}" 35 110

    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " HIDE/SHOW A SYSTEM MENU " \
            --ok-label OK --cancel-label Back \
            --menu "OK Let's decide what would you like to hide/show..." 25 75 20 \
            - "*** HIDE RETROPIE SYSTEM SELECTIONS ***" \
            1 " - Hide The RetroPie/Options Menu " \
            2 " - Show The RetroPie/Options Menu " \
            ""      "" \
            - "*** HIDE A SPECIFIC SYSTEM SELECTIONS ***" \
		    3 " - Hide A System... " \
            4 " - Show A System... " \
            ""      "" \
            5 " - Show/Restore ALL HIDDEN Systems" \
		   2>&1 > /dev/tty)

        case "$choice" in
            1) toggle_system retropiemenu hide ;;
			2) toggle_system retropiemenu show ;;
			3) clear; read -p "System to hide: " sname; toggle_system "$sname" hide ;;
			4) clear; read -p "System to show: " sname; toggle_system "$sname" show ;;
			5) show_all_systems ;;
            -) none ;;
            *) break ;;
        esac
    done
}


function toggle_system() {
    local target="$1"   # "retropiemenu" or system name
    local action="$2"   # "hide" or "show"

    case "$action" in
        hide)
            if [ -d "$HOME/RetroPie/$target" ]; then
                mv -f "$HOME/RetroPie/$target" "$HOME/RetroPie/$target.OFF"
            elif [ -d "$HOME/RetroPie/roms/$target" ]; then
                mv -f "$HOME/RetroPie/roms/$target" "$HOME/RetroPie/roms/$target.OFF"
            elif [ -d "$HOME/RetroPie/localroms/$target" ]; then
                mv -f "$HOME/RetroPie/localroms/$target" "$HOME/RetroPie/localroms/$target.OFF"
                mv -f "$HOME/RetroPie/addonusb/roms/$target" "$HOME/RetroPie/addonusb/roms/$target.OFF"
            fi
            ;;
        show)
            if [ -d "$HOME/RetroPie/$target.OFF" ]; then
                mv -f "$HOME/RetroPie/$target.OFF" "$HOME/RetroPie/$target"
            elif [ -d "$HOME/RetroPie/roms/$target.OFF" ]; then
                mv -f "$HOME/RetroPie/roms/$target.OFF" "$HOME/RetroPie/roms/$target"
            elif [ -d "$HOME/RetroPie/localroms/$target.OFF" ]; then
                mv -f "$HOME/RetroPie/localroms/$target.OFF" "$HOME/RetroPie/localroms/$target"
                mv -f "$HOME/RetroPie/addonusb/roms/$target.OFF" "$HOME/RetroPie/addonusb/roms/$target"
            fi
            ;;
    esac

    clear
    echo "[OK DONE!...]"
    restart_es
}


function show_all_systems() {
    cd "$HOME/RetroPie/roms/"
    rename -v 's/\.OFF$//i' *
    echo "[OK DONE!...]"
    restart_es
}


function music_2p() {
# The PlayBox Project 04.2026

	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " ES BGM MUSIC SELECTION MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select the type of music you would like to apply." 25 75 20 \
            - "*** 2Play!'s PLAYBOX ES MUSIC SELECTIONS ***" \
			""      "" \
            1 "Arcades 80's Selection " \
            2 "Cool Synthwave Tracks " \
            3 "Smooth Royalty Free Tracks " \
			""      "" \
            4 "I Want To Mix All 'n' Enjoy Pure Retro Music!!! " \
            2>&1 > /dev/tty)

        case "$choice" in
            1) set_music_theme synthpop   ;;
			2) set_music_theme synthwave  ;;
			3) set_music_theme royalfree  ;;
			4) set_music_theme mix        ;;
            -) none ;;
            *)  break ;;
        esac
    done
}


function set_music_theme() {
    local theme="$1"   # "synthpop", "synthwave", "royalfree", or "mix"

    dialog --infobox "...Fixing..." 3 17 ; sleep 1
    clear

    if [ -d "$HOME/addonusb" ]; then
        echo "You have enabled the External USB Script..."
        echo "Using correct paths..."
        read -n 1 -s -r -p "Press any key to continue..."
        echo
        rm -rf "$HOME/RetroPie/localroms/music/"* "$HOME/addonusb/roms/music/"*
        case "$theme" in
            synthpop)  rsync -avh "$HOME/Music/synthpop/"*  "$HOME/RetroPie/localroms/music" ;;
            synthwave) rsync -avh "$HOME/Music/synthwave/"* "$HOME/RetroPie/localroms/music" ;;
            royalfree) rsync -avh "$HOME/Music/royalfree/"* "$HOME/RetroPie/localroms/music" ;;
            mix)
                rsync -avh "$HOME/Music/synthpop/"*   "$HOME/RetroPie/localroms/music"
                rsync -avh "$HOME/Music/synthwave/"*  "$HOME/RetroPie/localroms/music"
                rsync -avh "$HOME/Music/royalfree/"*  "$HOME/RetroPie/localroms/music"
                ;;
        esac
    else
        rm -rf "$HOME/RetroPie/roms/music/"*
        case "$theme" in
            synthpop)  rsync -avh "$HOME/Music/synthpop/"*  "$HOME/RetroPie/roms/music" ;;
            synthwave) rsync -avh "$HOME/Music/synthwave/"* "$HOME/RetroPie/roms/music" ;;
            royalfree) rsync -avh "$HOME/Music/royalfree/"* "$HOME/RetroPie/roms/music" ;;
            mix)
                rsync -avh "$HOME/Music/synthpop/"*   "$HOME/RetroPie/roms/music"
                rsync -avh "$HOME/Music/synthwave/"*  "$HOME/RetroPie/roms/music"
                rsync -avh "$HOME/Music/royalfree/"*  "$HOME/RetroPie/roms/music"
                ;;
        esac
    fi
    restart_es
}


function skyscraper() {
    dialog --infobox "...Starting..." 3 20 ; sleep 1
    clear
    echo
    echo "*** You need a keyboard connected! ***"
    echo
    read -n 1 -s -r -p "Press any key to continue..."
    echo

    # Menu with 3 options
    local choice=$(dialog --clear --stdout \
        --menu "Choose Skyscraper Mode:" 12 40 3 \
        ""      "" \
		1 " Skyscraper Help & --flags Info " \
        ""      "" \
		2 " SkyscrapeBoxart By 2Play! " \
        3 " SkyscrapeMixart By 2Play! ")

    clear
    case "$choice" in
        1) check_and_run Skyscraper ;;
        2) check_and_run SkyscrapeBoxart ;;
        3) check_and_run SkyscrapeMixart ;;
        *) echo "Cancelled." ;;
    esac
   
}



function mesa_vk() {
# The PlayBox Project 03.2026

	dialog --backtitle "PlayBox Toolkit" \
	--title "MESA & VULKAN OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MESA & VULKAN OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's do some magic..." 25 75 20 \
            - "*** MESA & VULKAN SELECTIONS ***" \
			""      "" \
           1 " - Update PlayBox MESA & Vulkan Drivers: Latest Stable Version " \
		   ""      "" \
           2 " - Update PlayBox RetroArch Vulkan/GLES: Latest Stable Version " \
		   3 " - Default RetroArch To Use Vulkan/GLES or RPie Stock " \
		   2>&1 > /dev/tty)

        case "$choice" in
           1) mesa_up  ;;
		   2) vulkan_ra  ;;
		   3) ra_default  ;;
		   #4) igalia_dm  ;;
           -) none ;;
            *)  break ;;
        esac
    done
}

function mesa_up() {
clear
cd $HOME
echo
echo "STEP 1. Bring OS Up to date... "
echo
sudo apt update -y && sudo apt upgrade -y
echo
echo "STEP 2. Installing Repository & Integrate to OS... "
echo
sudo add-apt-repository ppa:kisak/kisak-mesa && sudo apt update -y && sudo apt upgrade -y
echo
done_message
reboot_message
}

function vulkan_ra() {
clear
echo
echo "Compile RetroArch with Vulkan Support... "
echo
cd $HOME
if [ ! -d code ]; then
mkdir code && cd code/
else
cd code/
fi
#Install some previous dependencies for the GSLANG shader compiler: these are needed for Vulkan!
sudo apt install -y glslang-dev glslang-tools spirv-tools spirv-headers libgles2-mesa-dev libx11-xcb-dev libpulse-dev libvulkan-dev libgbm-dev libudev-dev libxkbcommon-dev libsdl2-dev libasound2-dev libusb-1.0-0-dev libmp3lame-dev libx264-dev -y
##Custom FFMPEG
vffmpeg=$(ffmpeg -version | grep "git-2026-04-01-e64a1d2" | cut -f3 -d' ')
if [ "$vffmpeg" != "git-2024-03-26-f872b19" ]; then
	git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git;
	cd ffmpeg/;
	#./configure --enable-libx264 --enable-gpl --enable-libmp3lame --disable-debug --enable-shared --enable-mmal --enable-vulkan;
	./configure --enable-libx264 --enable-gpl --enable-libmp3lame --disable-debug --enable-shared;
	make -j$(nproc);
	sudo make install;
	cd $HOME/code/;
	sudo ldconfig;
	rm -rf ffmpeg*;
	hash -r
else
	echo
	echo "Ffmpeg Custom requirement OK!"
	echo
fi
echo
##Latest RA from source
git clone --depth 1 https://github.com/libretro/RetroArch.git RetroArch

cd RetroArch*/
#
# Check sources.list if extra space after # and fix as needed
sudo sed -i 's|^deb-src|#deb-src|g' /etc/apt/sources.list
sudo sed -i 's|#deb-src|deb-src|g' /etc/apt/sources.list
sudo apt update
sudo apt build-dep retroarch -y
sudo sed -i 's|^deb-src|#deb-src|g' /etc/apt/sources.list

##2P BT With GLES3
CFLAGS="-march=native" CXXFLAGS="-march=native" ./configure --disable-opengl1 --disable-videocore --enable-udev --enable-kms --enable-x11 --enable-egl --enable-vulkan --disable-sdl --enable-sdl2 --disable-oss --disable-al --disable-jack --disable-qt --enable-opengles --enable-opengles3 --enable-opengles3_1 --enable-opengles3_2
make -j$(nproc)
if [ -f "retroarch" ]; then
	mv retroarch retroarchNEW
	sudo cp retroarchNEW /opt/retropie/emulators/retroarch/bin/
	cd /opt/retropie/emulators/retroarch/bin
	sudo mv retroarch retroarchORIG
	sudo ln -sfn retroarchNEW retroarch
else
echo
echo " Compile Failed! Please retry or post error in 🙋questions-and-answers discord channel... "
echo
read -n 1 -s -r -p "Press any key to continue..."
break
fi
cd $HOME/code/
rm -rf RetroArch*/ && rm v1*.tar.gz && sudo rm -rf mesa && rm -rf sascha-willems && rm -rf drm* && rm -rf libdrm* && rm -rf SDL2*
cd $HOME
done_message
}

function ra_default() {
    clear
    cd /opt/retropie/emulators/retroarch/bin
    target=$(readlink retroarch)

    if [ "$target" = "retroarchNEW" ]; then
        sudo ln -sfn retroarchORIG retroarch
    elif [ "$target" = "retroarchORIG" ] && [ -f retroarchNEW ]; then
        sudo ln -sfn retroarchNEW retroarch
    else
        echo "A Vulkan RetroArch binary does not exist... Nothing to do!"
        cd $HOME
        return
    fi

    clear
    echo
    echo "[OK Swap Complete...]"
    echo
    echo "RetroArch version now set to:"
    ./retroarch --version | sed -n '2p'   # show only the version line
    echo
    sleep 2
    cd $HOME
}

function igalia_dm() {
clear
cd $HOME
if [ ! -d code ]; then
mkdir code && cd code/
else
cd code/
fi
echo
echo "Vulkan Demos... "
echo
cd $HOME/code/
if [ ! -d sascha-willems ]; then
sudo apt install libassimp-dev
git clone --recursive https://github.com/SaschaWillems/Vulkan.git  sascha-willems
cd sascha-willems
python3 download_assets.py
mkdir build
cd build
#cmake -DCMAKE_BUILD_TYPE=Debug  ..
cmake -DCMAKE_BUILD_TYPE=Release  ..
make -j$(nproc)
mv -v build/bin/* bin/
chmod 755 bin/benchmark-all.py
else
echo
echo "Directory exists so most probably you compiled before!!!"
fi
cd $HOME/code/
rm -rf RetroArch*/ && rm v1*.tar.gz && sudo rm -rf mesa && rm -rf sascha-willems && rm -rf drm* && rm -rf libdrm* && rm -rf SDL2*
echo
echo -e 'You can invoke a Vulkan demo to test from the OS desktop.\n- Go to [/home/pi/code/sascha-willems/bin/] and test in there...\nYou can check your driver versions by typing in a Terminal on your OS desktop [glinfo -B]...'
echo
read -n 1 -s -r -p "Press any key to continue"
done_message
}


function pikiss_git() {
# curl -sSL https://git.io/JfAPE | bash	
	clear
	cd $HOME/piKiss/
	echo "Let's pull latest PiKISS updates..."
	echo
	sleep 1
	git fetch
	git reset --hard HEAD
	git merge '@{u}'
	sleep 2
	$HOME/piKiss/piKiss.sh
}


function rpc80_saves() {
# Based on RPC80 Saves Single Directory Script
# The PlayBox Project 04.2026

	dialog --backtitle "PlayBox Toolkit" \
	--title "RPC80 SAVES SINGLE DIR OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " RPC80 SINGLE SAVES DIR OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Based on original RPC80 Saves Script. Let's do it..." 25 75 20 \
            - "*** RPC80's SAVES SINGLE DIR OPTIONS MENU ***" \
			""      "" \
           1 " - Enable The Saves Single Directory " \
           2 " - Disable The Saves Single Directory " \
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
# Updates by 2Play! 														   # 
# Date: 04.2026
################################################################################
# Purpose: Creates a SAVES directory at $HOME/RetroPie/saves                   #
# and configures all retroarch emulators with their own config files           #
# to store savefiles at $HOME/RetroPie/saves/{system_name}                     #
# and savestate files at $HOME/Retropie/saves/{system_name}/states             #
################################################################################

CONFIGS_DIR=/opt/retropie/configs
CONFIG_FILENAME=retroarch.cfg
SAVES_DIR=$HOME/RetroPie/saves
ROMS_DIR=$HOME/RetroPie/roms

SAVE_FILE_CONFIG="savefile_directory = \"$HOME/RetroPie/saves"
SAVE_STATE_CONFIG="savestate_directory = \"$HOME/RetroPie/saves"

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

	# Skip a list of folders
	#skip_list=("all" "amiga" "genh" "megh" "moto" "neogeocd"  "pce-cd" "snesmsu1" "tg-cd")
	#if [[ " ${skip_list[@]} " =~ " ${system_name} " ]]; then
	# Skip `all` & symbolic link config folders
    if [ -L "$d" ] || [[ ${system_name} == 'all' ]]; then
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
          echo "[ERROR] Failed to create save file directory: ${SAVES_DIR}"
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
      if grep -qE 'savefile_directory|savestate_directory' "${config_file}"; then
        echo "Overwriting configs..."
        sed -i "s|savefile_directory.*|${SAVE_FILE_CONFIG}/${system_name}\"|" "${config_file}"
		sed -i "s|savestate_directory.*|${SAVE_STATE_CONFIG}/${system_name}/states\"|" "${config_file}"
      else
        echo "Writing save configs...!"
		sed -i '/#include "/i \
savefile_directory = \"$HOME/RetroPie/saves/'${system_name}'\" \
savestate_directory = \"$HOME/RetroPie/saves/'${system_name}'/states\" \
<->' "${config_file}"
	  fi
	  
	  # Move existing saves to the master saves rom directory
	  if [[ "$system_name" != "daphne" ]]; then
	  find "$ROMS_DIR/$system_name" -regextype posix-egrep \
	  -regex ".*\.(srm|auto|state.auto|ldci|hi|dsv|lst.nvmem|lst.eeprom|nvmem|nvmem2|brm|dat)$" \
	  -type f -exec mv -t "$SAVES_DIR/$system_name/" {} +
	  find "$ROMS_DIR/$system_name/states" -regextype posix-egrep \
	  -regex ".*\.(state[0-9]|state.auto|state)$" \
	  -type f -exec mv -t "$SAVES_DIR/$system_name/states/" {} +
	  fi	
	done
	done_message
}


function rpc80_svoff() {
	dialog --infobox "...Reverting..." 3 20	; sleep 1
	CONFIGS_DIR=/opt/retropie/configs
	CONFIG_FILENAME=retroarch.cfg
	SAVES_DIR=$HOME/RetroPie/saves
	ROMS_DIR=$HOME/RetroPie/roms

	SAVE_FILE_CONFIG="savefile_directory = \"$HOME/RetroPie/saves"
	SAVE_STATE_CONFIG="savestate_directory = \"$HOME/RetroPie/saves"

	clear
	# Check for the existence of the saves directory
	if [ ! -d "$SAVES_DIR" ]; then
		echo "No save file directory. Exiting."
		#break
		return
		#continue
	fi

	# Loop through the configs directory
	for d in ${CONFIGS_DIR}//*; do
    # Get the system/emulator name
    system_name=${d##*/}
	
	# Skip a list of folders
	#skip_list=("all" "amiga" "genh" "megh" "moto" "neogeocd"  "pce-cd" "snesmsu1" "tg-cd")
	#if [[ " ${skip_list[@]} " =~ " ${system_name} " ]]; then
	# Skip `all` & symbolic link config folders
	if [ -L "$d" ] || [[ ${system_name} == 'all' ]]; then
		echo "Skipping ${system_name} folder configs"
		continue
	fi	
	
    # Check for existing config file
    config_file=${CONFIGS_DIR}/${system_name}/${CONFIG_FILENAME}

	if [[ -f ${config_file} ]]; then
		echo "Found config file: ${config_file}"
		else
		echo "No config file found for ${system_name}"
		continue
	fi

	# Remove duplicate savefile/savestate configs if present
	if grep -qE 'savefile_directory|savestate_directory' "$config_file"; then
		echo "Removing config entries..."
		sed -i '/savefile_directory.*/d' "$config_file"
		sed -i '/savestate_directory.*/d' "$config_file"
		sed -i '/<->.*/d' "$config_file"
	fi

	# Move savestates back into system states dir or RetroArch default path (if enabled in retroarch.cfg)
	global_cfg="/opt/retropie/configs/all/retroarch.cfg"
	state_dir=""

	# Check savestates_in_content_dir (quoted or unquoted true/false)
	if grep -qE 'savestates_in_content_dir *= *"?true"?' "$global_cfg"; then
		# true → use global retroarch path
		state_dir=$(grep -E '^savestate_directory' "$global_cfg" | awk -F'"' '{print $2}')
	else
		# false → use system ROMs path
		state_dir="$ROMS_DIR/$system_name/states"
	fi

	if [[ "$system_name" != "daphne" && -n "$state_dir" ]]; then
    # Count files before moving
    moved_files=$(find "$SAVES_DIR/$system_name" -type f | wc -l)

    # Move savefiles back
    find "$SAVES_DIR/$system_name" -regextype posix-egrep \
      -regex ".*\.(srm|auto|state.auto|ldci|hi|dsv|lst.nvmem|lst.eeprom|nvmem|nvmem2|brm|dat)$" \
      -type f -exec mv -t "$ROMS_DIR/$system_name/" {} +

    # Move savestates into whichever directory RetroArch is configured to use
    find "$SAVES_DIR/$system_name/states" -type f \
      \( -name "state" -o -name "state.auto" -o -name "state[0-9]" \) \
      -exec mv -t "$state_dir" {} +

    # Report how many files were moved
    echo "Moved $moved_files save files for $system_name"
	fi

  done
	# Delete system saves saves directory
	[ -d "$SAVES_DIR" ] && rm -rf "$SAVES_DIR"
	
	done_message	
}


function strg_bench() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	sudo /home/pi/PlayBox-Setup/.pb-fixes/_scripts/storage_bench.sh
}


function omxvol() {
	clear
# OMXPlayer Volume Control 04.2026 By 2Play! 

	local choice
	while true; do
    choice=$(dialog --backtitle "$BACKTITLE" --title " OMXPlayer VOLUME MENU " \
        --ok-label OK --cancel-label Back \
        --menu "Please Set Preferred OMXPlayer Volume:" 25 75 20 \
        1 " - Set to 90% " \
        2 " - Set to 85% " \
        3 " - Set to 80% " \
        4 " - Set to 75% " \
        5 " - Set to 70% " \
        6 " - Set to 60% " \
        7 " - Set to 50% " \
        8 " - Set to 25% " \
        9 " - Set to 100% (Default - Reset) " \
        10 " - Set to 0% (Mute) " \
        2>&1 > /dev/tty)

    case "$choice" in
        1) apply_omx_volume 600   ;; # 90%
        2) apply_omx_volume 900   ;; # 85%
        3) apply_omx_volume 1200  ;; # 80%
        4) apply_omx_volume 1500  ;; # 75%
        5) apply_omx_volume 1750  ;; # 70%
        6) apply_omx_volume 2400  ;; # 60%
        7) apply_omx_volume 3000  ;; # 50%
        8) apply_omx_volume 4500  ;; # 25%
        9) apply_omx_volume reset ;; # 100% default
        10) apply_omx_volume 6000 ;; # mute
        *) break ;;
    esac
done
}


function apply_omx_volume() {
	local offset="$1"
    dialog --infobox "...Applying..." 3 20 ; sleep 1
    if [ "$offset" = "reset" ]; then
        sudo sed -i 's/$OMXPLAYER_BIN --vol -[0-9]*/$OMXPLAYER_BIN/g' /usr/bin/omxplayer
    else
        sudo sed -i "s|\$OMXPLAYER_BIN --vol -[0-9]*|\$OMXPLAYER_BIN|g; s|\$OMXPLAYER_BIN|\$OMXPLAYER_BIN --vol -$offset|g" /usr/bin/omxplayer
    fi
    done_message
}																						


function emus_compile() {
# Emulators Custom Compile By 2Play! 
# 04.2026
	clear
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " EMULATORS COMPILE MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Choose the custom emulator you want to compile and apply..." 25 75 20 \
            - "*** EMULATORS COMPILE MENU SELECTIONS ***" \
			""      "" \
			1 "Amiberry Update or Compile GitHub Options " \
			2 "PPSSPP Compile GitHub Latest Release " \
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
        choice=$(dialog --backtitle "$BACKTITLE" --title " AMIBERRY UPDATE MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which amiberry binary you want to compile or install?" 25 75 20 \
            - "*** AMIBERRY UPDATE SELECTIONS ***" \
			""      "" \
			1 "Amiberry: Latest Official Stable Release " \
			2 "Amiberry: Compile From GitHub Source " \
			3 "Amiberry: Toggle Default Binary (NEW or ORIG) " \
			""      "" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) amiberry_x86  ;;
            2) compile_amiberry_x86  ;;
            3) amiberry_default  ;;
            -) none ;;
            *)  break ;;
        esac
    done
}

function amiberry_x86() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd $HOME/code/
	# Download the latest .deb from Releases or Development Builds https://github.com/BlitterStudio/amiberry/releases/latest
set -e

# Detect OS release
OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
VER=$(lsb_release -rs)

echo "Detected OS: $OS $VER"

# Get latest release assets list from GitHub
LATEST_URL="https://api.github.com/repos/BlitterStudio/amiberry/releases/latest"
ASSETS=$(curl -s $LATEST_URL | grep "browser_download_url" | cut -d '"' -f 4)

# Try to find matching asset for your OS version
MATCH=$(echo "$ASSETS" | grep -i "$OS" | grep -i "$VER" || true)

if [ -z "$MATCH" ]; then
    echo "No exact match for $OS $VER, trying generic assets..."
    MATCH=$(echo "$ASSETS" | grep -E '\.deb$|\.zip$' | head -n1)
fi

echo "Selected asset: $MATCH"

# Download
FILE=$(basename "$MATCH")
curl -L "$MATCH" -o "$FILE"

# Install depending on type
if [[ "$FILE" == *.deb ]]; then
    echo "Installing .deb package..."
    sudo dpkg -i "$FILE" || sudo apt-get -f install -y

elif [[ "$FILE" == *.zip ]]; then
    echo "Unzipping archive..."
    unzip -o "$FILE" -d amiberry-latest
    cd amiberry-latest

    # Find the deb inside the zip
    INNER_DEB=$(find . -name "*.deb" | head -n1)
    if [ -n "$INNER_DEB" ]; then
        echo "Installing extracted deb: $INNER_DEB"
        sudo dpkg -i "$INNER_DEB" || sudo apt-get -f install -y
    else
        echo "No .deb file found inside the zip!"
        exit 1
    fi
else
    echo "Unknown file type: $FILE"
    exit 1
fi
	clear
	cd /opt/retropie/emulators/amiberry/
	# Only back up if "amiberry" is a regular file (binary), not a symlink
	if [ -f amiberry ] && [ ! -L amiberry ]; then
		echo "Backing up original binary..."
		sudo mv amiberry amiberryORIG
	fi
	sudo ln -sfn /usr/bin/amiberry amiberry
	
	cd $HOME/code/
	rm -rf amiberry-latest amiberry*.deb amiberry*.zip
	done_message
}

function compile_amiberry_x86() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd $HOME/code/

	##Dependencies Do Before Release
	sudo apt install build-essential git cmake libsdl3-dev libsdl3-image-dev libflac-dev libmpg123-dev libpng-dev libmpeg2-4-dev libserialport-dev libportmidi-dev libenet-dev libpcap-dev libzstd-dev libcurl4-openssl-dev nlohmann-json3-dev libdbus-1-dev nlohmann-json3-dev -y

	#Requires SDL3, will coexist with SDL2
	set -e
	BASE="$HOME/code"
	mkdir -p "$BASE"
	cd "$BASE"

	# Function to fetch, build, and install SDL-style projects
	build_sdl_component() {
    local repo=$1
    local prefix=$2

    # Get latest from GitHub API
    TAG=$(curl -s https://api.github.com/repos/libsdl-org/$repo/releases/latest | grep tag_name | cut -d '"' -f4)
    VERSION=${TAG#release-}
    URL="https://github.com/libsdl-org/$repo/releases/download/$TAG/${prefix}-${VERSION}.tar.gz"

    echo "Fetching $repo $VERSION..."
    wget -q "$URL"
    tar -xvf ${prefix}-${VERSION}.tar.gz

    cd ${prefix}-${VERSION}
    cmake -B build -DCMAKE_PREFIX_PATH=/usr/local
    cmake --build build -j$(nproc)
    sudo cmake --install build

    cd "$BASE"
	}

	# Build SDL3 and SDL3_image inside $HOME/code
	build_sdl_component SDL SDL3
	build_sdl_component SDL_image SDL3_image
	clear
	sleep 1
	
	#Get Amiberry Latest Source
	#git clone --recursive https://github.com/BlitterStudio/amiberry.git
	cd amiberry
	#make clean
	rm -rf build
	git pull
	cmake -B build && cmake --build build
	#CMake's default installation prefix is /usr/local/. To change this, specify a different prefix when invoking CMake. For example, to install under /opt, use:
	#cmake -B build -G Ninja -DCMAKE_INSTALL_PREFIX=$HOME/code && cmake --build build
	echo "[COMPILE COMPLETE!...]"
	sudo cp ./build/amiberry /opt/retropie/emulators/amiberry/amiberryNEW
	#rm -rf amiberry* SDL3*
	rm -rf SDL3*
	cd /opt/retropie/emulators/amiberry/
	# Only back up if "amiberry" is a regular file (binary), not a symlink
	if [ -f amiberry ] && [ ! -L amiberry ]; then
		echo "Backing up original binary..."
		sudo mv amiberry amiberryORIG
	fi
	sudo chmod 755 amiberryNEW
	sudo ln -sfn amiberryNEW amiberry
	done_message
}

function amiberry_default() {
clear
cd /opt/retropie/emulators/amiberry/
# Only back up if "amiberry" is a regular file (binary), not a symlink
if [ -f amiberry ] && [ ! -L amiberry ]; then
    echo "Backing up original binary..."
    sudo mv amiberry amiberryORIG
fi
target=$(readlink amiberry)
if [ "$target" = "amiberryNEW" ]; then
    sudo ln -sfn amiberryORIG amiberry
    echo "[OK Swap Complete...]"
elif [ "$target" = "amiberryORIG" ] && [ -f amiberryNEW ]; then
    sudo ln -sfn amiberryNEW amiberry
    echo "[OK Swap Complete...]"
else
    echo "A New Amiberry binary does not exist... Nothing to do!"
fi
clear
cd $HOME
}


function ppsspp_git() {
	clear
	local choice
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " PPSSPP SOURCE UPDATE MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which PPSSPP binary you want: Latest Compile or RPie binary?" 25 75 20 \
            - "*** PPSSPP UPDATE SELECTIONS ***" \
			""      "" \
			1 "PPSSPP: Compile From GitHub Source " \
			2 "PPSSPP: Toggle Default Binary (NEW or ORIG) " \
			""      "" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) compile_ppsspp_x86  ;;
            2) ppsspp_default  ;;
            -) none ;;
            *)  break ;;
        esac
    done
}


function compile_ppsspp_x86() {
	dialog --infobox "...Starting..." 3 20 ; sleep 1
	clear
	cd $HOME/code/
	#git clone --recurse-submodules https://github.com/hrydgard/ppsspp.git
	cd ppsspp
	#make clean
	rm -rf build
	git pull --rebase https://github.com/hrydgard/ppsspp.git
	./b.sh --release	
	echo "[COMPILE COMPLETE!...]"
	sudo cp ./build/PPSSPPSDL /opt/retropie/emulators/ppsspp/PPSSPPSDLNEW
	cd /opt/retropie/emulators/ppsspp/
	# Only back up if "PPSSPPSDL" is a regular file (binary), not a symlink
	if [ -f PPSSPPSDL ] && [ ! -L PPSSPPSDL ]; then
		echo "Backing up original binary..."
		sudo mv PPSSPPSDL PPSSPPSDLORIG
	fi
	sudo ln -sfn PPSSPPSDLNEW PPSSPPSDL
	#rm -rf ppsspp
	done_message
}

function ppsspp_default() {
clear
cd /opt/retropie/emulators/ppsspp/
# Only back up if "PPSSPPSDL" is a regular file (binary), not a symlink
	if [ -f PPSSPPSDL ] && [ ! -L PPSSPPSDL ]; then
		echo "Backing up original binary..."
		sudo mv PPSSPPSDL PPSSPPSDLORIG
	fi
target=$(readlink PPSSPPSDL)
if [ "$target" = "PPSSPPSDLNEW" ]; then
    sudo ln -sfn PPSSPPSDLORIG PPSSPPSDL
    echo "[OK Swap Complete...]"
elif [ "$target" = "PPSSPPSDLORIG" ] && [ -f PPSSPPSDLNEW ]; then
    sudo ln -sfn PPSSPPSDLNEW PPSSPPSDL
    echo "[OK Swap Complete...]"
else
    echo "A New PPSSPPSDL binary does not exist... Nothing to do!"
fi
clear
cd $HOME
}


function emus_tks() {
clear
# Emulators Extra Tweaks/Automations By 2Play! 
# 04.2026
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " EMULATOR TWEAKS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Apply the tweak(s) you need..." 25 75 20 \
            - "*** EMULATOR TWEAKS SELECTIONS ***" \
			""      "" \
			1 " - Virtual Boy Core: 3D Anaglyph Display Options " \
			2 " - GameBoy Core: Original or Enhanced GameBoy Display Options " \
			3 " - PPSSPP: Exits To ES or PPSSPP Menu " \
			4 " - N64 Lr-Core: Set Native Resolution to LowRes or HiRes OPTIONS" \
			5 " - Lr-PUAE Core: Amiga Model Selection Options " \
			6 " - Amiga Emulator: Selection Options  " \
			2>&1 > /dev/tty)

        case "$choice" in
            1) vboy_3d  ;;
            2) gboy_enh  ;;
			3) ppsspp_exit  ;;
            4) n64_res  ;;
			5) amiga_models  ;;
			6) amiga_choices  ;;
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
			""      "" \
           1 " - Disable PlayBox 3D Anaglyph Display Option " \
           2 " - Enable PlayBox 3D Anaglyph Display Option " \
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
    sed -i 's/^vb_anaglyph_preset/#vb_anaglyph_preset/' retroarch-core-options.cfg
    sed -i 's/^vb_3dmode/#vb_3dmode/' retroarch-core-options.cfg
    done_message
}

function vb_3d_on() {
    clear
    cd /opt/retropie/configs/virtualboy
    # Uncomment if present
    sed -i 's/^#vb_anaglyph_preset/vb_anaglyph_preset/' retroarch-core-options.cfg
    sed -i 's/^#vb_3dmode/vb_3dmode/' retroarch-core-options.cfg
    # Ensure entries exist if missing
    grep -q '^vb_anaglyph_preset' retroarch-core-options.cfg || echo 'vb_anaglyph_preset = "0"' >> retroarch-core-options.cfg
    grep -q '^vb_3dmode' retroarch-core-options.cfg || echo 'vb_3dmode = "anaglyph"' >> retroarch-core-options.cfg
    done_message
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
			""      "" \
           0 " - Show Current Cetting... " \
           1 " - Enable GameBoy Original (B/W) Display " \
           2 " - Enable GameBoy Enhanced (COLOR) Display " \
           2>&1 > /dev/tty)

        case "$choice" in
           0) gb_status  ;;
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
	grep -q 'sameboy_model = "Super Game Boy"' retroarch-core-options.cfg && \
    sed -i 's|sameboy_model = "Super Game Boy"|sameboy_model = "Auto"|' retroarch-core-options.cfg;
	sed -i \
	-e "s|gb_sameboy.cfg|gb.cfg|" \
	-e 's|custom_viewport_width = "1243"|custom_viewport_width = "665"|' \
    -e 's|custom_viewport_height = "1080"|custom_viewport_height = "610"|' \
    -e 's|custom_viewport_x = "339"|custom_viewport_x = "629"|' \
    -e 's|custom_viewport_y = "0"|custom_viewport_y = "235"|' retroarch.cfg
	done_message
}

function gb_clr_on() {
	clear
	cd /opt/retropie/configs/gb
	sed -i 's|sameboy_model = "Auto"|sameboy_model = "Super Game Boy"|' retroarch-core-options.cfg;
	sed -i \
	-e "s|gb.cfg|gb_sameboy.cfg|" \
	-e 's|custom_viewport_width = "665"|custom_viewport_width = "1243"|' \
	-e 's|custom_viewport_height = "610"|custom_viewport_height = "1080"|' \
	-e 's|custom_viewport_x = "629"|custom_viewport_x = "339"|' \
	-e 's|custom_viewport_y = "235"|custom_viewport_y = "0"|' retroarch.cfg
	done_message
}

function gb_status() {
    cd /opt/retropie/configs/gb
    if grep -q 'sameboy_model = "Super Game Boy"' retroarch-core-options.cfg; then
        clear && echo "Game Boy Color mode is active."
    else
        clear && echo "Game Boy Black & White mode is active."
    fi
    cd $HOME
	pausepress
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
			""      "" \
           0 " - Show PPSSPP Emu Exit Status: Exit to ES or to Emulator Menu " \
           ""      "" \
		   1 " - PPSSPP Emulator Exits to ES " \
           2 " - PPSSPP Emulator Exits to PPSSPP Menu " \
           2>&1 > /dev/tty)

        case "$choice" in
           0) ppsspp_ex_status  ;;
           1) ppsspp_ex_on  ;;
           2) ppsspp_ex_off  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function ppsspp_ex_status() {
    cd /opt/retropie/configs/psp
    if grep -q '--escape-exit' emulators.cfg; then
        clear && echo "PPSSPP will exit to ES."
    else
        clear && echo "PPSSPP will exit to PPSSPP Menu."
    fi
    cd $HOME
	pausepress
}

function ppsspp_ex_on() {
	clear
	cd /opt/retropie/configs/psp
	grep -q '--escape-exit' emulators.cfg || \
	sed -i 's|--fullscreen %ROM%|--fullscreen --escape-exit %ROM%|' emulators.cfg
	done_message
}

function ppsspp_ex_off() {
	clear
	cd /opt/retropie/configs/psp
	grep -q '--escape-exit' emulators.cfg && \
	sed -i 's|--fullscreen --escape-exit %ROM%|--fullscreen %ROM%|' emulators.cfg
	done_message
}


function n64_res() {
# The PlayBox Project 04.2026

	dialog --backtitle "PlayBox Toolkit" \
	--title "N64 CORE LOW OR HIGH RESOLUTION OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " N64 CORE LOW OR HIGH RESOLUTION OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's apply your favorable choice..." 25 75 20 \
            - "*** N64 CORE LOW OR HIGH RESOLUTION OPTIONS MENU SELECTIONS ***" \
			""      "" \
           0 " - Show N64 Current Resolution Setting " \
		   ""      "" \
           1 " - Set Native Low-Res (320x240) To N64 Lr-Core " \
           2 " - Set Native Hi-Res (640x480) To N64 Lr-Core " \
           2>&1 > /dev/tty)

        case "$choice" in
           0) n64_status  ;;
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
	sed -i 's|^mupen64plus-43screensize.*|mupen64plus-43screensize = "320x240"|' retroarch-core-options.cfg
	sed -i 's|^mupen64plus-next-43screensize.*|mupen64plus-next-43screensize = "320x240"|' retroarch-core-options.cfg
	done_message
}

function n64_hr_on() {
	clear
	cd /opt/retropie/configs/n64
	sed -i 's|^mupen64plus-43screensize.*|mupen64plus-43screensize = "640x480"|' retroarch-core-options.cfg
	sed -i 's|^mupen64plus-next-43screensize.*|mupen64plus-next-43screensize = "640x480"|' retroarch-core-options.cfg
	done_message
}

function n64_status() {
    cd /opt/retropie/configs/n64
    if grep -q 'mupen64plus-43screensize = "640x480"' retroarch-core-options.cfg; then
        clear && echo "N64 High Resolution mode is active."
    else
        clear && echo "N64 Low Resolution mode is active."
    fi
    cd $HOME
	pausepress
}


function amiga_models() {
# The PlayBox Project 04.2026

	dialog --backtitle "PlayBox Toolkit" \
	--title "AMIGA MODELS OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " AMIGA MODELS OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select The Amiga Model You Want to Use For..." 25 75 20 \
            ""      "" \
			0 " - Show Which AMIGA System Model is set... " \
			""      "" \
			- "*** AMIGA SPLIT SYSTEM FOLDER MODEL OPTIONS ***" \
			""      "" \
			1 " - Set Amiga 1200 (2MB Chip RAM + 8MB Fast RAM) " \
			2 " - Set Amiga 4000/040 (2MB Chip RAM + 8MB Fast RAM) " \
			3 " - Set Amiga 500+ (1MB Chip RAM) " \
			4 " - Set Amiga CD32 " \
			5 " - Set Amiga CDTV " \
			""      "" \
			- "*** AMIGA SINGLE SYSTEM FOLDER OPTION ***" \
			""      "" \
			6 " - Set Amiga System To AUTO (If You Use Amiga ONLY Roms Folder " \
			2>&1 > /dev/tty)

        case "$choice" in
           0) amiga_status  ;;
           1) A1200_on  ;;
           2) A4040_on  ;;
		   3) A_500+_on  ;;
		   4) CD32_on  ;;
           5) CDTV_on  ;;
           5) A_Auto_on  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}

function amiga_status() {
    clear
	echo "===== Amiga System Status ====="
    for sys in amiga amiga1200 amiga4000 amigacd32 cdtv; do
        cfg="/opt/retropie/configs/$sys/retroarch-core-options.cfg"
        if [[ -f $cfg ]]; then
            model=$(grep '^puae_model' "$cfg" | cut -d'=' -f2 | tr -d ' "')
            if [[ -n $model ]]; then
                echo "$sys: puae_model = $model"
            else
                echo "$sys: puae_model not set"
            fi
        else
            echo "$sys: config file missing"
        fi
    done
    echo "==============================="
    pausepress
	cd $HOME	
}

function A1200_on() {
	clear
	cd /opt/retropie/configs/amiga1200
	sed -i 's|^puae_model.*|puae_model = "A1200"|' retroarch-core-options.cfg
	done_message
}

function A4040_on() {
	clear
	cd /opt/retropie/configs/amiga4000
	sed -i 's|^puae_model.*|puae_model = "A4040"|' retroarch-core-options.cfg
	done_message
}

function A_500+_on() {
	clear
	cd /opt/retropie/configs/amiga
	sed -i 's|^puae_model.*|puae_model = "A500+"|' retroarch-core-options.cfg
	done_message
}

function CD32_on() {
	clear
	cd /opt/retropie/configs/amigacd32
	sed -i 's|^puae_model.*|puae_model = "CD32"|' retroarch-core-options.cfg
	done_message
}

function CDTV_on() {
	clear
	cd /opt/retropie/configs/cdtv
	sed -i 's|^puae_model.*|puae_model = "CDTV"|' retroarch-core-options.cfg
	done_message
}

function A_Auto_on() {
	clear
	cd /opt/retropie/configs/amiga
	sed -i 's|^puae_model.*|puae_model = "Auto"|' retroarch-core-options.cfg
	done_message
}


function amiga_choices() {
# The PlayBox Project 04.2026

	dialog --backtitle "PlayBox Toolkit" \
	--title "AMIGA SETUP OPTIONS MENU" \
	
    local choice
    while true; do
	    choice=$(dialog --backtitle "$BACKTITLE" --title " AMIGA SETUP OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select The Amiga Setup You Want to Apply..." 25 75 20 \
            - "*** AMIGA - PLAYBOX SETUP OPTIONS MENU SELECTIONS ***" \
			""      "" \
           0 " - Show Τhe Status Οf Βelow Οptions " \
			""      "" \
           1 " - Set Lr-PUAE as main emulator " \
           2 " - Set Amiberry as main emulator " \
		   ""      "" \
		   - "*** AMIGA CUSTOM OVERLAYS LR-PUAE SETUP ***" \
		   ""      "" \
           3 " - Custom Overlay Set For The Loaded Image (Art/View/Shader) " \
		   - "   Tx to Quizaseraq (LoadedImage-Set), Ransom & Pipmick (Creators) " \
		   ""      "" \
		   4 " - Quick Disable Shader from Custom Setup Option #3 " \
		   5 " - Quick Enable  Shader from Custom Setup Option #3 " \
		   2>&1 > /dev/tty)

        case "$choice" in
           0) amiga_choices_status  ;;
           1) lrpuae_on  ;;
           2) amiberry_on  ;;
		   3) lrpuae_custom_on  ;;
		   4) lrpuae_custom_sh_off  ;;
		   5) lrpuae_custom_sh_on  ;;
           -) none ;;
           *) break ;;
        esac
    done
}


function amiga_choices_status() {
    # Emulator default
    emu=$(grep '^default' /opt/retropie/configs/amiga/emulators.cfg | cut -d'"' -f2)
	clear
	echo "=== AMIGA Choices Status ==="
    
    echo "Default Emulator: $emu"

    # Overlay state
    if [[ -d /opt/retropie/configs/all/retroarch/config/PUAE ]]; then
        echo "Overlay: ENABLED"
    else
        echo "Overlay: DISABLED"
    fi

    # Shader state
    if [[ -f /opt/retropie/configs/all/retroarch/config/PUAE/PUAE.glslp ]]; then
        echo "Shader: ENABLED"
    else
        echo "Shader: DISABLED"
    fi
    echo "==========================="
	pausepress
}

function lrpuae_overlay_fix() {
    for sys in amigacd32 cdtv; do
        find "$sys" -name "retroarch.cfg" -exec sed -i \
            -e 's|.*#input_overlay_enable|input_overlay_enable|g' \
            -e 's|.*#input_overlay|input_overlay|g' \
            -e 's|.*#aspect_ratio_index|aspect_ratio_index|g' \
            -e 's|.*#custom_viewport_width|custom_viewport_width|g' \
            -e 's|.*#custom_viewport_height|custom_viewport_height|g' \
            -e 's|.*#custom_viewport_x|custom_viewport_x|g' \
            -e 's|.*#custom_viewport_y|custom_viewport_y|g' {} 2>/dev/null \;
    done
}

function lrpuae_on() {
	clear
	cd /opt/retropie/configs/
	find \( -name cdtv -prune \) -o -name "emulators.cfg" -exec sed -i 's|default = "amiberry"|default = "lr-puae"|' {} 2>/dev/null \;
	mv /opt/retropie/configs/all/retroarch/config/PUAE/ /opt/retropie/configs/all/retroarch/config/PUAE.OFF/
	find amiga -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g' {} 2>/dev/null \;
	find amiga1200 -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g' {} 2>/dev/null \;
	find amiga4000 -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g' {} 2>/dev/null \;
	lrpuae_overlay_fix
	done_message
}

function amiberry_on() {
	clear
	cd /opt/retropie/configs/
	find \( -name cdtv -prune \) -o -name "emulators.cfg" -exec sed -i 's|default = "lr-puae"|default = "amiberry"|' {} 2>/dev/null \;
	done_message
}

function lrpuae_custom_on() {
	clear
	cd /opt/retropie/configs/
	find \( -name cdtv -prune \) -o -name "emulators.cfg" -exec sed -i 's|default = "amiberry"|default = "lr-puae"|' {} 2>/dev/null \;
	mv /opt/retropie/configs/all/retroarch/config/PUAE.OFF/ /opt/retropie/configs/all/retroarch/config/PUAE/
	find amiga -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|^input_overlay|#input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g' {} 2>/dev/null \;
	find amiga1200 -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|^input_overlay|#input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g' {} 2>/dev/null \;
	find amiga4000 -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|^input_overlay|#input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g' {} 2>/dev/null \;
	lrpuae_overlay_fix
	done_message
}

function lrpuae_custom_sh_off() {
	clear
	cd /opt/retropie/configs/all/retroarch/config/PUAE
	done_message
}

function lrpuae_custom_sh_on() {
	clear
	cd /opt/retropie/configs/all/retroarch/config/PUAE
	mv PUAE.glslp.OFF PUAE.glslp
	done_message
}


function safe_shut() {
clear
# Safe Shutdown RetroFlag and Argon Scripts On/Off
# 04.2026
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " SAFE SHUTDOWN SCRIPTS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Apply the script you need..." 25 75 20 \
            - "*** RETROFLAG SHUTDOWN SCRIPT SELECTIONS ***" \
			- "*** Turn switch 'SAFE SHUTDOWN' on PCB to ON position. ***" \
			""      "" \
			0 " - RetroFlag Safe Shutdown Status " \
			1 " - RetroFlag NesPi+, MegaPi, SuperPi, NESPI4 Safe Shutdown [ON] " \
			2 " - RetroFlag GPi-Case Safe Shutdown [ON] " \
			3 " - RetroFlag All Cases Safe Shutdown [OFF] " \
			""      "" \
			- "*** ARGON ONE SHUTDOWN SCRIPT SELECTIONS ***" \
			- "*** Extra Settings Check https://bit.ly/3nfaID6 ***" \
			""      "" \
			4 " - Argon ONE Safe Shutdown Status " \
			5 " - Argon ONE Safe Shutdown & Fan [ON] " \
			6 " - Argon ONE Safe Shutdown & Fan [OFF] " \
			7 " - Argon ONE Adjust Fan Settings " \
			2>&1 > /dev/tty)

        case "$choice" in
            0) retroflag_status  ;;
            1) rflag_on  ;;
            2) rflaggpi_on  ;;
            3) rflag_off  ;;
			4) argon1_status  ;;
			5) argon1_on  ;;
            6) argon1_off  ;;
			7) argon1_fan  ;;
			-) none ;;
            *)  break ;;
        esac
    done
}

function retroflag_status() {
    clear
	echo "=== RetroFlag Status ==="

    # Check folder and scripts
    if [[ -d /opt/RetroFlag ]]; then
        echo "RetroFlag folder present in /opt"
        [[ -f /opt/RetroFlag/SafeShutdown.py ]] && echo "SafeShutdown.py found" || echo "SafeShutdown.py missing"
        [[ -f /opt/RetroFlag/multi_switch.sh ]] && echo "multi_switch.sh found" || echo "multi_switch.sh missing"
    else
        echo "RetroFlag not installed"
		pausepress
        return
    fi

    # Check rc.local entry
    if grep -q "sudo python3 /opt/RetroFlag/SafeShutdown.py &" /etc/rc.local; then
        echo "rc.local configured to run SafeShutdown.py"
    else
        echo "rc.local not configured"
    fi

    # Check overlay line in config.txt
    if grep -q "dtoverlay=gpio-poweroff,gpiopin=4,active_low=1,input=1" /boot/config.txt; then
        echo "Overlay line present in config.txt"
        echo "→ This matches Pi Case style install"
    else
        echo "Overlay line not present"
        echo "→ This matches GPI style install"
    fi

    echo "========================="
	pausepress
}

function argon1_status() {
    clear
	if [[ -x /usr/bin/argonone-config ]]; then
        echo "Argon1: ENABLED"
    else
        echo "Argon1: DISABLED"
    fi
	pausepress
}

function rflag_on() {
	clear
	wget -O - "https://raw.githubusercontent.com/crcerror/retroflag-picase/master/install.sh" | sudo bash
	done_message
}

function rflaggpi_on() {
	clear
	wget -O - "https://raw.githubusercontent.com/crcerror/retroflag-picase/master/install_gpi.sh" | sudo bash
	done_message
}

function rflag_off() {
	clear
	wget -O - "https://raw.githubusercontent.com/crcerror/retroflag-picase/master/uninstall_all.sh" | sudo bash
	reboot_message
}

function argon1_on() {
	clear
	curl https://download.argon40.com/argon1.sh | bash
	reboot_message
}

function argon1_off() {
	clear
	check_and_run /usr/bin/argonone-uninstall
	reboot_message
}

function argon1_fan() {
	clear
	check_and_run /usr/bin/argonone-config
	done_message
}


function desk_env() {
	clear
	echo "You need a keyboard..."
	echo
	echo "Choose the Desktop Environment you want by typing the selection/number..."
	echo "Pick from the ones with the (-session), from the seletions table below..."
	echo "(-session) ones start the Desktop Environment. "
	echo "Option 0 is the default one."
	echo
	sleep 1
	sudo update-alternatives --config x-session-manager
}



function clean_pbt() {
# The PlayBox Project 04.2026

	dialog --backtitle "PlayBox Toolkit" \
	--title "CLEANUP TOOLS OPTIONS MENU" \
	
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " CLEANUP TOOLS OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Let's do some cleanup..." 25 75 20 \
            - "*** PLAYBOX CLEANUP TOOLS SELECTIONS ***" \
			""      "" \
           1 " - Clean A gamelist.xml To Have Only Existing Roms, Meleu-2P! " \
		   2 " - Clean LastPlayed & PlayCount or Favorites Options " \
		   3 " - Clean Save Files Inside Roms & Saves Folder (Not fs|nv)" \
           4 " - Remove ES Auto-generated Gamelists " \
		   ""      "" \
		   5 " - Clean CLi Commands History & Reset To PlayBox Top Ones  " \
		   6 " - Clean Wi-Fi Settings " \
           7 " - Clean Filesystem & Cache " \
            2>&1 > /dev/tty)

        case "$choice" in
           1) cl_gm_xml  ;;
		   2) cl_xml  ;;
		   3) cl_saves  ;;
		   4) cl_es_gamelist  ;;
		   5) cl_cli_hist  ;;
           6) cl_wifi  ;;
           7) cl_sysncache  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}


function cl_gm_xml() {
	clear
	local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " GAMELIST.XML CLEANUP OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select one of the gamelist.xml cleanup options." 25 75 20 \
            - "*** GAMELIST.XML CLEANUP SELECTIONS ***" \
			""      "" \
            0 " - Show Which Systems Already Have A .CLEAN Backup File  " \
            ""      "" \
			1 " - Clean & Create for ALL systems [Original + gamelist.xml.CLEAN] " \
            2 " - Clean & Create for a specific system [Orig + gamelist.xml.CLEAN] " \
            2>&1 > /dev/tty)

        case "$choice" in
            0) gamelist_status ;;
			1) cl_gm_xml_all ;;
			2) cl_gm_xml_sys ;;
			-) none  ;;
			*)  break ;;
        esac
    done
}


function gamelist_status() {
    clear
	echo "=== Gamelist Status ==="
    cd $HOME/RetroPie/roms/

    # Find all gamelist.xml files
    for sys in $(find . -name "gamelist.xml" -printf "%h\n" | sort -h); do
        cleanfile="$sys/gamelist.CLEAN.xml"
        if [[ -f "$cleanfile" ]]; then
            echo "$(basename $sys): CLEAN version present"
        else
            echo "$(basename $sys): only original gamelist.xml"
        fi
    done

    echo "========================"
    pausepress
}

function cl_gm_xml_all() {
    clear
    /home/pi/PlayBox-Setup/.pb-fixes/_scripts/gamelist-cleaner.sh -a
    echo
    echo "Original Script by Meleu, updated for PlayBox v2 by 2Play!"
    echo "Cleaned XMLs saved in roms/%systemname% folders."
    echo "[CLEANED!...]"
    pausepress
}

function cl_gm_xml_sys() {
    clear
    echo "Available systems with gamelist.xml:"
    find $HOME/RetroPie/roms -name "gamelist.xml" -printf "%h\n" | sort -h | column | more
    echo
    read -p 'Which system would you like to clean?: ' sname
    echo

    if [[ -f $HOME/RetroPie/roms/$sname/gamelist.xml ]]; then
        $HOME/PlayBox-Setup/.pb-fixes/_scripts/gamelist-cleaner.sh "$HOME/RetroPie/roms/$sname/gamelist.xml"
        echo
        echo "Original Script by Meleu, updated for PlayBox v2 by 2Play!"
        echo "Cleaned XML saved in roms/$sname folder."
        echo "[CLEANED!...]"
        pausepress

        while true; do
            read -p 'Clean another system? [y/n]: ' yn
            case $yn in
                [Yy]*) cl_gm_xml_sys; return ;;
                [Nn]*) break ;;
                *) echo "Please answer y or n." ;;
            esac
        done
    else
        echo "[No gamelist.xml found or wrong system name. Back to menu...]"
        sleep 2
    fi
    clear
}


function cl_saves() {
    dialog --infobox "...Cleaning..." 3 20 ; sleep 1
    clear
    cl_saves_status
	
	# Common extensions
	exts=".*\.(srm|auto|state.auto|ldci|hi|dsv|lst.nvmem|lst.eeprom|nvmem|nvmem2|brm)$"

	# Daphne adds dat
	daphne_exts=".*\.(dat)$"

	# Clean common everywhere under roms + saves
	find "$HOME/RetroPie/roms"  -regextype posix-egrep -regex "$exts" -type f -delete
	find "$HOME/RetroPie/saves" -regextype posix-egrep -regex "$exts" -type f -delete

	# Clean Daphne extras
	find "$HOME/RetroPie/roms/daphne"  -regextype posix-egrep -regex "$daphne_exts" -type f -delete
	find "$HOME/RetroPie/saves/daphne" -regextype posix-egrep -regex "$daphne_exts" -type f -delete
    clear
    echo "[OK DONE!...]"
    sleep 1
}

function cl_saves_status() {
    clear
    echo "====== Save Cleaner Status ======"

    exts=".*\.(srm|auto|state.auto|ldci|hi|dsv|lst.nvmem|lst.eeprom|nvmem|nvmem2|brm)$"
    daphne_exts=".*\.(dat)$"

    total=0
    for d in "$HOME/RetroPie/roms" "$HOME/RetroPie/saves" "$HOME/RetroPie/roms/daphne" "$HOME/RetroPie/saves/daphne"; do
        if [[ "$d" == *daphne* ]]; then
            count=$(find "$d" -regextype posix-egrep -regex "$daphne_exts" -type f | wc -l)
        else
            count=$(find "$d" -regextype posix-egrep -regex "$exts" -type f | wc -l)
        fi
        echo "$(basename $d): $count files to be cleaned"
        total=$((total + count))
    done

    echo "--------------------------------"
    echo "Total files across all dirs: $total"
    echo "================================"
    pausepress
}


function cl_xml() {
	clear
	## ES check status
	#if pgrep -x emulationstation > /dev/null; then
    #echo "EmulationStation is running, killing now..."
    #pkill emulationstation
	#else
	#	echo "EmulationStation is not running."
	#fi
	
# Clear AutoLastPlayed & PlayCount or Favorites New Cleaner Script
# 04.2026

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
            1 " - Clear AutoLastPlayed & PlayCount " \
            ""      "" \
            - "*** CLEANUP FAVORITES SELECTIONS ***" \
            2 " - Clear Favorites " \
            2>&1 > /dev/tty)

        case "$choice" in
            1) clear_ALP_PC  ;;
            2) clear_FAV  ;;
            -)  none ;;
            *) break ;;
        esac
    done
}


# Helper: Clean gamelist.xml entries by pattern
function clean_gamelists() {
    local pattern="$1"
    shift
    local dirs=("$@")

    for d in "${dirs[@]}"; do
        for f in "$d"/**/gamelist.xml; do
            [ -f "$f" ] || continue
            echo "file: $f"
            grep -v -e "$pattern" "$f" > "$f.tmp" && mv -f "$f.tmp" "$f"
        done
        echo "[OK DONE!...]"
        sleep 1
    done
}

function clear_ALP_PC() {
    dialog --infobox "...Clearing..." 3 20 ; sleep 2
    clear
    if [ -d "$HOME/addonusb" ]; then
        echo "External USB enabled..."
        sleep 2
        clean_gamelists "lastplayed\|playcount" \
            "$HOME/addonusb/roms" \
            "$HOME/addonusb/roms/ports" \
            "$HOME/RetroPie/localroms"
    else
        echo "External USB disabled..."
        sleep 2
        clean_gamelists "lastplayed\|playcount" \
            "$HOME/RetroPie/roms" \
            "/opt/retropie/configs/all/emulationstation/gamelists"
    fi
    restart_es
}

function clear_FAV() {
    dialog --infobox "...Clearing..." 3 20 ; sleep 2
    clear
    if [ -d "$HOME/addonusb" ]; then
        echo "External USB enabled..."
        sleep 2
        clean_gamelists "favorite>" \
            "$HOME/addonusb/roms" \
            "$HOME/addonusb/roms/ports" \
            "$HOME/RetroPie/localroms" \
            "$HOME/RetroPie/localroms/ports"
    else
        echo "External USB disabled..."
        sleep 2
        clean_gamelists "favorite>" \
            "$HOME/RetroPie/roms" \
            "$HOME/RetroPie/roms/ports" \
            "/opt/retropie/configs/all/emulationstation/gamelists"
    fi
    restart_es
}


function cl_es_gamelist() {
    dialog --infobox "...Please Wait..." 3 22 ; sleep 1
    clear
    echo
    echo " This script will remove all the auto-generated EmulationStation gamelists."
    echo " They are located in /opt/retropie/configs/all/emulationstation/gamelists/"
    echo " EXCEPT the retropie/options one that handles the retropiemenu."
    echo
    sleep 3
    find /opt/retropie/configs/all/emulationstation/gamelists/ \
        -type f -name '*.xml' \
        ! -path "/opt/retropie/configs/all/emulationstation/gamelists/retropie/*" \
        -exec rm {} \;
    done_message
    restart_es
}


function cl_cli_hist() {
	dialog --infobox "...Fixing..." 3 17 ; sleep 1
	#cat /dev/null > $HOME/.bash_history
	history -cw && clear
	cp $HOME/PlayBox-Setup/.pb-fixes/cli/.bash_history $HOME/
	cp $HOME/PlayBox-Setup/.pb-fixes/cli/input_history $HOME/.config/mps-youtube/
	cp $HOME/PlayBox-Setup/.pb-fixes/cli/play_history.m3u $HOME/.config/mps-youtube/
	cd $HOME
	#sed -i '1i***Welcome to PlayBox, 2Play!***\nsdl2-config --version\nmodetest -s 89:#0\nvulkaninfo | grep deviceName\nglxinfo -B\npython3 $HOME/code/export.py $HOME/RetroPie/roms/full_list.xlsx -d\nsudo raspi-config\nSkyscraper\nstartx\nglances\nbpytop\nsudo $HOME/RetroPie-Setup/retropie_setup.sh\nemulationstation\n2p-FixPlayBox' .bash_history
	sed -i '15,1000d' .bash_history
	done_message
}


function cl_wifi() {
    dialog --infobox "...Cleaning..." 3 20 ; sleep 1
    clear

	# Get active WiFi device + SSID
    active=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION d | grep '^.*:wifi:connected')

    if [ -z "$active" ]; then
        dialog --msgbox "No active WiFi connection found." 8 50
        return
    fi

    # Parse device and SSID
    device=$(echo "$active" | cut -d: -f1)
    ssid=$(echo "$active" | cut -d: -f4)

    # Confirm disconnect
    dialog --yesno "Disconnect from SSID: $ssid (device: $device)?" 8 60
    if [ $? -eq 0 ]; then
        sudo nmcli device disconnect "$device"
		sudo nmcli connection delete $ssid
		sudo rm /etc/NetworkManager/system-connections/*.nmconnection 2>/dev/null
		sudo systemctl restart NetworkManager
        dialog --msgbox "Disconnected from SSID: $ssid & Removed configuration." 8 50
    fi
	
	done_message
}


function cl_sysncache() {
	dialog --infobox "...System Cleanup..." 3 25 ; sleep 1
    clear

    echo "Removing unused packages..."
    sudo apt autoremove --purge -y

    echo "Cleaning package cache..."
    sudo apt autoclean

    echo "Vacuuming system logs (keep last 15 days)..."
    sudo journalctl --vacuum-time=15d

    echo "Checking cache sizes..."
    sudo du -sh /var/cache/* 2>/dev/null

    echo "[OK DONE! System cleanup completed]"
    done_message
}


function sys_pbt() {
	dialog --backtitle "PlayBox Toolkit" \
	--title "SYSTEM OPTIONS MENU" \
	
    local choice
    
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " SYSTEM OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Get to know your System..." 25 75 20 \
            - "*** PLAYBOX SYSTEM TOOLS ***" \
			""      "" \
		   1 " - Filesystem Check is Automated " \
		   2 " - Expand The Armbian OS Partition " \
		   ""      "" \
		   3 " - Show Partitions & Space Info " \
		   4 " - Show Folders Size [roms/BIOS/root] " \
           5 " - Show System Free Memory Info " \
           6 " - Show OS Version & Info " \
           7 " - System & FW Update Options " \
		   ""      "" \
           8 " - PlayBox System Full Info " \
		   9 " - Monitor In Real Time Board Temperature " \
		  10 " - Show CPU Cores Status " \
		  11 " - Ratio Video Tool Options [OFF] " \
		   2>&1 > /dev/tty)

        case "$choice" in
           1) fschk_bt  ;;
           2) expand_os  ;;
		   #3) hide_uboot  ;;
           3) partitions  ;;
		   4) fold_sz  ;;
           5) mem_status  ;;
           6) os_info  ;;
           7) os_update  ;;
           8) sysinfo  ;;
		   9) temp_rt  ;;
		  10) cores_status  ;;
		  #11) ratio_vt  ;;
		   -) none ;;
            *)  break ;;
        esac
    done
}


function fschk_bt() {
	#dialog --infobox "...Please Wait..." 3 22 ; sleep 1
	clear
	echo
	#echo "Please be patient..."
	#echo "Screen will go black, activity led will be on while filsystem check. Once completed your system will reboot as normal."
	echo -e "Filesystem check policy:\n"
    echo -e "• Automatic filesystem check runs every 1 month (via tune2fs).\n"
    echo -e "• If warnings or errors appear, run a manual check or use gparted on another host.\n"
    echo -e "• Old /forcefsck method is deprecated.\n"
    echo -e "\nFor details, see Discord guide:\nHow to Scan-Fix your Linux filesystem (Pi or similar)\nUpdate 28.05.2021\n"

	fschk_status
	#sleep 5
	#sudo touch /forcefsck && sudo reboot
}

function fschk_status() {
    clear
    echo "Filesystem check status (ext4 partitions):"
    echo

    # Loop through all ext4 entries in fstab
    awk '$3 == "ext4" {print $2}' /etc/fstab | while read -r mountpoint; do
        dev=$(findmnt -n -o SOURCE "$mountpoint" 2>/dev/null)
        if [[ -b "$dev" ]]; then
            echo "Mountpoint: $mountpoint"
            echo "Device: $dev"
            sudo tune2fs -l "$dev" | grep -E "Mount count:|Maximum mount count:"
            echo
        fi
    done
	
	count=$(awk '$3 == "ext4" {print $2}' /etc/fstab | wc -l)
	echo "Checked total $count ext4 partition(s)."

    read -n 1 -s -r -p "Press any key to continue"
}



function expand_os() {
	dialog --infobox "...Expanding..." 3 20 ; sleep 1
	clear
	sudo systemctl enable armbian-resize-filesystem >/dev/null 2>&1
	echo
	reboot_message
}


function hide_uboot() {
	dialog --infobox "...Fixing..." 3 20 ; sleep 1
	clear
	sudo dpkg -i code/linux-u-boot-tinkerboard-current_23.08.0-trunk_armhf__2022.04-Se4b6-Pf734-H0e2e-Vc2b8-B9963-R448a.deb
	echo
	reboot_message
}


function partitions() {
	dialog --infobox "...Checking..." 3 20 ; sleep 1
	clear
	df -h
	pausepress
}


function fold_sz() {
	dialog --infobox "...Checking..." 3 20 ; sleep 1
	clear
	
	disk_usage_top /home/pi/RetroPie/roms
	pausepress
	
	disk_usage_top /home/pi/RetroPie/BIOS
	pausepress
	
	disk_usage_top
	pausepress
}

function disk_usage_top() {
    target=${1:-/}   # default to root if no argument
    echo "Top disk usage in $target:"
    sudo du -h --max-depth=1 "$target" | sort -hr | head -20 | more -d
	
	#With Subfolders
	#du -h | sort -hr | column | more -d
	
	#Only Top Folder Names
	#du -h --max-depth=1 | sort -hr | column | more -d
	
	#Shows the top 20 largest entries.
	#du -h --max-depth=1 / | sort -hr | head -20
}


function freemem() {
	dialog --infobox "...Checking..." 3 20 ; sleep 1
	clear
	free -h
	#free mem
	pausepress
	
	#live updating memory usage every second. Set press any key to stop (see temp)
	#watch -n 1 free -h
	#sleep 2
	#read -t 0.1 -n 1 key && break

}

function mem_status() {
    clear
    echo "Memory usage:"
    free -h
    echo
    echo "Top 5 memory-hungry processes:"
    ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6
    pausepress
}


function os_info() {
	dialog --infobox "...Checking..." 3 20 ; sleep 2
	clear
	#uname -snrmo
	#lsb_release -ds
	ensure_lolcat
	fastfetch | lolcat
	pausepress
}


function os_update() {
	clear
# SYSTEM Update Options Script by 2Play!
# 03.2026

infobox=""
infobox="${infobox}\n"
infobox="${infobox}\n- Upgrades packages to the newest versions **without removing anything**.\n- Safe, but may leave some packages “held back” if dependencies change.\n\n"
infobox="${infobox}\n                  SYSTEM WILL REBOOT AFTER UPDATING."
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
            1 " - OS Upgrade: Upgrades Packages To The Newest Versions " \
            ""      "" \
            - "*** FIRMWARE UPDATING SELECTIONS ***" \
            2 " - Firmware - Check/Upgrade With Armbian-Config" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) upgrade_os  ;;
            2) fw_up  ;;
            -) none ;;
            *) break ;;
        esac
    done
}


function upgrade_os() {
#- Upgrades packages to the newest versions **without removing anything**.
#- Safe, but may leave some packages “held back” if dependencies change.

	dialog --infobox "...Please wait until updates completed!..." 3 47 ; sleep 2
	clear
	sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove --purge && sudo apt autoclean && sudo apt clean
	echo
	pausepress
	reboot_message
}

function upgrade_fullos() {
#full-upgrade performs the function of upgrade but will remove currently installed packages if this is needed to upgrade the system as a whole.
	dialog --infobox "...Please wait until updates completed!..." 3 47 ; sleep 2
	clear
	sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove --purge && sudo apt autoclean && sudo apt clean
	echo
	pausepress
	reboot_message
}


function fw_up() {
	clear
	sudo armbian-config
}


function sysinfo() {
	dialog --infobox "...Please Wait..." 3 22 ; sleep 1
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 03.2026
	clear
# Ensure environment is correctly set up
source $HOME/.bash_profile
#$HOME/PlayBox-Setup/.pb-fixes/_scripts/2play_sysinfo.sh
pausepress
}


function temp_rt() {
    dialog --infobox "...Press any key to exit..." 3 36 ; sleep 3
    clear
    # Run temperature script in a loop until a key is pressed
    while true; do
        clear
        $HOME/PlayBox-Setup/.pb-fixes/_scripts/temperature.sh
        sleep 2
        read -t 0.1 -n 1 key && break
    done
    clear
    echo "[Exited Temperature Monitor]"
}

function cores_status() {
    dialog --infobox "...Checking..." 3 20 ; sleep 1
    clear

    local cores=$(getconf _NPROCESSORS_ONLN)
    echo "Your system has $cores core(s)"
    echo "Online cores: $(cat /sys/devices/system/cpu/online)"
    echo

    local total=0 count=0
    for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
        core=$(basename "$cpu")
        freq_file="$cpu/cpufreq/scaling_cur_freq"
        gov_file="$cpu/cpufreq/scaling_governor"

        if [[ -f "$freq_file" ]]; then
            freq=$(awk '{printf "%.1f", $1/1000}' "$freq_file") # kHz → MHz
            total=$(echo "$total + $freq" | bc)
            ((count++))
        else
            freq="N/A"
        fi

        governor=$( [[ -f "$gov_file" ]] && cat "$gov_file" || echo "N/A" )

        echo "$core → ${freq} MHz | governor: $governor"
    done

    if (( count > 0 )); then
        avg=$(echo "scale=1; $total / $count" | bc)
        echo
        echo "Average frequency across $count core(s): $avg MHz"
    fi
    pausepress
}




function ratio_vt() {
#VIDEO+ RATIO & RESOLUTION For Pi Boards, By 2Play!
# 08.10.2020 - 0x.2026

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
			""      "" \
           V1 " - LIST CONNECTED DISPLAY DEVICES " \
		   V2 " - SHOW YOUR HDMI 0&1 STATUS (Resolution etc.) " \
		   A1 " - SHOW YOUR SUPPORTED (HDMI 0&1) AUDIO INFORMATION " \
		  CEA " - SHOW YOUR SUPPORTED MODES (HDMI 0&1) FOR THIS GROUP " \
		  DMT " - SHOW YOUR SUPPORTED MODES (HDMI 0&1) FOR THIS GROUP " \
			""      "" \
			- "*** HDMI PORT [4:3] SELECTIONS ***" \
        1:CEA01 " - VGA     640x480   60Hz   [4:3] " \
		2:CEA02 " - 480p    720x480   60Hz   [4:3] " \
		3:CEA17 " - 576p    720x576   50Hz   [4:3] " \
        4:DMT09 " - SVGA    800x600   60Hz   [4:3] " \
        5:DMT16 " - XGA    1024x768   60Hz   [4:3] " \
		6:DMT32 " - SXGA   1280x960   60Hz   [4:3] " \
		7:DMT51 " - UXGA  1600×1200   60Hz   [4:3] " \
		    ""      "" \
            - "*** HDMI PORT [16:9] SELECTIONS ***" \
		8:CEA03 " - 480p    720x480   60Hz  [16:9] " \
		9:CEA18 " - 576p    720x576   50Hz  [16:9] " \
	   10:CEA04 " - 720p   1280x720   60Hz  [16:9] " \
	   11:CEA19 " - 720p   1280x720   50Hz  [16:9] " \
	   12:CEA16 " - 1080p 1920x1080   60Hz  [16:9] " \
	   13:CEA31 " - 1080p 1920x1080   50Hz  [16:9] " \
	   14:CEA97 " - 2160p 3840x2160   60Hz  [16:9] " \
	   15:DMT85 " - 720p   1280x720   60Hz  [16:9] " \
       16:DMT82 " - 1080p 1920x1080   60Hz  [16:9] " \
	        ""      "" \
            - "*** HDMI PORT [x:x] SELECTIONS ***" \
       17:DMT35 " - SXGA   1280x1024  60Hz   [5:4] " \
       18:DMT58 " - WSXGA+ 1680x1050  60Hz [16:10] " \
	   19:DMT69 " - WUXGA  1920x1200  60Hz [16:10] " \
	   20:CEA76 " - 1080p  1920x1080  60Hz [64:27] " \
	   21:CEA75 " - 1080p  1920x1080  50Hz [64:27] " \
	   22:DMT87 " - CUSTOM .NOTxSET.  60Hz [xx:xx] " \
	        ""      "" \
            - "*** SDTV - COMPOSITE VIDEO PORT SELECTIONS ***" \
            - "*** Default values are: NTSC & [4:3] No Change ***" \
       23:STD " - Composite Video Port Mode   JP NTSC " \
       24:STD " - Composite Video Port Mode   PAL " \
       25:STD " - Composite Video Port Mode   Brazil PAL " \
       26:STR " - Composite Video Port Ratio  [14:9] " \
       27:STR " - Composite Video Port Ratio  [16:9] " \
            ""      "" \
            - "*** DISABLE HDMI SELECTIONS ***" \
       28:ALL " - Disable Any CEA/DMT HDMI or STDTV Setting Applied " \
            2>&1 > /dev/tty)
			
        case "$choice" in
           V1) list_dvc ;;
		   V2) hdmi_stat ;;
		   A1) audio_inf ;;
		  CEA) sup_cea ;;
		  DMT) sup_dmt ;;
		1:CEA01) enable_vr 1 ;;
        2:CEA02) enable_vr 2 ;;
		3:CEA17) enable_vr 17 ;;
		4:DMT09) enable_vrd 9 ;;
        5:DMT16) enable_vrd 16 ;;
        6:DMT32) enable_vrd 32 ;;
        7:DMT51) enable_vrd 51 ;;
        8:CEA03) enable_vr 3 ;;
		9:CEA18) enable_vr 18 ;;
	   10:CEA04) enable_vr 4 ;;
       11:CEA19) enable_vr 19 ;;
       12:CEA16) enable_vr 16 ;;
	   13:CEA31) enable_vr 31 ;;
	   14:CEA97) enable_vr 97 ;;
       15:DMT85) enable_vrd 85 ;;
       16:DMT82) enable_vrd 82 ;;
	   17:DMT35) enable_vrd 35 ;;
	   18:DMT58) enable_vrd 58 ;;
	   19:DMT69) enable_vrd 69 ;;
	   20:CEA76) enable_vr 76 ;;
	   21:CEA75) enable_vr 75 ;;
	   22:DMT87) enable_vrdcX 87 ;;
       23:STD) enable_sdtvm 1 ;;
       24:STD) enable_sdtvm 2 ;;
       25:STD) enable_sdtvm 3 ;;
       26:STR) enable_sdtvr 2 ;;
       27:STR) enable_sdtvr 3 ;;
       29:ALL) disable_vrALL ;;
	        -) none ;;
            *) break ;;
        esac
    done
}

# List all attached devices
function list_dvc() {
	clear
	tvservice -l
	pausepress
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
	pausepress
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
	pausepress
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
	pausepress
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
	pausepress
}

# Enables a custom standard CEA ratio & resolution.
function enable_vr() {
  #dialog --infobox "...Applying..." 3 20 ; sleep 2
  sudo sed -i "s|^hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
  #sudo sed -i "s|^hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
  sudo sed -i "s|^hdmi_cvt=|#hdmi_cvtX=|" "${CONFIG_PATH}";
  sudo sed -i "s|#hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
  #sudo sed -i "s|#hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
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
	done_message
	reboot_message
}

# Enables a custom standard DMT ratio & resolution.
function enable_vrd() {
  #dialog --infobox "...Applying..." 3 20 ; sleep 2
  sudo sed -i "s|^hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
  #sudo sed -i "s|^hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
  sudo sed -i "s|^hdmi_cvt=|#hdmi_cvtX=|" "${CONFIG_PATH}";
  sudo sed -i "s|#hdmi_mode=.*|hdmi_mode=$1|" "${CONFIG_PATH}";
  #sudo sed -i "s|#hdmi_ignore_edid=0xa5000080|hdmi_ignore_edid=0xa5000080|" "${CONFIG_PATH}";
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
	done_message
	reboot_message
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
	done_message
	reboot_message
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
	done_message
	reboot_message
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
	done_message
	reboot_message
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
	done_message
	reboot_message
}


function thankyou_pb() {
	#dialog --infobox "...Please Wait..." 3 22 ; sleep 1
	clear
	$HOME/PlayBox-Setup/.pb-fixes/_scripts/thankyou.sh
}


function update_pbs() {
	#dialog --infobox "...Updating..." 3 20 ; sleep 1
# Update Toolkit 05.26
	clear
	#cd "$HOME/PlayBox-Setup" || return
	cd $HOME/PlayBox-Setup
	chmod 755 .pb-fixes/retropiemenu/fixplaybox.sh
	
	echo "Let's pull latest PlayBox-Setup updates..."
	sleep 1
	git fetch
	git reset --hard HEAD
	git merge '@{u}'
	sleep 2
	
	# Detect current branch
	branch=$(git rev-parse --abbrev-ref HEAD)

	# Make sure we’re tracking the remote
	#git fetch --all

	# Reset to the remote branch
	#git reset --hard origin/$branch

	# Clean up untracked files
	#git clean -fd

	echo "[OK DONE! Updated branch $branch]"
	
	# Check if critical files were updated
    if git diff --name-only HEAD@{1} HEAD | grep -E "fixplaybox.sh|post-fixes.sh" >/dev/null; then
        echo
        echo "[CRITICAL UPDATE DETECTED]"
        echo "fixplaybox.sh or post-fixes.sh was updated."
        echo "Please rerun the toolkit update to apply/use the latest changes."
		pausepress
        exit 1
    fi
	
	safe_remove /home/pi/PlayBox-Setup/.pb-fixes/music
	
	pausepress
	fix_rpmenu
	#sanitize_scripts
	
	$HOME/PlayBox-Setup/.pb-fixes/_scripts/post-fixes.sh
    #cd "$HOME" || return
    cd $HOME
}


# === Overlay Fixes with Arguments ===
#overlay_fix "FinalBurn Neo" "MAME" "Arcade" "Genesis Plus GX" "megadrive"

function overlay_fix() {
    echo "Applying overlay fixes..."

    # Loop over all arguments passed to the function
    for sys in "$@"; do
        cfg_dir="/opt/retropie/configs/all/retroarch/config/$sys"
        if [[ -d "$cfg_dir" ]]; then
            echo "Patching overlays in $cfg_dir ..."
            find "$cfg_dir" -type f -name "*.cfg" -print0 | \
                xargs -0 sed -i 's|MAME-Vertical.cfg|pb-vr.cfg|g'
        else
            echo "Skipping $sys (no config dir found)"
        fi
    done

    # Symlink overlay file for compatibility
    ln -sfn /opt/retropie/configs/all/retroarch/overlay/PlayBox/pb-vr.cfg \
            /opt/retropie/configs/all/retroarch/overlay/MAME-Vertical.cfg
}

# === Overlay Fixes with Target List ===

#function overlay_fix() {
#    echo "Applying overlay fixes..."

    # List of system config folders to patch
#    systems=( "FinalBurn Neo" )

#   for sys in "${systems[@]}"; do
#        cfg_dir="/opt/retropie/configs/all/retroarch/config/$sys"
#       if [[ -d "$cfg_dir" ]]; then
#            echo "Patching overlays in $cfg_dir ..."
#            find "$cfg_dir" -type f -name "*.cfg" -print0 | \
#                xargs -0 sed -i 's|MAME-Vertical.cfg|pb-vr.cfg|g'
#        else
#            echo "Skipping $sys (no config dir found)"
#        fi
#    done

    # Symlink overlay file for compatibility
#    ln -sfn /opt/retropie/configs/all/retroarch/overlay/PlayBox/pb-vr.cfg \
#            /opt/retropie/configs/all/retroarch/overlay/MAME-Vertical.cfg
#}


# === Core Config Management ===

function disable_core_cfg() {
    core="$1"
    cfg_dir="/opt/retropie/configs/all/retroarch/config/$core"

    if [[ -d "$cfg_dir" ]]; then
        mv "$cfg_dir" "${cfg_dir}.OFF"
        echo "Disabled $core config"
    else
        echo "Skipping $core (not found)"
    fi
}

function enable_core_cfg() {
    core="$1"
    cfg_dir="/opt/retropie/configs/all/retroarch/config/$core.OFF"

    if [[ -d "$cfg_dir" ]]; then
        mv "$cfg_dir" "/opt/retropie/configs/all/retroarch/config/$core"
        echo "Re-enabled $core config"
    else
        echo "Skipping $core (no .OFF backup found)"
    fi
}

# === Usage Example ===

#overlay_fix

#disable_core_cfg "Genesis Plus GX"
#disable_core_cfg "fMSX"
#disable_core_cfg "Stella 2014"


function restart_es() {
    clear
    echo "[WARN] Please restart EmulationStation manually or Reboot for changes to take effect..."
    
	#echo "[Restarting EmulationStation...]"
    #sleep 1
 
    # Detect if running locally or via SSH
	#	if [[ -n "$SSH_CONNECTION" ]]; then
		
	#	echo "[WARN] Restart skipped: Script running under SSH session]"
	#	echo "Please restart ES manually on the actual console."
	#else
	# Stop ES
	#	pkill -f emulationstation

    # Wait until ES is really gone
	#	while pgrep -f emulationstation >/dev/null; do sleep 2; done

    # Extra delay to let esbgm service react
	#	sleep 1
	
    # Relaunch ES bound to the local console
	#	nohup emulationstation --no-splash >/dev/null 2>&1 &
	#	disown
	#	echo "[EmulationStation restarted successfully]"
	#	fi
	
	pausepress
}


function done_message() {
    clear
    echo
    echo -e "[OK \033[32mDONE\033[0m!...]"
    cd $HOME
    sleep 1
}

function pausepress() {
    echo
    read -n 1 -s -r -p "Press any key to continue..."
    echo
}

function reboot_message() {
    clear
	echo
	echo "[OK DONE!...]"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

function check_and_run() {
    local bin="$1"
    shift
    local resolved
    resolved=$(command -v "$bin")
    if [[ -n "$resolved" && -x "$resolved" ]]; then
        "$resolved" "$@"
    else
        echo "[ERROR] $bin not found in PATH or not executable."
        sleep 2
    fi
}


function enjoy_message() {
    local width=$(tput cols)   # get terminal width
    local msg1="================================="
    local msg2=" [ Hope you enjoy the Toolkit! ] "
    local msg3="          Time 2Play! ..."
    local msg4="================================="

    # function to center text
    center() {
        local text="$1"
        local pad=$(( (width - ${#text}) / 2 ))
		ensure_lolcat
        printf "%*s%s\n" $pad "" "$text" | lolcat
    }

    echo "" | lolcat
    center "$msg1"
    center "$msg2"
    center "$msg3"
    center "$msg4"
    echo "" | lolcat
}

function enjoy_message_v1() {
    ensure_lolcat
	echo "" | lolcat
    echo "=================================" | lolcat
    echo " [ Hope you enjoy the Toolkit! ] " | lolcat
    echo "          Time 2Play! ..."        | lolcat
    echo "=================================" | lolcat
    echo "" | lolcat
}


function ensure_lolcat() {
    if ! command -v lolcat >/dev/null 2>&1; then
        sudo gem install lolcat >/dev/null 2>&1
    else
        # Test if lolcat runs without Ruby errors
        if ! echo "test" | lolcat >/dev/null 2>&1; then
            sudo gem install lolcat >/dev/null 2>&1
        fi
    fi
}


function sanitize_scripts() {
    echo "Checking for CRLF line endings in scripts..."

    # Directories to sanitize (user can edit this list)
    dirs=("$HOME/PlayBox-Setup" "$HOME/RetroPie/roms")

    for d in "${dirs[@]}"; do
        if [ -d "$d" ]; then
            echo "[INFO] Scanning $d ..."
            if find "$d" -name "*.sh" -exec file {} \; 2>/dev/null | grep -q "CRLF"; then
                echo "[WARN] CRLF detected in $d scripts. Converting..."
                find "$d" -name "*.sh" -exec dos2unix {} +
                echo "[OK DONE! Scripts sanitized in $d]"
            else
                echo "[INFO] All scripts in $d already clean (LF endings)"
            fi
        else
            echo "[INFO] Directory $d not found, skipping."
        fi
    done

    # Summary after all directories
    total=$(find "${dirs[@]}" -name "*.sh" 2>/dev/null | wc -l)
    echo "[SUMMARY] Checked $total scripts across ${#dirs[@]} directories."
    sleep 3
}


function safe_remove() {
    for target in "$@"; do
        if [ -e "$target" ]; then
            rm -rf "$target"
            echo "[OK DONE!] Removed $target"
        else
            echo "[INFO] $target not found, skipping."
        fi
    done
}



function poff_pb() {
	dialog --infobox "...Powering Off..." 3 23 ; sleep 1
	clear
	echo
	echo "[OK System Will Power Off now...]"
	clear
	sudo poweroff
}

function restart_pb() {
	dialog --infobox "...Restarting..." 3 20 ; sleep 1
	clear
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

main_menu

enjoy_message

cd $HOME
