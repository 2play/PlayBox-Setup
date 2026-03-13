#!/bin/bash
# Audio Select hdmi | usb with set vol

STATE_FILE=/tmp/audio_mode

# Per-device target volumes
TARGET_VOL_HDMI="81%"
TARGET_VOL_USB="51%"

# Get sink names dynamically
ANALOG_SINK=$(pactl list short sinks | grep analog | awk '{print $2}' | head -n1)
HDMI_SINK=$(pactl list short sinks | grep hdmi | awk '{print $2}' | head -n1)

case "$1" in
  usb)
    echo "Switching to ANALOG..."
    echo "ANALOG" > "$STATE_FILE"
    pactl set-default-sink "$ANALOG_SINK"
    pactl set-sink-volume "$ANALOG_SINK" "$TARGET_VOL_USB"
    ;;
  hdmi)
    echo "Switching to HDMI..."
    echo "HDMI" > "$STATE_FILE"
    pactl set-default-sink "$HDMI_SINK"
    pactl set-sink-volume "$HDMI_SINK" "$TARGET_VOL_HDMI"
    ;;
  *)
    echo "Usage: $0 hdmi | usb"
    exit 1
    ;;
esac