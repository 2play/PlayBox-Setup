#!/bin/bash
# Created by David Marti
# Revised By 2Play!

scrversion="PlayBox Revision 05.04.2021"

IFS=';'

# Welcome
 dialog --backtitle "RetroPie" --title "RetroPie Media Removal Utility" \
    --yesno "\n$scrversion\n\nThis utility will remove extra media files from mixart, boxart, cartart, snap(s) and wheel for a chosen system where there is not a matching game for it.\n\nIf you keep your media for MAME or Final Burn Alpha in the /roms/arcade folder, there is a special choice just for that.\n\n*** WARNING ***:\nDavid's script removes art basis romname! So art files have to MATCH romname!\nAlways have a backup copy of your media files before making changes to your system.\n\nDo you want to proceed? You can still exit at next step..." \
    25 80 2>&1 > /dev/tty \
    || exit


function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MEDIA REMOVAL DAVID MARTI MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which System Media Folders Do You Wish To Clean up?" 25 75 20 \
            1 "amiga" \
            2 "amstradcpc" \
            3 "apple2" \
            4 "arcade" \
            5 "atari2600" \
            6 "atari5200" \
            7 "atari7800" \
            8 "atari800" \
            9 "atarilynx" \
            10 "atarist" \
            11 "c64" \
            12 "coco" \
            13 "coleco" \
            14 "daphne" \
            15 "dragon32" \
            16 "dreamcast" \
            17 "famicom" \
            18 "fba" \
            19 "fba (media in arcade)" \
            20 "fds" \
            21 "gameandwatch" \
            22 "gamegear" \
            23 "gb" \
            24 "gba" \
            25 "gbc" \
            26 "genesis" \
            27 "intellivision" \
            28 "mame-advmame" \
            29 "mame-advmame (media in arcade)" \
            30 "mame-libretro" \
            31 "mame-libretro (media in arcade)" \
            32 "mame-mame4all" \
            33 "mame-mame4all (media in arcade)" \
            34 "mastersystem" \
            35 "megadrive" \
            36 "megadrive-japan" \
            37 "msx" \
            38 "msx2" \
            39 "n64" \
            40 "nds" \
            41 "neogeo" \
            42 "nes" \
            43 "ngp" \
            44 "ngpc" \
            45 "oric" \
            46 "pc" \
            47 "pce-cd" \
            48 "pcengine" \
            49 "psp" \
            50 "pspminis" \
            51 "psx" \
            52 "residualvm" \
            53 "scummvm" \
            54 "sega32x" \
            55 "segacd" \
            56 "sfc" \
            57 "sg-1000" \
            58 "snes" \
            59 "supergrafx" \
            60 "tg16" \
            61 "tg-cd" \
            62 "ti99" \
            63 "trs-80" \
            64 "vectrex" \
            65 "videopac" \
            66 "virtualboy" \
            67 "wonderswan" \
            68 "wonderswancolor" \
            69 "x68000" \
            70 "zmachine" \
            71 "zxspectrum" \
			- "" \
			- "*** PLAYBOX EXTRA SYSTEMS ***" \
			72 "3do" \
			73 "ags" \
			74 "amiga-aga" \
			75 "amigacd32" \
			76 "apple2gs" \
			77 "arcadia" \
			78 "archimedes" \
			79 "astrocade" \
			80 "atarifalcon" \
			81 "atarijaguar" \
			82 "ataritt" \
			83 "atarixegs" \
			84 "atomiswave" \
			85 "bbcmicro" \
			86 "c16" \
			87 "c128" \
			88 "cdimono1" \
			89 "cdtv" \
			90 "channelf" \
			91 "coleco_adam" \
			92 "crvision" \
			93 "electron" \
			94 "fm7" \
			95 "genesish (hacks)" \
			96 "gx4000" \
			97 "intellivision_ecs" \
			98 "lightgun" \
			99 "love" \
			100 "lutro" \
			101 "macintosh" \
			102 "markiii" \
			103 "mega32x" \
			104 "megacd" \
			105 "megadriveh (hacks)" \
			106 "moto" \
			107 "msx2+" \
			108 "msxturbor" \
			109 "naomi" \
			110 "neogeocd" \
			111 "nesh (hacks)" \
			112 "odyssey2" \
			113 "openbor" \
			114 "pc128" \
			115 "pc88" \
			116 "pc98" \
			117 "pcenginecd" \
			118 "pcfx" \
			119 "pico" \
			120 "pico8" \
			121 "plus4" \
			122 "samcoupe" \
			123 "satellaview" \
			124 "saturn" \
			125 "saturn-japan" \
			126 "sc-3000" \
			127 "scv" \
			128 "sgb" \
			129 "sgfx" \
			130 "snesh (hacks)" \
			131 "snesmsu1" \
			132 "spinner" \
			133 "stv" \
			134 "sufami" \
			135 "swancrystal" \
			136 "tg16cd" \
			137 "trackball" \
			138 "vic20" \
			139 "x1" \
			140 "zx81" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) remove_media "amiga" ;;
            2) remove_media "amstradcpc" ;;
            3) remove_media "apple2" ;;
            4) remove_media "arcade" ;;
            5) remove_media "atari2600" ;;
            6) remove_media "atari5200" ;;
            7) remove_media "atari7800" ;;
            8) remove_media "atari800" ;;
            9) remove_media "atarilynx" ;;
            10) remove_media "atarist" ;;
            11) remove_media "c64" ;;
            12) remove_media "coco" ;;
            13) remove_media "coleco" ;;
            14) remove_media "daphne" ;;
            15) remove_media "dragon32" ;;
            16) remove_media "dreamcast" ;;
            17) remove_media "famicom" ;;
            18) remove_media "fba" ;;
            19) remove_media_arcade "fba" ;;
            20) remove_media "fds" ;;
            21) remove_media "gameandwatch" ;;
            22) remove_media "gamegear" ;;
            23) remove_media "gb" ;;
            24) remove_media "gba" ;;
            25) remove_media "gbc" ;;
            26) remove_media "genesis" ;;
            27) remove_media "intellivision" ;;
            28) remove_media "mame-advmame" ;;
            29) remove_media_arcade "mame-advmame" ;;
            30) remove_media "mame-libretro" ;;
            31) remove_media_arcade "mame-libretro" ;;
            32) remove_media "mame-mame4all" ;;
            33) remove_media_arcade "mame-mame4all" ;;
            34) remove_media "mastersystem" ;;
            35) remove_media "megadrive" ;;
            36) remove_media "megadrive-japan" ;;
            37) remove_media "msx" ;;
            38) remove_media "msx2" ;;
            39) remove_media "n64" ;;
            40) remove_media "nds" ;;
            41) remove_media "neogeo" ;;
            42) remove_media "nes" ;;
            43) remove_media "ngp" ;;
            44) remove_media "ngpc" ;;
            45) remove_media "oric" ;;
            46) remove_media "pc" ;;
            47) remove_media "pce-cd" ;;
            48) remove_media "pcengine" ;;
            49) remove_media "psp" ;;
            50) remove_media "pspminis" ;;
            51) remove_media "psx" ;;
            52) remove_media "residualvm" ;;
            53) remove_media "scummvm" ;;
            54) remove_media "sega32x" ;;
            55) remove_media "segacd" ;;
            56) remove_media "sfc" ;;
            57) remove_media "sg-1000" ;;
            58) remove_media "snes" ;;
            59) remove_media "supergrafx" ;;
            60) remove_media "tg16" ;;
            61) remove_media "tg-cd" ;;
            62) remove_media "ti99" ;;
            63) remove_media "trs-80" ;;
            64) remove_media "vectrex" ;;
            65) remove_media "videopac" ;;
            66) remove_media "virtualboy" ;;
            67) remove_media "wonderswan" ;;
            68) remove_media "wonderswancolor" ;;
            69) remove_media "x68000" ;;
            70) remove_media "zmachine" ;;
            71) remove_media "zxspectrum" ;;
			72) remove_media "3do" ;;
			73) remove_media "ags" ;;
			74) remove_media "amiga-aga" ;;
			75) remove_media "amigacd32" ;;
			76) remove_media "apple2gs" ;;
			77) remove_media "arcadia" ;;
			78) remove_media "archimedes" ;;
			79) remove_media "astrocade" ;;
			80) remove_media "atarifalcon" ;;
			81) remove_media "atarijaguar" ;;
			82) remove_media "ataritt" ;;
			83) remove_media "atarixegs" ;;
			84) remove_media "atomiswave" ;;
			85) remove_media "bbcmicro" ;;
			86) remove_media "c16" ;;
			87) remove_media "c128" ;;
			88) remove_media "cdimono1" ;;
			89) remove_media "cdtv" ;;
			90) remove_media "channelf" ;;
			91) remove_media "coleco_adam" ;;
			92) remove_media "crvision" ;;
			93) remove_media "electron" ;;
			94) remove_media "fm7" ;;
			95) remove_media "genesish (hacks)" ;;
			96) remove_media "gx4000" ;;
			97) remove_media "intellivision_ecs" ;;
			98) remove_media "lightgun" ;;
			99) remove_media "love" ;;
			100) remove_media "lutro" ;;
			101) remove_media "macintosh" ;;
			102) remove_media "markiii" ;;
			103) remove_media "mega32x" ;;
			104) remove_media "megacd" ;;
			105) remove_media "megadriveh (hacks)" ;;
			106) remove_media "moto" ;;
			107) remove_media "msx2+" ;;
			108) remove_media "msxturbor" ;;
			109) remove_media "naomi" ;;
			110) remove_media "neogeocd" ;;
			111) remove_media "nesh (hacks)" ;;
			112) remove_media "odyssey2" ;;
			113) remove_media "openbor" ;;
			114) remove_media "pc128" ;;
			115) remove_media "pc88" ;;
			116) remove_media "pc98" ;;
			117) remove_media "pcenginecd" ;;
			118) remove_media "pcfx" ;;
			119) remove_media "pico" ;;
			120) remove_media "pico8" ;;
			121) remove_media "plus4" ;;
			122) remove_media "samcoupe" ;;
			123) remove_media "satellaview" ;;
			124) remove_media "saturn" ;;
			125) remove_media "saturn-japan" ;;
			126) remove_media "sc-3000" ;;
			127) remove_media "scv" ;;
			128) remove_media "sgb" ;;
			129) remove_media "sgfx" ;;
			130) remove_media "snesh (hacks)" ;;
			131) remove_media "snesmsu1" ;;
			132) remove_media "spinner" ;;
			133) remove_media "stv" ;;
			134) remove_media "sufami" ;;
			135) remove_media "swancrystal" ;;
			136) remove_media "tg16cd" ;;
			137) remove_media "trackball" ;;
			138) remove_media "vic20" ;;
			139) remove_media "x1" ;;
			140) remove_media "zx81" ;;
            -) none ;;
            *)  break ;;
        esac
    done
}

