#!/bin/bash
# Pathfinder 4 Custom Collections by Cyperghost
# How to find files maybe usefull for custom collections
# Without using IFS or other bad tricks!
# iname, iregex vs name, regex is independent of upper lower cases
# The PlayBox Project
# Copyright (C)2018-2024 2Play! (S.R.)
# Dual Script with USB Roms check, 15.02.22 By 2Play! (Based/Using Original Creator's script)

infobox=""
infobox="${infobox}\n"
infobox="${infobox}Pathfinder 4 Custom Collections by Cyperghost\n"
infobox="${infobox}Dual Script with USB Roms Option by 2Play!\n"
infobox="${infobox}(Based/Using Original Creator's script)\n"
infobox="${infobox}\n\n\n"
infobox="${infobox}It compares custom imported collections (by other users) with your Romsets. It will automatically correct paths. If there are more than one possible hit, then you can choose out of a selection of ROMs. Standard & advanced search options.\n"
infobox="${infobox}\n\n"


dialog --backtitle "Pathfinder 4 Custom Collections by Cyperghost" \
--title "CUSTOM COLLECTIONS" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " CUSTOM COLLECTIONS MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Are you ready?" 25 75 20 \
            - "*** CUSTOM COLLECTIONS FIX SELECTIONS ***" \
            1 " - Fix Imported Collections Paths - Non USB Roms" \
            2 " - Fix Imported Collections Paths - External USB Roms" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) fix_local_cs  ;;
            2) fix_usb_cs  ;;
            -) none  ;;
            *)  break ;;
        esac
    done
}

function fix_local_cs() {
readonly VERSION="1.10_060918"
readonly TITLE="Pathfinder 4 Custom Collections"
readonly ROMBASE_DIR="/home/pi/RetroPie/roms"
readonly COLLECTION_DIR="/opt/retropie/configs/all/emulationstation/collections"
readonly ignore_list=("the" "The" "and" "is" "III" "II" "I")

# Possible Backups
#readonly BACKUP_DIR="$(cd "$(dirname "$0")" && pwd)/collection_backup"
readonly BACKUP_DIR="/opt/retropie/configs/all/emulationstation/collection_backup"
readonly CURRENT_TIME="$(date +%s)"
[[ -d $BACKUP_DIR ]] || mkdir -p "$BACKUP_DIR"

# ---- Function Calls ----

# LOG every action
# instead of echo "Something of this" we call the record
# All actions will be performed to the backup directory with timestamp

function record() {
    local message="$1"   # This stores message
    local show_msg="$2"  # This enables/disables textouput and log caps
                         # 0 disables stdout output and enables log
                         # 1 enables stdout output and enables log
                         # 2 enables stdout output only
                         # -1 left empty nothing happens

    [[ $show_msg -lt 0 ]] && return
    local backup="$BACKUP_DIR/${CURRENT_TIME}-filefinder.log"

    [[ $show_msg -lt 2 ]] && echo "$1" >> "$backup"
    [[ $show_msg -gt 0 ]] && echo "$1"
}

# get extension for specfic system
# if system isn't available then file extension is ignored
# we got all files from base rom without

function system_extension () {

    case "$1" in

        amstradcpc) echo ".*\.\(cdt\|cpc\|dsk\)" ;;
        arcade) echo ".*\.\(fba\|zip\)" ;;
        atari2600) echo ".*\.\(7z\|a26\|bin\|rom\|zip\|gz\)" ;;
        atari7800) echo ".*\.\(7z\|a78\|bin\|zip\)" ;;
        atarilynx) echo ".*\.\(7z\|lnx\|zip\)" ;;
        cps1) echo ".*\.\(fba\|zip\)" ;;
        cps2) echo ".*\.\(fba\|zip\)" ;;
        fba) echo ".*\.\(fba\|zip\)" ;;
        fds) echo ".*\.\(nes\|fds\|zip\)" ;;
        gameandwatch) echo ".*\.\(mgw\)" ;;
        gamegear) echo ".*\.\(7z\|gg\|bin\|sms\|zip\)" ;;
        gb) echo ".*\.\(7z\|gb\|zip\)" ;;
        gba) echo ".*\.\(7z\|gba\|zip\)" ;;
        gbc) echo ".*\.\(7z\|gbc\|zip\)" ;;
        mame-libretro) echo ".*\.\(zip\)" ;;
        mame-mame4all) echo ".*\.\(zip\)" ;;
        mastersystem) echo ".*\.\(7z\|sms\|bin\|zip\)" ;;
        megadrive) echo ".*\.\(7z\|smd\|bin\|gen\|md\|sg\|zip\)" ;;
        msx) echo ".*\.\(rom\|mx1\|mx2\|col\|dsk\|zip\)" ;;
        n64) echo ".*\.\(z64\|n64\|v64\)" ;;
        neogeo) echo ".*\.\(fba\|zip\)" ;;
        nes) echo ".*\.\(7z\|nes\|zip\)" ;;
        ngp) echo ".*\.\(ngp\|zip\)" ;;
        ngpc) echo ".*\.\(ngc\|zip\)" ;;
        pcengine) echo ".*\.\(7z\|pce\|ccd\|cue\|zip\)" ;;
        ports) echo ".*\.\(sh\)" ;;
        psp) echo ".*\.\(iso\|pbp\|cso\)" ;;
        psx) echo ".*\.\(cue\|cbn\|img\|iso\|m3u\|mdf\|pbp\|toc\|z\|znx\)" ;;
        sega32x) echo ".*\.\(7z\|32x\|smd\|bin\|md\|zip\)" ;;
        segacd) echo ".*\.\(iso\|cue\)" ;;
        sg-1000) echo ".*\.\(sg\|bin\|zip\)" ;;
        snes) echo ".*\.\(7z\|bin\|smc\|sfc\|fig\|swc\|mgd\|zip\)" ;;
        vectrex) echo ".*\.\(7z\|vec\|gam\|bin\|zip\)" ;;
        zxspectrum) echo ".*\.\(7z\|sh\|sna\|szx\|z80\|tap\|tzx\|gz\|udi\|mgt\|img\|trd\|scl\|dsk\|zip\|rzx\)" ;;

    esac
}

