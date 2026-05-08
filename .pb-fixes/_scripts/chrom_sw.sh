#!/bin/sh
# ./chrom_sw.sh https://example.com
export LIBGL_ALWAYS_SOFTWARE=1
exec chromium --ignore-gpu-blacklist "$@"
