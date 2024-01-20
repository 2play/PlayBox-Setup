#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2024 2Play! (S.R.)
# 26.03.2022
echo "
        $(tput setaf 1)__________.__                 $(tput setaf 7)__________
        $(tput setaf 1)\______   \  | _____   ___.__.$(tput setaf 7)\______   \ ________  ___
        $(tput setaf 1) |     ___/  | \__  \ <   |  | $(tput setaf 7)|    |  _//  _  \  \/  /
        $(tput setaf 1) |    |   |  |__/ __ \ \___  | $(tput setaf 7)|    |   (  <_>  >    <
        $(tput setaf 1) |____|   |____(____  )/ ____| $(tput setaf 7)|______  /\_____/__/\_ \ 
        $(tput setaf 1)                    \/ \/      $(tput setaf 7)       \/             \/
                                                      By $(tput setaf 1)2$(tput setaf 7)Play!

$(tput setaf 2)`uname -srmo` - `lsb_release -ds`
$(tput setaf 2)Your $(tput setaf 1)Play$(tput setaf 7)Box $(tput setaf 2)is `uptime -p` since `uptime -s` 😃
User `exec -- last | head -1`
$(tput bold)$(tput setaf 5)
Date & Time     : `date +"%A, %e %B %Y, %r"`
$(tput bold)$(tput setaf 7)
...SYSTEM INFO...$(tput sgr0)$(tput setaf 3)
                            $(tput bold)Size 	Used	Avail 	Used%
SD Boot         Partition: `df -h | grep '/dev/mmcblk[0-9]*p1' | awk '{print " "$2,"	"$3," 	"$4," 	 "$5}'`
SD/USB Root     Partition: `df -h | grep '/dev/root' 	 | awk '{print " "$2,"	"$3,"	"$4," 	 "$5}'`
Ext-USB/USBBoot Partition: `df -h | grep '/dev/sda1' 	 | awk '{print " "$2,"	"$3,"	"$4," 	 "$5}'`$(tput sgr0)

$(tput bold)$(tput setaf 7)`grep Model /proc/cpuinfo`$(tput sgr0)
CPU & Board     : `tr -d '\0' </proc/device-tree/model`
GPU Version     : Mali™-T860 ARM MP4 GPU

$(tput bold)$(tput setaf 1)SoC Temperature : `exec -- /home/pi/PlayBox-Setup/.pb-fixes/_scripts/temperature.sh`
CPU-A53 C. Speed: `cpumxs=$(($(cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_cur_freq)/1000)); printf "$cpumxs MHz"`
CPU-A72 C. Speed: `cpumxs=$(($(cat /sys/devices/system/cpu/cpufreq/policy4/cpuinfo_cur_freq)/1000)); printf "$cpumxs MHz"`
GPU     C. Speed: `gpumxs=$(($(cat /sys/class/devfreq/ff9a0000.gpu/cur_freq)/1000000)); printf "$gpumxs  MHz"`$(tput sgr0)
$(tput setaf 6)
Memory          : `cat /proc/meminfo | grep MemFree | awk '{printf( "%.2f\n", $2 / 1024 )}'`MB (Free) / `cat /proc/meminfo | grep MemTotal | awk '{printf( "%.2f\n", $2 / 1024 )}'`MB (Total)
Local IP        : `hostname -I` 
$(tput setaf 7)
...WEATHER INFO...
$(tput setaf 5)
- City -         Temp  Condition
LONDON, UK     : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=EUR|UK|UK001|LONDON" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
ATHENS, GR     : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=EUR|GR|GR007|ATHINAI" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
N.Y., US       : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=0&locCode=NAM|US|NY|NEWYORK" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
TOKYO, JP      : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=ASI|JP|JA041|TOKYO" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
MELBOURNE, AU  : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=OCN|AU|VIC|MELBOURNE" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
$(tput sgr0)"
echo
read -n 1 -s -r -p "Press any key to continue"
