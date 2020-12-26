#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2020 2Play! (S.R.)
# 26.12.20
celsius1=$(cat /sys/class/thermal/thermal_zone0/temp | sed 's/.\{3\}$/.&/')
celsius2=$(cat /sys/class/thermal/thermal_zone1/temp | sed 's/.\{3\}$/.&/')
fahrenheit1=$(echo "scale=2;((9/5) * $celsius1) + 32" |bc)
fahrenheit2=$(echo "scale=2;((9/5) * $celsius2) + 32" |bc)
echo "Zone 0: ${celsius1}°C (${fahrenheit1}°F) - Zone 1: ${celsius2}°C (${fahrenheit2}°F)"
