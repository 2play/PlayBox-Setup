#!/bin/bash
# Advanced USB External Script by 2Play!
# Based on concept created by EazyHax for his USB Enable/Disable Script
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 08.05.2026
BACKTITLE="PLAYBOX PROJECT"

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " EXTERNAL USB ROMS SCRIPT MENU " \
            --ok-label OK --cancel-label Exit --no-tags \
            --menu "Choose A Roms USB Option:" 25 80 20 \
            sep1 "      *** EXTERNAL USB HDD SELECTIONS *** " \
            1 " - FORMAT An External USB to NTFS (Required) " \
			""      "" \
			2 " - ENABLE External USB Setup " \
            3 " - DISABLE External USB Setup " \
			""      "" \
            sep2 "      *** SYSTEM LOCATOR & GAMELIST.XML FIX *** " \
            4 " - SYSTEM from SD(localroms) => Ext. USB: Roms, Media & xml on USB " \
			5 " - SYSTEM from Ext. USB => SD(localroms): Roms, Media & xml on SD/Int. " \
			""      "" \
			6 " - Apply/Fix Default Relative Paths (./) To ALL gamelist.xml(s) " \
			2>&1 > /dev/tty)

        case "$choice" in
			1) format_usb   || echo "[ERROR] Format failed" ;;
			2) enable_usb   || echo "[ERROR] Enable failed" ;;
			3) disable_usb  || echo "[ERROR] Disable failed" ;;
			4) system_move_menu usb ;;
			5) system_move_menu sd	;;
			6) all_rel_path        	;;
			-) none             	;;
			*) break 				;;
		esac
    done
	clear
}

log_action() { echo "[INFO] $1"; sleep 2; }

function format_usb() {
dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
clear
echo
echo "This will perform a quick format of your USB sda# device to NTFS..."
echo
echo "*** Let's make sure WHICH sda device you want to format... ***"
echo
log_action "STEP 1: Listing available sda devices..."
lsblk -f | grep sda

count=$(lsblk -f | grep -c sda)
echo "[INFO] Found $count sda device(s)."

echo
echo "***Please Type the sda# from above list***"
echo "Example: 1 for sda1"
echo
ensure_lolcat
echo "---------------------------------------------------------------------" | lolcat
echo "WARNING: This will ERASE all data on /dev/sda$sda. Format to NTFS? (y/N):" | lolcat
echo "---------------------------------------------------------------------" | lolcat
read -p "Confirm choice: " confirm

[[ $confirm != "y" ]] && echo "Cancelled." && return 1

echo
read -p 'So Which sda device would you like to format?: ' sda
echo
if ! lsblk -f | grep -q "sda$sda"; then
        echo "[ERROR] Device /dev/sda$sda not found."
        sleep 2
        return 1
    fi
	
log_action "STEP 2: Unmounting device..."
mountpoint -q "/dev/sda$sda" && sudo umount "/dev/sda$sda"

log_action "STEP 3: Formatting device to NTFS..."
#    sudo mkntfs -f -L "roms" "/dev/sda$sda" || { echo "[ERROR] mkntfs failed"; return 1; }
read -p "Enter a label for the NTFS volume (default: roms): " label
label=${label:-roms}
sudo mkntfs -f -L "$label" "/dev/sda$sda" || { echo "[ERROR] mkntfs failed"; return 1; }

log_action "STEP 4: Finalizing..."
    echo "[OK DONE!...]"
    echo "[System will restart now...]"
    pausepress
    clear
    sudo reboot
}


