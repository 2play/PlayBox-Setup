#!/usr/bin/env bash
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 14.07.20
echo ""
echo "Setting HyperPie 2.5.1 as the default frontend."
echo ""
sleep 5
#echo "/home/pi/.attract/ambootcheck/amromcheck.sh" > /opt/retropie/configs/all/autostart.sh
#echo "while pgrep omxplayer >/dev/null; do sleep 1; done" > /opt/retropie/configs/all/autostart.sh
#echo "(sleep 10; mpg123 -Z /home/pi/RetroPie/roms/music/*.mp3 > /dev/null 2>&1) &" >>/opt/retropie/configs/all/autostart.sh 
echo "/home/pi/.attract/intro/intro.mp4" | sudo tee /etc/splashscreen.list > /dev/null
echo "attract #auto" | tee /opt/retropie/configs/all/autostart.sh > /dev/null
sudo reboot
