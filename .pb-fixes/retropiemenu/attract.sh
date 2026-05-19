#!/usr/bin/env bash
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 05.05.2026

frontend_cfg="/opt/retropie/configs/all/autostart.sh"

while true; do
    choice=$(dialog --backtitle "Select Frontend..." \
        --title "PLAYBOX FRONTEND OPTIONS" \
        --ok-label OK --cancel-label Exit \
        --menu "Select which frontend you want to use..." 20 75 10 \
		- "*** FRONTEND SELECTIONS ***" \
        ""      "" \
        1 "EmulationStation (PlayBox)" \
        2 "AttractMode Plus (HyperPie 2.5.1)" \
		""      "" \
        3 "Restore clean vanilla autostart.sh from GitHub" \
        2>&1 >/dev/tty)

    case "$choice" in
        1)
        # Enable EmulationStation + splash shuffle
        sudo sed -i 's|^#ls -1|ls -1|' "$frontend_cfg"
		sudo sed -i 's|^#*emulationstation.*|emulationstation --no-splash #auto|' "$frontend_cfg"
		sudo sed -i 's|^#*mpv ~/.attract/intro/intro.mp4.*|#mpv ~/.attract/intro/intro.mp4 >/dev/null 2>\&1|' "$frontend_cfg"
		sudo sed -i 's|^#*attractplus.*|#attractplus #auto|' "$frontend_cfg"
		dialog --msgbox "EmulationStation set as default frontend (splashscreen shuffle enabled)." 8 60
        ;;
		2)
        # Enable AttractMode Plus + intro, disable splash shuffle & ES
        sudo sed -i 's|^#*ls -1*|#ls -1|' "$frontend_cfg"
		sudo sed -i 's|^#*emulationstation.*|#emulationstation --no-splash #auto|' "$frontend_cfg"
		sudo sed -i 's|^#*mpv ~/.attract/intro/intro.mp4.*|mpv ~/.attract/intro/intro.mp4 >/dev/null 2>\&1|' "$frontend_cfg"
		sudo sed -i 's|^#*attractplus.*|attractplus #auto|' "$frontend_cfg"
        dialog --msgbox "AttractMode Plus set as default frontend (splashscreen shuffle disabled)." 8 60
        ;;
        3)
            # Restore clean vanilla autostart.sh from GitHub
            sudo curl -L -o "$frontend_cfg" \
              "https://raw.githubusercontent.com/2play/PBv2-PostFixes/clean-vanilla-x86/opt/retropie/configs/all/autostart.sh"
            dialog --msgbox "Clean vanilla autostart.sh restored from GitHub." 8 60
            ;;
        *)
            break
			#reboot_message
            ;;
    esac
done

function reboot_message() {
    clear
	echo
	echo "[OK DONE!...]"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}
