#!/bin/bash

# copy command to clipboard to use in SLADE
# -iwad %i -file %r %a +map %mn
RUNCMD="gzdoom $*"
LASTRUN=~/.slade-run-last.sh

echo '#!/bin/bash' > $LASTRUN
echo $RUNCMD >> "$LASTRUN"
chmod +x $LASTRUN
echo "Command saved to $LASTRUN"
echo $RUNCMD

echo -n $RUNCMD | xclip -selection clipboard

zenity --info --text="Command copied to clipboard:\n\n$RUNCMD"