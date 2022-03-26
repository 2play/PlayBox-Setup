#!/bin/sh
export LIBGL_ALWAYS_SOFTWARE=1
"$@"
exec chromium --ignore-gpu-blacklist
