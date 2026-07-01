# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
clear
pb_version="PlayBox v2 Post Updates & Fixes: Dated 01.07.2026"
echo $pb_version
sleep 2
cd $HOME/code/

# Get Post Fixes Clean Burn Or Normal Post Fix Update
function post_fix_update() {
    local choice
	
	while true; do
		choice=$(dialog --backtitle "PLAYBOX PROJECT" --title " POST FIXES SETUP OPTIONS " \
            --ok-label OK --cancel-label Exit \
			--menu "Choose Clean or Normal Update!" 25 75 20 \
            ""      "" \
			CLEAN " - CLEAN IMAGE: UPDATE & FIXES " \
			""      "	(Apply After A Clean Burn)" \
			""      "	(... OR To Restore All To Latest Clean State)" \
			""      "" \
			NORMAL " - NORMAL UPDATE: POST RELEASE UPDATES & FIXES " \
            ""      "	(Applies Post Release Updates) " \
			""      "" \
			2>&1 > /dev/tty)

		case "$choice" in
			CLEAN)   post_up CLEAN "clean-vanilla-x86"   ;;
			NORMAL)  post_up NORMAL "main-vanilla-x86"   ;;
			-)       none ;;
			*)       break ;;
        esac
	done
}

function post_up() {
    mode=$1   # CLEAN or NORMAL
    branch=$2 # branch name

    clear
    echo "Cloning branch: $branch"
	
	# Remove old repo if present
    rm -rf PBv2-PostFixes
	
	# Verify branch exists before cloning
    if ! git ls-remote --exit-code https://github.com/2play/PBv2-PostFixes.git "$branch"; then
        echo "Branch $branch not found on remote!"
        return 1
    fi

    # Clone fresh
    if ! git clone --depth 1 --branch="$branch" https://github.com/2play/PBv2-PostFixes.git; then
        echo "Clone failed"
        return 1
    fi

    cd PBv2-PostFixes/ || { echo "Could not enter PBv2-PostFixes directory"; return 1; }


    if [[ "$mode" == "CLEAN" ]]; then
        next_steps
        global_shader
    elif [[ "$mode" == "NORMAL" ]]; then
        next_steps_pr
        global_shader
    else
        echo "Unknown mode: $mode"
        return 1
    fi
	if [[ "$mode" == "CLEAN" ]]; then
			echo -e "[PostFixes applied in \033[1;32m$mode\033[0m mode]"
		elif [[ "$mode" == "NORMAL" ]]; then
			echo -e "[PostFixes applied in \033[1;34m$mode\033[0m mode]"
		else
			echo "[PostFixes applied in $mode mode]"
		fi
	echo
	read -n 1 -s -r -p "Press any key to continue..."
}


