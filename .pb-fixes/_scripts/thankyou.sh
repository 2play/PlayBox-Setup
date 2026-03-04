#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 03.2024

infobox=""
infobox="${infobox}\n*** 2Play! Top Supporters & Friends***:\n- Jahitu, jucosorin, VGMonkey, scaled, BMP, Tisusbr, Yelah05, TechXero, bluestang, Randyslim, Traxis, Strunx, ChrisKerkides, Mrnebu, Edale, Gomer, QUIZASERAQ, dbresson, Everblight82, Eliasblizzard, Sunrise169, Grumpa and of course any/all MEGA supporters!\n\n

*** Developers & Scripts ***:\n
Rpc80 (Ryan Connors), Rydra, EasyHax (aka Forrest), Demetris Ierokipides aka Ntemis, CyperGhost, Meleu, Lars Muldjord (Skyskraper), David Marti (Motion Blue), Bezel Project Team, Folly, Valerino, Aditya Shakya aka adi1090x, Paul Cercueil aka pcercuei.\n\n

*** OS & FrontEnd ***:\n
Armbian Team for the nice clean OS!.\n
Retropie Team (Retropie), Andrew Mickelson (Attract Mode) & Radek Dutkiewicz aka oomek (Attract Plus), HyperPie Team (HyperPie), Mátyás Mustoha (Pegasus-FE).\n\n

*** Themes & Art Ideas ***:\n
Chicuelo & c64-dev, GeekOB, Ricky Romero, TreyM, Mr_RetroLust, Rachid Lotf and all devianart\art creators.\n\n

"
infobox="${infobox}\n"

dialog --backtitle "PlayBox Toolkit" \
--title "THANK YOU!" \
--msgbox "${infobox}" 35 110

