#!/usr/bin/env bash
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 15.10.20
clear
echo ""
echo "Setting HyperPie 2.5.1 as the default frontend."
echo ""
sleep 5
#echo "/home/pi/.attract/ambootcheck/amromcheck.sh" > /opt/retropie/configs/all/autostart.sh
#echo "#while pgrep omxplayer >/dev/null; do sleep 1; done" > /opt/retropie/configs/all/autostart.sh
#echo "(sleep 10; mpg123 -Z /home/pi/RetroPie/roms/music/*.mp3 > /dev/null 2>&1) &" >>/opt/retropie/configs/all/autostart.sh
echo "/home/pi/.attract/intro/intro.mp4" | sudo tee /etc/splashscreen.list > /dev/null
echo "#fbset -fb /dev/fb0 -g 1920 1080 1920 1080 16" | tee /opt/retropie/configs/all/autostart.sh > /dev/null
echo 'HDMI2OFF=`tvservice -l |grep "2 attached device"`' | tee -a /opt/retropie/configs/all/autostart.sh > /dev/null
echo 'if [[ $HDMI2OFF == "2 attached device" ]]; then' | tee -a /opt/retropie/configs/all/autostart.sh > /dev/null
echo "/usr/bin/python /opt/retropie/configs/all/PieMarquee2/PieMarquee2.py > /dev/null 2>&1 &" | tee -a /opt/retropie/configs/all/autostart.sh > /dev/null
echo "fi" | tee -a /opt/retropie/configs/all/autostart.sh > /dev/null
RNDMTHM=`grep "^/home/pi/scripts/themerandom.sh" /opt/retropie/configs/all/autostart.sh`
if [[ $RNDMTHM == "/home/pi/scripts/themerandom.sh" ]]; then
  echo "/home/pi/scripts/themerandom.sh" | tee -a /opt/retropie/configs/all/autostart.sh > /dev/null
  else
  echo "#/home/pi/scripts/themerandom.sh" | tee -a /opt/retropie/configs/all/autostart.sh > /dev/null
fi
echo "attract #auto" | tee -a /opt/retropie/configs/all/autostart.sh > /dev/null
sudo reboot