function enable_usb() {
dialog --infobox "...Applying..." 3 18 ; sleep 2
# 
# Your USB mass storage device (MSD) needs to be in NTFS format.
clear

log_action "STEP 1: Checking For External Drive..."
#testdrive=`df |grep media |awk '{print $1 }'|wc -l`
testdrive=$(lsblk -f | grep ntfs | wc -l)
if [ $testdrive -eq 0 ] ; then
echo "No External drive detected. Exiting."
sleep 2
return 1
else
echo "External Drive detected"

log_action "STEP 2: Performing checks for NTFS filesystem."
fi
EXTDR=$(sudo blkid | grep -v mmc | grep ntfs)
usb_mount=`echo $EXTDR|awk '{print $1 }'|tr -d :`
#usb_filesystem=`echo $EXTDR |grep -Po 'TYPE="\K.*?(?=")'`
usb_filesystem=`echo $EXTDR |grep -Po 'ntfs'`
usb_uuid=`blkid -o value -s UUID $usb_mount`

if [ "$usb_filesystem" != "ntfs" ] ; then
ensure_lolcat
echo "This external drive is not correctly formatted. Please format it to NTFS." | lolcat
sleep 5; main_menu
else
echo "External drive is correctly formatted to NTFS" | lolcat
sleep 5
fi

if grep -q "$usb_uuid" /etc/fstab; then
    echo -e 'It seems you already have an external drive mapped...\n  *** Only one assigned external drive is supported. *** \nPlease run the "EXTERNAL USB Roms NTFS Setup, EZH-2P!" script again, disable other drive before adding a new drive.'
    sleep 5
    exit
#sudo grep -w UUID /etc/fstab |grep -v ext4 > /dev/null 2>&1
#if [ $? -eq 0 ] ; then
#echo -e 'It seems you already have an external drive mapped...\n  *** Only one assigned external drive is supported. *** \nPlease run the "EXTERNAL USB Roms NTFS Setup, EZH-2P!" script again, disable other drive before adding a new drive.'
#sleep 5
#exit
else
mkdir -p "$HOME/addonusb/roms" "$HOME/RetroPie/combined_drives" "$HOME/.work"
#echo "UUID=$usb_uuid  $HOME/addonusb      $usb_filesystem    nofail,user,umask=0000  0       2" > $HOME/.currentdrive
#sudo sh -c "cat $HOME/.currentdrive >> /etc/fstab"
echo "UUID=$usb_uuid $HOME/addonusb ntfs nofail,user,umask=0000 0 2" | sudo tee -a /etc/fstab > /dev/null
#sudo umount $usb_mount
#sudo mount -a
sudo umount "$usb_mount" || true
sudo mount "$HOME/addonusb" || { echo "[ERROR] mount failed"; exit 1; }
fi
testdrive2=$(df | grep addonusb | wc -l)
if [ $testdrive2 -eq 0 ] ; then
	echo -e "Something went wrong. Unable to detect that external drive mounted correctly. Exiting...."
	sleep 2
	exit
fi

log_action "STEP 3: Syncing the roms directories."
echo -e '...Will add roms directories to the external drive. They will be located in the "roms" directory on your external drive.'
sleep 2
sudo chmod 775 "$HOME/addonusb"
#find "$HOME/RetroPie/roms" -mindepth 1 -maxdepth 1 -type d -printf "$HOME/addonusb/roms/%f\n" | xargs mkdir -p 2>/dev/null || true
#rsync -vd -l $HOME/RetroPie/roms/ $HOME/addonusb/roms
rsync -vd -l "$HOME/RetroPie/roms/" "$HOME/addonusb/roms" || {
    echo "[ERROR] rsync failed"; return 1;
}
sleep 1
[ ! -d "$HOME/RetroPie/localroms" ] && mv "$HOME/RetroPie/roms" "$HOME/RetroPie/localroms"
cd /etc/samba/
sudo cp /home/pi/PlayBox-Setup/usb/smb.conf.USB ./
sudo mv smb.conf smb.conf.BAK
sudo ln -s smb.conf.USB smb.conf
cd /etc/profile.d
sudo cp /home/pi/PlayBox-Setup/usb/10-retropie.sh.USB ./
sudo mv /etc/profile.d/10-retropie.sh /etc/profile.d/10-retropie.sh.BAK
sudo ln -s 10-retropie.sh.USB 10-retropie.sh
#sed -i 's+/home/pi/RetroPie/roms+/home/pi/RetroPie/localroms+g' ~/.livewire.py

log_action "STEP 4: Finalizing..."
echo -e 'Drive expanded. Your system will now shutdown...\n\nOnce system is off, you can detach your external drive...\n- Plug it up to your computer.\n- Transfer your extra roms then plug it back in your pi and restart it...\n- You should see the added roms.\n\n'
echo "- You can also upload roms by using the samba shares 'roms_SD' or 'roms_USB'."
ensure_lolcat
echo "- DO NOT COPY ANYTHING TO THE [roms_combined_view]" | lolcat
echo "- To relocate a system you can use the RELOCATE A SYSTEM options of this tool!"
pausepress
echo " ** Based on the script by Forrest aka EazyHax ** "
sleep 1
echo
echo "  **   New Script By 2Play!   **  "
sleep 1
clear
echo "[OK System Will Shutdown now...]"
pausepress
sudo poweroff
}


