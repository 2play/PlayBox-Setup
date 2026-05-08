#!/bin/bash
# Quick Manual Update of Bezels Project for PlayBox
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 06.05.26

cd $HOME/RetroPie/retropiemenu/"Visuals 'n' Theme Tools"
rm -f bezelproject.sh ../bezelproject.sh
wget "https://raw.githubusercontent.com/thebezelproject/BezelProject/master/bezelproject.sh"
chmod 755 bezelproject.sh

cd $HOME/PlayBox-Setup/.pb-fixes/retropiemenu/"Visuals 'n' Theme Tools"
rm bezelproject.sh
wget "https://raw.githubusercontent.com/thebezelproject/BezelProject/master/bezelproject.sh"
chmod 755 bezelproject.sh

cd $HOME