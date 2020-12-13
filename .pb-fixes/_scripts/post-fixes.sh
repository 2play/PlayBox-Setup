# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 12.12.2020
echo "Welcome to PlayBox v2 Post Fixes & Tweaks"
sleep 2
cd $HOME/code/
#Get Post Fixes
git clone https://github.com/2play/PBv2-PostFixes.git
cd PBv2-PostFixes/
rsync -urv --exclude '.git' --exclude 'etc' --exclude 'LICENSE' --exclude 'README.md' . /
sleep 1
cd etc/
sudo rsync -urv . /
sleep 1
cd ../..
rm -rf PBv2-PostFixes
sleep 2
#Overlay Fixes
mv /opt/retropie/configs/all/retroarch/config/Stella\ 2014 /opt/retropie/configs/all/retroarch/config/Stella\ 2014.OFF
mv /opt/retropie/configs/all/retroarch/config/ProSystem 2014 /opt/retropie/configs/all/retroarch/config/ProSystem.OFF
mv /opt/retropie/configs/all/retroarch/config/fMSX /opt/retropie/configs/all/retroarch/config/fMSX.OFF
mv /opt/retropie/configs/all/retroarch/config/Genesis\ Plus\ GX /opt/retropie/configs/all/retroarch/config/Genesis\ Plus\ GX.OFF
echo
#Core Options Per System Config Folder
cd /opt/retropie/configs
find . -type f -name "retroarch.cfg" -print0 | xargs -0 sed -i 's|#core_options_path = "/opt/retropie/configs/|core_options_path = "/opt/retropie/configs/|g'
echo
cd /opt/retropie/configs/all/retroarch/config
rm -rf fuse
echo
echo "[OK DONE!...]"
cd $HOME