function disable_usb() {
dialog --infobox "...Applying..." 3 18 ; sleep 2
clear

log_action "STEP 1: Checking For External Drive..."
if [ ! -d "$HOME/addonusb" ]; then
    echo ""
    echo ""
	sleep 2
	echo "This Retropie is not expanded. Stopping now..."
    echo ""
    echo ""
    sleep 5
else
echo "External Drive Detected..."
sleep 2

log_action "STEP 2: Removing External Drive..."
sudo sed -i '/addon/d' /etc/fstab
sudo unlink /etc/profile.d/10-retropie.sh
[ -f /etc/profile.d/10-retropie.sh.BAK ] && sudo cp /etc/profile.d/10-retropie.sh.BAK /etc/profile.d/10-retropie.sh
[ -f /etc/samba/smb.conf.BAK ] && sudo cp /etc/samba/smb.conf.BAK /etc/samba/smb.conf
sudo unlink /etc/samba/smb.conf
sudo service smbd restart
unlink "$HOME/RetroPie/roms" || true
sudo umount "$HOME/addonusb" || true
sudo umount overlay || true
#while [ `df |grep overlay |awk '{print $1 }'|wc -l` -eq 1 ]; do
#            echo -e "\n\nOverlay Mount is still present. Waiting a few seconds and will try to dismout the drive again.\n\n"
#            sleep 7
#            sudo umount overlay
#done
retries=5
while [ "$(df | grep overlay | wc -l)" -eq 1 ] && [ $retries -gt 0 ]; do
    echo "Overlay Mount still present. Retrying unmount..."
    sleep 7
    sudo umount overlay
    retries=$((retries-1))
done

log_action "STEP 3: Finalizing..."
echo -e '\nCombined drives have been unmounted. Moving on with cleaning up directories and restoring your retro rig.\n[OK!] Rebooting Now...\n'
sleep 10
#sed -i 's+/home/pi/RetroPie/localroms+/home/pi/RetroPie/roms+g' ~/.livewire.py
rm -r "$HOME/RetroPie/combined_drives" || echo "[WARN] combined_drives not found"
rm -r "$HOME/addonusb" || echo "[WARN] addonusb not found"
rm -rf "$HOME/.work" || echo "[WARN] .work not found"
[ ! -d "$HOME/RetroPie/roms" ] && mv "$HOME/RetroPie/localroms" "$HOME/RetroPie/roms"  > /dev/null 2>&1
clear
echo "[OK System Will Restart now...]"
pausepress
clear
sudo reboot
fi
}


function system_move_menu() {
    mode=$1  # usb, sd
    src_sd="$HOME/RetroPie/localroms/$sname"
	dest_usb="$HOME/addonusb/roms/$sname"
	src_usb="$HOME/addonusb/roms/$sname"
	dest_sd="$HOME/RetroPie/localroms/$sname"
	

	dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
    clear

    if [ -d "$HOME/addonusb" ]; then
        cd "$HOME/addonusb/roms"
        echo "Listing ROM folders..."
        echo
		echo "----------------------------------------------------------------------"
		echo " <space>	Display next k lines of text [current screen size]"
		echo " <return>	Display next k lines of text [1]*"
		echo " d		Scroll k lines [current scroll size, initially 11]*"
		echo " q		Exit from more"
		echo "----------------------------------------------------------------------"
		sleep 1
		ls | column | more -d
        echo
        read -p 'So which system would you like to update: ' sname
        echo

        case $mode in
            usb)
                cd "$sname"
                #sudo mv -f "$HOME/RetroPie/localroms/$sname/gamelist.xml" ./
                move_with_preview "$src_sd" "$dest_usb"
				;;		
            sd)
                cd "$sname"
                move_with_preview "$src_usb" "$dest_sd"
                ;;
        esac

        # Common sed replacements
        sed -i "s#<image>$HOME/addonusb/roms/.*/boxart#<image>./boxart#g" gamelist.xml
        sed -i "s#<image>$HOME/addonusb/roms/.*/mixart#<image>./mixart#g" gamelist.xml
        sed -i "s#<marquee>$HOME/addonusb/roms/.*/wheel#<marquee>./wheel#g" gamelist.xml
        sed -i "s#<video>$HOME/addonusb/roms/.*/snap#<video>./snap#g" gamelist.xml

        echo "[OK DONE!...]"
        sleep 1

        # Loop back or restart ES
        while true; do
            read -p 'Do more systems [y/c] or finalize & restart ES [n/r]? ' yn
            case $yn in
                [YyCc]* ) system_move_menu "$mode";;
                [NnRr]* ) restart_es;;
                * ) echo "Please answer yes or no.";;
            esac
        done
    else
        echo "The External USB is disabled... Nothing to do!"
        pausepress
    fi
}


