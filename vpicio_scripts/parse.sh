#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

file="$1"

types=("Obj create time" "Transfer create time" "Transfer start time" \
       "Sleep start" "Sleep end" "Transfer wait time" "Transfer close time" \
       "Obj close time")

for type in "${types[@]}"; do
    # Print type name followed by comma-separated values
    echo -n "$type,"
    grep "\[WARNING\] PDC_CLIENT.*: $type:" "$file" \
        | awk -F': ' '{printf "%s,", $NF}' \
        | sed 's/,$//'
    echo
done

