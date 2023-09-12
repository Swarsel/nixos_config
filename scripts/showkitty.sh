#!/bin/bash

STR=$(cat /tmp/kittystate.txt)
if [ "$STR" == "1" ]
then
    exec swaymsg [title="kittyterm"] scratchpad show
fi
exit 0

