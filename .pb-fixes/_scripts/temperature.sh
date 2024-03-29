#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2024 2Play! (S.R.)
# 14.12.19
gpu=$(/opt/vc/bin/vcgencmd measure_temp | awk -F "[=']" '{print $2}')
#cpu=$(</sys/class/thermal/thermal_zone0/temp)
#cpu=$(echo "$cpu / 100 * 0.1" | bc)

if [[ -f "/sys/class/thermal/thermal_zone0/temp" ]]; then
        cpu=$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000)) && cpuf=$((cpu*9/5+32))
fi
#cpuf=$(echo "(1.8 * $cpu) + 32" |bc)
#gpuf=$(echo "(1.8 * $gpu) + 32" |bc)
    if [[ -f "/opt/vc/bin/vcgencmd" ]]; then
        if gpu=$(/opt/vc/bin/vcgencmd measure_temp); then
            gpu=${gpu:5:2}
            gpuf=$((gpu*9/5+32))
        else
            gpu=""
        fi
    fi
echo "CPU: $cpu°C ($cpuf°F) - GPU: $gpu°C ($gpuf°F)"