function remove_media() {
dialog --infobox "...processing..." 3 20 ; sleep 2
choice=$1
directory="/home/pi/RetroPie/roms/${choice}"

ls "${directory}/mixart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/mixart.txt
ls "${directory}/boxart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/boxart.txt
ls "${directory}/cartart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/cartart.txt
ls "${directory}/snap" | sed -e 's/\.mp4$//' > /tmp/snap.txt
ls "${directory}/snaps" | sed -e 's/\.mp4$//' > /tmp/snaps.txt
ls "${directory}/wheel" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/wheel.txt

rm /tmp/remove_media.sh 2> /dev/null

while read mname
do
ifexist=`ls "${directory}" |grep "${mname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/mixart/${mname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${directory}/mixart/${mname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/mixart.txt

while read bname
do
ifexist=`ls "${directory}" |grep "${bname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/boxart/${bname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${directory}/boxart/${bname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/boxart.txt

while read cname
do
ifexist=`ls "${directory}" |grep "${cname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/cartart/${cname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${directory}/cartart/${cname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/cartart.txt

while read sname
do
ifexist=`ls "${directory}" |grep "${sname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/snap/${sname}.mp4\"" >> /tmp/remove_media.sh
fi
done < /tmp/snap.txt

while read ssname
do
ifexist=`ls "${directory}" |grep "${ssname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/snap/${ssname}.mp4\"" >> /tmp/remove_media.sh
fi
done < /tmp/snaps.txt

while read wname
do
ifexist=`ls "${directory}" |grep "${wname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/wheel/${wname}.png\""  >> /tmp/remove_media.sh
echo "rm \"${directory}/wheel/${wname}.jpg\""  >> /tmp/remove_media.sh
fi
done < /tmp/wheel.txt

#execute the removal
chmod 777 /tmp/remove_media.sh
/tmp/remove_media.sh
rm /tmp/remove_media.sh
}

