#!/bin/bash

STR=$(swaymsg -t get_tree | grep kittyterm)
if [ "$STR" == "" ]; then
    exec kitty -T kittyterm & sleep 0.5
    exec swaymsg [title="kittyterm"] scratchpad show
else
    exec swaymsg [title="kittyterm"] scratchpad show
fi
exit 0

  
