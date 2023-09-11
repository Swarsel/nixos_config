#!/bin/bash

STR=$(swaymsg -t get_tree | grep SchildiChat)
if [ "$STR" == "" ]; then
    exec SchildiChat & sleep 0.5
    exec swaymsg [app_id="SchildiChat"] scratchpad show
else
    exec swaymsg [app_id="SchildiChat"] scratchpad show
fi
exit 0

  
