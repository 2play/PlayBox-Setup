#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2022 2Play! (S.R.)
# 15.06.2021

infobox=""
infobox="${infobox}\n*** 2Play! Top Supporters & Friends***:\n- Jahitu, Gomer, BMP, bluestang, Randyslim, QUIZASERAQ, Tisusbr, dbresson, Everblight82, Eliasblizzard, Sunrise169, Yelah05, Aeonis, Traxis, Strunx, ChrisKerkides, Grumpa, TechXero, Mrnebu, Edale and of course any/all MEGA supporters!\n\n

*** Developers & Scripts ***:\n
Demetris (Tinker PlayBox), rpc80 (Ryan Connors), Folly, EasyHax (aka Forrest), CyperGhost, David Marti (Motion Blue), Meleu, Lars Muldjord (Skyskraper), Bezel Project Team, Valerino, Luis Torres aka Naprosnia.\n\n

*** OS & FrontEnd ***:\n
Raspberry Pi Foundation for the nice clean OS.\n
Retropie Team (Retropie), Andrew Mickelson (Attract Mode), HyperPie Team (HyperPie), Mátyás Mustoha (Pegasus-FE).\n\n

*** Themes & Art Ideas ***:\n
Chicuelo & c64-dev, GeekOB, Ricky Romero, TreyM, Mr_RetroLust, Rachid Lotf and all devianart\art creators.\n\n

*** Builders ***:\n
Schmoomer, VirtualMan, Rick Dangerous\n
"
infobox="${infobox}\n"

dialog --backtitle "PlayBox Toolkit" \
--title "THANK YOU!" \
--msgbox "${infobox}" 35 110

