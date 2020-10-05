#!/bin/bash
# Raspberry official USB Boot Mode.
# A hidden gem for your Pi3B. No SD Card needed to boot from USB!
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 25.06.20

infobox=""
infobox="${infobox}\n"
infobox="${infobox}USB Boot Mode Activator, By 2Play!\n"
infobox="${infobox}\n"
infobox="${infobox}This script will enable the hidden gem as I call it, the USB Boot Mode for Pi3B boards. Burn your image to a USB mass storage device (MSD) and boot straight from it. No need of a SD card or any extra configuration.\n"
infobox="${infobox}This is a permanent setting. But you can still boot only from any SD as usual.\n"
infobox="${infobox}	NOTE: Not all USB devices might be compatible. So please report to my discord channel your findings.\n"
infobox="${infobox}\n"
infobox="${infobox}**Enable**\nWhen you select the Enable option, the USB Boot mode will be applied"
infobox="${infobox}\n"
infobox="${infobox}**Verify**\nwhen you select the Verify option, you can verify activation. You should see this code displayed: 17:3020000a\n"
infobox="${infobox}\n"


dialog --backtitle "USB Boot Mode Activator" \
--title "USB Boot Mode Activator by 2Play!" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " Pi3B USB BOOT ENABLER " \
            --ok-label OK --cancel-label Exit \
            --menu "First check and enable if not?" 25 75 20 \
            - "*** USB BOOT MODE SELECTIONS ***" \
            1 " - Verify USB Boot Mode" \
            2 " - Enable USB Boot Mode" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) verify_usb_boot_mode  ;;
            2) enable_usb_boot_mode  ;;
            -) none  ;;
            *)  break ;;
        esac
    done
}


function enable_usb_boot_mode() {
	dialog --infobox "...Activating..." 3 20 ; sleep 2
	sudo apt-get update && sudo apt-get upgrade
	sleep 5
	echo program_usb_boot_mode=1 | sudo tee -a /boot/config.txt
	sleep 3
	sudo reboot
}

function verify_usb_boot_mode() {
	dialog --infobox "...Verifying..." 3 20 ; sleep 2
	vcgencmd otp_dump | grep 17:
	sleep 5
}

main_menu