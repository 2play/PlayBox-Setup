#bash $HOME/RetroPie-BGM-Player/bgm_system.sh -s
touch ~/.musicpaused.flag
ifexist=`ls /home/pi/PlayBox-Setup/mp4/$1.mp4 |wc -l`
if [[ $ifexist > 0 ]];then
mpv --really-quiet /home/pi/lmp4/$1.mp4
else
mpv --really-quiet /home/pi/PlayBox-Setup/getready2play.mp4
fi