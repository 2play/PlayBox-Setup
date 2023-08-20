#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2023 2Play! (S.R.)
# 08.2023

infobox=""
infobox="${infobox}\n*** 2Play! Top Supporters & Friends***:\n- Jahitu, BMP, bluestang, Randyslim, Tisusbr, Yelah05, Traxis, Strunx, ChrisKerkides,  TechXero, Mrnebu, Edale, Gomer, QUIZASERAQ, dbresson, Everblight82, Eliasblizzard, Sunrise169, Aeonis, Grumpa, Wolf and of course any/all MEGA supporters!\n\n

*** Developers & Scripts ***:\n
Rpc80 (Ryan Connors), Rydra, EasyHax (aka Forrest), Demetris Ierokipides aka Ntemis, CyperGhost, Meleu, Lars Muldjord (Skyskraper), David Marti (Motion Blue), Bezel Project Team, Folly, Valerino, Aditya Shakya aka adi1090x, Paul Cercueil aka pcercuei.\n\n

*** OS & FrontEnd ***:\n
Armbian Team for the nice clean OS!.\n
Retropie Team (Retropie), Andrew Mickelson (Attract Mode), HyperPie Team (HyperPie), Mátyás Mustoha (Pegasus-FE).\n\n

*** Themes & Art Ideas ***:\n
Chicuelo & c64-dev, GeekOB, Ricky Romero, TreyM, Mr_RetroLust, Rachid Lotf and all devianart\art creators.\n\n

*** Builders ***:\n
Schmoomer, VirtualMan\n
"
infobox="${infobox}\n"

dialog --backtitle "PlayBox Toolkit" \
--title "THANK YOU!" \
--msgbox "${infobox}" 35 110