# Rebuild Filenames, if $i starts with "./" an new filename is found
# Array postion 1 is always empty, we can use that later

function build_find_array() {

    local i;local ii
    local filefind="$1"

    for i in $filefind; do
        if [[ ${i:0:2} == "./" ]]; then
            array+=("$ii")
            ii=
            ii="$i"
         else
            ii="$ii $i"
         fi
    done
    array[0]="$ii" #Catch last entry and put it in first row

}

# File Search Function with different levels
# Wie return, number of filesfound and array
# level 1=simple 1:1 find (autmatic)
# level 2.1=intermediate: /path/system/rom*.{systemext}
# level 2.2=super intermediate: /path/system/*rom*.{systemext}
# level 3.1=arcade: /path/rom.{systemext}
# level 3.2=arcade: /path/rom*.{systemext}
# level 4=slight advanced: /path/system/rom_first_word*.{systemext}
# level 5 == like level 1 simple 1:1 find (autmatic)
# experimental level 6.1=advanced: /path/rom*.{systemext}
# experimental level 6.2=lastresort: /path/*rom*

function file_search() {

    local level="$1"
    local filefind

    case $level in

        1)
           # This is LEVEL 1 search - this are direct hits

           if [[ -d $ROMBASE_DIR/$rom_system ]] && [[ $ROMBASE_DIR/$rom_system == $rom_path ]]; then
               cd "$rom_path"
               filefind=$(find -name "$rom_mask_brkts" -type f 2>/dev/null)
               [[ -n $filefind ]] && array[0]="file found"
           fi

           [[ -z $filefind ]] && file_search 2
        ;;

        2)
           # This is LEVEL 2 search - search per system!
           # Search 2.1: Brackets removed, all file extension for system available are considered
           # Search 2.2: All special character will be removed and resolved as *
           #             Word like "The" "of" and some roman numbers will be stripped *
           #             Like in 2.1 all file extensions for system will be considered      

           if [[ -d $ROMBASE_DIR/$rom_system ]]; then
               rom_path="$ROMBASE_DIR/$rom_system"
               cd "$rom_path"
               system_extension=$(system_extension "$rom_system")

               filefind=$(find -iname "$rom_no_brkts*" -iregex "$system_extension" -type f 2>/dev/null)

               if [[ -z $filefind ]]; then
                   rom_no_brkts_temp="${rom_no_brkts//[^[:alnum:].]/\*}"
                   for i in "${ignore_list[@]}"; do
                       rom_no_brkts_temp="${rom_no_brkts_temp//$i/\*}"
                   done

                   filefind=$(find -iname "*$rom_no_brkts_temp*" -iregex "$system_extension" -type f 2>/dev/null) 

               fi

               if [[ -n $filefind ]]; then
                   # Build Array for files
                   build_find_array "$filefind"

                   # Remove ./ from filenames and add pathes to array
                   z=0
                   for i in "${array[@]}"; do
                       array[z]="$rom_path${i#.*}"
                       z=$((z+1))
                   done
               fi
           fi

           [[ -z $filefind ]] && file_search 3
        ;;

        3)
           # This is LEVEL 3 of file search - search in BASE folders
           # It's a suitable case for arcades for example
           # Search 3.1: Just exact filename (good for arcades)
           # Search 3.2: Just filename* to catch subroms, all extension for system available

           if [[ -d $ROMBASE_DIR ]]; then
               rom_base="$ROMBASE_DIR"
               cd "$rom_base"
               filefind=$(find -name "$rom_name" -type f 2>/dev/null)

               if [[ -z $filefind ]]; then
                   system_extension=$(system_extension "$rom_system")
                   [[ -z $system_extension ]] && return
                   filefind=$(find -iname "$rom_no_ext*" -iregex "$system_extension" -type f 2>/dev/null)
               fi

               if [[ -n $filefind ]]; then
                   # Build Array for files
                   build_find_array "$filefind"

                   # Remove ./ from filenames and add pathes to array
                   z=0
                   for i in "${array[@]}"; do
                       array[z]="$rom_base${i#.*}"
                       z=$((z+1))
                   done
               fi
             fi

           [[ -z $filefind ]] && file_search 4
       ;;

        4)
           # This level 4 search - First word of ROMName is used
           # This will generate massive hits in some cases (Super Mario...)
           # Therefore I just search in system folder for this!

           if [[ -d $ROMBASE_DIR/$rom_system ]]; then
               rom_path="$ROMBASE_DIR/$rom_system"
               cd "$rom_path"
               system_extension=$(system_extension "$rom_system")

                   rom_no_brkts_temp="${rom_no_brkts%% *}"    # Only last ROM word!
                   filefind=$(find -iname "*$rom_no_brkts_temp*" -iregex "$system_extension" -type f 2>/dev/null) 

               if [[ -n $filefind ]]; then
                   # Build Array for files
                   build_find_array "$filefind"

                   # Remove ./ from filenames and add pathes to array
                   z=0
                   for i in "${array[@]}"; do
                       array[z]="$rom_path${i#.*}"
                       z=$((z+1))
                   done
               fi
           fi

           [[ -z $filefind ]] && unset array
        ;;

        5)
           # This is LEVEL 5 search - this are direct hits

           if [[ -d $ROMBASE_DIR/$rom_system ]] && [[ $ROMBASE_DIR/$rom_system == $rom_path ]]; then
               cd "$rom_path"
               filefind=$(find -name "$rom_mask_brkts" -type f 2>/dev/null)
               [[ -n $filefind ]] && array[0]="file found"
           fi

           [[ -z $filefind ]] && file_search 6
        ;;

        6)
           # This is LEVEL 6 of file search - search in BASE folders
           # This is a special search level
           # Search 6.1: filename without brackets for first try am determinated extension only
           # Search 6.2: filename with stripped down characters

           if [[ -d $ROMBASE_DIR ]]; then
               rom_base="$ROMBASE_DIR"
               cd "$rom_base"
               system_extension=$(system_extension "$rom_system")

               filefind=$(find -iname "$rom_no_brkts*" -iregex "$system_extension" -type f 2>/dev/null)

               if [[ -z $filefind ]]; then
                   rom_no_brkts_temp="${rom_no_brkts//[^[:alnum:].]/\*}"
                   for i in "${ignore_list[@]}"; do
                       rom_no_brkts_temp="${rom_no_brkts_temp//$i/\*}"
                   done

                   filefind=$(find -iname "*$rom_no_brkts_temp*" ! -iregex ".*\.\(srm\|state*\|auto*\|nv\|\hi\|jpg\|jpeg\|png\)" -type f 2>/dev/null) 

               fi

               if [[ -n $filefind ]]; then
                   # Build Array for files
                   build_find_array "$filefind"

                   # Remove ./ from filenames and add pathes to array
                   z=0
                   for i in "${array[@]}"; do
                       array[z]="$rom_base${i#.*}"
                       z=$((z+1))
                   done
               fi
               array+=("./!!!/EXTENDED SEARCH RESULT !!! - .!!!") # Force dialog!
           fi

           [[ -z $filefind ]] && unset array
        ;;

    esac
}

