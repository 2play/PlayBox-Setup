#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 11.09.2020

infobox=""
infobox="${infobox}\n*** 2Play! VIP, Testers & Top Supporters ***:\n- Jahitu, Gomer, Aeonis, Traxis, Yelah05, Sunrise169, BMP, Rick Dangerous, Randyslim, Strunx, TechXero, Edale, R1SKbreaker, Tisusbr, Mrnebu, ChrisKerkides, Grumpa and of course all supporters!\n\n

*** Developers & Scripts ***:\n
Demetris (Tinker PlayBox), rpc80 (Ryan Connors), EasyHax (aka Forrest), CyperGhost, David Marti (Motion Blue), Meleu, Lars Muldjord (Skyskraper), Bezel Project Team.\n\n

*** OS & FrontEnd ***:\n
Raspberry Pi Foundation for the nice clean OS.\n
Retropie Team (Retropie), Andrew Mickelson (Attract Mode), HyperPie Team (HyperPie), Mátyás Mustoha (Pegasus-FE).\n\n

*** Themes ***:\n
Chicuelo, Controllers art updates Ricky Romero, Rachid Lotf and all devianart\art creators.\n\n

*** Builders ***:\n
VirtualMan.\n
"
infobox="${infobox}\n"

dialog --backtitle "PlayBox Toolkit" \
--title "THANK YOU!" \
--msgbox "${infobox}" 35 110

