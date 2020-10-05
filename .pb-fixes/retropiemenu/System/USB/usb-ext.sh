#!/bin/bash
# Advanced USB External Script by 2Play!
# Based on Eazy Hax USB Enable/Disable Script
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 19.07.20


function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " EXTERNAL NTFS USB ROMS MULTI SCRIPT MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose your Roms USB Option:" 25 80 20 \
            - "              *** EXTERNAL USB HDD SELECTIONS ***" \
            1 " - ENABLE External USB ROMs" \
            2 " - DISABLE External USB ROMs" \
			3 " - FORMAT External USB to NTFS" \
			4 " - FIX Missing Symbolic Links - External USB Roms Path" \
			- "" \
            - "          *** ART FOLDERS & GAMELIST.XML OPTIONS ***" \
            - "               -> Single System Update <-" \
			5 " - My ADD-ON System: USB ART Folders & I want XML on USB " \
			6 " - My ADD-ON System: USB ART Folders & I want XML on SD " \
			7 " - I want to restore a single USB ADD-ON XML to Default " \
			- "" \
			- "               -> Multi System Update <-" \
		    8 " - I want to Restore/Clean ALL my Gamelist XMLs to Default " \
			- "" \
			- "              *** MOVE A SYSTEM SELECTIONS ***" \
            9 " - I want to move a SYSTEM in FULL from SD => Ext. USB" \
		   10 " - I want to move a SYSTEM in FULL from Ext. USB => SD" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) enable_usb  ;;
            2) disable_usb  ;;
            3) format_usb  ;;
			4) fix_links  ;;
			5) addon_artxml_usb  ;;
			6) addon_artxml_sd  ;;
			7) addon_art_def  ;;
		    8) all_sd  ;;
		    9) sys_usb  ;;
		   10) sys_sd  ;;
			-) none  ;;
            *)  break ;;
        esac
    done
	clear
}


function enable_usb() {
dialog --infobox "...Applying..." 3 18 ; sleep 2
# Script created by EazyHax to expand the roms file system to an external MSD
# Your USB mass storage device (MSD) needs to be in NTFS format.
# 16.07.2020
clear
echo "STEP 1: Checking For External Drive..."
sleep 3
testdrive=`df |grep media |awk '{print $1 }'|wc -l`
if [ $testdrive -eq 0 ] ; then
echo "No External drive detected. Exiting."
sleep 5
exit
else
echo "External Drive detected"
echo
echo "STEP 2: Performing checks for NTFS filesystem."
sleep 5
fi

EXTDR=`sudo blkid |grep -v mmc|grep ntfs`
usb_mount=`echo $EXTDR|awk '{print $1 }'|tr -d :`
#usb_filesystem=`echo $EXTDR |grep -Po 'TYPE="\K.*?(?=")'`
usb_filesystem=`echo $EXTDR |grep -Po 'ntfs'`
usb_uuid=`blkid -o value -s UUID $usb_mount`

if [ "$usb_filesystem" != "ntfs" ] ; then
echo "This external drive is not correctly formatted. Please format it to NTFS."
sleep 5; main_menu
else
echo "External drive is correctly formatted to NTFS"
sleep 5
fi

sudo grep -w UUID /etc/fstab |grep -v ext4 > /dev/null 2>&1
if [ $? -eq 0 ] ; then
echo -e 'It seems you already have an external drive mapped...\n  *** Only one assigned external drive is supported. *** \nPlease run the "EXTERNAL USB Roms NTFS Setup, EZH-2P!" script again, disable other drive before adding a new drive.'
sleep 10
exit
else
mkdir $HOME/addonusb > /dev/null 2>&1
echo "UUID=$usb_uuid  $HOME/addonusb      $usb_filesystem    nofail,user,umask=0000  0       2" > $HOME/.currentdrive
sudo sh -c "cat $HOME/.currentdrive >> /etc/fstab"
sudo umount $usb_mount
sudo mount -a
fi
testdrive2=`df |grep addonusb|wc -l`
if [ $testdrive2 -eq 0 ] ; then
	echo -e "Something went wrong. Unable to detect that external drive mounted correctly. Exiting...."
	sleep 5
	exit
fi

sleep 3
mkdir $HOME/addonusb/roms/
mkdir $HOME/RetroPie/combined_drives
mkdir $HOME/.work
echo
echo "STEP 3: Syncing the roms directories."
sleep 3
echo "...Will add roms directories to the external drive. They will be located in the "roms" directory on your external drive."
sleep 3
sudo chmod 777  $HOME/addonusb
#find "$HOME/RetroPie/roms" -mindepth 1 -maxdepth 1 -type d -printf "$HOME/addonusb/roms/%f\n" | xargs mkdir -p 2>/dev/null || true
rsync -vd -l $HOME/RetroPie/roms/ $HOME/addonusb/roms
sleep 1
mv $HOME/RetroPie/roms $HOME/RetroPie/localroms
cd /etc/samba/
sudo cp /home/pi/PlayBox-Setup/usb/smb.conf.USB ./
sudo mv smb.conf smb.conf.BAK
sudo ln -s smb.conf.USB smb.conf
cd /etc/profile.d
sudo cp /home/pi/PlayBox-Setup/usb/10-retropie.sh.USB ./
sudo mv /etc/profile.d/10-retropie.sh /etc/profile.d/10-retropie.sh.BAK
sudo ln -s 10-retropie.sh.USB 10-retropie.sh
sed -i 's+/home/pi/RetroPie/roms+/home/pi/RetroPie/localroms+g' ~/.livewire.py
echo
echo "STEP 4: Finalizing..."
sleep 3
echo -e 'The drive has been expanded and your system will now halt/shutdown...\n\nOnce system is off, you can detach your external drive...\n- Plug it up to your computer.\n- Load/copy your extra roms then plug it back in your pi and restart it...\n- You should see your additional games.\n\n'
echo "- You also have the option of uploading games by using the samba shares 'roms_SD' or 'roms_USB'."
echo "- DO NOT COPY ANYTHING TO THE [roms_combined_view]"
echo "- You can also use the MOVE System Options of the script!"
echo
read -n 1 -s -r -p "Press any key to continue..."
echo
echo " ** Based on the script by Forrest aka EazyHax ** "
sleep 1
echo
echo "  **   New Script By 2Play!   **  "
sleep 3
clear
echo
read -n 1 -s -r -p "Press any key to Power Off System"
echo
clear
echo "[OK System Will Shutdown now...]"
clear
sudo halt
}