# ---- Dialog Functions ----

# Dialog Error
# Display dialog --msgbox with text parsed with by function call

function dialog_error() {
    dialog --title " $2 " --backtitle " $TITLE - $VERSION " --msgbox "$1" 0 0
}

# ---- Dialog Select Custom Collection ---

# This builds dialog for custom collections
# We need to create valid array (dialog_array) before
# I disabled tags, so custom collections are showen exactly as in ES

function dialog_customcollection() {

    # Create array for dialog
    local dialog_array
    local i
    for i in "${array[@]}"; do
        dialog_array+=("$i" "${i:9:-4}")
    done

    # -- Begin Dialog
    local cmd=(dialog --backtitle "$TITLE - $VERSION " \
                      --title " Select Custom Collection " \
                      --ok-label "Select " \
                      --cancel-label "Exit to ES" \
                      --no-tags --stdout \
                      --menu "There are ${#array[@]} collection files available\nPlease select one:" 16 70 16)
    local choices=$("${cmd[@]}" "${dialog_array[@]}")
    echo "$choices"
    # -- End Dialog
}

# ---- Dialog ROM selection by user ---

# This builds dialog for ROM selection
# We need to create valid array (dialog_array) before


function dialog_romselection() {

    # Create array for dialog
    local dialog_array
    local i
    local status

    local rom="${array[1]}"
    local idx="${array[0]}"
    filepos="${array[2]}"
    unset array[0]
    unset array[1]
    unset array[2]

    for i in "${array[@]}"; do
        local rom_name="$(basename "$i")"
        local rom_no_ext="${rom_name%.*}"
        local rom_ext="${rom_name##*.}"
        local rom_path="$(dirname "$i")"
        local rom_system="${rom_path##*/}"
        dialog_array+=("$i" "$rom_system - $rom_ext - $rom_name")
    done

    # -- Begin Dialog
    while true; do

    local cmd=(dialog --backtitle "$TITLE - $VERSION " \
                      --title " Select ROM file " \
                      --ok-label "Select " \
                      --cancel-label "Don't change!" \
                      --help-button \
                      --extra-button --extra-label "Exit" \
                      --no-tags --stdout \
                      --menu "For file: $rom\n\nThere are $idx ROMs available please select one:" 16 70 16)
    choices=$("${cmd[@]}" "${dialog_array[@]}")
    status=$?
    [[ $choices == "./!!!/EXTENDED SEARCH RESULT !!! - .!!!" ]] && status="!!!"

    # -- End Dialog

    case "$status" in
        1) # Don't change = Cancel Button
           break
        ;;

        2) # Help = Help Button
           dialog_error "Not implented yet - Still WIP!" " HELP! "
        ;;

        3) # Extra = Exit
           exit
        ;;

        !!!)
           # Non valid entry!
           # Do nothing
           dialog_error "This entry is not selectable!\nChoose annother valid entry!" " Error! "
        ;;

        *)  # Select
            sed -i -e "$filepos"c"$choices" "$collection_file"
            break
        ;;
    esac
    done
}

# ----------------------------------------------------------------------------------------------------
# ------------------------------------ M A I N - P R O G R A M M -------------------------------------
# ----------------------------------------------------------------------------------------------------

