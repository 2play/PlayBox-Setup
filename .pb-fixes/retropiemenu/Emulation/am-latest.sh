#!/bin/bash
# Pi4 Install or Update Attract Mode Script By 2Play! 
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 25.06.2020

infobox=""
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}This script will install or update your Attract Mode.\n"
infobox="${infobox}This script is for Pi3 or Pi4.\n"
infobox="${infobox}\n"
infobox="${infobox}\n\n"
infobox="${infobox}INFO:\nIt will install or update your Attract Mode or any extras such as the SFML-Pi & FFMPEG with mmal HW Video Encoding Support.\n -To Enable mmal you need also to set it in the attract.cfg in the general section 'video_decoder        mmal'.\n -Can be done also, while in AM, by pressing TAB.\n"
infobox="${infobox}\n"
infobox="${infobox}\n"

dialog --backtitle "Install or Update Attract Mode" \
--title "Install or Update Attract Mode Pi3/4 Script by 2Play!" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " ATTRACT MODE SETUP " \
            --ok-label OK --cancel-label Exit \
            --menu "Let's Install or Update your Attract Mode and Extras!" 25 75 20 \
            - "*** ATTRACT MODE INSTALL SELECTIONS ***" \
            1 " - Install or Update Attract Mode Pi4 (DRM/KMS)" \
            2 " - Install or Update Attract Mode Pi4 (DISPMANX)" \
            3 " - Install or Update Attract Mode Pi3 (DISPMANX)" \
            4 " - Update/Install FFMPEG with HW VE MMAL Support" \
            5 " - Update/Install SMFL-Pi (DRM/KMS)" \
            6 " - Update/Install SMFL-Pi (DISPMANX)" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) AM_KMS_Pi4  ;;
            2) AM_X11_Pi4  ;;
            3) AM_X11_Pi3  ;;
            4) FFMPEG  ;;
            5) SFML_KMS  ;;
            6) SFML_X11  ;;
            -) none  ;;
            *) break ;;
        esac
    done
}


function AM_KMS_Pi4() {
	cd ~; mkdir code
	cd ~/code
	echo
	echo "*** Install or Update FFMPEG with mmal HW Video Decoding ***"
	echo
	sleep 2
	#Orig
	#git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git
	git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git ffmpeg
	cd ffmpeg
	#Older Options
	#./configure --enable-mmal --disable-debug --enable-shared
	./configure --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree --enable-mmal
	make -j5
	sudo make install
	sudo ldconfig
	#Lock the package so it won't get replaced by another version during software updates
	#echo "ffmpeg hold" | sudo dpkg --set-selections
	echo
	read -n 1 -s -r -p "Press any key to continue and install SFML-PI"
	clear
	echo
	echo "*** Install or Update SFML-PI Dependencies! ***"
	echo
	sleep 2
	sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libjpeg8-dev libfreetype6-dev libudev-dev libdrm-dev libgbm-dev libegl1-mesa-dev
	cd ~; mkdir code
	cd ~/code
	echo
	echo "*** Install or Update SFML-PI! ***"
	echo
	sleep 2
	git clone --depth 1 https://github.com/mickelson/sfml-pi sfml-pi
	mkdir sfml-pi/build; cd sfml-pi/build
	cmake .. -DSFML_DRM=1
	#OpenGL will be used by default with this mode. If you want to use OpenGL ES instead, you need to enable below instead.
	#cmake .. -DSFML_DRM=1 -DSFML_OPENGL_ES=1
	sudo make install
	sudo ldconfig
	echo
	read -n 1 -s -r -p "Press any key to continue and install ATTRACT MODE"
	clear
	echo "*** Install or Update Attract Mode ***"
	echo
	echo "*** Install or Update Attract Mode Pi4 Dependencies! ***"
	echo
	sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libavutil-dev libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libavresample-dev libopenal-dev libfreetype6-dev libudev-dev libjpeg-dev libudev-dev libfontconfig1-dev libglu1-mesa-dev libsfml-dev libxinerama-dev libcurl4-openssl-dev
	sleep 2
	cd code	
	git clone --depth 1 https://github.com/mickelson/attract attract
	cd attract
	make USE_DRM=1 USE_MMAL=1
	sudo make install USE_DRM=1 USE_MMAL=1
	cd util/linux/drm
	make
	sudo make install
	echo
	sleep 2
	echo
	echo "Completed! Cleaning up & Rebooting..."
	echo
	cd ~;rm -rf ./code/attract && rm -rf ./code/ffmpeg && rm -rf ./code/sfml-pi
	sleep 3
	echo
	echo "Done! Rebooting Now..."
	echo
	sudo reboot now
}

