# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
pb_version="PlayBox v2 Post Updates & Fixes: Dated 04.2026"
clear
echo $pb_version
sleep 1
cd $HOME/code/

# Get Post Fixes Clean Burn Or Normal Post Fix Update
function post_fix_update() {
    local choice
	
	while true; do
		choice=$(dialog --backtitle "$BACKTITLE" --title " POST FIXES SETUP OPTIONS " \
            --ok-label OK --cancel-label Exit \
			--menu "Choose Clean or Normal Update!" 25 75 20 \
            - "*** POST FIXES SETUP OPTIONS ***" \
            - "" \
			CLEAN " - CLEAN IMAGE: UPDATE & FIXES " \
			- "    (Apply After A Clean Burn OR To Restore All To Latest Clean State)" \
			- "" \
			NORMAL " - NORMAL UPDATE: POST RELEASE UPDATES & FIXES " \
            - "    (Applies Post Release Updates) " \
			2>&1 > /dev/tty)

	case "$choice" in
		CLEAN)   post_up "clean-vanilla-x86"   ;;
		NORMAL)  post_up "main-vanilla-x86"    ;;
		-)       none ;;
		*)       break ;;
	esac
	done
	clear
}


function post_up() {
    branch=$1
    clear
    echo "Cloning branch: $branch"
    git clone --depth 1 --branch="$branch" https://github.com/2play/PBv2-PostFixes.git
    cd PBv2-PostFixes/ || { echo "Clone failed"; return 1; }
    #mv ~/RetroPie/roms/piegalaxy ~/RetroPie/roms/piegalaxy.OFF
    next_steps
    global_shader
}


