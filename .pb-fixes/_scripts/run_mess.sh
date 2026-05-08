#!/bin/bash
# lr-mess launcher without softlists
# Improved version with safer argument handling, stats, and logging

if [ $# -lt 6 ]; then
    echo "Usage: $0 <retroarch_bin> <mess_libretro> <retroarch.cfg> <mess_system> <bios_folder> <params... game>"
    echo "Note: path/to/game_to_launch MUST ALWAYS BE THE LAST PARAMETER!"
    exit 1
fi

_retroarchbin="$1"; shift
_messpath="$1"; shift
_config="$1"; shift
_cfgdir=$(dirname "$_config")
_system="$1"; shift
_biosdir="$1"; shift

echo "[.] Parameters dump"
echo "  retroarchbin : $_retroarchbin"
echo "  messpath     : $_messpath"
echo "  config       : $_config (+ $_config.add)"
echo "  cfg_directory: $_cfgdir"
echo "  system       : $_system"
echo "  biosdir      : $_biosdir"

_cmdarr=( "$_system" -rp "$_biosdir" -cfg_directory "$_cfgdir" )

_lastparam=""
removed_flags=0

for _param in "$@"; do
    case "$_param" in
        --appendconfig|--verbose)
            ((removed_flags++))
            continue
            ;;
    esac
    _cmdarr+=( "$_param" )
    _lastparam="$_param"
done

_romdir=$(dirname "$_lastparam")
echo "  romdir       : $_romdir"

_tmpcmd="$_romdir/tmpmess.cmd"
_tmpcfg="$_cfgdir/tmpconfig.add"
rm -f "$_tmpcmd" "$_tmpcfg"

echo "${_cmdarr[@]}" > "$_tmpcmd"

cat /dev/shm/retroarch.cfg >> "$_tmpcfg"
cat "$_config.add" >> "$_tmpcfg"

# Timestamped log file
timestamp=$(date +"%Y%m%d-%H%M%S")
_logfile="$~/logs/mess-launch-$timestamp.log"

set -- "$_retroarchbin" --verbose --config "$_config" --appendconfig "$_tmpcfg" -L "$_messpath" "$_tmpcmd"
echo "[.] Launching: $*" | tee -a "$_logfile"
"$@" 2>&1 | tee -a "$_logfile"

total_params=${#_cmdarr[@]}
{
    echo "[.] Stats:"
    echo "  Parameters passed : $total_params"
    echo "  Flags removed     : $removed_flags"
    echo "[OK DONE!] Log saved to $logfile"
} | tee -a "$_logfile"

rm -f "$_tmpcmd" "$_tmpcfg"
