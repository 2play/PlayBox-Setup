#!/bin/bash
# gamelist-cleaner.sh
#####################
# Cleans gamelist.xml files by removing <game> entries whose <path> points
# to non-existent ROMs. Creates a .CLEAN file or replaces the original if
# requested. Includes stats on how many entries were removed.
# Run the script with '--help' to get more info.
# 
# meleu - 2017/Jun
# kaltinril - 2017-08-19 - Added -r option to replace the existing gameslist
# Updated Script by 2Play! For PlayBox v2 04.05.2026	

# Global Variables
REPLACE_GAMELIST=false
DO_ALL=false
LISTS_DIR="$HOME/RetroPie/roms"
ROMS_DIR="$HOME/RetroPie/roms"
ELIMINATE_BACKUPS=false

# Read only Variables
readonly SCRIPT_DIR="$(dirname "$0")"
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_FULL="$SCRIPT_DIR/$SCRIPT_NAME"

readonly USAGE="Usage:
$0 [OPTIONS] [gamelist.xml]...
"

readonly EXAMPLE="Example:
$0 $HOME/RetroPie/roms/amiga/gamelist.xml
"

readonly HELP="
This script gets a gamelist.xml as input and checks if the path for the games
leads to an existing file. If the file doesn't exist, the <game> entry will
be deleted and a cleaner gamelist.xml file will be generated.

The resulting file will be named \"gamelist.xml.CLEAN\" and will be in the
same folder as the original file. Nothing changes in the original gamelist.xml.

Options:
-h|--help           Show this message and exit
-r|--replace        Replace gamelist.xml (backup created)
-a|--all            Clean all gamelists under \$LISTS_DIR
-l|--list <DIR>     Set lists directory
-d|--directory <DIR>Set ROMs directory
-e|--eliminate      Remove backup files
"

# --- Safety checks ---
command -v xmlstarlet >/dev/null || { echo "ERROR: xmlstarlet is required"; exit 1; }

# --- Functions ---
function eliminate_backup_files() {
    shopt -s nullglob
    local backups=("$LISTS_DIR"/*/gamelist.xml-orig*)
    for file in "${backups[@]}"; do
        echo "Removing: $file"
        rm -f "$file"
    done
}

# --- Argument parsing ---
while [[ -n "$1" ]]; do
    case "$1" in
        -h|--help) echo "$HELP"; exit 0 ;;
        -r|--replace) REPLACE_GAMELIST=true; shift ;;
        -a|--all) DO_ALL=true; shift ;;
        -l|--list) shift; LISTS_DIR="$1"; shift ;;
        -d|--directory) shift; ROMS_DIR="$1"; shift ;;
        -e|--eliminate) ELIMINATE_BACKUPS=true; shift ;;
        *) break ;;
    esac
done

# --- File list ---
if [ "$DO_ALL" = true ]; then
    gamelist_files=$(ls "$LISTS_DIR"/*/gamelist.xml 2>/dev/null)
else
    gamelist_files="$@"
fi

if [ -z "$gamelist_files" ]; then
    echo "ERROR: No gamelist.xml files specified or found."
    exit 1
fi

# --- Processing loop ---
for file in $gamelist_files; do
    original_gamelist="$(readlink -e "$file")"
    [[ -z "$original_gamelist" ]] && original_gamelist="$file"
    clean_gamelist="${original_gamelist}.CLEAN"
    gamelist_dir="$(dirname "$original_gamelist")"
    backup_gamelist="${original_gamelist}-orig-$(date +%s)"

    if [[ ! -s "$original_gamelist" ]]; then
        echo "\"$original_gamelist\": file not found or empty. Skipping..."
        continue
    fi

    system="$(basename "$gamelist_dir")"
    if [[ ! -d "$ROMS_DIR/$system" ]]; then
        echo "WARNING: \"$ROMS_DIR/$system\" not found. Skipping \"$original_gamelist\"..."
        continue
    fi

    echo "Working on: $original_gamelist"

    if [ "$REPLACE_GAMELIST" = true ]; then
        cp "$original_gamelist" "$backup_gamelist"
        clean_gamelist="$original_gamelist"
        original_gamelist="$backup_gamelist"
    else
        cp "$original_gamelist" "$clean_gamelist"
    fi

    # Count before
    total_before=$(xmlstarlet sel -t -v "count(/gameList/game)" "$original_gamelist")

    removed=0
    while read -r path; do
        full_path="$path"
        [[ "$path" == ./* ]] && full_path="$ROMS_DIR/$system/$path"
        full_path="$(echo "$full_path" | sed 's/&amp;/\&/g')"
        if [[ ! -f "$full_path" ]]; then
            xmlstarlet ed -L -d "/gameList/game[path=\"$path\"]" "$clean_gamelist"
            ((removed++))
        fi
    done < <(xmlstarlet sel -t -v "/gameList/game/path" "$original_gamelist"; echo)

    total_after=$(xmlstarlet sel -t -v "count(/gameList/game)" "$clean_gamelist")

    echo "Stats for $system:"
    echo "  Entries before: $total_before"
    echo "  Entries after : $total_after"
    echo "  Removed       : $removed"
    echo -e "[OK \033[32mDONE\033[0m!] Cleaned $file"
    echo
done

if [ "$ELIMINATE_BACKUPS" = true ]; then
    echo "Removing backups..."
    eliminate_backup_files
fi