dialog_error "This programm will check your custom collections and changes pathes to ROM\
             \nThe purpose is clear... We can share now our custom collections, without\
             \nediting them manually. In most cases all is done by automatic.\n\
             \nThis script offers 3 ways of search levels:\
             \nSimple Search: Search in it's system and varies file names for good hits\
             \n  So you may find Tetris (JUE).gb if the collection name was Tetris.zip\
             \n  you may find mslug.zip located in system FBA if it was in ARCADE\
             \n  you not find Alex Kidd located in MEGADRIVE if it was in MASTERSYSTEM\
             \n\nAdvanced Search: Searches in base ROM folder for filenames, there will be\n
             lots of hits, so you can select wanted file manually!
             \n\nRegionChange: Is "same" as Simple Search but lefts first filesearch stage!
             \n\n>>>> Please.... give feedback - Yours cyperghost --- Version $VERSION"

# ----------------------------------------------------------------------------------------------------
# ---------------------------- Get collection files and build valid array ----------------------------
# ----------------------------------------------------------------------------------------------------

! [[ -d "$COLLECTION_DIR" ]] && dialog_error "Custom Collection path: $COLLECTION_DIR Directory not found! Set correct path!" " Error! " && exit

cd "$COLLECTION_DIR"
find_collection=$(find -name "custom-*.cfg" -type f 2>/dev/null)

# Are there any collection files available?
if [[ -z $find_collection ]]; then
    dialog_error "No Collection files found in location:\n$COLLECTION_DIR"
    exit
fi

# Dialog for Collection and results of choices
build_find_array "$find_collection"
collection_file=$("dialog_customcollection")

if [[ -z $collection_file ]]; then
    echo "Exit ... without any changes done!"; sleep 3
    exit
fi

# Backup Collections
cp "$collection_file" "$BACKUP_DIR/${CURRENT_TIME}-${collection_file:2}"
collection_file="$COLLECTION_DIR${collection_file#.*}"

# ----------------------------------------------------------------------------------------------------
# ------------------------------ Select search methods (simple/advanced) -----------------------------
# ----------------------------------------------------------------------------------------------------

dialog --title " Choose search method " \
--backtitle " $VERSION " \
--extra-button --extra-label "Exit" \
--help-button --help-label "Change Region" \
--ok-label "Simple Search" \
--cancel-label "Advanced Search" \
--yesno \
          "\nI would prefer the simple search engine!\nI recommend to do simple search first - use advanced search in 2nd try.\
          \nThe CHANGE REGION Button is only usefull for console games. Arcade games\naren't affected by this!\n\
          \nPlease consider the ADVANCED SEARCH and the REGION CHANGE option as experimental features with risk of false hits!\
          \n\nMake your decision! Are you ready?" 16 76

filesearch=$?
[[ filesearch -eq 1 ]] && filesearch=5
[[ filesearch -eq 2 ]] && filesearch=2
[[ filesearch -eq 0 ]] && filesearch=1
[[ filesearch -eq 3 ]] && exit

# ----------------------------------------------------------------------------------------------------
# ----------------------------- Process collection and compare with ROMs -----------------------------
# ----------------------------------------------------------------------------------------------------

# Okay We have our collection file, now we are processing it.
# First: we go to our ROMBASE_DIR
# Second: we remove some garbage and unset the old array
# Third: we compare our files with the collections - so hard work ;)
#
cd "$ROMBASE_DIR"
unset array

