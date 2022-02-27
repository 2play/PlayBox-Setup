#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2022 2Play! (S.R.)
# 26.02.2022

infobox=""
infobox="${infobox}\n"
infobox="${infobox}OverClocking Your Pi Board\n\n"
infobox="${infobox}\n"
infobox="${infobox}This will apply necessary configuration to enable/disable overclocking.\n\n"
infobox="${infobox}A 3A or more PSU & a heatsink/fan combo for good CPU cooling is recommended!\n\n"
infobox="${infobox}>>> For the anything above 1100 good cooling heatsink/fan setup is mandatory! <<<\n\n"
infobox="${infobox}Options:\nPi Zero at 1100/1300MHz \n\n"
infobox="${infobox}**Enable**\n"
infobox="${infobox}Overclocks the CPU\n"
infobox="${infobox}**Disable**\n"
infobox="${infobox}Disables Overclocking"
infobox="${infobox}\n"

dialog --backtitle "Pi OverClocking" \
--title "Pi OverClocking By 2Play! Based on RPC80 Code" \
--msgbox "${infobox}" 35 110

# Config file path
CONFIG_PATH=/boot/config.txt

# Overclocking settings description
OVERCLOCK_DESCRIPTION="#uncomment to enable custom overclock settings"

declare -a OVERCLOCK_SETTINGS=(
	"core_freq=450"
	"over_voltage=6"
)

declare -a OVERCLOCK_SETTINGS1=(
    "gpu_freq=450"
	"core_freq=450"
	"sdram_freq=450"
	"sdram_schmoo=0x02000020"
	"over_voltage=6"
	"sdram_over_voltage=2"
)


function main_menu() {
    local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " OVERCLOCKING MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Choose your OverClocking Option:" 25 75 20 \
            - "*** OVERCLOCKING OPTIONS Pi Zero  ***" \
            1 " - Enable - Pi Zero [1100MHz]" \
            2 " - Enable - Pi Zero [1300MHz]" \
            3 " - Disable OverClocking" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) enable_oc 1100;;
            2) enable_oc 1300;;
            3) disable_oc ;;
            -) none ;;
            *) break ;;
        esac
    done
}

# Enables Overclocking by adding properties to /boot/config.txt
function enable_oc() {
  dialog --infobox "...Applying..." 3 20 ; sleep 2
#  overclock_setup
  sudo sed -i "s|#*arm_freq=.*|arm_freq=$1|" "${CONFIG_PATH}";
  for val in ${OVERCLOCK_SETTINGS[@]}; do
    if grep -q "#${val}" ${CONFIG_PATH}; then
      sudo sed -i "s|#${val}|${val}|" "${CONFIG_PATH}"; 
    fi
  done
  sudo sed -i "s|^over_voltage=6|#over_voltage=6|" "${CONFIG_PATH}"; 
  echo
clear
echo
read -n 1 -s -r -p "Press any key to reboot"
  echo
  echo "[OK] Rebooting Raspberry Pi ... "
  sudo reboot
}

# Enables Overclocking by adding properties to /boot/config.txt
function enable_oc+() {
  dialog --infobox "...Applying..." 3 20 ; sleep 2
#  overclock_setup
  sudo sed -i "s|#*arm_freq=.*|arm_freq=$1|" "${CONFIG_PATH}";
  for val in ${OVERCLOCK_SETTINGS1[@]}; do
    if grep -q "#${val}" ${CONFIG_PATH}; then
      sudo sed -i "s|#${val}|${val}|" "${CONFIG_PATH}"; 
    fi
  done
  sudo sed -i "s|^over_voltage=4|#over_voltage=2|" "${CONFIG_PATH}"; 
  echo
clear
echo
read -n 1 -s -r -p "Press any key to reboot"
  echo
  echo "[OK] Rebooting Raspberry Pi ... "
  sudo reboot
}

# Disables overclocking by commenting out overclock values
function disable_oc() {
  dialog --infobox "...Applying..." 3 20 ; sleep 2
#  overclock_setup
  sudo sed -i "s|^arm_freq=|#arm_freq=|" "${CONFIG_PATH}";
  for val in ${OVERCLOCK_SETTINGS[@]}; do
    sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
  done
  for val in ${OVERCLOCK_SETTINGS1[@]}; do
    sudo sed -i "s|^${val}|#${val}|" "${CONFIG_PATH}";
  done
  sudo sed -i "s|^gpu_freq=450|#gpu_freq=450|" "${CONFIG_PATH}"; 
  sudo sed -i "s|^over_voltage=[0-9]*|#over_voltage=[0-9]*|" "${CONFIG_PATH}"; 
  #sudo sed -i "s|^over_voltage=6|#over_voltage=6|" "${CONFIG_PATH}"; 
  echo
clear
echo
read -n 1 -s -r -p "Press any key to reboot"
  echo
  echo "[OK] Rebooting Raspberry Pi ... "
  sudo reboot
}

# Adds overclock entries to config.txt (Not Used)
function overclock_setup() {
  if ! grep -q "${OVERCLOCK_DESCRIPTION}" ${CONFIG_PATH}; then
    sudo echo -e "\n${OVERCLOCK_DESCRIPTION}" >> ${CONFIG_PATH}
    for val in ${OVERCLOCK_SETTINGS[@]}; do
      if ! grep -q "${val}" ${CONFIG_PATH}; then
        sudo echo $val >> ${CONFIG_PATH}
      fi
    done
  fi
}


main_menu