function AM_X11_Pi4() {
	cd ~; mkdir code
	cd ~/code
	echo
	echo "*** Install or Update FFMPEG with mmal HW Video Decoding ***"
	echo
	sleep 2
	#Orig
	#git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git
	git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git ffmpeg
	cd ffmpeg
	#Older Options
	#./configure --enable-mmal --disable-debug --enable-shared
	./configure --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree --enable-mmal
	make -j5
	sudo make install
	sudo ldconfig
	#Lock the package so it won't get replaced by another version during software updates
	#echo "ffmpeg hold" | sudo dpkg --set-selections
	echo
	read -n 1 -s -r -p "Press any key to continue and install SFML-PI"
	clear
	echo
	echo "*** Install or Update SFML-PI Dependencies! ***"
	echo
	sleep 2
	#Older dependencies
	#sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libfreetype6-dev libudev-dev libjpeg-dev libudev-dev libfontconfig1-dev
	sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libjpeg8-dev libfreetype6-dev libudev-dev libraspberrypi-dev
	cd ~; mkdir code
	cd ~/code
	echo
	echo "*** Install or Update SFML-PI! ***"
	echo
	sleep 2
	git clone --depth 1 https://github.com/mickelson/sfml-pi sfml-pi
	mkdir sfml-pi/build; cd sfml-pi/build
	cmake .. -DSFML_RPI=1 -DEGL_INCLUDE_DIR=/opt/vc/include -DEGL_LIBRARY=/opt/vc/lib/libbrcmEGL.so -DGLES_INCLUDE_DIR=/opt/vc/include -DGLES_LIBRARY=/opt/vc/lib/libbrcmGLESv2.so
	sudo make install
	sudo ldconfig
	echo
	read -n 1 -s -r -p "Press any key to continue and install ATTRACT MODE"
	clear
	echo "*** Install or Update Attract Mode ***"
	echo
	echo "*** Install or Update Attract Mode Pi4 Dependencies! ***"
	echo
	sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libavutil-dev libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libavresample-dev libopenal-dev libfreetype6-dev libudev-dev libjpeg-dev libudev-dev libfontconfig1-dev libglu1-mesa-dev libsfml-dev libxinerama-dev libcurl4-openssl-dev
	sleep 2
	cd code	
	git clone --depth 1 https://github.com/mickelson/attract attract
	cd attract
	make USE_XINERAMA=1 USE_LIBCURL=1
	sudo make install USE_XINERAMA=1 USE_LIBCURL=1
	echo
	sleep 2
	echo
	echo "Completed! Cleaning up & Rebooting..."
	echo
	cd ~;rm -rf ./code/attract && rm -rf ./code/ffmpeg && rm -rf ./code/sfml-pi
	sleep 3
	echo
	echo "Done! Rebooting Now..."
	echo
	sudo reboot now
}

function AM_X11_Pi3() {
	cd ~; mkdir code
	cd ~/code
	clear
	echo
	echo "*** Install or Update FFMPEG with mmal HW Video Decoding ***"
	echo
	sleep 2
	#Orig
	#git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git
	git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git ffmpeg
	cd ffmpeg
	#Older Options
	#./configure --enable-mmal --disable-debug --enable-shared
	./configure --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree --enable-mmal
	make -j5
	sudo make install
	sudo ldconfig
	#Lock the package so it won't get replaced by another version during software updates
	#echo "ffmpeg hold" | sudo dpkg --set-selections
	echo
	read -n 1 -s -r -p "Press any key to continue and install SFML-PI"
	clear
	echo
	echo "*** Install or Update SFML-PI Dependencies! ***"
	echo
	sleep 2
	#Older dependencies
	#sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libfreetype6-dev libudev-dev libjpeg-dev libudev-dev libfontconfig1-dev
	sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libjpeg8-dev libfreetype6-dev libudev-dev libraspberrypi-dev
	cd ~; mkdir code
	cd ~/code
	echo
	echo "*** Install or Update SFML-PI! ***"
	echo
	sleep 2
	git clone --depth 1 https://github.com/mickelson/sfml-pi sfml-pi
	mkdir sfml-pi/build; cd sfml-pi/build
	cmake .. -DSFML_RPI=1 -DEGL_INCLUDE_DIR=/opt/vc/include -DEGL_LIBRARY=/opt/vc/lib/libbrcmEGL.so -DGLES_INCLUDE_DIR=/opt/vc/include -DGLES_LIBRARY=/opt/vc/lib/libbrcmGLESv2.so
	sudo make install
	sudo ldconfig
	echo
	read -n 1 -s -r -p "Press any key to continue and install ATTRACT MODE"
	clear
	echo
	echo "*** Install or Update Attract Mode ***"
	echo
	sleep 2
	cd code	
	git clone --depth 1 https://github.com/mickelson/attract attract
	cd attract
	make USE_GLES=1
	sudo make install USE_GLES=1
	echo
	sleep 2
	echo
	echo "Completed! Cleaning up & Rebooting..."
	echo
	cd ~;rm -rf ./code/attract && rm -rf ./code/ffmpeg && rm -rf ./code/sfml-pi
	sleep 3
	echo
	echo "All done! Rebooting Now..."
	echo
	sudo reboot now
}

