#!/bin/bash

# nano ~/.bashrc
# source (...)/bash_aliases_troubleshooting.sh

# (sudo) show process listening
alias lsnet='netstat -plunt'

# (sudo) show open files by pids that are listening
alias lsnetf='netstat -plunt  | awk "{print \$7}" | cut -d "/" -f 1 | grep [0-9] | sed -s "s/\([0-9]\+\)/-p \1/g" | xargs lsof'

# find www -type f -not -iname '*/.git/*' -exec echo '{}' '/home/desenv/panning-produto/from-jairo/web-a/{}' ';'
# find . -type f -not -iname '*/not-from-here/*' -exec cp '{}' '/dest/{}' ';'