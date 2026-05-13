#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 06.05.2026
BACKTITLE="PLAYBOX PROJECT"

function main_menu() {
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " WiFi MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose your Option:" 25 75 20 \
            - " *** Network Manager WiFi OPTIONS  *** " \
            ""      "" \
			1 " - Check WiFi & Network Devices Status " \
            2 " - Connect to a WiFi [Wizard also on desktop] " \
            3 " - Reconnect/Refresh WiFi Connection " \
            ""      "" \
			4 " - Disconnect WiFi & Clean WiFi Configuration " \
			2>&1 > /dev/tty)

        case "$choice" in
            1) wifi_status;;
            2) wifi_connect;;
            3) wifi_reconnect;;
            4) wifi_disconnect;;
            -) none ;;
            *) break ;;
        esac
    done
clear
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
    dialog --infobox "...Scanning for available WiFi SSIDs..." 3 45 ; sleep 2
    clear

    # Get list of SSIDs (filter out blanks and duplicates)
    ssids=$(nmcli -t -f SSID dev wifi | grep -v '^--' | grep -v '^$' | sort -u)

    # Build menu options: tag = number, item = SSID
    options=()
    i=1
    while read -r ssid; do
        options+=($i "$ssid")
        i=$((i+1))
    done <<< "$ssids"

    # Show menu
    choice=$(dialog --backtitle "$BACKTITLE" --title "WiFi Networks" \
        --menu "Select WiFi SSID to connect:" 20 70 15 \
        "${options[@]}" \
        2>&1 >/dev/tty)
		clear

    # If user made a choice, map number back to SSID
if [ -n "$choice" ]; then
    selected_ssid=$(echo "$ssids" | sed -n "${choice}p")
    sudo nmcli dev wifi connect "$selected_ssid" --ask

    # Check connection status
    status=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION d | grep ':wifi:connected')
    if echo "$status" | grep -q "$selected_ssid"; then
	ip=$(nmcli -t -f IP4.ADDRESS device show | grep -m1 'IP4.ADDRESS' | cut -d: -f2)
        dialog --msgbox "✅ Connected successfully to SSID: $selected_ssid\nIP Address: $ip" 10 60
    else
        dialog --msgbox "❌ Connection to SSID: $selected_ssid failed.\nCheck password or signal strength." 10 60
    fi
fi
}


# Reconnect to current WiFi
function wifi_reconnect() {
    clear
    active=$(nmcli -t -f DEVICE,TYPE,STATE,CONNECTION d | grep ':wifi:connected')
    if [ -z "$active" ]; then
        dialog --msgbox "No active WiFi connection found." 8 50
        return
    fi

    device=$(echo "$active" | cut -d: -f1)
    ssid=$(echo "$active" | cut -d: -f4)

    dialog --infobox "Reconnecting to $ssid..." 5 50 ; sleep 2
    clear
	sudo nmcli device disconnect "$device"
    sudo nmcli dev wifi connect "$ssid" --ask
    dialog --msgbox "Reconnected to SSID: $ssid" 8 50
}


# Disconnect from active WiFi
function wifi_disconnect() {
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
}


main_menu