while read line; do

    # Get as much description as possible from custom collection entries
    #
    ((filepos++))
    rom_name="$(basename "$line")"       # Pure ROMs name with it's extension
    rom_mask_brkts="${rom_name//[/?}"    # This masks opening square brackets to get level 1 hit
    rom_path="$(dirname "$line")"        # This is ROMs path with system
    rom_base="$(dirname "$rom_path")"    # This represents all systemspathes
    rom_no_ext="${rom_name%.*}"          # ROM without extension
    rom_ext="${rom_name##*.}"            # The ROM extension (fallback)
    rom_no_brkts="${rom_no_ext%% [*}"    # ROMs Name without square brackets
    rom_no_brkts="${rom_no_ext%% (*}"    # ROMs Name without any brackets
    rom_system="${rom_path##*/}"         # ROMs system extracted out of path

    # Start file investigation
    # You can set level 1 to 4
    # 1-3 for simple search to 5-6 to advanced

    file_search $filesearch              # Set to 1 for simple and 4 for advanced search

    # Results:
    if [[ ${#array[@]} -eq 0 ]]; then
        record "File not found: $line" "1"
    elif [[ ${array[0]} == "file found" ]]; then
        record  "Found level 1: $line" "0"
    elif [[ ${#array[@]} -eq 1 ]]; then
         record "Found write with sed: $line -- ${array[*]}" "0"
         sed -i -e "$filepos"c"$array" "$collection_file"
    elif [[ ${#array[@]} -gt 1 ]]; then
        record "Dialog hold ${#array[@]} files: $line -- ${array[*]}" "0"
        temp_array+=("${#array[@]}")
        temp_array+=("$line")
        temp_array+=("$filepos")
        for i in "${array[@]}"; do
            temp_array+=("$i")
        done
    else
        echo "Critical error accourd!"
        echo "This might not happend!"
        exit
    fi

    unset array

done < <(tr -d '\r' < "$collection_file")

# Wow that was fun!
# My coding skills aren't as good so I might ask the user for file choice!
# Maybe everything went good and only 1 accournce of files were found
# So we can end here

[[ ${#temp_array[@]} -eq 0 ]] && echo "All done...." && exit

# But I think the chances that there are more than one accourence
# So let us do this job NOW!
# I setted number of all entries in first field
# So we read array[0] and get number of entries and build a dialog array
# array [0] presents number of entries for ex: 2 (that's a total of 5!}
# array [1] presents orignial name of custom collection
# array [2] is fileposition in custom collection (needed for sed)
# array [3] is possible rom #1
# array [4] is possible rom #2
# array [5] present number of entries of next dialog ;)
#

z=-3
idx="${temp_array[0]}"

for i in "${temp_array[@]}"; do

    record "$z -- $idx: $i" "-1"

    if [[ $z -lt $idx ]]; then
        array+=("$i")
    else
        dialog_romselection
        unset array
        array+=("$i")
        idx="$i"
        z=-3
    fi

    ((z++))

done

dialog_romselection #To catch last entry!
}

function fix_local_cs() {
readonly VERSION="1.10_060918"
readonly TITLE="Pathfinder 4 Custom Collections"
readonly ROMBASE_DIR="/home/pi/RetroPie/combined_drives"
readonly COLLECTION_DIR="/opt/retropie/configs/all/emulationstation/collections"
readonly ignore_list=("the" "The" "and" "is" "III" "II" "I")

# Possible Backups
#readonly BACKUP_DIR="$(cd "$(dirname "$0")" && pwd)/collection_backup"
readonly BACKUP_DIR="/opt/retropie/configs/all/emulationstation/collection_backup"
readonly CURRENT_TIME="$(date +%s)"
[[ -d $BACKUP_DIR ]] || mkdir -p "$BACKUP_DIR"

# ---- Function Calls ----

# LOG every action
# instead of echo "Something of this" we call the record
# All actions will be performed to the backup directory with timestamp

function record() {
    local message="$1"   # This stores message
    local show_msg="$2"  # This enables/disables textouput and log caps
                         # 0 disables stdout output and enables log
                         # 1 enables stdout output and enables log
                         # 2 enables stdout output only
                         # -1 left empty nothing happens

    [[ $show_msg -lt 0 ]] && return
    local backup="$BACKUP_DIR/${CURRENT_TIME}-filefinder.log"

    [[ $show_msg -lt 2 ]] && echo "$1" >> "$backup"
    [[ $show_msg -gt 0 ]] && echo "$1"
}

# get extension for specfic system
# if system isn't available then file extension is ignored
# we got all files from base rom without

function system_extension () {

    case "$1" in

        amstradcpc) echo ".*\.\(cdt\|cpc\|dsk\)" ;;
        arcade) echo ".*\.\(fba\|zip\)" ;;
        atari2600) echo ".*\.\(7z\|a26\|bin\|rom\|zip\|gz\)" ;;
        atari7800) echo ".*\.\(7z\|a78\|bin\|zip\)" ;;
        atarilynx) echo ".*\.\(7z\|lnx\|zip\)" ;;
        cps1) echo ".*\.\(fba\|zip\)" ;;
        cps2) echo ".*\.\(fba\|zip\)" ;;
        fba) echo ".*\.\(fba\|zip\)" ;;
        fds) echo ".*\.\(nes\|fds\|zip\)" ;;
        gameandwatch) echo ".*\.\(mgw\)" ;;
        gamegear) echo ".*\.\(7z\|gg\|bin\|sms\|zip\)" ;;
        gb) echo ".*\.\(7z\|gb\|zip\)" ;;
        gba) echo ".*\.\(7z\|gba\|zip\)" ;;
        gbc) echo ".*\.\(7z\|gbc\|zip\)" ;;
        mame-libretro) echo ".*\.\(zip\)" ;;
        mame-mame4all) echo ".*\.\(zip\)" ;;
        mastersystem) echo ".*\.\(7z\|sms\|bin\|zip\)" ;;
        megadrive) echo ".*\.\(7z\|smd\|bin\|gen\|md\|sg\|zip\)" ;;
        msx) echo ".*\.\(rom\|mx1\|mx2\|col\|dsk\|zip\)" ;;
        n64) echo ".*\.\(z64\|n64\|v64\)" ;;
        neogeo) echo ".*\.\(fba\|zip\)" ;;
        nes) echo ".*\.\(7z\|nes\|zip\)" ;;
        ngp) echo ".*\.\(ngp\|zip\)" ;;
        ngpc) echo ".*\.\(ngc\|zip\)" ;;
        pcengine) echo ".*\.\(7z\|pce\|ccd\|cue\|zip\)" ;;
        ports) echo ".*\.\(sh\)" ;;
        psp) echo ".*\.\(iso\|pbp\|cso\)" ;;
        psx) echo ".*\.\(cue\|cbn\|img\|iso\|m3u\|mdf\|pbp\|toc\|z\|znx\)" ;;
        sega32x) echo ".*\.\(7z\|32x\|smd\|bin\|md\|zip\)" ;;
        segacd) echo ".*\.\(iso\|cue\)" ;;
        sg-1000) echo ".*\.\(sg\|bin\|zip\)" ;;
        snes) echo ".*\.\(7z\|bin\|smc\|sfc\|fig\|swc\|mgd\|zip\)" ;;
        vectrex) echo ".*\.\(7z\|vec\|gam\|bin\|zip\)" ;;
        zxspectrum) echo ".*\.\(7z\|sh\|sna\|szx\|z80\|tap\|tzx\|gz\|udi\|mgt\|img\|trd\|scl\|dsk\|zip\|rzx\)" ;;

    esac
}

# Rebuild Filenames, if $i starts with "./" an new filename is found
# Array postion 1 is always empty, we can use that later

