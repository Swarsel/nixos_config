#!/bin/bash

STR=$(swaymsg -t get_tree | grep kittyterm)
if [ "$STR" == "" ]; then
    echo 0 > /tmp/kittystate.txt
else
    echo 1 > /tmp/kittystate.txt
    exec swaymsg [title="kittyterm"] scratchpad show
fi
exit 0

  
