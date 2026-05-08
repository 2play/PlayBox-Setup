#!/bin/bash
exec env \
    LD_LIBRARY_PATH=/home/pi/mesa/lib/arm-linux-gnueabihf/ \
    LIBGL_DRIVERS_PATH=/home/pi/mesa/lib/arm-linux-gnueabihf/dri \
    GBM_DRIVERS_PATH=/home/pi/mesa/lib/arm-linux-gnueabihf/ \
    $@glxinfo -B