#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 05.2026
# Supports Intel, AMD, NVIDIA GPUs - For CLI, KMS and X11

# Timestamp
now=$(date +"%m_%d_%Y--h%H-m%M-s%S")
OUTDIR="$HOME/ScreenShots"
OUTFILE="$OUTDIR/printscreen$now.png"

# Make sure output dir exists
mkdir -p "$OUTDIR"

# Auto detect card and render devices
card=$(readlink -f /dev/dri/by-path/$(ls /dev/dri/by-path/ | grep -i "pci.*-card$" | head -1))
vaapi=$(readlink -f /dev/dri/by-path/$(ls /dev/dri/by-path/ | grep -i "pci.*-render$" | head -1))

# Auto detect GPU vendor
if lspci | grep -qi nvidia; then
    GPU="nvidia"
elif lspci | grep -qi "amd\|radeon"; then
    GPU="amd"
else
    GPU="intel"
fi

# Capture based on GPU
case $GPU in
    intel|amd)
        sudo ffmpeg -vaapi_device "$vaapi" \
            -f kmsgrab -device "$card" -i - \
            -vf 'hwmap=derive_device=vaapi,scale_vaapi=format=nv12,hwdownload,format=nv12' \
            -frames:v 1 -v quiet \
            "$OUTFILE"
        ;;
    nvidia)
        sudo ffmpeg \
            -f kmsgrab -device "$card" -i - \
            -vf 'hwdownload,format=bgr0' \
            -frames:v 1 -v quiet \
            "$OUTFILE"
        ;;
esac

# Confirm
if [ -f "$OUTFILE" ]; then
    echo "Screenshot saved: $OUTFILE"
else
    echo "Screenshot failed!"
fi