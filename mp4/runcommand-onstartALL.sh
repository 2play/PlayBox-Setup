ifexist=`ls /home/pi/PlayBox-Setup/mp4/$1.mp4 |wc -l`
if [[ $ifexist > 0 ]];then
loader --blank /home/pi/lmp4/$1.mp4
else
loader --blank /home/pi/PlayBox-Setup/getready2play.mp4
fi