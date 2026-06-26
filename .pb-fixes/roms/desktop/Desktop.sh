#!/bin/bash
#exec startx /usr/bin/mate-session -- :0 vt$(fgconsole)

# Stop background music before starting X
/home/pi/PlayBox-Setup/.pb-fixes/_scripts/bgm-muteX.sh stop

# Launch desktop session
startx

# When X exits, restart background music
/home/pi/PlayBox-Setup/.pb-fixes/_scripts/bgm-muteX.sh start