function remove_media_arcade() {
dialog --infobox "...processing..." 3 20 ; sleep 2
choice=$1
arcade="/home/pi/RetroPie/roms/arcade"
directory="/home/pi/RetroPie/roms/${choice}"

ls "${arcade}/mixart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/mixart.txt
ls "${arcade}/boxart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/boxart.txt
ls "${arcade}/cartart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/cartart.txt
ls "${arcade}/snap" | sed -e 's/\.mp4$//' > /tmp/snap.txt
ls "${arcade}/snaps" | sed -e 's/\.mp4$//' > /tmp/snaps.txt
ls "${arcade}/wheel" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/wheel.txt

rm /tmp/remove_media.sh 2> /dev/null

while read mname
do
ifexist=`ls "${directory}" |grep "${mname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/boxart/${mname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${arcade}/boxart/${mname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/mixart.txt

while read bname
do
ifexist=`ls "${directory}" |grep "${bname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/boxart/${bname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${arcade}/boxart/${bname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/boxart.txt

while read cname
do
ifexist=`ls "${directory}" |grep "${cname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/cartart/${cname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${arcade}/cartart/${cname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/cartart.txt

while read sname
do
ifexist=`ls "${directory}" |grep "${sname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/snap/${sname}.mp4\"" >> /tmp/remove_media.sh
fi
done < /tmp/snap.txt

while read ssname
do
ifexist=`ls "${directory}" |grep "${ssname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/snap/${ssname}.mp4\"" >> /tmp/remove_media.sh
fi
done < /tmp/snap.txt

while read wname
do
ifexist=`ls "${directory}" |grep "${wname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/wheel/${wname}.png\""  >> /tmp/remove_media.sh
echo "rm \"${arcade}/wheel/${wname}.jpg\""  >> /tmp/remove_media.sh
fi
done < /tmp/wheel.txt

#execute the removal
chmod 777 /tmp/remove_media.sh
/tmp/remove_media.sh
rm /tmp/remove_media.sh
}

# Main

main_menu
