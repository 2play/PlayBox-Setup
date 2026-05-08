#!/bin/bash
#./mesa_v.sh glxinfo -B
#./mesa_v.sh mygame --fullscreen
#./mesa-run.sh glmark2
# Run any command with custom Mesa libraries

MESA_DIR="/home/pi/mesa/lib/arm-linux-gnueabihf"

export LD_LIBRARY_PATH="$MESA_DIR"
export LIBGL_DRIVERS_PATH="$MESA_DIR/dri"
export GBM_DRIVERS_PATH="$MESA_DIR"

# Replace the shell with the command you pass in
exec "$@"