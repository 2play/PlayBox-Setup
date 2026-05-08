#!/bin/bash
# Based on the original concept by David Marti
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)+
# PlayBox ToolKit

scrversion="PlayBox Revision 06.05.2026"

ROM_BASES=(
  "$HOME/addonusb/roms"
  "$HOME/RetroPie/localroms"
  "$HOME/RetroPie/roms"
)

# Welcome
 dialog --backtitle "PlayBox & RetroPie" --title "Extra Media CleanUp Tool" \
    --yesno "\n$scrversion\n\nThis tool will remove extra media files from mixart, boxart, cartart, snap(s) and wheel for a chosen system where there is not a matching game for it.\n\nIf you keep your media for MAME or Final Burn Alpha in the /roms/arcade folder, there is a special choice just for that.\n\n*** WARNING ***:\nDavid's script removes art basis romname! So art files have to MATCH romname!\nAlways have a backup copy of your media files before making changes to your system.\n" \
    25 80 2>&1 > /dev/tty \
    || exit


# Collect system names dynamically
SYSTEMS=$(for base in "${ROM_BASES[@]}"; do
              [ -d "$base" ] && ls -1 "$base"
           done | sort -u) 
		   
function main_menu() {
    local menu_items=()
    local i=1
    for sys in $SYSTEMS; do
        menu_items+=($i "$sys")
        ((i++))
    done

    choice=$(dialog --backtitle "PlayBox Media Cleanup Tool" \
                    --title "Select System" \
                    --ok-label OK --cancel-label Exit \
                    --menu "Choose a system to clean up:" 25 75 20 \
                    "${menu_items[@]}" \
                    2>&1 > /dev/tty)

    [ -z "$choice" ] && exit

    selected_system=$(echo "$SYSTEMS" | sed -n "${choice}p")
    remove_media "$selected_system"
}

function remove_media() {
    dialog --infobox "...processing..." 3 20 ; sleep 2
    choice=$1

    for base in "${ROM_BASES[@]}"; do
        directory="$base/$choice"
        [ -d "$directory" ] || continue   # skip if system folder not present

        # Collect media filenames (strip extensions)
        ls "$directory/mixart" 2>/dev/null | sed -e 's/\.[jp][pn]g$//' > /tmp/mixart.txt
        ls "$directory/boxart" 2>/dev/null | sed -e 's/\.[jp][pn]g$//' > /tmp/boxart.txt
        ls "$directory/cartart" 2>/dev/null | sed -e 's/\.[jp][pn]g$//' > /tmp/cartart.txt
        ls "$directory/snap"   2>/dev/null | sed -e 's/\.mp4$//' > /tmp/snap.txt
        ls "$directory/snaps"  2>/dev/null | sed -e 's/\.mp4$//' > /tmp/snaps.txt
        ls "$directory/wheel"  2>/dev/null | sed -e 's/\.[jp][pn]g$//' > /tmp/wheel.txt

        rm /tmp/remove_media.sh 2>/dev/null

        for mname in $(cat /tmp/mixart.txt); do
            if ! ls "$directory" | grep -q "$mname"; then
                echo "rm \"$directory/mixart/$mname.png\"" >> /tmp/remove_media.sh
                echo "rm \"$directory/mixart/$mname.jpg\"" >> /tmp/remove_media.sh
            fi
        done

        for bname in $(cat /tmp/boxart.txt); do
            if ! ls "$directory" | grep -q "$bname"; then
                echo "rm \"$directory/boxart/$bname.png\"" >> /tmp/remove_media.sh
                echo "rm \"$directory/boxart/$bname.jpg\"" >> /tmp/remove_media.sh
            fi
        done

        for cname in $(cat /tmp/cartart.txt); do
            if ! ls "$directory" | grep -q "$cname"; then
                echo "rm \"$directory/cartart/$cname.png\"" >> /tmp/remove_media.sh
                echo "rm \"$directory/cartart/$cname.jpg\"" >> /tmp/remove_media.sh
            fi
        done

        for sname in $(cat /tmp/snap.txt); do
            if ! ls "$directory" | grep -q "$sname"; then
                echo "rm \"$directory/snap/$sname.mp4\"" >> /tmp/remove_media.sh
            fi
        done

        for ssname in $(cat /tmp/snaps.txt); do
            if ! ls "$directory" | grep -q "$ssname"; then
                echo "rm \"$directory/snaps/$ssname.mp4\"" >> /tmp/remove_media.sh
            fi
        done

        for wname in $(cat /tmp/wheel.txt); do
            if ! ls "$directory" | grep -q "$wname"; then
                echo "rm \"$directory/wheel/$wname.png\"" >> /tmp/remove_media.sh
                echo "rm \"$directory/wheel/$wname.jpg\"" >> /tmp/remove_media.sh
            fi
        done

        # Execute removal
        [ -s /tmp/remove_media.sh ] && chmod +x /tmp/remove_media.sh && /tmp/remove_media.sh
        rm /tmp/remove_media.sh 2>/dev/null
    done
}

main_menu
