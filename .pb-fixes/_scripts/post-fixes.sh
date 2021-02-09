# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
pb_version="PlayBox v2 Post Updates & Fixes: Dated 03.02.2021"
echo $pb_version
sleep 3
mkdir /home/pi/lmp4
cd $HOME/code/

# Get Post Fixes Clean Burn Update Or Normal Post Fix Update
function post_fix_update() {
    local choice
	while true; do
		choice=$(dialog --backtitle "$BACKTITLE" --title " POST FIXES SETUP OPTIONS " \
            --ok-label OK --cancel-label Exit \
			--menu "Choose Clean or Normal Update!" 25 75 20 \
            - "*** POST FIXES SETUP OPTIONS ***" \
            - "" \
			CLEAN " -  CLEAN IMAGE:   POST UPDATE FIXES" \
			- "    (Use On Clean Burn Or Revert To Clean Status)" \
			NORMAL " -  NORMAL UPDATE: POST UPDATE FIXES" \
            - "    (Use This If You Already Been Updating)" \
			2>&1 > /dev/tty)

        case "$choice" in
            CLEAN) post_up_clean  ;;
            NORMAL) post_up_normal  ;;
            -) none ;;
            *) break ;;
        esac
		done
echo ""
echo "[OK DONE!...]"
cd $HOME
sleep 2
}

function post_up_clean() {
clear
git clone --branch=clean https://github.com/2play/PBv2-PostFixes.git
cd PBv2-PostFixes/
mv ~/RetroPie/roms/piegalaxy ~/RetroPie/roms/piegalaxy.OFF
next_steps
global_shader
amiga_setup
}

function post_up_normal() {
clear
git clone https://github.com/2play/PBv2-PostFixes.git
cd PBv2-PostFixes/
#mv ~/RetroPie/roms/piegalaxy ~/RetroPie/roms/piegalaxy.OFF
next_steps
global_shader
amiga_setup
}