function next_steps() {
clear

#Sync New Files
rsync -urv --exclude '.git' --exclude 'boot' --exclude 'etc' --exclude 'var' --exclude 'usr' --exclude 'libretrocores' --exclude 'emulators' --exclude 'supplementary' --exclude 'LICENSE' --exclude 'README.md' --exclude 'roms' . /
sudo rsync -urv boot/ /boot/
sudo rsync -urv etc/ /etc/
#sudo ln -sfn /etc/emulationstation/es_systems.cfgFULL /etc/emulationstation/es_systems.cfg
current="/etc/emulationstation/es_systems.cfg"
full="/etc/emulationstation/es_systems.cfgFULL"

if ! cmp -s "$current" "$full"; then
    sudo ln -sfn "$full" "$current"
fi
sudo rsync -urv var/ /var/
sudo rsync -urv usr/ /usr/
sudo rsync -urv opt/retropie/libretrocores/ /opt/retropie/libretrocores/
sudo rsync -urv opt/retropie/emulators/ /opt/retropie/emulators/
if [ ! -d /opt/retropie/supplementary/emulationstation-dev ]; then
sudo rsync -urv opt/retropie/supplementary/ /opt/retropie/supplementary/
fi

rm -rf ~/code/PBv2-PostFixes/ ~/PBv2-PostFixes/


#APPS & SYSTEM SECTION
#------------

#Permissions
sudo chown pi:pi -R /etc/emulationstation/themes/
sudo chmod 644 /etc/mopidy/mopidy.conf
sudo chmod 755 ~/scripts/themerandom.sh
sudo chmod 755 /usr/local/bin/*grab

cd ~
# Remove only the ~/samba folder if it exists
[ -d samba ] && sudo rm -rf samba

# Remove only specific smb* files in home, not everything
for f in smb.conf smb.conf.bak smb.log smb.tmp; do
    [ -f "$f" ] && sudo rm -f "$f"
done

#Make extra custom PlayBox roms directories (Update/Add as needed)
cd "$HOME/RetroPie/roms" || exit 1
for dir in ags amiga1200 amiga4000 amigacd32 amstradcpc464 amstradcpc6128+ amstradcpc664 apple2 apple2gs apple2gs arcadia archimedes astrocade atari800 atarijaguar atarist ataritt atarixegs atomiswave bbcmicro c128 c16  cdtv  cdimono1 cdtv coleco coleco_adam crvision desktop dreamcast electron famicom gameandwatch gamemaker gc genesish gx4000 intellivision_ecs fba fds kodi lightgun mame mame-advmame mame-libretro markiii mastersystem mega32x megacd megadrive megadriveh megadrive-japan megadriveplus mess msx2 msx2+ msxturbor music n64 naomi nds neogeo neogeocd nes nesh odyssey2 openbor pc128 pc88 pc98 pcengine pcenginecd pcfx pico8 piegalaxy playbox plus4 power ps2 psp pspminis satellaview saturn-japan sega32x segacd sc-3000 scv sg-1000 sgb sgfx sfc sinclairql snes snesh snesmsu1 solarus spinner steam stv sufami swancrystal tg16 tg16cd tic80 trs-80 trackball vic20 videopac wii wiiu zx81 zxspectrum+2 zxspectrum+3 zxspectrum128; do
    mkdir -p "$dir"
    echo "Created directory: $dir"
done

# RetroArch PlayBox v2 Defaults:
cd /opt/retropie/configs/all/

declare -A ra_defaults=(
  # RA Defaults
  ["aspect_ratio_index"]="22"
  ["materialui_menu_color_theme"]="19"
  ["menu_driver"]="ozone"
  ["menu_linear_filter"]="false"
  ["menu_rgui_shadows"]="true"
  ["menu_show_overlays"]="false"
  ["menu_show_load_content_animation"]="false"
  ["menu_show_restart_retroarch"]="false"
  ["menu_swap_scroll_buttons"]="false"
  ["menu_disable_search_button"]="true"
  ["input_desktop_menu_toggle"]="nul"
  ["quick_menu_show_close_content"]="false"
  ["quick_menu_show_add_to_favorites"]="false"
  ["quick_menu_show_replay"]="false"
  ["quick_menu_show_start_recording"]="false"
  ["quick_menu_show_start_streaming"]="false"
  ["ozone_menu_color_theme"]="3"
  ["rgui_menu_color_theme"]="29"
  ["rgui_aspect_ratio_lock"]="2"
  ["rgui_switch_icons"]="false"
  ["xmb_menu_color_theme"]="7"
  ["xmb_show_add"]="false"
  ["xmb_show_history"]="false"
  ["xmb_show_images"]="false"
  ["xmb_show_music"]="false"
  ["xmb_shadows_enable"]="false"
  ["video_fullscreen"]="true"
  ["video_aspect_ratio_auto"]="true"
  ["video_shader_enable"]="true"
  ["video_font_size"]="24"
  ["screenshot_directory"]="~/ScreenShots"
  ["core_options_path"]=""
  ["video_threaded"]="false"
  ["config_save_on_exit"]="false"
  ["show_hidden_files"]="true"
  ["input_joypad_driver"]="udev"
  ["input_overlay_enable"]="true"
  ["input_overlay_show_mouse_cursor"]="false"
  ["input_autodetect_enable"]="true"
  ["system_directory"]="/home/pi/RetroPie/BIOS"
  ["rgui_browser_directory"]="/home/pi/RetroPie/roms"
  ["rgui_particle_effect"]="5"
  ["libretro_directory"]="/opt/retropie/libretrocores/"
  ["savefile_directory"]="/home/pi/RetroPie/saves"
  ["savestate_directory"]="/home/pi/RetroPie/states"
  ["global_core_options"]="true"
  ["auto_remaps_enable"]="true"
  ["remap_save_on_exit"]="false"
  ["core_info_cache_enable"]="false"
  ["quit_press_twice"]="true"
  ["sort_savestates_enable"]="false"
  ["sort_savefiles_enable"]="false"
  ["core_updater_buildbot_cores_url"]="http://buildbot.libretro.com/nightly/linux/x86_64/latest/"
  ["core_updater_buildbot_url"]="http://buildbot.libretro.com/nightly/linux/x86_64/latest/"
)

# Apply RA defaults
for cfg in retroarch.cfg retroarch/retroarch.cfg; do
  for key in "${!ra_defaults[@]}"; do
    value="${ra_defaults[$key]}"
    if grep -q "^$key" "$cfg"; then
      sed -i "s|\($key = \)\"[^\"]*\"|\1\"$value\"|g" "$cfg"
    elif grep -q "^# *$key" "$cfg"; then
      sed -i "/^# *$key/a$key = \"$value\"" "$cfg"
    fi
  done
done

#for key in "${!fixes[@]}"; do
#    grep "$key" es_settings.cfg
#done

# ES Video ScreenSaver Options
cd /opt/retropie/configs/all/emulationstation/

xml_escape() {
    local raw="$1"
    raw="${raw//&/&amp;}"
    raw="${raw//</&lt;}"
    raw="${raw//>/&gt;}"
    raw="${raw//\"/&quot;}"
    raw="${raw//\'/&apos;}"
    echo "$raw"
}

declare -A fixes=(
  ["DoublePressRemovesFromFavs"]="true"
  ["ScreenSaverOmxPlayer"]="false"
  ["ScreenSaverVideoMute"]="true"
  ["StretchVideoOnScreenSaver"]="false"
  ["ScreenSaverSwapVideoTimeout"]="10000"
  ["SubtitleAlignment"]="center"
  ["SortAllSystems"]="false"
  ["ScreenSaverGameInfo"]="start & end"
  ["SlideshowScreenSaverMediaDir"]="/home/pi/.emulationstation/slideshow/image"
  ["MaxVRAM"]="100"
  ["ScreenSaverBehavior"]="slideshow"
  ["ThemeSet"]="2Play!-EpicMavro"
)

for key in "${!fixes[@]}"; do
    value=$(xml_escape "${fixes[$key]}")
    # Escape & for sed replacement
    safe_value=${value//&/\\&}
	# Replace regardless of current value
    sed -i "s|\(<string name=\"$key\" value=\)\"[^\"]*\"|\1\"$safe_value\"|g" es_settings.cfg
done


# Set USB filesystem check every 1m
set_fsck_root

#Kernel error fix After OS Full update (5.10.17)
#if [[ `uname -r | grep 5.10.17-` ]]; then
#	if grep "gpu_mem_" /boot/config.txt ; then
#	sudo sed -i 's|^gpu_mem_*|#gpu_mem_|g' /boot/config.txt;
#	fi
#	else
#	if grep "gpu_mem_" /boot/config.txt ; then
#	sudo sed -i 's|#gpu_mem_*|gpu_mem_|g' /boot/config.txt;
#	fi
#	echo "Your Kernel isn't at 5.10.17 so All OK!"
#	echo
#fi

# Disable Dim Xinit?
	#sudo sed -i 's|#xserver-command=|xserver-command=X -s 0 -dpmsX -s 0 -dpms|g' /etc/lightdm/lightdm.conf
# WWF Typo Fix

# Install Latest Youtube-dl/yt-dlp
if [ -f /usr/local/bin/yt-dlp ]; then echo "YT Already installed! Let's update it...";pip3 install --upgrade yt-dlp; sudo yt-dlp -U; sudo cp -f /usr/local/bin/yt-dlp /usr/local/bin/youtube-dl; sudo cp -f /usr/local/bin/yt-dlp /home/pi/myenv/bin/youtube-dl; sleep 1
#to update pip3
#python3 -m pip install --upgrade pip
else 
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod 755 /usr/local/bin/yt-dlp
sudo cp -f /usr/local/bin/yt-dlp /usr/local/bin/youtube-dl; sudo cp -f /usr/local/bin/yt-dlp /home/pi/myenv/bin/youtube-dl
fi


# Check and install GTK appmenu modules
#if ! dpkg -s appmenu-gtk3-module >/dev/null 2>&1; then
#    echo "Installing GTK appmenu modules..."
#    sudo apt update
#    sudo apt install -y appmenu-gtk2-module appmenu-gtk3-module
#else
#    echo "All OK! GTK appmenu modules already installed."
#fi

# Clean Mesa/Vulkan Old Lib Files Dups
cd /usr/local/lib/
#if [ -f libEGL.so ] && [ ! -f /usr/local/lib/.mesa_cleaned ]; then
if [ -f libEGL.so ]; then
  echo "Cleaning old Mesa/Vulkan libraries..."
  for f in libEGL.so libEGL.so.1 libEGL.so.1.0.0 \
           libgbm.so libgbm.so.1 libgbm.so.1.0.0 \
           libGL.so libGL.so.1 libGL.so.1.2.0 \
           libglapi.so libglapi.so.0 libglapi.so.0.0.0 \
           libGLESv1_CM.so libGLESv1_CM.so.1 libGLESv1_CM.so.1.1.0 \
           libGLESv2.so libGLESv2.so.2 libGLESv2.so.2.0.0 \
           libvulkan_broadcom.so; do
    [ -e "$f" ] && sudo rm "$f" && echo "Removed $f"
	#touch /usr/local/lib/.mesa_cleaned
  done
  sudo rm -rf /usr/local/lib/dri
  sudo rm -rf /usr/local/share/vulkan /usr/local/share/drirc.d
  sudo rm -rf /usr/local/include/EGL /usr/local/include/GL /usr/local/include/GLES*
  sudo rm -rf /usr/local/include/KHR
  sudo rm -f /usr/local/lib/pkgconfig/{gl.pc,dri.pc,egl.pc,gbm.pc,glesv1_cm.pc,glesv2.pc}
else
  echo "All OK!"
fi
sleep 1
clear

#New Ports Dependencies ARM
#	if [[ -f /usr/lib/arm-linux-gnueabihf/libGLEW.so.1.7 ]]; then
#	return 0
#    fi
#	sudo ln -s /usr/lib/arm-linux-gnueabihf/libGLEW.so /usr/lib/arm-linux-gnueabihf/libGLEW.so.1.7
#	if [[ ! -e /usr/lib/arm-linux-gnueabihf/libSDL_gfx.so.13 ]]; then
#        echo -e "\nSetting libSDL_gfx..."
#        sudo ln -s /usr/lib/arm-linux-gnueabihf/libSDL_gfx.so.15 /usr/lib/arm-linux-gnueabihf/libSDL_gfx.so.13
#    fi

#New Ports Dependencies x86
# Ensure GLEW and SDL_gfx legacy symlinks exist
# To list/check: ls -l /usr/lib/*/libGLEW.so* /usr/lib/*/libSDL_gfx.so*

#set -e

# --- GLEW ---
if ldconfig -p | grep -q "libGLEW.so.1.7"; then
    echo "libGLEW.so.1.7 already present."
else
    echo "libGLEW.so.1.7 missing..."
    if ! dpkg -l | grep -q libglew-dev; then
        echo "Installing GLEW..."
        sudo apt update && sudo apt install -y libglew-dev
    fi
    glew_path=$(ldconfig -p | grep libGLEW.so | head -n1 | awk '{print $NF}')
    if [ -n "$glew_path" ]; then
        echo "Creating symlink: libGLEW.so.1.7 → $glew_path"
        sudo ln -sf "$glew_path" /usr/lib/x86_64-linux-gnu/libGLEW.so.1.7
    fi
fi

# --- SDL_gfx ---
if ldconfig -p | grep -q "libSDL_gfx.so.13"; then
    echo "libSDL_gfx.so.13 already present."
else
    echo "libSDL_gfx.so.13 missing..."
    if ! dpkg -l | grep -q libsdl-gfx1.2-dev; then
        echo "Installing SDL_gfx..."
        sudo apt update && sudo apt install -y libsdl-gfx1.2-dev
    fi
    sdl_path=$(ldconfig -p | grep libSDL_gfx.so | head -n1 | awk '{print $NF}')
    if [ -n "$sdl_path" ]; then
        echo "Creating symlink: libSDL_gfx.so.13 → $sdl_path"
        sudo ln -sf "$sdl_path" /usr/lib/x86_64-linux-gnu/libSDL_gfx.so.13
    fi
fi

echo "Dependency check complete."

# Sinden LightGun Requirements
pkgs="mono-complete v4l-utils libsdl1.2-dev libsdl-image1.2-dev libjpeg-dev"

# Check if all packages are installed
missing=$(dpkg -l $pkgs 2>/dev/null | awk '/^ii/ {print $2}' | grep -vxF "$pkgs" || true)

if [ -n "$missing" ]; then
    echo "Installing missing dependencies..."
    sudo apt update
    sudo apt install -y $pkgs
else
    echo "All OK!"
    echo
fi

# Symbolic links to main /usr/local/bin
sudo ln -s /home/pi/.local/bin/* /usr/local/bin/
if [[ -d /home/pi/myenv ]]; then
	sudo ln -s /home/pi/myenv/bin/* /usr/local/bin/
fi



#EMUS SECTION
#------------

#GSPlus roms symlink update
#sudo ln -sfn /home/pi/RetroPie/roms/apple2gs/.data /opt/retropie/emulators/gsplus/roms
#sudo ln -sfn /home/pi/RetroPie/BIOS- /opt/retropie/emulators/gsplus/bios
#totalchaos update save img 1.5GB
#rm /home/pi/RetroPie/roms/ports/doom/Skins/totalchaos.pk3

# Enable input_libretro_device_p2 = "513" 6-button controller/pad for both p1/p2
# 513 generally corresponds to a 6-button controller/pad in many Libretro cores, particularly:
#Sega Genesis / Mega Drive: Used to force 6-button pad support (critical for games like Street Fighter II or Mortal Kombat).
#Atari 800 / 5200: Used by the atari800 core to define the primary Atari Joystick device.
#Amstrad CPC: Used by the cap32 core to set the device type to a standard joystick.
#ZX Spectrum: Used by the lr-fuse core for certain joystick interfaces like the Kempston Joystick.
#Sega CD: Similar to the Genesis, used for 6-button controller support.

cd /opt/retropie/configs/
for sys in atari5200 atari800 genesis genesish megadrive megadriveh megadrive-japan megadriveplus segacd megacd; do
    cfg="$sys/retroarch.cfg"
    if [[ -f "$cfg" ]]; then
        echo "Updating $cfg ..."
        # Uncomment if commented, then force value to 513
        sed -i 's/^#input_libretro_device_p1.*/input_libretro_device_p1 = "513"/' "$cfg"
        sed -i 's/^#input_libretro_device_p2.*/input_libretro_device_p2 = "513"/' "$cfg"
        sed -i 's/^input_libretro_device_p1.*/input_libretro_device_p1 = "513"/' "$cfg"
        sed -i 's/^input_libretro_device_p2.*/input_libretro_device_p2 = "513"/' "$cfg"
    else
        echo "Skipping $sys (no retroarch.cfg found)"
    fi
done

# Overlay Fixes
overlay_fix "FinalBurn Neo"
#rm -rf fuse
disable_core_cfg "Genesis Plus GX"
disable_core_cfg "fMSX"
disable_core_cfg "ProSystem"
disable_core_cfg "PicoDrive"
disable_core_cfg "Stella 2014"

# Core Options Per System Config Folder - uncomment if exists (use for other uncommenting - this not needed due to global setting applying it)
#cd /opt/retropie/configs
#while IFS= read -r -d '' cfg; do
#    echo "Fixing $cfg ..."
#    sed -i 's|^#core_options_path = "/opt/retropie/configs/|core_options_path = "/opt/retropie/configs/|' "$cfg"
#done < <(find . -type f -name "retroarch.cfg" -print0)

# Amiga Saves Typo
#cd /opt/retropie/configs/amiga
#sed -i 's|3do|amiga|g' retroarch.cfg

# N64 Core Option ThreadedRenderer
#cd /opt/retropie/configs/n64
#sed -i 's|^mupen64plus-next-ThreadedRenderer = "False"|mupen64plus-next-ThreadedRenderer = "True"|' retroarch-core-options.cfg;

# Intellivision lr-freeintv fix due to latest video driver 
#cd /opt/retropie/configs/intellivision
#sed -i 's|lr-freeintv = "/opt/|lr-freeintv = "XINIT:/opt/|' emulators.cfg;

#Redream Path Fix
fix_redream_path

# N64 Controller Fix Revert and apply to all 4PL - Specific Setup in RA or N64 Applies
fix_n64_controllers

# Mame2003_Plus Controller
cd /opt/retropie/configs/arcade/
sed -i 's|^mame2003-plus_analog = "analog"|mame2003-plus_analog = "digital"|' retroarch-core-options.cfg;

# Pico8 & DuckStation Standalone & Core
sudo chown pi:pi -R /opt/retropie/emulators/pico8/
sudo chmod 755 /opt/retropie/emulators/pico8/*
rm *.sh
cd ~

#If user has Pico8 Disabled
# Pico-8 setup
#if ls ~/RetroPie/localroms/pico8.* ~/RetroPie/roms/pico8.* >/dev/null 2>&1; then
#    echo "You have Pico-8 disabled. We continue..."
#else
#    # Decide base directory
#    if [ -d ~/RetroPie/localroms ]; then
#        base=~/RetroPie/localroms/pico8
#        mkdir -p "$base" ~/addonusb/pico8
#    else
#        base=~/RetroPie/roms/pico8
#        mkdir -p "$base"
#    fi

#    cd "$base"
#    if [ ! -f "+Start PICO8.sh" ]; then
#        wget -O "+Start PICO8.sh" \
#          "https://github.com/2play/PBv2-PostFixes/raw/clean/home/pi/RetroPie/roms/pico8/%2BStart%20PICO8.sh"
#        chmod 755 "+Start PICO8.sh"
#    fi
#fi
#cd ~

# Fix duckstation ownership and permissions
sudo chown pi:pi -R /opt/retropie/emulators/duckstation/
sudo chmod 755 /opt/retropie/emulators/duckstation/*

cfg="/opt/retropie/configs/psx/emulators.cfg"

# DuckStation standalone
duck_line='duckstation = "XINIT:/opt/retropie/emulators/duckstation/duckstation-qt %ROM%"'
if ! grep -Fxq "$duck_line" "$cfg"; then
    echo "$duck_line" | sudo tee -a "$cfg" > /dev/null
else
    echo "DuckStation standalone already inserted!"; sleep 1
fi

# DuckStation libretro core
sudo chmod 755 /opt/retropie/latestcores/duckstation_libretro.so
lr_line='lr-duckstation = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/latestcores/duckstation_libretro.so --config /opt/retropie/configs/psx/retroarch.cfg %ROM%"'
if ! grep -Fxq "$lr_line" "$cfg"; then
    echo "$lr_line" | sudo tee -a "$cfg" > /dev/null
else
    echo "DuckStation libretro already inserted!"; sleep 1
fi

# Delete Old OpenBor & Fix Logs Link (only if present)
if [[ -d /opt/retropie/ports/openbor ]]; then
	echo "Cleaning old OpenBOR..."
	sudo rm -rf /opt/retropie/ports/openbor
fi

if [[ -d /opt/retropie/emulators/openbor ]]; then
	sudo chown pi:pi /opt/retropie/emulators/openbor/* 2>/dev/null
	sudo rm -f /opt/retropie/emulators/openbor/{Logs,Paks,Saves,ScreenShots}
	ln -sfn /opt/retropie/configs/openbor/{Logs,Saves,ScreenShots} /opt/retropie/emulators/openbor/
	ln -sfn /home/pi/RetroPie/roms/openbor /opt/retropie/emulators/openbor/Paks
	echo "OpenBOR cleanup complete."
else
	echo "OpenBOR emulator folder not found, skipping cleanup."
fi

# OTHER TEMP/MINOR
#xmllint --noout /opt/retropie/configs/all/emulationstation/es_settings.cfg || {
#    echo "[ERROR] ES settings file invalid, restoring backup..."
#    cp ~/backup/es_settings.cfg /opt/retropie/configs/all/emulationstation/es_settings.cfg

restart_es
}

#Post Release Update steps
function next_steps_pr() {
clear
   
}


# Global Shader
function global_shader() {
    local choice
		choice=$(dialog --backtitle "PLAYBOX PROJECT" --title " GLOBAL SHADER OPTION " \
            --ok-label OK --cancel-label Exit \
			--menu "Choose Enable or Disable!" 25 75 20 \
            - "*** GLOBAL RETRO SHADER ***" \
            ""      "" \
			1 " -  [ON]  Global Retro Shader By Chris Kekrides or 2P! " \
            2 " -  [OFF] Global Retro Shader By Chris Kekrides or 2P! " \
			2>&1 > /dev/tty)

        case "$choice" in
            6) toggle_global_shader enable ;;
			7) toggle_global_shader disable  ;;
		   	-) none ;;
            *) break ;;
        esac
    clear
}

function toggle_global_shader() {
    local action="$1"   # "enable" or "disable"
    local cfgdir="/opt/retropie/configs/all/retroarch/config"

    dialog --infobox "...${action^}ing..." 3 20 ; sleep 2
    clear
    cd "$cfgdir"

    case "$action" in
        disable)
            for f in global.glslp global.slangp; do
                [ -f "$f" ] && mv "$f" "$f.OFF"
            done
            ;;
        enable)
            # Restore if OFF files exist
            for f in global.glslp global.slangp; do
                [ -f "$f.OFF" ] && mv "$f.OFF" "$f"
                # If missing entirely, fetch fresh copy
                [ ! -f "$f" ] && wget "https://raw.githubusercontent.com/2play/PBv2-PostFixes/clean-vanilla-x86/opt/retropie/configs/all/retroarch/config/$f"
            done
            ;;
    esac

    echo "[OK DONE!...]"
    sleep 1
}


##Support Functions

function set_fsck_root() {
    root_dev=$(findmnt -n -o SOURCE /)
    echo "Setting filesystem check every 1 month on $root_dev..."
    sudo tune2fs -i 1m "$root_dev"
    sudo tune2fs -l "$root_dev" | grep -E "Mount count|Maximum mount count"
}

function fix_redream_path() {
    cfg="/opt/retropie/configs/dreamcast/redream/redream.cfg"
    correct="/home/pi/RetroPie/roms/dreamcast;"
    default="/home/pi/RetroPie/roms;"

    if grep -q "$correct" "$cfg"; then
        echo "Already has corrected value..."
    else
        echo "Fixing Redream path..."
        sed -i "s|$default|$correct|" "$cfg"
    fi
}


function fix_n64_controllers() {
    # Global configs
    for cfg in /opt/retropie/configs/all/retroarch.cfg \
               /opt/retropie/configs/all/retroarch/retroarch.cfg; do
        for p in {1..4}; do
            sed -i "s|input_player${p}_analog_dpad_mode = \"0\"|input_player${p}_analog_dpad_mode = \"1\"|" "$cfg"
        done
    done

    # N64-specific config
    n64cfg="/opt/retropie/configs/n64/retroarch.cfg"
    if grep -q 'input_player1_analog_dpad_mode = "2"' "$n64cfg"; then
        echo "Controller fix already applied..."
    else
        for p in {1..4}; do
            line=$((18 + p)) # insert at lines 19–22
            sed -i "${line}iinput_player${p}_analog_dpad_mode = \"2\"" "$n64cfg"
        done
    fi
}


function overlay_fix() {
    echo "Applying overlay fixes..."

    # Loop over all arguments passed to the function
    for sys in "$@"; do
        cfg_dir="/opt/retropie/configs/all/retroarch/config/$sys"
        if [[ -d "$cfg_dir" ]]; then
            echo "Patching overlays in $cfg_dir ..."
            find "$cfg_dir" -type f -name "*.cfg" -print0 | \
                xargs -0 sed -i 's|MAME-Vertical.cfg|pb-vr.cfg|g'
        else
            echo "Skipping $sys (no config dir found)"
        fi
    done

    # Symlink overlay file for compatibility
    ln -sfn /opt/retropie/configs/all/retroarch/overlay/PlayBox/pb-vr.cfg \
            /opt/retropie/configs/all/retroarch/overlay/MAME-Vertical.cfg
}

# === Overlay Fixes with Target List ===
#function overlay_fix() {
#    echo "Applying overlay fixes..."

    # List of system config folders to patch
#    systems=( "FinalBurn Neo" )

#   for sys in "${systems[@]}"; do
#        cfg_dir="/opt/retropie/configs/all/retroarch/config/$sys"
#       if [[ -d "$cfg_dir" ]]; then
#            echo "Patching overlays in $cfg_dir ..."
#            find "$cfg_dir" -type f -name "*.cfg" -print0 | \
#                xargs -0 sed -i 's|MAME-Vertical.cfg|pb-vr.cfg|g'
#        else
#            echo "Skipping $sys (no config dir found)"
#        fi
#    done

    # Symlink overlay file for compatibility
#    ln -sfn /opt/retropie/configs/all/retroarch/overlay/PlayBox/pb-vr.cfg \
#            /opt/retropie/configs/all/retroarch/overlay/MAME-Vertical.cfg
#}


function disable_core_cfg() {
    core="$1"
    cfg_dir="/opt/retropie/configs/all/retroarch/config/$core"

    if [[ -d "$cfg_dir" ]]; then
        mv "$cfg_dir" "${cfg_dir}.OFF"
        echo "Disabled $core config"
    else
        echo "Skipping $core (not found)"
    fi
}

function enable_core_cfg() {
    core="$1"
    cfg_dir="/opt/retropie/configs/all/retroarch/config/$core.OFF"

    if [[ -d "$cfg_dir" ]]; then
        mv "$cfg_dir" "/opt/retropie/configs/all/retroarch/config/$core"
        echo "Re-enabled $core config"
    else
        echo "Skipping $core (no .OFF backup found)"
    fi
}

function restart_es() {
    clear
    ensure_lolcat
    echo "[WARN] Please restart EmulationStation manually or Reboot for changes to take effect..." | lolcat
    
	#echo "[Restarting EmulationStation...]"
    #sleep 1
 
    # Detect if running locally or via SSH
	#	if [[ -n "$SSH_CONNECTION" ]]; then
		
	#	echo "[WARN] Restart skipped: Script running under SSH session]"
	#	echo "Please restart ES manually on the actual console."
	#else
	# Stop ES
	#	pkill -f emulationstation

    # Wait until ES is really gone
	#	while pgrep -f emulationstation >/dev/null; do sleep 2; done

    # Extra delay to let esbgm service react
	#	sleep 1
	
    # Relaunch ES bound to the local console
	#	nohup emulationstation --no-splash >/dev/null 2>&1 &
	#	disown
	#	echo "[EmulationStation restarted successfully]"
	#	fi
	
	pausepress
}


function pausepress() {
    echo
    read -n 1 -s -r -p "Press any key to continue..."
    echo
}


function ensure_lolcat() {
    if ! command -v lolcat >/dev/null 2>&1; then
        sudo gem install lolcat >/dev/null 2>&1
    else
        # Test if lolcat runs without Ruby errors
        if ! echo "test" | lolcat >/dev/null 2>&1; then
            sudo gem install lolcat >/dev/null 2>&1
        fi
    fi
}

post_fix_update

clear
ensure_lolcat
echo "[OK Updates Applied!... & Exited Toolkit]" | lolcat
cd $HOME
	   
