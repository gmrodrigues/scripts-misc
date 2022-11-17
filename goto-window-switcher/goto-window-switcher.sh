#!/bin/bash -l
# command to swith to window by process name
# usefull when you dont know the title of the window to use wmctrl -a alone
# for example: ./goto-win   dow-switcher.sh youtube-music
set -x
CMD_RUN=$1
CMD_SEARCH=$2
WIN_TITLE_SEARCH=$3
wmctrl -lx

if [[ ! "$CMD_RUN"  ]]; then
    wmctrl -lx
    exit -1
fi;

if [[ ! "$CMD_SEARCH"  ]]; then
    CMD_SEARCH=$CMD_RUN
fi;

if [[ "$WIN_TITLE_SEARCH"  ]]; then
    WINDOW_REF=$(wmctrl -lx | grep -iE "$CMD_SEARCH" | grep -iE "$WIN_TITLE_SEARCH" |  awk '{print $1}' )
else
    WINDOW_REF=$(wmctrl -lx | grep -i "$CMD_SEARCH" |  awk '{print $1}' )
fi;


if [[ "$WINDOW_REF" ]]; then
     wmctrl -ia  $WINDOW_REF
else
    bash -l -c "$CMD_RUN" || $CMD_SEARCH
fi;