function build_find_array() {

    local i;local ii
    local filefind="$1"

    for i in $filefind; do
        if [[ ${i:0:2} == "./" ]]; then
            array+=("$ii")
            ii=
            ii="$i"
         else
            ii="$ii $i"
         fi
    done
    array[0]="$ii" #Catch last entry and put it in first row

}

# File Search Function with different levels
# Wie return, number of filesfound and array
# level 1=simple 1:1 find (autmatic)
# level 2.1=intermediate: /path/system/rom*.{systemext}
# level 2.2=super intermediate: /path/system/*rom*.{systemext}
# level 3.1=arcade: /path/rom.{systemext}
# level 3.2=arcade: /path/rom*.{systemext}
# level 4=slight advanced: /path/system/rom_first_word*.{systemext}
# level 5 == like level 1 simple 1:1 find (autmatic)
# experimental level 6.1=advanced: /path/rom*.{systemext}
# experimental level 6.2=lastresort: /path/*rom*

function file_search() {

    local level="$1"
    local filefind

    case $level in

        1)
           # This is LEVEL 1 search - this are direct hits

           if [[ -d $ROMBASE_DIR/$rom_system ]] && [[ $ROMBASE_DIR/$rom_system == $rom_path ]]; then
               cd "$rom_path"
               filefind=$(find -name "$rom_mask_brkts" -type f 2>/dev/null)
               [[ -n $filefind ]] && array[0]="file found"
           fi

           [[ -z $filefind ]] && file_search 2
        ;;

        2)
           # This is LEVEL 2 search - search per system!
           # Search 2.1: Brackets removed, all file extension for system available are considered
           # Search 2.2: All special character will be removed and resolved as *
           #             Word like "The" "of" and some roman numbers will be stripped *
           #             Like in 2.1 all file extensions for system will be considered      

           if [[ -d $ROMBASE_DIR/$rom_system ]]; then
               rom_path="$ROMBASE_DIR/$rom_system"
               cd "$rom_path"
               system_extension=$(system_extension "$rom_system")

               filefind=$(find -iname "$rom_no_brkts*" -iregex "$system_extension" -type f 2>/dev/null)

               if [[ -z $filefind ]]; then
                   rom_no_brkts_temp="${rom_no_brkts//[^[:alnum:].]/\*}"
                   for i in "${ignore_list[@]}"; do
                       rom_no_brkts_temp="${rom_no_brkts_temp//$i/\*}"
                   done

                   filefind=$(find -iname "*$rom_no_brkts_temp*" -iregex "$system_extension" -type f 2>/dev/null) 

               fi

               if [[ -n $filefind ]]; then
                   # Build Array for files
                   build_find_array "$filefind"

                   # Remove ./ from filenames and add pathes to array
                   z=0
                   for i in "${array[@]}"; do
                       array[z]="$rom_path${i#.*}"
                       z=$((z+1))
                   done
               fi
           fi

           [[ -z $filefind ]] && file_search 3
        ;;

        3)
           # This is LEVEL 3 of file search - search in BASE folders
           # It's a suitable case for arcades for example
           # Search 3.1: Just exact filename (good for arcades)
           # Search 3.2: Just filename* to catch subroms, all extension for system available

           if [[ -d $ROMBASE_DIR ]]; then
               rom_base="$ROMBASE_DIR"
               cd "$rom_base"
               filefind=$(find -name "$rom_name" -type f 2>/dev/null)

               if [[ -z $filefind ]]; then
                   system_extension=$(system_extension "$rom_system")
                   [[ -z $system_extension ]] && return
                   filefind=$(find -iname "$rom_no_ext*" -iregex "$system_extension" -type f 2>/dev/null)
               fi

               if [[ -n $filefind ]]; then
                   # Build Array for files
                   build_find_array "$filefind"

                   # Remove ./ from filenames and add pathes to array
                   z=0
                   for i in "${array[@]}"; do
                       array[z]="$rom_base${i#.*}"
                       z=$((z+1))
                   done
               fi
             fi

           [[ -z $filefind ]] && file_search 4
       ;;

        4)
           # This level 4 search - First word of ROMName is used
           # This will generate massive hits in some cases (Super Mario...)
           # Therefore I just search in system folder for this!

           if [[ -d $ROMBASE_DIR/$rom_system ]]; then
               rom_path="$ROMBASE_DIR/$rom_system"
               cd "$rom_path"
               system_extension=$(system_extension "$rom_system")

                   rom_no_brkts_temp="${rom_no_brkts%% *}"    # Only last ROM word!
                   filefind=$(find -iname "*$rom_no_brkts_temp*" -iregex "$system_extension" -type f 2>/dev/null) 

               if [[ -n $filefind ]]; then
                   # Build Array for files
                   build_find_array "$filefind"

                   # Remove ./ from filenames and add pathes to array
                   z=0
                   for i in "${array[@]}"; do
                       array[z]="$rom_path${i#.*}"
                       z=$((z+1))
                   done
               fi
           fi

           [[ -z $filefind ]] && unset array
        ;;

        5)
           # This is LEVEL 5 search - this are direct hits

           if [[ -d $ROMBASE_DIR/$rom_system ]] && [[ $ROMBASE_DIR/$rom_system == $rom_path ]]; then
               cd "$rom_path"
               filefind=$(find -name "$rom_mask_brkts" -type f 2>/dev/null)
               [[ -n $filefind ]] && array[0]="file found"
           fi

           [[ -z $filefind ]] && file_search 6
        ;;

        6)
           # This is LEVEL 6 of file search - search in BASE folders
           # This is a special search level
           # Search 6.1: filename without brackets for first try am determinated extension only
           # Search 6.2: filename with stripped down characters

           if [[ -d $ROMBASE_DIR ]]; then
               rom_base="$ROMBASE_DIR"
               cd "$rom_base"
               system_extension=$(system_extension "$rom_system")

               filefind=$(find -iname "$rom_no_brkts*" -iregex "$system_extension" -type f 2>/dev/null)

               if [[ -z $filefind ]]; then
                   rom_no_brkts_temp="${rom_no_brkts//[^[:alnum:].]/\*}"
                   for i in "${ignore_list[@]}"; do
                       rom_no_brkts_temp="${rom_no_brkts_temp//$i/\*}"
                   done

                   filefind=$(find -iname "*$rom_no_brkts_temp*" ! -iregex ".*\.\(srm\|state*\|auto*\|nv\|\hi\|jpg\|jpeg\|png\)" -type f 2>/dev/null) 

               fi

               if [[ -n $filefind ]]; then
                   # Build Array for files
                   build_find_array "$filefind"

                   # Remove ./ from filenames and add pathes to array
                   z=0
                   for i in "${array[@]}"; do
                       array[z]="$rom_base${i#.*}"
                       z=$((z+1))
                   done
               fi
               array+=("./!!!/EXTENDED SEARCH RESULT !!! - .!!!") # Force dialog!
           fi

           [[ -z $filefind ]] && unset array
        ;;

    esac
}

