#!/bin/bash
#
# Creates icon

function help {
    echo "Usage: `basename $0` <path_to_bin> <name> <icon_file>"
    echo " Creates an Desktop Icon to a command."
    echo
}

PRG=`realpath "$1" 2> /dev/null`
PRG_NAME=$2
PRG_ICON_PATH=`realpath "$3" 2> /dev/null`

LE_PROGRAME_BIN=`dirname "$PRG" 2> /dev/null`
LE_PROGRAME_BASE=`basename "$PRG" | sed -s 's/\..*$//' 2> /dev/null`

ERR="Errors: "
if [[ -z `file "$PRG" | grep executable` ]] ; then
    ERR="$ERR 1st arg <path_to_bin> '$PRG' not executable."
fi

if [[ -z "$PRG_NAME" ]] ; then
    ERR="$ERR 2nd arg <name> is empty."
fi

if [[ -z `file "$PRG_ICON_PATH" | grep image` ]] ; then
    ERR="$ERR 3rd arg <icon_file> '$PRG_ICON_PATH' not image file."
fi

if [[ "$ERR" != 'Errors: ' ]] ; then
    echo -e "\e[31m$ERR\e[0m" 
    help
    exit 1
fi

# absolutize dir
oldpwd=`pwd`
cd "${LE_PROGRAME_BIN}"
LE_PROGRAME_BIN=`pwd`
cd "${oldpwd}"

ICON_NAME=$LE_PROGRAME_BASE-$LE_PROGRAME_BASE
TMP_DIR=`mktemp --directory`
DESKTOP_FILE="$TMP_DIR/$ICON_NAME.desktop"
cat << EOF > $DESKTOP_FILE
[Desktop Entry]
Version=1.0
Encoding=UTF-8
Name=$PRG_NAME
Keywords=$PRG_NAME
Comment=$PRG_NAME
Type=Application
Categories=Other
Terminal=false
StartupNotify=true
StartupWMClass=$LE_PROGRAME_BIN
Exec="$PRG" %u
Icon=$PRG_ICON_PATH
EOF

# seems necessary to refresh immediately:
chmod 644 $DESKTOP_FILE

xdg-desktop-menu install $DESKTOP_FILE
xdg-icon-resource install --size  32 "$PRG_ICON_PATH"  $ICON_NAME
xdg-icon-resource install --size  48 "$PRG_ICON_PATH"  $ICON_NAME
xdg-icon-resource install --size  64 "$PRG_ICON_PATH"  $ICON_NAME
xdg-icon-resource install --size 128 "$PRG_ICON_PATH"  $ICON_NAME

rm $DESKTOP_FILE
rm -R $TMP_DIR
