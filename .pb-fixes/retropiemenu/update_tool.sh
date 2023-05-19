#!/bin/bash
source <(sed '/GENRE_MAPPINGS/q' /home/pi/.update_tool/update_tool.ini | grep = | sed 's/ *= */=/g') 2>/dev/null
$home_exe $home_dir/$home_command $mega_dir $1