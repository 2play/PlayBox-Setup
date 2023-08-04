#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2023 2Play! (S.R.)
# 01.03.2022


function main_menu() {
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " WiFi MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose your Option:" 25 75 20 \
            - "*** Network Manager WiFi OPTIONS  ***" \
            1 " - Check WiFi & Network Devices Status " \
            2 " - Connect to a WiFi [Wizard also on desktop]" \
            3 " - Clean WiFi Configuration" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) wifi_status;;
            2) wifi_connect;;
            3) wifi_reset;;
            -) none ;;
            *) break ;;
        esac
    done
}

# Checking all network devices status
function wifi_status() {
	clear
	nmcli d
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo	
}

# Connect to an available WiFi
function wifi_connect() {
  clear
  dialog --infobox "...Let's find the available WiFi SSID..." 3 45 ; sleep 2
	clear
	#sudo nmcli dev wifi
	#echo
	#echo ***PLEASE TYPE OR COPY/PASTE THE 'SSID' NAME AS SHOWN IN THE LIST***
	#echo 
	#read -p 'Which WiFi you want to connect to: ' wifiname
	#echo
	#sudo nmcli --ask dev wifi connect $wifiname
	sudo nmtui connect
	#echo
	#read -n 1 -s -r -p "Press any key to continue..."
	echo
}

# Reset WiFi Configuration
function wifi_reset() {
  clear
  sudo rm /etc/NetworkManager/system-connections/*.nmconnection 2>/dev/null
  echo "[OK DONE!... Please reboot...]"
  echo
  read -n 1 -s -r -p "Press any key to continue..."
  echo
}

main_menu
