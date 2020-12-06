# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 06.12.2020
echo "Welcome to PlayBox v2 Post Fixes & Tweaks"
sleep 2
cd code
git clone https://github.com/2play/PBv2-PostFixes.git
cd PBv2-PostFixes
rsync -urv --exclude '.git' --exclude 'LICENSE' --exclude 'README.md' . /
echo
echo "[OK DONE!...]"
sleep 2
cd ..
rm -rf PBv2-PostFixes