function disable_usb() {
dialog --infobox "...Applying..." 3 18 ; sleep 2
 clear
echo "STEP 1: Checking For External Drive..."
sleep 3
if [ ! -d $HOME/addonusb ]; then
    echo ""
    echo ""
	sleep 3
	echo "This Retropie is not expanded. Stopping now..."
    echo ""
    echo ""
    sleep 5
else
echo "External Drive Detected..."
sleep 3
echo
echo "STEP 2: Removing External Drive..."
sleep 3

sudo sed -i '/addon/d' /etc/fstab
sudo unlink /etc/profile.d/10-retropie.sh
sudo cp /etc/profile.d/10-retropie.sh.BAK /etc/profile.d/10-retropie.sh
sudo unlink /etc/samba/smb.conf
sudo cp /etc/samba/smb.conf.BAK /etc/samba/smb.conf
sudo /usr/sbin/service smbd stop
unlink $HOME/RetroPie/roms; sudo umount $HOME/addonusb; sudo umount overlay
while [ `df |grep overlay |awk '{print $1 }'|wc -l` -eq 1 ]; do
            echo -e "\n\nOverlay Mount is still present. Waiting a few seconds and will try to dismout the drive again.\n\n"
            sleep 10
            sudo umount overlay
done
echo
echo "STEP 3: Finalizing..."
sleep 3
echo -e '\nCombined drives have been unmounted. Moving on with cleaning up directories and restoring your retro rig.\n[OK!] Rebooting Now...\n'
sleep 10
sed -i 's+/home/pi/RetroPie/localroms+/home/pi/RetroPie/roms+g' ~/.livewire.py
rm -r $HOME/RetroPie/combined_drives; rm -r $HOME/addonusb; rm -rf $HOME/.work; mv $HOME/RetroPie/localroms $HOME/RetroPie/roms  > /dev/null 2>&1
clear
echo
read -n 1 -s -r -p "Press any key to reboot"
echo
echo "[OK System Will Restart now...]"
clear
sudo reboot
fi
}

