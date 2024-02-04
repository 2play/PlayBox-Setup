touch ~/.musicpaused.flag
ifexist=`ls /home/pi/lmp4/$1.mp4 |wc -l`
if [[ $ifexist > 0 ]];then
loader --blank /home/pi/lmp4/$1.mp4; touch ~/.musicpaused.flag;
else
loader --blank /home/pi/PlayBox-Setup/getready2play.mp4
fi