# ---- Dialog Functions ----

# Dialog Error
# Display dialog --msgbox with text parsed with by function call

function dialog_error() {
    dialog --title " $2 " --backtitle " $TITLE - $VERSION " --msgbox "$1" 0 0
}

# ---- Dialog Select Custom Collection ---

# This builds dialog for custom collections
# We need to create valid array (dialog_array) before
# I disabled tags, so custom collections are showen exactly as in ES

function dialog_customcollection() {

    # Create array for dialog
    local dialog_array
    local i
    for i in "${array[@]}"; do
        dialog_array+=("$i" "${i:9:-4}")
    done

    # -- Begin Dialog
    local cmd=(dialog --backtitle "$TITLE - $VERSION " \
                      --title " Select Custom Collection " \
                      --ok-label "Select " \
                      --cancel-label "Exit to ES" \
                      --no-tags --stdout \
                      --menu "There are ${#array[@]} collection files available\nPlease select one:" 16 70 16)
    local choices=$("${cmd[@]}" "${dialog_array[@]}")
    echo "$choices"
    # -- End Dialog
}

# ---- Dialog ROM selection by user ---

# This builds dialog for ROM selection
# We need to create valid array (dialog_array) before


function dialog_romselection() {

    # Create array for dialog
    local dialog_array
    local i
    local status

    local rom="${array[1]}"
    local idx="${array[0]}"
    filepos="${array[2]}"
    unset array[0]
    unset array[1]
    unset array[2]

    for i in "${array[@]}"; do
        local rom_name="$(basename "$i")"
        local rom_no_ext="${rom_name%.*}"
        local rom_ext="${rom_name##*.}"
        local rom_path="$(dirname "$i")"
        local rom_system="${rom_path##*/}"
        dialog_array+=("$i" "$rom_system - $rom_ext - $rom_name")
    done

    # -- Begin Dialog
    while true; do

    local cmd=(dialog --backtitle "$TITLE - $VERSION " \
                      --title " Select ROM file " \
                      --ok-label "Select " \
                      --cancel-label "Don't change!" \
                      --help-button \
                      --extra-button --extra-label "Exit" \
                      --no-tags --stdout \
                      --menu "For file: $rom\n\nThere are $idx ROMs available please select one:" 16 70 16)
    choices=$("${cmd[@]}" "${dialog_array[@]}")
    status=$?
    [[ $choices == "./!!!/EXTENDED SEARCH RESULT !!! - .!!!" ]] && status="!!!"

    # -- End Dialog

    case "$status" in
        1) # Don't change = Cancel Button
           break
        ;;

        2) # Help = Help Button
           dialog_error "Not implented yet - Still WIP!" " HELP! "
        ;;

        3) # Extra = Exit
           exit
        ;;

        !!!)
           # Non valid entry!
           # Do nothing
           dialog_error "This entry is not selectable!\nChoose annother valid entry!" " Error! "
        ;;

        *)  # Select
            sed -i -e "$filepos"c"$choices" "$collection_file"
            break
        ;;
    esac
    done
}

# ----------------------------------------------------------------------------------------------------
# ------------------------------------ M A I N - P R O G R A M M -------------------------------------
# ----------------------------------------------------------------------------------------------------

dialog_error "This programm will check your custom collections and changes pathes to ROM\
             \nThe purpose is clear... We can share now our custom collections, without\
             \nediting them manually. In most cases all is done by automatic.\n\
             \nThis script offers 3 ways of search levels:\
             \nSimple Search: Search in it's system and varies file names for good hits\
             \n  So you may find Tetris (JUE).gb if the collection name was Tetris.zip\
             \n  you may find mslug.zip located in system FBA if it was in ARCADE\
             \n  you not find Alex Kidd located in MEGADRIVE if it was in MASTERSYSTEM\
             \n\nAdvanced Search: Searches in base ROM folder for filenames, there will be\n
             lots of hits, so you can select wanted file manually!
             \n\nRegionChange: Is "same" as Simple Search but lefts first filesearch stage!
             \n\n>>>> Please.... give feedback - Yours cyperghost --- Version $VERSION"