function format_usb() {
dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
clear
echo
echo "This will perform a quick format of your USB sda# device to NTFS..."
echo
echo "*** Let's make sure WHICH sda device you want to format... ***"
echo
blkid |grep sda
echo
echo "***Please Type the sda# from above list***"
echo 
echo "Example: 1 for sda1"
echo
read -n 1 -s -r -p "*** PRESS ANY KEY TO CONTINUE -OR- PRESS CTRL + C TO EXIT ***"
echo
echo
read -p 'So WHICH usb device would you like to format?: ' sda
echo
sudo umount /dev/sda$sda
sudo mkntfs -f -L "roms" /dev/sda$sda
sleep 1
echo "[OK DONE!...]"
echo
read -n 1 -s -r -p "Press any key to reboot..."
echo
clear
echo "[OK System Will Restart now...]"
clear
sudo reboot
}

function fix_links() {
dialog --infobox "...OK Let's Fix It..." 3 25 ; sleep 1
clear
echo
echo -e 'If you have a clean formatted drive [PREFERRED OPTION], exit now. No need to run this option!\nExpand script will do all required steps.\n\nIF YOU HAVE THOUGH AN EXISTING POPULATED DRIVE then you need to apply it! It will add the missing symbolic links!.\nIt will rename any wrong folder with [.OFF] extension so you can move contents to the link folders or delete them if you have duplicate systems ex. genesis and megadrive populated...'
echo
while true; do
echo
read -p 'Should I continue [y] or got back [n]? ' yn
	case $yn in
	[Yy]* ) if [ -d $HOME/addonusb ]; then cd $HOME/addonusb/roms && mv -f genesis genesis.OFF && mv -f genesish genesish.OFF && mv -f kodi kodi.OFF && mv -f odyssey2 odyssey2.OFF && mv -f segacd segacd.OFF && mv -f tg16 tg16.OFF && mv -f tg16cd tg16cd.OFF && rsync -vd -l $HOME/RetroPie/localroms/ $HOME/addonusb/roms && sleep 1 && echo "[OK DONE!...]"; echo; read -n 1 -s -r -p "Press any key to reboot..."; echo; clear; echo "[OK System Will Restart now...]"; clear; sudo reboot; else echo "The External USB is disabled... Nothing to do!"; echo; read -n 1 -s -r -p "Press any key to go back..."; echo; break; fi;;
    [Nn]* ) break;;
    * ) echo; echo "Please answer yes or no.";;
    esac
done	
}

function addon_artxml_usb() {
dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
clear
if [ -d $HOME/addonusb ]; then cd $HOME/addonusb/roms
	echo 
	echo " I will display a list of all USB Rom folders..."
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>	Display next k lines of text [current screen size]"
	echo " <return>	Display next k lines of text [1]*"
	echo " d		Scroll k lines [current scroll size, initially 11]*"
	echo " q		Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo "***PLEASE TYPE THE SYSTEM NAME AS IS IN THE ROMS LIST***"
	echo 
	echo "Example: arcade"
	echo "NOT Arcade or ARCADE etc..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	ls | column | more -d
	echo
	read -n 1 -s -r -p "*** PRESS ANY KEY TO CONTINUE -OR- PRESS CTRL + C TO EXIT ***"
	echo
	echo
	read -p 'So which system would you like to update: ' sname
	echo
	cd $sname
	sudo mv -f $HOME/RetroPie/localroms/$sname/gamelist.xml ./
	rm -rf $HOME/RetroPie/localroms/$sname/snap*/
		if grep '<image>'$HOME'/addonusb' gamelist.xml > /dev/null; then
		sed -i 's#<image>'$HOME'/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>'$HOME'/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>'$HOME'/addonusb/roms/.*\/snap#<video>./snap#g' gamelist.xml > /dev/null
		sed -i 's#<video>.#<video>'$HOME'/addonusb/roms/'$sname'#g' gamelist.xml > /dev/null
		echo
		echo "Your gamelist.xml already points to USB Art!"
		echo
		else
		sed -i 's#<video>'$HOME'/addonusb/roms/.*\/snap#<video>./snap#g' gamelist.xml > /dev/null
		sed -i 's#<video>.#<video>'$HOME'/addonusb/roms/'$sname'#g' gamelist.xml > /dev/null
		#rm -f /home/pi/RetroPie/combined_drives/$sname/gamelist.xml
		fi
	echo
	echo "[OK DONE!...]"
	sleep 1
	while true; do
	echo
	read -p 'Would you like to do more systems [y or c] or finalize & reboot [n or r]? ' yn
		case $yn in
		[YyCc]* ) addon_artxml_usb;;
		[NnRr]* ) echo; echo; read -n 1 -s -r -p "Press any key to reboot..."; echo; clear; echo "[OK System Will Restart now...]"; clear; sudo reboot;;
		* ) echo; echo "Please answer yes or no.";;
		esac
	done	
	else
	echo "The External USB is disabled... Nothing to do!"
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
	break
