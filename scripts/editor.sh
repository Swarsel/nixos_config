#!/bin/bash

STR=$(swaymsg -t get_tree | grep kittyterm)
if [ "$STR" == "" ]; then
    VAR="0"
else
    VAR="1"
    swaymsg [title="kittyterm"] scratchpad show
fi
emacsclient -c -a nano "$@"
if [ "$VAR" == "1" ]
then
    swaymsg [title="kittyterm"] scratchpad show
fi
exit 0

  
