#!/bin/bash

# This script will show a graphical warning message to the user that the system is going to shutdown in 5 minutes.
# Its meant to be used with cron, so that the system can be shutdown automatically after a certain time.

# The script will show a warning message to the user, and will give the user the option to cancel the shutdown.
# If the user does not cancel the shutdown, the system will be shutdown after 5 minutes.
# this script guesses the current user by the owner of the X display, and will show the dialog box on the user's screen.

# ITs takes two arguments, the hour and the minute at which the system should be shutdown.
# It will update crontab to schedule the shutdown at the specified time.
# It will not remove any existing cron jobs, it will just add a new one.
# To remove the cron job, the user can use the crontab -e command.

HOUR=$1
MINUTE=$2

DIALOG_CMD="/usr/bin/zenity"
TIMEOUT='00:05:00'
SHUTDOWN_CMD="/sbin/shutdown -P $TIMEOUT"
ABSOLUTE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CANCEL_SHUTDOWN_CMD="bash $ABSOLUTE_DIR/gcronshutdown-cancel.sh"


CURRENT_USER=`ps -o user= -p $(ps aux | grep -E 'Xorg|wayland' | awk '{print $2}' | head -n 1)`

COMMENT_KEY="DO NOT REMOVE THIS COMMENT LINE, ITs USED TO UPDATE THE CRON LINE"
w
CRONLINE="$MINUTE $HOUR * * * bash -c '$SHUTDOWN_CMD && $CANCEL_SHUTDOWN_CMD $CURRENT_USER' # $COMMENT_KEY";

# check for arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <hour> <minute>"
    echo "Example: $0 22 30"
    exit 1
fi

# become root
if [ $EUID -ne 0 ]; then
    sudo bash $0 $@
    exit $?
fi

# if the cron line already exists, do nothing
if crontab -l | grep -q "$CRONLINE"; then
    echo "Cron line already exists, not adding it again."
    echo "To remove the cron line, use crontab -e"
    echo "$CRONLINE"
    echo "Exiting..."
    exit 0
fi

# add the cron line
(crontab -l; echo "$CRONLINE") | crontab -
echo "Cron line added:"
echo "$CRONLINE"