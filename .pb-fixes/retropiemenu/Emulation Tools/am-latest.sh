#!/bin/bash
# Update Attract Mode Plus Script By 2Play! 
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 05.05.2026
BACKTITLE="PLAYBOX PROJECT"

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " ATTRACT MODE UPDATE " \
            --ok-label OK --cancel-label Exit \
            --menu "Let's Check and Update The Attract Mode Plus! " 25 75 20 \
            - "*** ATTRACT MODE SELECTIONS ***" \
            ""      "" \
			1 " - Update Attract Mode Plus (DRM/KMS)" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) AMP_KMS  ;;
            -) none  ;;
            *) break ;;
        esac
    done
}


function AMP_KMS() {
	cd ~/code/
	clear
	set -e

	# Detect OS release
	OS=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
	VER=$(lsb_release -rs)

	echo "Detected OS: $OS $VER"

	# Get latest release assets list from GitHub
	LATEST_URL="https://api.github.com/repos/oomek/attractplus/releases/latest"
	ASSETS=$(curl -s $LATEST_URL | grep "browser_download_url" | cut -d '"' -f 4)

	# Try to find matching KMS asset for your OS version
	MATCH=$(echo "$ASSETS" | grep -i "${OS}-${VER}" | grep -i "KMS" | grep -E '\.deb$|\.zip$' || true)

	if [ -z "$MATCH" ]; then
		echo "No exact KMS match for $OS $VER, trying generic KMS assets..."
		MATCH=$(echo "$ASSETS" | grep -i "KMS" | grep -E '\.deb$|\.zip$' | head -n1)
	fi

	echo "Selected asset: $MATCH"

	# Download
	FILE=$(basename "$MATCH")
	curl -L "$MATCH" -o "$FILE"

	# Install depending on type
	if [[ "$FILE" == *.deb ]]; then
		echo "Installing .deb package..."
		sudo dpkg -i "$FILE" || sudo apt -f install -y
		echo "Update Completed..."
		pausepress

	elif [[ "$FILE" == *.zip ]]; then
		echo "Unzipping archive..."
		mkdir -p attractplus-latest
		unzip -o "$FILE" -d attractplus-latest
		cd attractplus-latest

		# Find the deb inside the zip
		INNER_DEB=$(find . -name "*.deb" | head -n1)
		if [ -n "$INNER_DEB" ]; then
			echo "Installing extracted deb: $INNER_DEB"
			sudo dpkg -i "$INNER_DEB" || sudo apt -f install -y
			echo "Update Completed..."
			pausepress
		else
			echo "No .deb file found inside the zip!"
			exit 1
		fi
	else
		echo "Unknown file type: $FILE"
		exit 1
	fi
}

function pausepress() {
    echo
    read -n 1 -s -r -p "Press any key to continue..."
    echo
}

main_menu