function next_steps() {
clear
#Sync New Files
rsync -urv --exclude '.git' --exclude 'boot' --exclude 'etc' --exclude 'var' --exclude 'usr' --exclude 'libretrocores' --exclude 'emulators' --exclude 'supplementary' --exclude 'LICENSE' --exclude 'README.md' --exclude 'roms' . /
sudo rsync -urv boot/ /boot/
sudo rsync -urv etc/ /etc/
sudo rsync -urv var/ /var/
sudo rsync -urv usr/ /usr/
sudo rsync -urv opt/retropie/libretrocores/ /opt/retropie/libretrocores/
sudo rsync -urv opt/retropie/emulators/ /opt/retropie/emulators/
if [ ! -d /opt/retropie/supplementary/emulationstation-dev ]; then
sudo rsync -urv opt/retropie/supplementary/ /opt/retropie/supplementary/
fi

#Permissions
sudo chown pi:pi -R /etc/emulationstation/themes/
sudo chmod 644 /etc/mopidy/mopidy.conf
sudo chmod 755 ~/scripts/themerandom.sh
sudo chmod 755 /usr/local/bin/*grab

cd /.
sudo rm -rf samba/ && sudo rm smb*

rm -rf ~/code/PBv2-PostFixes/
rm -rf ~/PBv2-PostFixes/

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

#Misc Updates
#GSPlus roms symlink update
#sudo ln -sfn /home/pi/RetroPie/roms/apple2gs/.data /opt/retropie/emulators/gsplus/roms
#sudo ln -sfn /home/pi/RetroPie/BIOS- /opt/retropie/emulators/gsplus/bios
#totalchaos update save img 1.5GB
#rm /home/pi/RetroPie/roms/ports/doom/Skins/totalchaos.pk3

# Skyscraper New Setup 2P!
#sudo ln -sfn /home/pi/.skyscraper/2PSkyscrape_boxart.sh /usr/local/bin/2PSkyscrape_boxart;
#sudo ln -sfn /home/pi/.skyscraper/2PSkyscrape_mixart.sh /usr/local/bin/2PSkyscrape_mixart;

# Install Latest Youtube-dl/yt-dlp
if [ -f /usr/local/bin/yt-dlp ]; then echo "YT Already installed! Let's update it...";pip3 install --upgrade yt-dlp; sudo yt-dlp -U; sudo cp -f /usr/local/bin/yt-dlp /usr/local/bin/youtube-dl; sudo cp -f /usr/local/bin/yt-dlp /home/pi/myenv/bin/youtube-dl; sleep 1
#to update pip3
#python3 -m pip install --upgrade pip
else 
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod 755 /usr/local/bin/yt-dlp
sudo cp -f /usr/local/bin/yt-dlp /usr/local/bin/youtube-dl; sudo cp -f /usr/local/bin/yt-dlp /home/pi/myenv/bin/youtube-dl
fi

#Make extra custom PlayBox roms directories (Update/Add as needed)
cd "$HOME/RetroPie/roms" || exit 1
for dir in ags amiga4000 amigacd32 apple2 apple2gs arcadia archimedes astrocade atari800 atarifalcon atarijaguar atarist ataritt atarixegs atomiswave bbcmicro c128 c16 cdimono1 cdtv coleco coleco_adam crvision dragon32 electron famicom gamemaker gc genesish gx4000 intellivision_ecs kodi lightgun mame mame-advmame mame-libretro mame-mame4all mega32x megacd megadrive megadriveh megadrive-japan mess msx2 msx2+ msxturbor neogeocd nesh odyssey2 openbor pc128 pcengine pcenginecd pcfx pico8 piegalaxy playbox plus4 power ps2 pspminis desktop  satellaview saturn-japan sc-3000 scv sega32x segacd sfc sg-1000 sgb sgfx snesh snesmsu1 solarus spinner steam stv sufami swancrystal tg16 tg16cd ti99 tic80 trackball trs-80 vic20 videopac wii wiiu; do
    mkdir -p "$dir"
    echo "Created directory: $dir"
done

# Enable input_libretro_device_p2 = "513" 6-button controller/pad for both p1/p2
# 513 generally corresponds to a 6-button controller/pad in many Libretro cores, particularly:
#Sega Genesis / Mega Drive: Used to force 6-button pad support (critical for games like Street Fighter II or Mortal Kombat).
#Atari 800 / 5200: Used by the atari800 core to define the primary Atari Joystick device.
#Amstrad CPC: Used by the cap32 core to set the device type to a standard joystick.
#ZX Spectrum: Used by the lr-fuse core for certain joystick interfaces like the Kempston Joystick.
#Sega CD: Similar to the Genesis, used for 6-button controller support.

cd /opt/retropie/configs/
for sys in genesis megadrive atari5200 atari800 zxspectrum segacd megacd amstradcpc; do
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

# Core Options Per System Config Folder - uncomment if exists (use for othe uncommenting - this not needed due to global setting applying it)
#cd /opt/retropie/configs
#while IFS= read -r -d '' cfg; do
#    echo "Fixing $cfg ..."
#    sed -i 's|^#core_options_path = "/opt/retropie/configs/|core_options_path = "/opt/retropie/configs/|' "$cfg"
#done < <(find . -type f -name "retroarch.cfg" -print0)

# ES Video ScreenSaver Options
cd /opt/retropie/configs/all/emulationstation

declare -A fixes=(
  ["<bool name=\"ScreenSaverOmxPlayer\" value=\"true\" />"]="<bool name=\"ScreenSaverOmxPlayer\" value=\"false\" />"
  ["<bool name=\"ScreenSaverVideoMute\" value=\"false\" />"]="<bool name=\"ScreenSaverVideoMute\" value=\"true\" />"
  ["<bool name=\"StretchVideoOnScreenSaver\" value=\"false\" />"]="<bool name=\"StretchVideoOnScreenSaver\" value=\"true\" />"
  ["<int name=\"ScreenSaverSwapVideoTimeout\" value=\"15000\" />"]="<int name=\"ScreenSaverSwapVideoTimeout\" value=\"10000\" />"
  ["<string name=\"SubtitleAlignment\" value=\"left\" />"]="<string name=\"SubtitleAlignment\" value=\"center\" />"
)

for key in "${!fixes[@]}"; do
    sed -i "s|$key|${fixes[$key]}|g" es_settings.cfg
done


## Various Minor Typos Etc

# Amiga Saves Typo
#cd /opt/retropie/configs/amiga
#sed -i 's|3do|amiga|g' retroarch.cfg

# Disable Dim Xinit?
	#sudo sed -i 's|#xserver-command=|xserver-command=X -s 0 -dpmsX -s 0 -dpms|g' /etc/lightdm/lightdm.conf
# WWF Typo Fix

# N64 Core Option ThreadedRenderer
#cd /opt/retropie/configs/n64
#sed -i 's|^mupen64plus-next-ThreadedRenderer = "False"|mupen64plus-next-ThreadedRenderer = "True"|' retroarch-core-options.cfg;

# Intellivision lr-freeintv fix due to latest video driver 
#cd /opt/retropie/configs/intellivision
#sed -i 's|lr-freeintv = "/opt/|lr-freeintv = "XINIT:/opt/|' emulators.cfg;

# RetroArch PlayBox v2 Defaults: Hide Mouse Cursor On Overlay, Core Ratio, Menu Driver, video_threaded, glcore OFF add to specific
# Common substitutions
COMMON='
s|input_overlay_show_mouse_cursor = "true"|input_overlay_show_mouse_cursor = "false"|g;
s|aspect_ratio_index = "[0-9]*"|aspect_ratio_index = "22"|g;
s|materialui_menu_color_theme = "[0-9]*"|materialui_menu_color_theme = "19"|g;
s|menu_driver = ".*"|menu_driver = "ozone"|g;
s|menu_linear_filter = "true"|menu_linear_filter = "false"|g;
s|menu_rgui_shadows = "false"|menu_rgui_shadows = "true"|g;
s|ozone_menu_color_theme = "[0-9]*"|ozone_menu_color_theme = "3"|g;
s|rgui_menu_color_theme = "[0-9]*"|rgui_menu_color_theme = "29"|g;
s|xmb_menu_color_theme = "[0-9]*"|xmb_menu_color_theme = "7"|g;
s|"~/.config/retroarch/screenshots"|"~/ScreenShots"|g;

# New defaults
s|core_options_path = ".*"|core_options_path = ""|g;
s|config_save_on_exit = "true"|config_save_on_exit = "false"|g;
s|show_hidden_files = "false"|show_hidden_files = "true"|g;
s|input_joypad_driver = ".*"|input_joypad_driver = "udev"|g;
s|video_fullscreen = "false"|video_fullscreen = "true"|g;
s|video_aspect_ratio_auto = "false"|video_aspect_ratio_auto = "true"|g;
s|video_threaded = "false"|video_threaded = "true"|g;
s|video_shader_enable = "false"|video_shader_enable = "true"|g;
s|video_font_size = "[0-9]*"|video_font_size = "24"|g;
s|input_overlay_enable = "false"|input_overlay_enable = "true"|g;
s|input_autodetect_enable = "false"|input_autodetect_enable = "true"|g;
s|input_player1_a = ".*"|input_player1_a = "z"|g;
s|input_player1_b = ".*"|input_player1_b = "x"|g;
s|input_player1_y = ".*"|input_player1_y = "s"|g;
s|input_player1_x = ".*"|input_player1_x = "a"|g;
s|input_player1_start = ".*"|input_player1_start = "f6"|g;
s|input_player1_select = ".*"|input_player1_select = "f5"|g;
s|input_player1_l = ".*"|input_player1_l = "insert"|g;
s|input_player1_r = ".*"|input_player1_r = "pageup"|g;
s|input_player1_left = ".*"|input_player1_left = "left"|g;
s|input_player1_right = ".*"|input_player1_right = "right"|g;
s|input_player1_up = ".*"|input_player1_up = "up"|g;
s|input_player1_down = ".*"|input_player1_down = "down"|g;
s|input_player1_l2 = ".*"|input_player1_l2 = "del"|g;
s|input_player1_r2 = ".*"|input_player1_r2 = "pagedown"|g;
s|menu_swap_ok_cancel_buttons = "true"|menu_swap_ok_cancel_buttons = "false"|g;
s|input_exit_emulator = ".*"|input_exit_emulator = "f6"|g;
s|system_directory = ".*"|system_directory = "/home/pi/RetroPie/BIOS"|g;
s|rgui_browser_directory = ".*"|rgui_browser_directory = "/home/pi/RetroPie/roms"|g;
s|libretro_directory = ".*"|libretro_directory = "/opt/retropie/libretrocores/"|g;
s|savefile_directory = ".*"|savefile_directory = "/home/pi/RetroPie/saves"|g;
s|savestate_directory = ".*"|savestate_directory = "/home/pi/RetroPie/states"|g;
s|global_core_options = "false"|global_core_options = "true"|g;
s|input_enable_hotkey = ".*"|input_enable_hotkey = "f5"|g;
s|auto_remaps_enable = "false"|auto_remaps_enable = "true"|g;
s|remap_save_on_exit = "true"|remap_save_on_exit = "false"|g;
s|rgui_aspect_ratio_lock = "[0-9]*"|rgui_aspect_ratio_lock = "2"|g;
s|rgui_switch_icons = "true"|rgui_switch_icons = "false"|g;
s|menu_show_restart_retroarch = "true"|menu_show_restart_retroarch = "false"|g;
s|menu_disable_search_button = "false"|menu_disable_search_button = "true"|g;
s|quick_menu_show_close_content = "true"|quick_menu_show_close_content = "false"|g;
s|quick_menu_show_add_to_favorites = "true"|quick_menu_show_add_to_favorites = "false"|g;
s|quick_menu_show_replay = "true"|quick_menu_show_replay = "false"|g;
s|quick_menu_show_start_recording = "true"|quick_menu_show_start_recording = "false"|g;
s|quick_menu_show_start_streaming = "true"|quick_menu_show_start_streaming = "false"|g;
s|menu_show_overlays = "true"|menu_show_overlays = "false"|g;
s|menu_show_load_content_animation = "true"|menu_show_load_content_animation = "false"|g;
s|core_info_cache_enable = "true"|core_info_cache_enable = "false"|g;
s|xmb_show_add = "true"|xmb_show_add = "false"|g;
s|xmb_show_history = "true"|xmb_show_history = "false"|g;
s|xmb_show_images = "true"|xmb_show_images = "false"|g;
s|xmb_show_music = "true"|xmb_show_music = "false"|g;
s|xmb_shadows_enable = "true"|xmb_shadows_enable = "false"|g;
s|quit_press_twice = "false"|quit_press_twice = "true"|g;
s|sort_savestates_enable = "true"|sort_savestates_enable = "false"|g;
s|sort_savefiles_enable = "true"|sort_savefiles_enable = "false"|g
'

# Apply to first file (particle effect 5)
sed -i "${COMMON}; s|rgui_particle_effect = \"[0-9]*\"|rgui_particle_effect = \"5\"|g" \
  /opt/retropie/configs/all/retroarch.cfg

# Apply to second file (particle effect 1)
sed -i "${COMMON}; s|rgui_particle_effect = \"[0-9]*\"|rgui_particle_effect = \"1\"|g" \
  /opt/retropie/configs/all/retroarch/retroarch.cfg


#if ! [[ `dpkg -l | grep appmenu-gtk3-module` ]]; then
#sudo apt install appmenu-gtk2-module appmenu-gtk3-module; 
#else
#echo "All OK!"
#echo 
#fi

#Redream Path Fix
if grep '/home/pi/RetroPie/roms/dreamcast;' /opt/retropie/configs/dreamcast/redream/redream.cfg; then
echo "Already has corrected value..."; sleep 1
else
sed -i 's|/home/pi/RetroPie/roms;|/home/pi/RetroPie/roms/dreamcast;|' /opt/retropie/configs/dreamcast/redream/redream.cfg;
fi

# N64 Controller Fix Revert and apply to all 4PL - Specific Setup in RA or N64 Applies
sed -i 's|input_player1_analog_dpad_mode = "0"|input_player1_analog_dpad_mode = "1"|' /opt/retropie/configs/all/retroarch.cfg;
sed -i 's|input_player1_analog_dpad_mode = "0"|input_player1_analog_dpad_mode = "1"|' /opt/retropie/configs/all/retroarch/retroarch.cfg;
sed -i 's|input_player2_analog_dpad_mode = "0"|input_player2_analog_dpad_mode = "1"|' /opt/retropie/configs/all/retroarch.cfg;
sed -i 's|input_player2_analog_dpad_mode = "0"|input_player2_analog_dpad_mode = "1"|' /opt/retropie/configs/all/retroarch/retroarch.cfg;
sed -i 's|input_player3_analog_dpad_mode = "0"|input_player3_analog_dpad_mode = "1"|' /opt/retropie/configs/all/retroarch.cfg;
sed -i 's|input_player3_analog_dpad_mode = "0"|input_player3_analog_dpad_mode = "1"|' /opt/retropie/configs/all/retroarch/retroarch.cfg;
sed -i 's|input_player4_analog_dpad_mode = "0"|input_player4_analog_dpad_mode = "1"|' /opt/retropie/configs/all/retroarch.cfg;
sed -i 's|input_player4_analog_dpad_mode = "0"|input_player4_analog_dpad_mode = "1"|' /opt/retropie/configs/all/retroarch/retroarch.cfg;
if grep 'input_player1_analog_dpad_mode = "2"' /opt/retropie/configs/n64/retroarch.cfg; then
echo "Controller fix already applied..."; sleep 1
else
sed -i '19iinput_player1_analog_dpad_mode = "2"' /opt/retropie/configs/n64/retroarch.cfg;
sed -i '20iinput_player2_analog_dpad_mode = "2"' /opt/retropie/configs/n64/retroarch.cfg;
sed -i '21iinput_player3_analog_dpad_mode = "2"' /opt/retropie/configs/n64/retroarch.cfg;
sed -i '22iinput_player4_analog_dpad_mode = "2"' /opt/retropie/configs/n64/retroarch.cfg;
fi
#sed -i 's|video_threaded = "true"|video_threaded = "false"|' /opt/retropie/configs/all/retroarch.cfg;
#sed -i 's|video_threaded = "true"|video_threaded = "false"|' /opt/retropie/configs/all/retroarch/retroarch.cfg;
#sed -i 's|video_threaded = "true"|video_threaded = "false"|' /opt/retropie/configs/amiga/amiberry/conf/retroarch.cfg;
#sed -i 's|video_driver = ".*"|video_driver = "gl"|' /opt/retropie/configs/all/retroarch.cfg;
# Clean Mesa/Vulkan Old Lib Files Dups
cd /usr/local/lib
if [ -f libEGL.so ]; then
sudo rm libEGL.so libEGL.so.1 libEGL.so.1.0.0 libgbm.so libgbm.so.1 libgbm.so.1.0.0 libGL.so libGL.so.1 libGL.so.1.2.0 libglapi.so libglapi.so.0 libGLESv1_CM.so libGLESv1_CM.so.1 libGLESv1_CM.so.1.1.0 libGLESv2.so libGLESv2.so.2 libGLESv2.so.2.0.0 libvulkan_broadcom.so libglapi.so.0.0.0
sudo rm -rf /usr/local/lib/dri
cd /usr/local/share
sudo rm -rf vulkan drirc.d
cd /usr/local/include
sudo rm -rf EGL GL GLES GLES2 GLES3 KHR
cd /usr/local/lib/pkgconfig
sudo rm gl.pc dri.pc egl.pc gbm.pc glesv1_cm.pc glesv2.pc
else
echo "All OK!"
echo
fi
sleep 1
clear
# Mame2003_Plus Controller
cd /opt/retropie/configs/arcade
sed -i 's|^mame2003-plus_analog = "analog"|mame2003-plus_analog = "digital"|' retroarch-core-options.cfg;
# Pico8 & DuckStation Standalone & Core
sudo chown pi:pi -R /opt/retropie/emulators/pico8/
sudo chmod 755 /opt/retropie/emulators/pico8/*
rm *.sh
cd ~
# Pico8 & DuckStation Standalone & Core
sudo chown pi:pi -R /opt/retropie/emulators/pico8/
sudo chmod 755 /opt/retropie/emulators/pico8/*
#If user has Pico8 Disabled
#if [ -d ~/RetroPie/localroms/pico8.* ]; then
#echo "You have it disabled. We continue..."
#else
#	if [ -d ~/RetroPie/localroms ]; then
#	mkdir ~/RetroPie/localroms/pico8 && mkdir ~/addonusb/pico8
#	cd ~/RetroPie/localroms/pico8
#		if [ ! -f ~/RetroPie/localroms/pico8/+Start\ PICO8.sh ]; then wget https://github.com/2play/PBv2-PostFixes/raw/clean/home/pi/RetroPie/roms/pico8/%2BStart%20PICO8.sh
#		chmod 755 ~/RetroPie/localroms/pico8/+Start\ PICO8.sh
#		fi
#	else
#		if [ -d ~/RetroPie/roms/pico8.* ]; then
#			echo "You have it disabled. We continue..."
#			else
#			mkdir ~/RetroPie/roms/pico8 && cd ~/RetroPie/roms/pico8
#			if [ ! -f ~/RetroPie/roms/pico8/+Start\ PICO8.sh ]; then wget https://github.com/2play/PBv2-PostFixes/raw/clean/home/pi/RetroPie/roms/pico8/%2BStart%20PICO8.sh
#			chmod 755 ~/RetroPie/roms/pico8/+Start\ PICO8.sh
#			fi
#		fi
#	fi
#fi
cd ~
sudo chown pi:pi -R /opt/retropie/emulators/duckstation/
sudo chmod 755 /opt/retropie/emulators/duckstation/*
if ! grep -E 'duckstation = "XINIT:/opt/retropie/emulators/duckstation/duckstation-qt %ROM%"' /opt/retropie/configs/psx/emulators.cfg; then
echo 'duckstation = "XINIT:/opt/retropie/emulators/duckstation/duckstation-qt %ROM%"' | tee -a /opt/retropie/configs/psx/emulators.cfg > /dev/null
else
echo "Already inserted!"; sleep 1
fi
sudo chmod 755 /opt/retropie/latestcores/duckstation_libretro.so
if ! grep -E 'lr-duckstation = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/latestcores/duckstation_libretro.so --config /opt/retropie/configs/psx/retroarch.cfg %ROM%"' /opt/retropie/configs/psx/emulators.cfg; then
echo 'lr-duckstation = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/latestcores/duckstation_libretro.so --config /opt/retropie/configs/psx/retroarch.cfg %ROM%"' | tee -a /opt/retropie/configs/psx/emulators.cfg > /dev/null
else
echo "Already inserted..."; sleep 1
fi
#New Ports Dependencies
	if [[ -f /usr/lib/arm-linux-gnueabihf/libGLEW.so.1.7 ]]; then
	return 0
    fi
	sudo ln -s /usr/lib/arm-linux-gnueabihf/libGLEW.so /usr/lib/arm-linux-gnueabihf/libGLEW.so.1.7
	if [[ ! -e /usr/lib/arm-linux-gnueabihf/libSDL_gfx.so.13 ]]; then
        echo -e "\nSetting libSDL_gfx..."
        sudo ln -s /usr/lib/arm-linux-gnueabihf/libSDL_gfx.so.15 /usr/lib/arm-linux-gnueabihf/libSDL_gfx.so.13
    fi
#Sinden LightGun Requirements
if ! [[ `dpkg -l | egrep 'mono-complete|v4l-utils|libsdl1.2-dev|ibsdl-image1.2-dev|libjpeg-dev'`  ]]; then
sudo apt install -y mono-complete
sudo apt install -y v4l-utils
sudo apt install -y libsdl1.2-dev
sudo apt install -y libsdl-image1.2-dev
sudo apt install -y libjpeg-dev
else
echo "All OK!"
echo 
fi
#Delete Old OpenBor & Fix Logs Link
sudo rm -rf /opt/retropie/ports/openbor
sudo chown pi:pi /opt/retropie/emulators/openbor/*
sudo rm /opt/retropie/emulators/openbor/Logs
sudo rm /opt/retropie/emulators/openbor/Paks
sudo rm /opt/retropie/emulators/openbor/Saves
sudo rm /opt/retropie/emulators/openbor/ScreenShots
ln -sfn /opt/retropie/configs/openbor/Logs /opt/retropie/emulators/openbor/Logs
ln -sfn /home/pi/RetroPie/roms/openbor /opt/retropie/emulators/openbor/Paks
ln -sfn /opt/retropie/configs/openbor/Saves /opt/retropie/emulators/openbor/Saves
ln -sfn /opt/retropie/configs/openbor/ScreenShots /opt/retropie/emulators/openbor/ScreenShots

sudo ln -s /home/pi/.local/bin/* /usr/local/bin/
#Check if myenv exists:
if [ -d /home/pi/myenv ]; then
sudo ln -s /home/pi/myenv/bin/* /usr/local/bin/
fi
}

# Global Shader
function global_shader() {
    local choice
		choice=$(dialog --backtitle "$BACKTITLE" --title " GLOBAL SHADER OPTION " \
            --ok-label OK --cancel-label Exit \
			--menu "Choose Enable or Disable!" 25 75 20 \
            - "*** GLOBAL RETRO SHADER ***" \
            - "" \
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

post_fix_update

done_message

function set_fsck_root() {
    root_dev=$(findmnt -n -o SOURCE /)
    echo "Setting filesystem check every 1 month on $root_dev..."
    sudo tune2fs -i 1m "$root_dev"
    sudo tune2fs -l "$root_dev" | grep -E "Mount count|Maximum mount count"
}


# === Overlay Fixes with Arguments ===
#overlay_fix "FinalBurn Neo" "MAME" "Arcade" "Genesis Plus GX" "megadrive"

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

# === Core Config Management ===

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
	echo "[Restarting EmulationStation...]"
    sleep 2
    pkill -f emulationstation
    nohup emulationstation --no-splash &>/dev/null &
}

function done_message() {
    clear
    echo
    echo "[OK DONE!...]"
    cd $HOME
    sleep 1
}

function pausepress() {
    echo
    read -n 1 -s -r -p "Press any key to continue..."
    echo
}

function reboot_message() {
    clear
	echo
	echo "[OK DONE!...]"
	echo
	echo "[OK System Will Restart now...]"
	clear
	sudo reboot
}

function check_and_run() {
    local bin="$1"
    shift
    if [[ -x "$bin" ]]; then
        "$bin" "$@"
    else
        echo "[ERROR] $bin not found or not executable."
        sleep 2
    fi
}

main_menu