function next_steps() {
clear
#Sync New Files
rsync -urv --exclude '.git' --exclude 'etc' --exclude 'usr' --exclude 'libretrocores' --exclude 'LICENSE' --exclude 'README.md' . /
sudo rsync -urv etc/ /etc/
sudo rsync -urv usr/ /usr/
sudo rsync -urv opt/retropie/libretrocores/ /opt/retropie/libretrocores/
sudo rsync -urv opt/retropie/emulators/ /opt/retropie/emulators/
sudo chown pi:pi -R /etc/emulationstation/themes/
sudo cp /home/pi/PieMarquee2/PieMarquee2/PieMarquee2.py /opt/retropie/configs/all/PieMarquee2/PieMarquee2.py
sleep 1
cd /.
sudo rm -rf samba/ && sudo rm smb*
sleep 1
rm -rf ~/code/PBv2-PostFixes/
sleep 2
# Config.txt OC additions
if ! grep "gpu_freq=750" /boot/config.txt ; then
sudo sed -i '66i#gpu_freq=750' /boot/config.txt
fi
if ! grep "over_voltage=8" /boot/config.txt ; then
sudo sed -i '67i#over_voltage=8' /boot/config.txt
fi
# Enable input_libretro_device_p2 = "513"
cd /opt/retropie/configs/
find -name "retroarch.cfg" -exec sed -i 's|^#input_libretro_device_p1|input_libretro_device1p1|g' {} 2>/dev/null \;
find -name "retroarch.cfg" -exec sed -i 's|^#input_libretro_device_p2|input_libretro_device1p2|g' {} 2>/dev/null \;
# Overlay Fixes
echo
cd /opt/retropie/configs/all/retroarch/config/FinalBurn\ Neo/
find . -type f -name "*.cfg" -print0 | xargs -0 sed -i 's|MAME-Vertical.cfg|pb-vr.cfg|g'  {} 2>/dev/null \;
ln -sfn /opt/retropie/configs/all/retroarch/overlay/PlayBox/pb-vr.cfg /opt/retropie/configs/all/retroarch/overlay/MAME-Vertical.cfg
cd /opt/retropie/configs/all/retroarch/config
rm -rf fuse
ln -sfn Stella\ 2014.EMPTY Stella\ 2014
mv /opt/retropie/configs/all/retroarch/config/Stella\ 2014 /opt/retropie/configs/all/retroarch/config/Stella\ 2014.OFF
mv /opt/retropie/configs/all/retroarch/config/fMSX /opt/retropie/configs/all/retroarch/config/fMSX.OFF
mv /opt/retropie/configs/all/retroarch/config/Genesis\ Plus\ GX /opt/retropie/configs/all/retroarch/config/Genesis\ Plus\ GX.OFF
if [ -d /opt/retropie/configs/all/retroarch/config/ProSystem.OFF ]; then
mv /opt/retropie/configs/all/retroarch/config/ProSystem/* /opt/retropie/configs/all/retroarch/config/ProSystem.OFF/
rm -rf /opt/retropie/configs/all/retroarch/config/ProSystem
else
mv /opt/retropie/configs/all/retroarch/config/ProSystem /opt/retropie/configs/all/retroarch/config/ProSystem.OFF
fi
if [ -d /opt/retropie/configs/all/retroarch/config/PicoDrive.OFF ]; then
mv /opt/retropie/configs/all/retroarch/config/PicoDrive/* /opt/retropie/configs/all/retroarch/config/PicoDrive.OFF/
rm -rf /opt/retropie/configs/all/retroarch/config/PicoDrive
else
mv /opt/retropie/configs/all/retroarch/config/PicoDrive /opt/retropie/configs/all/retroarch/config/PicoDrive.OFF
fi
echo
# Core Options Per System Config Folder
cd /opt/retropie/configs
find . -type f -name "retroarch.cfg" -print0 | xargs -0 sed -i 's|#core_options_path = "/opt/retropie/configs/|core_options_path = "/opt/retropie/configs/|g'
echo
# ES Video ScreenSaver Options
cd /opt/retropie/configs/all/emulationstation
sed -i 's|<bool name="ScreenSaverOmxPlayer" value="true" />|<bool name="ScreenSaverOmxPlayer" value="false" />|g; s|<bool name="ScreenSaverVideoMute" value="false" />|<bool name="ScreenSaverVideoMute" value="true" />|g; s|<bool name="StretchVideoOnScreenSaver" value="false" />|<bool name="StretchVideoOnScreenSaver" value="true" />|g; s|<int name="ScreenSaverSwapVideoTimeout" value="15000" />|<int name="ScreenSaverSwapVideoTimeout" value="10000" />|g; s|<string name="SubtitleAlignment" value="left" />|<string name="SubtitleAlignment" value="center" />|g' es_settings.cfg;
# Various Minor Types Etc
# Amiga Saves Typo
cd /opt/retropie/configs/amiga
sed -i 's|3do|amiga|g' retroarch.cfg
# Disable Dim Xinit?
sudo sed -i 's|#xserver-command=|xserver-command=X -s 0 -dpmsX -s 0 -dpms|g' /etc/lightdm/lightdm.conf
sudo apt-get install xscreensaver -y
# Install Latest Youtube-dl
if [ -f /usr/bin/youtube-dl ]; then echo "Already installed!"; sleep 1
else 
sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/bin/youtube-dl
sudo chmod 755 /usr/bin/youtube-dl
fi
# WWF Typo Fix
rm -rf $HOME/RetroPie/saves-unified
#Remove PUAE cfgs to avoid dups
rm -rf /opt/retropie/configs/all/retroarch/config/PUAE*
# Lr-PUAE Related
cd $HOME/RetroPie/saves
mkdir amiga amiga1200 amigacd32 cdtv
# N64 Core Option
cd /opt/retropie/configs/n64
sed -i 's|^mupen64plus-next-ThreadedRenderer = "False"|mupen64plus-next-ThreadedRenderer = "True"|' retroarch-core-options.cfg;
# Joy Selection Meleu Clean Setup
#wget -O- "https://raw.githubusercontent.com/meleu/RetroPie-joystick-selection/master/install.sh" | sudo bash
# Amiga Aga ra cfg minor update
cd /opt/retropie/configs/amiga-aga
sed -i 's|input_remapping_directory = "/opt/retropie/configs/amiga1200/"|input_remapping_directory = "/opt/retropie/configs/amiga-aga/"|' retroarch.cfg;
# Intellivision lr-freeintv fix due to latest video driver 
cd /opt/retropie/configs/intellivision
sed -i 's|lr-freeintv = "/opt/|lr-freeintv = "XINIT:/opt/|' emulators.cfg;
# RA Main cfg Uniformity PlayBox v2: Hide Mouse Cursor On Overlay, Core Ratio, Menu Driver, RA 10db Vol Gain
sed -i 's|input_overlay_show_mouse_cursor = "true"|input_overlay_show_mouse_cursor = "false"|g; s|aspect_ratio_index = "[0-9]*"|aspect_ratio_index = "22"|g; s|materialui_menu_color_theme = "[0-9]*"|materialui_menu_color_theme = "19"|g; s|menu_driver = ".*"|menu_driver = "ozone"|g; s|menu_linear_filter = "true"|menu_linear_filter = "false"|g; s|menu_rgui_shadows = "false"|menu_rgui_shadows = "true"|g; s|ozone_menu_color_theme = "[0-9]*"|ozone_menu_color_theme = "3"|g; s|rgui_menu_color_theme = "[0-9]*"|rgui_menu_color_theme = "1"|g; s|rgui_particle_effect = "[0-9]*"|rgui_particle_effect = "1"|g' /opt/retropie/configs/all/retroarch.cfg;
sed -i 's|input_overlay_show_mouse_cursor = "true"|input_overlay_show_mouse_cursor = "false"|g; s|aspect_ratio_index = "[0-9]*"|aspect_ratio_index = "22"|g; s|materialui_menu_color_theme = "[0-9]*"|materialui_menu_color_theme = "19"|g; s|menu_driver = ".*"|menu_driver = "ozone"|g; s|menu_linear_filter = "true"|menu_linear_filter = "false"|g; s|menu_rgui_shadows = "false"|menu_rgui_shadows = "true"|g; s|ozone_menu_color_theme = "[0-9]*"|ozone_menu_color_theme = "3"|g; s|rgui_menu_color_theme = "[0-9]*"|rgui_menu_color_theme = "1"|g; s|rgui_particle_effect = "[0-9]*"|rgui_particle_effect = "1"|g' /opt/retropie/configs/all/retroarch/retroarch.cfg;
if ! grep "audio_volume = "0.000000"" /opt/retropie/configs/all/retroarch/retroarch.cfg; then
sed -i 's|audio_volume = "[0-9]*.[0-9]*"|audio_volume = "6.000000"|' /opt/retropie/configs/all/retroarch.cfg;
sed -i 's|audio_volume = "[0-9]*.[0-9]*"|audio_volume = "6.000000"|' /opt/retropie/configs/all/retroarch/retroarch.cfg;
echo "Already has a custom volume setting..."; sleep 1
fi
# Enable exFAT Support
sudo apt-get install exfat-fuse -y
sudo apt-get install exfat-utils -y
# Clean Mesa Old Lib Files
cd /usr/local/lib
sudo rm libEGL.so libEGL.so.1 libEGL.so.1.0.0 libgbm.so libgbm.so.1 libgbm.so.1.0.0 libGL.so libGL.so.1 libGL.so.1.2.0 libglapi.so libglapi.so.0 libGLESv1_CM.so libGLESv1_CM.so.1 libGLESv1_CM.so.1.1.0 libGLESv2.so libGLESv2.so.2 libGLESv2.so.2.0.0 libvulkan_broadcom.so libglapi.so.0.0.0
sudo rm -rf /usr/local/lib/dri
cd /usr/local/share
sudo rm -rf vulkan drirc.d
cd /usr/local/include
sudo rm -rf EGL GL GLES GLES2 GLES3 KHR
cd /usr/local/lib/pkgconfig
sudo rm gl.pc dri.pc egl.pc gbm.pc glesv1_cm.pc glesv2.pc
# Mame2003_Plus Controller
cd /opt/retropie/configs/arcade
sed -i 's|^mame2003-plus_analog = "analog"|mame2003-plus_analog = "digital"|' retroarch-core-options.cfg;
# Pico8 & DuckStation Standalone & Core
sudo chown pi:pi -R /opt/retropie/emulators/pico8/
sudo chmod 755 /opt/retropie/emulators/pico8/*
if [ -d ~/RetroPie/localroms ]; then
mkdir $HOME/RetroPie/localroms/pico8 && mkdir $HOME/addonusb/pico8
cd $HOME/RetroPie/localroms/pico8
	if [ -f $HOME/RetroPie/localroms/pico8/+Start\ PICO8.sh ]; then echo "Already installed!"; sleep 1
	else 
	wget https://github.com/2play/PBv2-PostFixes/raw/clean/home/pi/RetroPie/localroms/pico8/%2BStart%20PICO8.sh
	chmod 755 ~/RetroPie/localroms/pico8/+Start\ PICO8.sh
	fi
else
cd ~/RetroPie/roms && mkdir pico8
cd pico8
	if [ -f $HOME/RetroPie/roms/pico8/+Start\ PICO8.sh ]; then echo "Already installed!"; sleep 1
	else 
	wget https://github.com/2play/PBv2-PostFixes/raw/clean/home/pi/RetroPie/roms/pico8/%2BStart%20PICO8.sh
	chmod 755 ~/RetroPie/roms/pico8/+Start\ PICO8.sh
	fi
fi
sudo chown pi:pi -R /opt/retropie/emulators/duckstation/
sudo chmod 755 /opt/retropie/emulators/duckstation/*
if ! grep -E 'duckstation = "XINIT:/opt/retropie/emulators/duckstation/duckstation-qt %ROM%"' /opt/retropie/configs/psx/emulators.cfg; then
echo 'duckstation = "XINIT:/opt/retropie/emulators/duckstation/duckstation-qt %ROM%"' | tee -a /opt/retropie/configs/psx/emulators.cfg > /dev/null
else
echo "Already inserted..."; sleep 1
fi
sudo chmod 755 /opt/retropie/latestcores/duckstation_libretro.so
if ! grep -E 'lr-duckstation = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/latestcores/duckstation_libretro.so --config /opt/retropie/configs/psx/retroarch.cfg %ROM%"' /opt/retropie/configs/psx/emulators.cfg; then
echo 'lr-duckstation = "/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/latestcores/duckstation_libretro.so --config /opt/retropie/configs/psx/retroarch.cfg %ROM%"' | tee -a /opt/retropie/configs/psx/emulators.cfg > /dev/null
else
echo "Already inserted..."; sleep 1
fi
# New Monitoring Tools
if [ -f /usr/local/bin/glances ]; then echo "Already installed!"; sleep 1
else 
sudo ln -sfn /home/pi/.local/bin/glances /usr/local/bin/glances
fi
if [ -f /home/pi/.local/bin/glances ]; then echo "Already installed!"; sleep 1
else 
pip install glances
#pip install 'glances[action,browser,cloud,cpuinfo,docker,export,folders,gpu,graph,ip,raid,snmp,web,wifi]'
#pip uninstall glances
fi
echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
if [ -f /usr/local/bin/bpytop ]; then echo "Already installed!"; sleep 1
else 
cd $HOME/code/
git clone https://github.com/aristocratos/bpytop.git
cd bpytop
sudo make install
#sudo make uninstall
cd ..
rm -rf bpytop/
fi

echo
clear
}

# Global Shader
function global_shader() {
    local choice
		choice=$(dialog --backtitle "$BACKTITLE" --title " GLOBAL SHADER OPTION " \
            --ok-label OK --cancel-label Exit \
			--menu "Choose Enable or Disable!" 25 75 20 \
            - "*** GLOBAL RETRO SHADER ***" \
            - "" \
			1 " -  Enable The Chris Kekrides Global Retro Shader" \
            2 " -  Disable The Chris Kekrides Global Retro Shader" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) glb_shon  ;;
            2) glb_shoff  ;;
            -) none ;;
            *) break ;;
        esac
    clear
}

function glb_shon() {
cd /opt/retropie/configs/all/retroarch/config/
if [ -f global.glslp.OFF ]; then rm global.glslp.OFF
fi
clear
echo ""
echo "[OK DONE!...]"
cd $HOME
sleep 2
}

function glb_shoff() {
cd /opt/retropie/configs/all/retroarch/config/
if [ -f global.glslp ]; then mv global.glslp global.glslp.OFF
fi
clear
echo ""
echo "[OK DONE!...]"
cd $HOME
sleep 2
}


# Amiga Emulator Setup Option
function amiga_setup() {
    local choice
		choice=$(dialog --backtitle "$BACKTITLE" --title " AMIGA SETUP OPTIONS MENU " \
            --ok-label OK --cancel-label Back \
            --menu "Select The Amiga Setup You Want to Apply..." 25 75 20 \
            - "*** AMIGA 2PLAY! SETUP OPTIONS MENU SELECTIONS ***" \
			- "	" \
           1 " -  Set Lr-PUAE as main emulator " \
           2 " -  Set Amiberry as main emulator " \
		   - "	" \
		   - "*** AMIGA CUSTOM LR-PUAE SETUP ***" \
		   - "	" \
           3 " -  Custom Overlay Set For The Loaded Image (Art/View/Shader) " \
		   - "    Tx to Quizaseraq (Loaded-Set), Ransom & Pipmick (Creators) " \
		   4 " -  Disable Shader from Custom Setup Option #3 " \
		   - "	" \
           5 " -  SKIP THIS STEP: If You Enabled Already Any Of The Above! " \
		   2>&1 > /dev/tty)

        case "$choice" in
           1) lrpuae_on  ;;
           2) amiberry_on  ;;
		   3) lrpuae_custom_on  ;;
		   4) lrpuae_custom_sh_off  ;;
		   5) skip_step  ;;
           -) none ;;
           *) break ;;
        esac
    clear
}

function lrpuae_on() {
	clear
	cd /opt/retropie/configs/
	find -name "emulators.cfg" -exec sed -i 's|default = "amiberry"|default = "lr-puae"|' {} 2>/dev/null \;
	#find \( -name cdtv -prune \) -o -name "emulators.cfg" -exec sed -i 's|default = "amiberry"|default = "lr-puae"|' {} 2>/dev/null \;
	mv /opt/retropie/configs/all/retroarch/config/PUAE/ /opt/retropie/configs/all/retroarch/config/PUAE.OFF/
	find amiga -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g' {} 2>/dev/null \;
	find amiga1200 -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g' {} 2>/dev/null \;
	find amiga-aga -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1010"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "713"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "455"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "183"|g' {} 2>/dev/null \;
	find amigacd32 -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width|custom_viewport_width|g; s|.*#custom_viewport_height|custom_viewport_height|g; s|.*#custom_viewport_x|custom_viewport_x|g; s|.*#custom_viewport_y|custom_viewport_y|g' {} 2>/dev/null \;
	find cdtv -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width|custom_viewport_width|g; s|.*#custom_viewport_height|custom_viewport_height|g; s|.*#custom_viewport_x|custom_viewport_x|g; s|.*#custom_viewport_y|custom_viewport_y|g' {} 2>/dev/null \;
	clear
	echo ""
	echo "[OK DONE!...]"
	cd $HOME
	sleep 2
	exit
}

function amiberry_on() {
	clear
	cd /opt/retropie/configs/
	find -name "emulators.cfg" -exec sed -i 's|default = "amiberry"|default = "lr-puae"|' {} 2>/dev/null \;
	#find \( -name cdtv -prune \) -o -name "emulators.cfg" -exec sed -i 's|default = "amiberry"|default = "lr-puae"|' {} 2>/dev/null \;
	clear
	echo ""
	echo "[OK DONE!...]"
	cd $HOME
	sleep 2
	exit
}

function lrpuae_custom_on() {
	clear
	cd /opt/retropie/configs/
	find -name "emulators.cfg" -exec sed -i 's|default = "amiberry"|default = "lr-puae"|' {} 2>/dev/null \;
	#find \( -name cdtv -prune \) -o -name "emulators.cfg" -exec sed -i 's|default = "amiberry"|default = "lr-puae"|' {} 2>/dev/null \;
	mv /opt/retropie/configs/all/retroarch/config/PUAE.OFF/ /opt/retropie/configs/all/retroarch/config/PUAE/
	find amiga -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|^input_overlay|#input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g' {} 2>/dev/null \;
	find amiga1200 -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|^input_overlay|#input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g' {} 2>/dev/null \;
	find amiga-aga -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|^input_overlay|#input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*#custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*#custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*#custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g; s|.*custom_viewport_width = "[0-9]*"|custom_viewport_width = "1340"|g; s|.*custom_viewport_height = "[0-9]*"|custom_viewport_height = "1000"|g; s|.*custom_viewport_x = "[0-9]*"|custom_viewport_x = "289"|g; s|.*custom_viewport_y = "[0-9]*"|custom_viewport_y = "34"|g' {} 2>/dev/null \;
	find amigacd32 -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width|custom_viewport_width|g; s|.*#custom_viewport_height|custom_viewport_height|g; s|.*#custom_viewport_x|custom_viewport_x|g; s|.*#custom_viewport_y|custom_viewport_y|g' {} 2>/dev/null \;
	find cdtv -name "retroarch.cfg" -exec sed -i 's|.*#input_overlay_enable|input_overlay_enable|g; s|.*#input_overlay|input_overlay|g; s|.*#aspect_ratio_index|aspect_ratio_index|g; s|.*#custom_viewport_width|custom_viewport_width|g; s|.*#custom_viewport_height|custom_viewport_height|g; s|.*#custom_viewport_x|custom_viewport_x|g; s|.*#custom_viewport_y|custom_viewport_y|g' {} 2>/dev/null \;
	clear
	echo ""
	echo "[OK DONE!...]"
	cd $HOME
	sleep 2
	exit
}

function lrpuae_custom_sh_off() {
	clear
	cd /opt/retropie/configs/all/retroarch/config/PUAE
	mv PUAE.glslp PUAE.glslp.OFF
	clear
	echo ""
	echo "[OK DONE!...]"
	cd $HOME
	sleep 2
	exit
}

function skip_step() {
	clear
	echo ""
	echo "[OK YOU GOT IT!...]"
	cd $HOME
	sleep 2
	exit
}


post_fix_update

echo ""
echo "[OK DONE!...]"
cd $HOME
sleep 2
