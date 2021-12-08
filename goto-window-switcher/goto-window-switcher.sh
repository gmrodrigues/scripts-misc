#!/bin/bash
# command to swith to window by process name
# for example: ./goto-window-switcher.sh youtube-music
set -x
CMD_SEARCH_NAME=$*
CMD_PID=$(ps aux | grep  "$CMD_SEARCH_NAME" | awk '{print $2}' | xargs echo | sed 's/ /|/g')

#sudo apt  install wmctrl
WINDOW_REF=$(wmctrl -lp | grep -E "($CMD_PID)" | awk '{print $5" "$6" "$7" "$8" "$9" "$10" "}')
 wmctrl -a  $WINDOW_REF
 