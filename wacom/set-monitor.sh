#!/bin/bash
set -xe

xsetwacom --list devices
xrandr --listactivemonitors

STYLUS=$(xsetwacom --list devices | grep STYLUS | cut -d ':' -f 2  | awk '{print $1}')
MONITOR=$(xrandr --listactivemonitors | grep HDMI |awk '{print $4}')

xsetwacom --set "$STYLUS" MapToOutput "$MONITOR"