function FFMPEG() {
	cd ~; mkdir code
	cd ~/code
	echo
	echo "*** Install or Update FFMPEG with mmal HW Video Decoding ***"
	echo
	sleep 2
	#Orig
	#git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git
	git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git ffmpeg
	cd ffmpeg
	#Older Options
	#./configure --enable-mmal --disable-debug --enable-shared
	./configure --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree --enable-mmal
	make -j5
	sudo make install
	sudo ldconfig
	#Lock the package so it won't get replaced by another version during software updates
	#echo "ffmpeg hold" | sudo dpkg --set-selections
	cd ~;rm -rf ./code/attract && rm -rf ./code/ffmpeg && rm -rf ./code/sfml-pi
	sleep 3
	echo
	echo "All done! Rebooting Now..."
	echo
	sudo reboot now
}

function SFML_KMS() {
	echo
	echo "*** Install or Update SFML-PI Dependencies! ***"
	echo
	sleep 2
	sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libjpeg8-dev libfreetype6-dev libudev-dev libdrm-dev libgbm-dev libegl1-mesa-dev
	cd ~; mkdir code
	cd ~/code
	echo
	echo "*** Install or Update SFML-PI! ***"
	echo
	sleep 2
	git clone --depth 1 https://github.com/mickelson/sfml-pi sfml-pi
	mkdir sfml-pi/build; cd sfml-pi/build
	cmake .. -DSFML_DRM=1
	#OpenGL will be used by default with this mode. If you want to use OpenGL ES instead, you need to enable below instead.
	#cmake .. -DSFML_DRM=1 -DSFML_OPENGL_ES=1
	sudo make install
	sudo ldconfig
	cd ~;rm -rf ./code/attract && rm -rf ./code/ffmpeg && rm -rf ./code/sfml-pi
	sleep 3
	echo
	echo "All done! Rebooting Now..."
	echo
	sudo reboot now
}

function SFML_X11() {
	echo
	echo "*** Install or Update SFML-PI Dependencies! ***"
	echo
	sleep 2
	#Older dependencies
	#sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libfreetype6-dev libudev-dev libjpeg-dev libudev-dev libfontconfig1-dev
	sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libjpeg8-dev libfreetype6-dev libudev-dev libraspberrypi-dev
	sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libjpeg8-dev libfreetype6-dev libudev-dev libraspberrypi-dev
	cd ~; mkdir code
	cd ~/code
	echo
	echo "*** Install or Update SFML-PI! ***"
	echo
	sleep 2
	git clone --depth 1 https://github.com/mickelson/sfml-pi sfml-pi
	mkdir sfml-pi/build; cd sfml-pi/build
	cmake .. -DSFML_RPI=1 -DEGL_INCLUDE_DIR=/opt/vc/include -DEGL_LIBRARY=/opt/vc/lib/libbrcmEGL.so -DGLES_INCLUDE_DIR=/opt/vc/include -DGLES_LIBRARY=/opt/vc/lib/libbrcmGLESv2.so
	sudo make install
	sudo ldconfig
	cd ~;rm -rf ./code/attract && rm -rf ./code/ffmpeg && rm -rf ./code/sfml-pi
	sleep 3
	echo
	echo "All done! Rebooting Now..."
	echo
	sudo reboot now
}

main_menu
