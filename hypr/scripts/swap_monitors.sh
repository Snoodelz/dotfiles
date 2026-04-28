#!/usr/bin/env bash

data=$(hyprctl monitors -j)

dp1_x=$(echo "$data" | jq '.[] | select(.name=="DP-1") | .x')
dp1_w=$(echo "$data" | jq '.[] | select(.name=="DP-1") | .width')
dp1_h=$(echo "$data" | jq '.[] | select(.name=="DP-1") | .height')
dp1_r=$(echo "$data" | jq '.[] | select(.name=="DP-1") | .refreshRate')

dp2_w=$(echo "$data" | jq '.[] | select(.name=="DP-2") | .width')
dp2_h=$(echo "$data" | jq '.[] | select(.name=="DP-2") | .height')
dp2_r=$(echo "$data" | jq '.[] | select(.name=="DP-2") | .refreshRate')

mode1="${dp1_w}x${dp1_h}@${dp1_r}"
mode2="${dp2_w}x${dp2_h}@${dp2_r}"

if [[ "$dp1_x" -eq 0 ]]; then
    # DP-1 is left → swap

    # 1. Move DP-1 far away
    hyprctl keyword monitor "DP-1,$mode1,10000x0,1"

    # 2. Move DP-2 to left
    hyprctl keyword monitor "DP-2,$mode2,0x0,1"

    # 3. Move DP-1 to right
    hyprctl keyword monitor "DP-1,$mode1,${dp2_w}x0,1"

else
    # DP-1 is right → swap back

    # 1. Move DP-1 far away
    hyprctl keyword monitor "DP-1,$mode1,10000x0,1"

    # 2. Move DP-2 to right
    hyprctl keyword monitor "DP-2,$mode2,${dp1_w}x0,1"

    # 3. Move DP-1 to left
    hyprctl keyword monitor "DP-1,$mode1,0x0,1"
fi
