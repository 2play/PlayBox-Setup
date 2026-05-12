#!/usr/bin/env bash
# AdvanceMAME + Aimtrak setup script
# Updated by 2Play! - 05.05.2026

set -e  # exit on error
set -u  # treat unset vars as errors

echo "[.] Checking AdvanceMAME 1.4 installation..."
sleep 2

if [[ ! -d "$HOME/RetroPie/roms/mame-advmame" ]]; then
    echo "[!] AdvanceMAME not found. Installing version 1.4..."
    sleep 3
    sudo "$HOME/RetroPie-Setup/retropie_packages.sh" 101
else
    echo "[✓] AdvanceMAME already installed."
fi

echo
echo "[.] Installing required packages for Aimtrak gun configuration..."
sleep 2
sudo apt update -qq
sudo apt -y install apt-transport-https python3-dev python3-pygame python3-setuptools

echo
echo "[.] Updating AdvanceMAME config for Aimtrak detection..."
sleep 2
cfg="$HOME/.advance/advmame-1.4.rc"
sed -i \
    -e 's/device_mouse auto/device_mouse raw/' \
    -e 's/device_raw_mousedev

\[0\]

 auto/device_raw_mousedev[0] \/dev\/input\/mouse0/' \
    -e 's/device_raw_mousedev

\[1\]

 auto/device_raw_mousedev[1] \/dev\/input\/mouse1/' \
    -e 's/device_raw_mousedev

\[2\]

 auto/device_raw_mousedev[2] \/dev\/input\/mouse2/' \
    -e 's/device_raw_mousedev

\[3\]

 auto/device_raw_mousedev[3] \/dev\/input\/mouse3/' \
    -e 's/device_raw_mousetype

\[0\]

 pnp/device_raw_mousetype[0] ps2/' \
    -e 's/device_raw_mousetype

\[1\]

 pnp/device_raw_mousetype[1] ps2/' \
    -e 's/device_raw_mousetype

\[2\]

 pnp/device_raw_mousetype[2] ps2/' \
    -e 's/device_raw_mousetype

\[3\]

 pnp/device_raw_mousetype[3] ps2/' \
    "$cfg"

echo
echo "[.] Checking for cheats.dat..."
sleep 2
if [[ ! -f "$HOME/.advance/cheat.dat" ]]; then
    echo "[!] Cheats not found. Installing..."
    wget -q -O "$HOME/.advance/cheat.dat" \
        https://raw.githubusercontent.com/libretro/mame2003-libretro/master/metadata/cheat.dat
    sed -i 's/misc_cheat no/misc_cheat yes/' "$cfg"
else
    echo "[✓] Cheats already installed."
fi

echo
echo "[.] Installing gun configuration application..."
sleep 2
cd "$HOME/code"
git clone https://github.com/2play/gunconf.git
cd gunconf
sudo cp utils/aimtrak.rules /etc/udev/rules.d/99-aimtrak.rules
sudo udevadm control --reload-rules
sudo pip3 install --upgrade pip setuptools wheel
sudo pip3 install git+https://github.com/parogers/pgu.git
#sudo python3 setup.py install
sudo pip3 install .
#cp ~/PlayBox-Setup/.pb-fixes/retropiemenu/Controller Tools/LightGunConf.sh "~/RetroPie/retropiemenu/Controller Tools/"
cd ~/code
sudo rm -rf gunconf
cd "$HOME"

echo
echo "[.] Checking for shooter ROMs..."
sleep 2
romdir="$HOME/RetroPie/roms/mame-advmame"
declare -A ROMS=(
    ["alien3.zip"]="https://www.doperoms.org/files/roms/mame/alien3.zip/687364/alien3.zip"
    ["le2.zip"]="https://www.doperoms.org/files/roms/mame/le2.zip/685590/le2.zip"
    ["duckhunt.zip"]="https://www.doperoms.org/files/roms/mame/duckhunt.zip/682101/duckhunt.zip"
)
for rom in "${!ROMS[@]}"; do
    if [[ ! -f "$romdir/$rom" ]]; then
        echo "[!] Downloading $rom..."
        wget -q -O "$romdir/$rom" "${ROMS[$rom]}"
    else
        echo "[✓] $rom already present."
    fi
done

echo
echo "[✓] All done. System will reboot in 10 seconds..."
sleep 10
sudo reboot