function all_rel_path() {
dialog --infobox "...Restoring!..." 3 21 ; sleep 2
clear
log_action "STEP 1: Checking for USB..."
cd "$HOME/RetroPie"
 if [ -d "$HOME/addonusb" ]; then
		echo
		echo "The External USB is enabled. Using correct path..."
		pausepress
		cd "$HOME/addonusb/roms"
		log_action "STEP 2: Patching gamelist.xml in USB roms..."
		count=$(find . -type f -name "gamelist.xml" | wc -l)
		if [ "$count" -eq 0 ]; then
		echo "[WARN] No gamelist.xml files found in USB roms."
		else
		find . -type f -name "gamelist.xml" -print0 | xargs -0 sed -i "s#<image>$HOME/addonusb/roms/.*\/boxart#<image>./boxart#g; s#<image>$HOME/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>$HOME/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>$HOME/addonusb/roms/.*\/snap#<video>./snap#g" || echo "[WARN] sed failed on some files"
		echo "[INFO] Patched $count gamelist.xml files in USB roms."
		fi;
		cd "$HOME/RetroPie/localroms"
		log_action "STEP 3: Patching gamelist.xml in localroms..."
        count=$(find . -type f -name "gamelist.xml" | wc -l)
		if [ "$count" -eq 0 ]; then
		echo "[WARN] No gamelist.xml files found in localroms."
		else
		find . -type f -name "gamelist.xml" -print0 | xargs -0 sed -i "s#<image>$HOME/addonusb/roms/.*\/boxart#<image>./boxart#g; s#<image>$HOME/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>$HOME/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>$HOME/addonusb/roms/.*\/snap#<video>./snap#g" || echo "[WARN] sed failed on some files"
		echo "[INFO] Patched $count gamelist.xml files in localroms."
		fi;
	else
		echo "The External USB is disabled. Using correct path..."
		pausepress
		cd "$HOME/RetroPie/roms"
		log_action "STEP 2: Patching gamelist.xml in SD-internal roms..."
        count=$(find . -type f -name "gamelist.xml" | wc -l)
		if [ "$count" -eq 0 ]; then
		echo "[WARN] No gamelist.xml files found in SD-internal roms."
		else
		find . -type f -name "gamelist.xml" -print0 | xargs -0 sed -i "s#<image>$HOME/addonusb/roms/.*\/boxart#<image>./boxart#g; s#<image>$HOME/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>$HOME/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>$HOME/addonusb/roms/.*\/snap#<video>./snap#g" || echo "[WARN] sed failed on some files"
		echo "[INFO] Patched $count gamelist.xml files in SD-internal roms."
		fi;
fi
echo "[OK DONE!...]"
sleep 1
clear
restart_es
 }


function move_with_preview() {
    src="$1"
    dest="$2"
	
    echo "=== DRY-RUN: Previewing rsync move from $src to $dest ==="
    rsync --remove-source-files -avh --dry-run "$src" "$dest"

    echo
    read -p "Proceed with actual move? (y/N): " confirm
    if [[ "$confirm" == "y" ]]; then
        echo "=== Executing System Move ==="
        rsync --remove-source-files -avh "$src" "$dest"
        # optional cleanup of empty dirs
        #rsync --remove-source-dirs -avh "$src" "$dest"
        echo "[OK DONE! Files moved.]"
    else
        echo "[CANCELLED] No changes made."
    fi
}


function restart_es() {
    clear
    echo "[Restarting EmulationStation...]"
    sleep 1
	
	# Stop ES
    pkill -f emulationstation

    # Wait until ES is really gone
    while pgrep -f emulationstation >/dev/null; do
        sleep 2
    done

    # Extra delay to let esbgm service react
    sleep 1

    # Relaunch ES quietly
    nohup emulationstation --no-splash 2>/dev/null &
    disown

    echo "[EmulationStation restarted]"
}


function pausepress() {
    echo
    read -n 1 -s -r -p "Press any key to continue..."
    echo
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

main_menu
