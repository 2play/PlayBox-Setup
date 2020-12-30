# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 30.12.2020
echo "Welcome to PlayBox v2 Post Fixes & Tweaks"
sleep 2
cd $HOME/code/
#Get Post Fixes
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
#Overlay Fixes
echo
cd /opt/retropie/configs/all/retroarch/config
rm -rf fuse
ln -sfn Stella\ 2014.EMPTY Stella\ 2014
mv /opt/retropie/configs/all/retroarch/config/Stella\ 2014 /opt/retropie/configs/all/retroarch/config/Stella\ 2014.OFF
mv /opt/retropie/configs/all/retroarch/config/ProSystem /opt/retropie/configs/all/retroarch/config/ProSystem.OFF
mv /opt/retropie/configs/all/retroarch/config/fMSX /opt/retropie/configs/all/retroarch/config/fMSX.OFF
mv /opt/retropie/configs/all/retroarch/config/PicoDrive /opt/retropie/configs/all/retroarch/config/PicoDrive.OFF
mv /opt/retropie/configs/all/retroarch/config/Genesis\ Plus\ GX /opt/retropie/configs/all/retroarch/config/Genesis\ Plus\ GX.OFF
mv ~/RetroPie/roms/piegalaxy ~/RetroPie/roms/piegalaxy.OFF
echo
#Core Options Per System Config Folder
cd /opt/retropie/configs
find . -type f -name "retroarch.cfg" -print0 | xargs -0 sed -i 's|#core_options_path = "/opt/retropie/configs/|core_options_path = "/opt/retropie/configs/|g'
echo
echo "[OK DONE!...]"
cd $HOME
