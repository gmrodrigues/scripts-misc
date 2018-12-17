#!/bin/bash
# usage:
#  TEMP=$(./command_pool.sh NEW)              # Create tmp command list file
#  ./command_pool.sh ADD "$TEMP" grep ..| curl # Add to tmp command list file
#  ./command_pool.sh RUN "$TEMP" 5             # Run command list file in <5> threads

if [[ "$1" = "NEW" ]]; then
    mktemp
    exit
fi

if [[ "$1" = "ADD" ]]; then
    TEMP=$2
    CMD="${@:3}"
    echo "$CMD" >> "$TEMP"
    exit
fi

if [[ "$1" = "RUN" ]]; then
    TEMP=$2
    MAX_PROCS=$3
    cat "$TEMP" | xargs -I CMD --max-procs=$MAX_PROCS bash -c CMD
    rm "$TEMP"
    #echo $TEMP
    exit
fi

exit 1