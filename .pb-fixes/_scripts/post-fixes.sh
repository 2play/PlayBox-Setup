# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 01.01.2021
pb_version="PlayBox v2 Post Updates & Fixes: Dated 01.01.2021"
echo $pb_version
sleep 3
mkdir /home/pi/lmp4
cd $HOME/code/
# Get Post Fixes
git clone https://github.com/2play/PBv2-PostFixes.git
cd PBv2-PostFixes/
rsync -urv --exclude '.git' --exclude 'etc' --exclude 'usr' --exclude 'LICENSE' --exclude 'README.md' . /
sudo rsync -urv etc/ /etc/
sudo rsync -urv usr/ /usr/
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
# Overlay Fixes
echo
cd /opt/retropie/configs/all/retroarch/config
rm -rf fuse
ln -sfn Stella\ 2014.EMPTY Stella\ 2014
mv /opt/retropie/configs/all/retroarch/config/Stella\ 2014 /opt/retropie/configs/all/retroarch/config/Stella\ 2014.OFF
mv /opt/retropie/configs/all/retroarch/config/fMSX /opt/retropie/configs/all/retroarch/config/fMSX.OFF
mv /opt/retropie/configs/all/retroarch/config/Genesis\ Plus\ GX /opt/retropie/configs/all/retroarch/config/Genesis\ Plus\ GX.OFF
mv ~/RetroPie/roms/piegalaxy ~/RetroPie/roms/piegalaxy.OFF
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
clear
# Global Shader
function global_shader() {
    local choice
	while true; do
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
            *)  break ;;
        esac
    done
	clear
}

function glb_shon() {
cd /opt/retropie/configs/all/retroarch/config/
if [ -f global.glslp.OFF ]; then rm global.glslp.OFF
fi
clear
sleep 1
echo ""
echo "[OK DONE!...]"
cd $HOME
exit
}

function glb_shoff() {
cd /opt/retropie/configs/all/retroarch/config/
if [ -f global.glslp ]; then mv global.glslp global.glslp.OFF
fi
clear
sleep 1
echo ""
echo "[OK DONE!...]"
cd $HOME
exit
}

global_shader