fi
}

function addon_artxml_sd() {
dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
clear
if [ -d $HOME/addonusb ]; then cd $HOME/addonusb/roms
	echo 
	echo " I will display a list of all USB Rom folders..."
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>	Display next k lines of text [current screen size]"
	echo " <return>	Display next k lines of text [1]*"
	echo " d		Scroll k lines [current scroll size, initially 11]*"
	echo " q		Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo "***PLEASE TYPE THE SYSTEM NAME AS IS IN THE ROMS LIST***"
	echo 
	echo "Example: arcade"
	echo "NOT Arcade or ARCADE etc..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	ls | column | more -d
	echo
	read -n 1 -s -r -p "*** PRESS ANY KEY TO CONTINUE -OR- PRESS CTRL + C TO EXIT ***"
	echo
	echo
	read -p 'So which system would you like to update: ' sname
	echo
	cd $sname
	mv -f gamelist.xml $HOME/RetroPie/localroms/$sname
	cd $HOME/RetroPie/localroms/$sname
	rm -rf snap*/
		if grep '<image>'$HOME'/addonusb' gamelist.xml > /dev/null; then
		sed -i 's#<image>'$HOME'/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>'$HOME'/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>'$HOME'/addonusb/roms/.*\/snap#<video>./snap#g' gamelist.xml > /dev/null
		sed -i 's#<video>.#<video>'$HOME'/addonusb/roms/'$sname'#g' gamelist.xml > /dev/null
		echo
		echo "Your gamelist.xml already points to USB Art!"
		echo
		else
		sed -i 's#<video>'$HOME'/addonusb/roms/.*\/snap#<video>./snap#g' gamelist.xml > /dev/null
		sed -i 's#<video>.#<video>'$HOME'/addonusb/roms/'$sname'#g' gamelist.xml > /dev/null
		fi
	echo
	echo "[OK DONE!...]"
	sleep 1
	while true; do
	echo
	read -p 'Would you like to do more systems [y or c] or finalize & reboot [n or r]? ' yn
		case $yn in
		[YyCc]* ) addon_artxml_usb;;
		[NnRr]* ) echo; echo; read -n 1 -s -r -p "Press any key to reboot..."; echo; clear; echo "[OK System Will Restart now...]"; clear; sudo reboot;;
		* ) echo; echo "Please answer yes or no.";;
		esac
	done	
	else
	echo "The External USB is disabled... Nothing to do!"
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
	break
fi
}

function addon_art_def() {
dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
clear
if [ -d $HOME/addonusb ]; then cd $HOME/addonusb/roms
	echo 
	echo " I will display a list of all USB Rom folders..."
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>	Display next k lines of text [current screen size]"
	echo " <return>	Display next k lines of text [1]*"
	echo " d		Scroll k lines [current scroll size, initially 11]*"
	echo " q		Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo "*** PLEASE TYPE THE SYSTEM NAME AS IS IN THE ROMS LIST ***"
	echo 
	echo "Example: arcade"
	echo "NOT Arcade or ARCADE etc..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	ls | column | more -d
	echo
	read -n 1 -s -r -p "*** PRESS ANY KEY TO CONTINUE -OR- PRESS CTRL + C TO EXIT ***"
	echo
	echo
	read -p 'So which system would you like to update: ' sname
	echo
	cd $sname
	if [ -f "gamelist.xml" ]; then
	sed -i 's#<image>'$HOME'/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>'$HOME'/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>'$HOME'/addonusb/roms/.*\/snap#<video>./snap#g' gamelist.xml > /dev/null
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	cd $HOME/RetroPie/localroms/$sname
	sed -i 's#<image>'$HOME'/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>'$HOME'/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>'$HOME'/addonusb/roms/.*\/snap#<video>./snap#g' gamelist.xml > /dev/null
	echo
	echo "[OK DONE!...]"
	sleep 1
	fi
	else
	echo "The External USB is disabled... Nothing to do!"
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
	break
fi
}

function all_artxml_sd() {
dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
clear
}

function all_artxml_sd() {
dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
clear
 }

