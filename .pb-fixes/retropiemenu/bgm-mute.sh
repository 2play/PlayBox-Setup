#!/usr/bin/env bash
stop_bgm(){
        cp /opt/retropie/configs/all/autostartNOBGM.sh /opt/retropie/configs/all/autostart.sh
    clear
        echo -e "\n\n\n                               Background Music Disabled\n\n\n"
        sleep 3
}

start_bgm(){
        cp /opt/retropie/configs/all/autostartBGM.sh /opt/retropie/configs/all/autostart.sh
        echo -e "\n\n\n                                    Background Music Enabled\n\n\n"
        sleep 3
}

	clear
	echo "We need to restart system now..."
	echo
	read -n 1 -s -r -p "Press any key to continue..."
	sleep 1
	sudo reboot
	echo
exit
