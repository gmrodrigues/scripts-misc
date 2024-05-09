#!/bin/bash

# this script will cancel a shutdown that was scheduled by gcronshutdown.sh
# its meant to bu run by cron, so that the user can cancel the shutdown if he wants to.
# it takes an username as argument, and will cancel the shutdown for that user if user choses to do so.

# the script will show a warning message to the user, and will give the user the option to cancel the shutdown.
# the DISPLAY variable is set to :0.0, so that the dialog box will be shown on the user's screen.
set -xe
export DISPLAY=:0.0
DIALOG_CMD="/usr/bin/zenity --question --text='The system is going to shutdown in 5 minutes. Do you want to cancel the shutdown?' --title='Shutdown Warning' --timeout=300"
CANCEL_SHUTDOWN_CMD="/sbin/shutdown -c"
CURRENT_USER=$1

# call zenity to show the warning message
su $CURRENT_USER -c "$DIALOG_CMD"
if [ $? -eq 0 ]; then
    # user chose to cancel the shutdown
    $CANCEL_SHUTDOWN_CMD
fi