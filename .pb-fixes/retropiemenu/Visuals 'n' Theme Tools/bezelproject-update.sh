#!/bin/bash
# Quick Manual Update of Bezels Project by 2Play!
# The PlayBox Project
# Copyright (C)2018-2023 2Play! (S.R.)
# 30.01.19

cd /home/pi/RetroPie/retropiemenu/Visuals\ \'n\'\ Theme\ Tools/
rm bezelproject.sh && rm /home/pi/RetroPie/retropiemenu/bezelproject.sh
wget https://raw.githubusercontent.com/thebezelproject/BezelProject/master/bezelproject.sh
chmod 755 bezelproject.sh

cd /home/pi/PlayBox-Setup/.pb-fixes/retropiemenu/Visuals\ \'n\'\ Theme\ Tools/
rm bezelproject.sh && rm /home/pi/RetroPie/retropiemenu/bezelproject.sh
wget https://raw.githubusercontent.com/thebezelproject/BezelProject/master/bezelproject.sh
chmod 755 bezelproject.sh