function all_sd() {
dialog --infobox "...Restoring!..." 3 21 ; sleep 2
clear
cd $HOME/RetroPie
 if [ -d $HOME/addonusb ]; then
	echo
    echo "The External USB is enabled..."
	echo "Using correct path..."
    echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	cd $HOME/addonusb/roms
	find . -type f -name "gamelist.xml" -print0 | xargs -0 sed -i 's#<image>'$HOME'/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>'$HOME'/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>'$HOME'/addonusb/roms/.*\/snap#<video>./snap#g'  {} 2>/dev/null \;
	sleep 1
	cd $HOME/RetroPie/localroms
	find . -type f -name "gamelist.xml" -print0 | xargs -0 sed -i 's#<image>'$HOME'/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>'$HOME'/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>'$HOME'/addonusb/roms/.*\/snap#<video>./snap#g'  {} 2>/dev/null \;
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	echo "The External USB is disabled..."
	echo "Using correct path..."
    echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	cd $HOME/RetroPie/roms
	find . -type f -name "gamelist.xml" -print0 | xargs -0 sed -i 's#<image>'$HOME'/addonusb/roms/.*\/mixart#<image>./mixart#g; s#<marquee>'$HOME'/addonusb/roms/.*\/wheel#<marquee>./wheel#g; s#<video>'$HOME'/addonusb/roms/.*\/snap#<video>./snap#g'  {} 2>/dev/null \;
	echo
	echo "[OK DONE!...]"
	sleep 1
 fi
 }

function sys_usb() {
dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
 clear
 if [ -d $HOME/addonusb ]; then cd $HOME/RetroPie/localroms
	echo
    echo "The External USB is enabled..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo 
	echo " I will display a list of all USB Rom folders..."
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>	Display next k lines of text [current screen size]"
	echo " <return>	Display next k lines of text [1]*"
	echo " d		Scroll k lines [current scroll size, initially 11]*"
	echo " q		Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo "*** PLEASE TYPE THE SYSTEM NAME AS IS IN THE ROMS LIST ***"
	echo 
	echo "Example: arcade"
	echo "NOT Arcade or ARCADE etc..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	ls | column | more -d
	echo
	read -n 1 -s -r -p "*** PRESS ANY KEY TO CONTINUE -OR- PRESS CTRL + C TO EXIT ***"
	echo
	echo
	read -p 'So which system would you like to update: ' sname
	echo
	cd $sname
	sudo rsync --remove-source-files -avh ./ $HOME/addonusb/roms/$sname/
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	echo "The External USB is disabled... Nothing to do!"
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
	break
fi
}

function sys_sd() {
dialog --infobox "...OK Let's Do It..." 3 25 ; sleep 1
clear
 if [ -d $HOME/addonusb ]; then cd $HOME/addonusb/roms
	echo
    echo "The External USB is enabled..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo 
	echo " I will display a list of all USB Rom folders..."
	echo " If you can't see full list. Use below keys to scroll or exit list!"
	echo
	echo "----------------------------------------------------------------------"
	echo " <space>	Display next k lines of text [current screen size]"
	echo " <return>	Display next k lines of text [1]*"
	echo " d		Scroll k lines [current scroll size, initially 11]*"
	echo " q		Exit from more"
	echo "----------------------------------------------------------------------"
	echo
	echo "*** PLEASE TYPE THE SYSTEM NAME AS IS IN THE ROMS LIST ***"
	echo 
	echo "Example: arcade"
	echo "NOT Arcade or ARCADE etc..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	echo
	ls | column | more -d
	echo
	read -n 1 -s -r -p "*** PRESS ANY KEY TO CONTINUE -OR- PRESS CTRL + C TO EXIT ***"
	echo
	echo
	read -p 'So which system would you like to update: ' sname
	echo
	cd $sname
	rsync --remove-source-files -rvh ./ $HOME/RetroPie/localroms/$sname/
	cd $HOME/RetroPie/localroms/$sname/
	find ./ -type d -print0 | xargs -0 chmod 755
	find ./ -type f -print0 | xargs -0 chmod 644
	chmod 755 *.sh && chmod 755 *.exe  && chmod 755 *.com && chmod 755 *.bat
	echo
	echo "[OK DONE!...]"
	sleep 1
	else
	echo "The External USB is disabled... Nothing to do!"
	echo
	read -n 1 -s -r -p "Press any key to go back..."
	echo
	break
fi
}

main_menu
