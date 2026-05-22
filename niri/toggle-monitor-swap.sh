#!/usr/bin/env bash
# ~/.config/niri/toggle-monitor-swap.sh

CONFIG="${HOME}/.config/niri/config.kdl"

# Parse outputs and positions from niri
declare -A output_positions
current_output=""

while IFS= read -r line; do
    if [[ "$line" =~ ^Output\ \"(.+)\" ]]; then
        current_output="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ Logical\ position:\ ([0-9]+) ]]; then
        output_positions["$current_output"]="${BASH_REMATCH[1]}"
    fi
done < <(niri msg outputs)

# Sort outputs by current x position
mapfile -t sorted_outputs < <(
    for output in "${!output_positions[@]}"; do
        echo "${output_positions[$output]} $output"
    done | sort -n | sed 's/^[0-9]* //'
)

# Collect sorted x positions
sorted_xs=()
for output in "${sorted_outputs[@]}"; do
    sorted_xs+=("${output_positions[$output]}")
done

count=${#sorted_outputs[@]}

# Rewrite config with swapped positions
tmpfile=$(mktemp)
cp "$CONFIG" "$tmpfile"

for ((i = 0; i < count; i++)); do
    reversed_i=$((count - 1 - i))
    output="${sorted_outputs[$i]}"
    new_x="${sorted_xs[$reversed_i]}"
    old_x="${sorted_xs[$i]}"

    if [ "$new_x" != "$old_x" ]; then
        awk -v name="$output" -v new_x="$new_x" '
            /output "/ { in_block = ($0 ~ "\"" name "\"") }
            in_block && /position x=/ {
                sub(/x=[0-9]+/, "x=" new_x)
            }
            { print }
        ' "$tmpfile" >"${tmpfile}.tmp" && mv "${tmpfile}.tmp" "$tmpfile"
    fi
done

cp "$tmpfile" "$CONFIG"
rm -f "$tmpfile"
