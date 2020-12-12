# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 06.12.2020
echo "Welcome to PlayBox v2 Post Fixes & Tweaks"
sleep 2
cd $HOME/code/
git clone https://github.com/2play/PBv2-PostFixes.git
cd PBv2-PostFixes/
rsync -urv --exclude '.git' --exclude 'etc' --exclude 'LICENSE' --exclude 'README.md' . /
sleep 1
cd etc/
sudo rsync -urv . /
echo
echo "[OK DONE!...]"
sleep 2
cd ../..
rm -rf PBv2-PostFixes
cd $HOME
