#!/bin/bash

STR=$(swaymsg -t get_tree | grep SchildiChat)
if [ "$STR" == "" ]; then
    exec swaymsg [class="SchildiChat"] scratchpad show
else
    exec swaymsg [class="SchildiChat"] scratchpad show
fi
exit 0

  
