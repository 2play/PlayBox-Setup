ifexist=`ls ~/lmp4/$1.mp4 |wc -l`
if [[ $ifexist > 0 ]];then mpv ~/lmp4/$1.mp4 >/dev/null 2>&1; touch ~/.musicpaused.flag;
else
mpv ~/PlayBox-Setup/getready2play.mp4 >/dev/null 2>&1;
fi