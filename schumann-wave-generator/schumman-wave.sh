#!/bin/bash
ffplay -f lavfi -i "sine=frequency=7.83" -nodisp &
#ffplay -f lavfi -i "sine=frequency=15.66" -nodisp &
ffplay -f lavfi -i "sine=frequency=63.61" -nodisp &
echo "press anykey to exit"
read keypress
killall ffplay