# ----------------------------------------------------------------------------------------------------
# ---------------------------- Get collection files and build valid array ----------------------------
# ----------------------------------------------------------------------------------------------------

! [[ -d "$COLLECTION_DIR" ]] && dialog_error "Custom Collection path: $COLLECTION_DIR Directory not found! Set correct path!" " Error! " && exit

cd "$COLLECTION_DIR"
find_collection=$(find -name "custom-*.cfg" -type f 2>/dev/null)

# Are there any collection files available?
if [[ -z $find_collection ]]; then
    dialog_error "No Collection files found in location:\n$COLLECTION_DIR"
    exit
fi

# Dialog for Collection and results of choices
build_find_array "$find_collection"
collection_file=$("dialog_customcollection")

if [[ -z $collection_file ]]; then
    echo "Exit ... without any changes done!"; sleep 3
    exit
fi

# Backup Collections
cp "$collection_file" "$BACKUP_DIR/${CURRENT_TIME}-${collection_file:2}"
collection_file="$COLLECTION_DIR${collection_file#.*}"

# ----------------------------------------------------------------------------------------------------
# ------------------------------ Select search methods (simple/advanced) -----------------------------
# ----------------------------------------------------------------------------------------------------

dialog --title " Choose search method " \
--backtitle " $VERSION " \
--extra-button --extra-label "Exit" \
--help-button --help-label "Change Region" \
--ok-label "Simple Search" \
--cancel-label "Advanced Search" \
--yesno \
          "\nI would prefer the simple search engine!\nI recommend to do simple search first - use advanced search in 2nd try.\
          \nThe CHANGE REGION Button is only usefull for console games. Arcade games\naren't affected by this!\n\
          \nPlease consider the ADVANCED SEARCH and the REGION CHANGE option as experimental features with risk of false hits!\
          \n\nMake your decision! Are you ready?" 16 76

filesearch=$?
[[ filesearch -eq 1 ]] && filesearch=5
[[ filesearch -eq 2 ]] && filesearch=2
[[ filesearch -eq 0 ]] && filesearch=1
[[ filesearch -eq 3 ]] && exit

# ----------------------------------------------------------------------------------------------------
# ----------------------------- Process collection and compare with ROMs -----------------------------
# ----------------------------------------------------------------------------------------------------

# Okay We have our collection file, now we are processing it.
# First: we go to our ROMBASE_DIR
# Second: we remove some garbage and unset the old array
# Third: we compare our files with the collections - so hard work ;)
#
cd "$ROMBASE_DIR"
unset array

while read line; do

    # Get as much description as possible from custom collection entries
    #
    ((filepos++))
    rom_name="$(basename "$line")"       # Pure ROMs name with it's extension
    rom_mask_brkts="${rom_name//[/?}"    # This masks opening square brackets to get level 1 hit
    rom_path="$(dirname "$line")"        # This is ROMs path with system
    rom_base="$(dirname "$rom_path")"    # This represents all systemspathes
    rom_no_ext="${rom_name%.*}"          # ROM without extension
    rom_ext="${rom_name##*.}"            # The ROM extension (fallback)
    rom_no_brkts="${rom_no_ext%% [*}"    # ROMs Name without square brackets
    rom_no_brkts="${rom_no_ext%% (*}"    # ROMs Name without any brackets
    rom_system="${rom_path##*/}"         # ROMs system extracted out of path

    # Start file investigation
    # You can set level 1 to 4
    # 1-3 for simple search to 5-6 to advanced

    file_search $filesearch              # Set to 1 for simple and 4 for advanced search

    # Results:
    if [[ ${#array[@]} -eq 0 ]]; then
        record "File not found: $line" "1"
    elif [[ ${array[0]} == "file found" ]]; then
        record  "Found level 1: $line" "0"
    elif [[ ${#array[@]} -eq 1 ]]; then
         record "Found write with sed: $line -- ${array[*]}" "0"
         sed -i -e "$filepos"c"$array" "$collection_file"
    elif [[ ${#array[@]} -gt 1 ]]; then
        record "Dialog hold ${#array[@]} files: $line -- ${array[*]}" "0"
        temp_array+=("${#array[@]}")
        temp_array+=("$line")
        temp_array+=("$filepos")
        for i in "${array[@]}"; do
            temp_array+=("$i")
        done
    else
        echo "Critical error accourd!"
        echo "This might not happend!"
        exit
    fi

    unset array

done < <(tr -d '\r' < "$collection_file")

# Wow that was fun!
# My coding skills aren't as good so I might ask the user for file choice!
# Maybe everything went good and only 1 accournce of files were found
# So we can end here

[[ ${#temp_array[@]} -eq 0 ]] && echo "All done...." && exit

# But I think the chances that there are more than one accourence
# So let us do this job NOW!
# I setted number of all entries in first field
# So we read array[0] and get number of entries and build a dialog array
# array [0] presents number of entries for ex: 2 (that's a total of 5!}
# array [1] presents orignial name of custom collection
# array [2] is fileposition in custom collection (needed for sed)
# array [3] is possible rom #1
# array [4] is possible rom #2
# array [5] present number of entries of next dialog ;)
#

z=-3
idx="${temp_array[0]}"

for i in "${temp_array[@]}"; do

    record "$z -- $idx: $i" "-1"

    if [[ $z -lt $idx ]]; then
        array+=("$i")
    else
        dialog_romselection
        unset array
        array+=("$i")
        idx="$i"
        z=-3
    fi

    ((z++))

done

dialog_romselection #To catch last entry!
}

main_menu
