#!/bin/bash
# command to swith to window by process name
# usefull when you dont know the title of the window to use wmctrl -a alone
# for example: ./goto-win   dow-switcher.sh youtube-music
set -x
CMD_RUN=$1
CMD_SEARCH=$2
wmctrl -lx

if [[ !"$CMD_SEARCH"  ]]; then
    CMD_SEARCH=$CMD_RUN
fi;

WINDOW_REF=$(wmctrl -lx | grep -i "$CMD_SEARCH" |  awk '{print $5" "$6" "$7" "$8" "$9" "$10" "}' )

if [[ "$WINDOW_REF" ]]; then
     wmctrl -a  $WINDOW_REF
else
    $CMD_RUN || $CMD_SEARCH
fi;