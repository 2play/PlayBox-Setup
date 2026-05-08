ifexist=`ls /home/pi/lmp4/$1.mp4 |wc -l`
if [[ $ifexist > 0 ]];then
mpv /home/pi/lmp4/$1.mp4 >/dev/null 2>&1;
else
#mpv /home/pi/PlayBox-Setup/getready2play.mp4 >/dev/null 2>&1;
mpv /home/pi/PlayBox-Setup/getready2playSchmoomer.mp4 >/dev/null 2>&1;
fi