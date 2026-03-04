#!/bin/bash
# The PlayBox Project
# Copyright (C)2018-2026 2Play! (S.R.)
# 02.2025
# Ensure environment is correctly set up
source ~/.bash_profile
echo "
...WEATHER INFO...
$(tput setaf 5)
- City -         Temp  Condition
LONDON, UK     : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=EUR|UK|UK001|LONDON" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
ATHENS, GR     : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=EUR|GR|GR007|ATHINAI" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
N.Y., US       : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=0&locCode=NAM|US|NY|NEWYORK" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
TOKYO, JP      : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=ASI|JP|JA041|TOKYO" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
MELBOURNE, AU  : `curl -s "http://rss.accuweather.com/rss/liveweather_rss.asp?metric=1&locCode=OCN|AU|VIC|MELBOURNE" | sed -n '/Currently:/ s/.*: \(.*\): \([0-9]*\)\([CF]\).*/\2°\3, \1/p'`
$(tput sgr0)"
echo
read -n 1 -s -r -p "Press any key to continue"
