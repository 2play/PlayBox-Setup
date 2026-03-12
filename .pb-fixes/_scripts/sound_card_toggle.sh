#!/bin/bash
# Switch between USB analog and active HDMI

OUTCONF="$HOME/.asoundrc"
TESTFILE="/usr/share/sounds/alsa/Front_Center.wav"

choose_usb() {
    echo "Switching to USB analog (card 0, device 0)..."
    cat > "$OUTCONF" <<EOF
pcm.!default {
    type plug
    slave {
        pcm "hw:0,0"
    }
}
ctl.!default {
    type hw
    card 0
}
EOF
    alsactl kill quit
    sudo alsactl store
    echo "Default set to USB analog."
}

choose_hdmi() {
    ACTIVE_HDMI=""
    for DEV in 3 7 8; do
        if aplay -D plughw:1,$DEV "$TESTFILE" >/dev/null 2>&1; then
            ACTIVE_HDMI=$DEV
            break
        fi
    done

    if [ -n "$ACTIVE_HDMI" ]; then
        echo "Found active HDMI on device $ACTIVE_HDMI"
        cat > "$OUTCONF" <<EOF
pcm.!default {
    type plug
    slave {
        pcm "hw:1,$ACTIVE_HDMI"
    }
}
ctl.!default {
    type hw
    card 1
}
EOF
        alsactl kill quit
        sudo alsactl store
        echo "Default set to HDMI (card 1, device $ACTIVE_HDMI)."
    else
        echo "No active HDMI detected, falling back to USB."
        choose_usb
    fi
}

case "$1" in
    usb)
        choose_usb ;;
    hdmi)
        choose_hdmi ;;
    *)
        echo "Usage: $0 [usb|hdmi]"
        echo "usb  → force USB analog"
        echo "hdmi → auto-detect active HDMI, fallback to USB"
        ;;
esac
