#!/bin/bash

PARSE_SCRIPT_VPIC="./parse_vpic.sh"
PARSE_SCRIPT_BDCATS="./parse_bdcats.sh"

echo "VPIC Times"

files=$(find . -type f -name 'client_output_raw_*.log' | sort -t'_' -k4 -n)
for file in $files; do
    $PARSE_SCRIPT_VPIC "$file"
done

echo "BDCATS Times"

files=$(find . -type f -name 'client_output_restart_raw_*.log' | sort -t'_' -k4 -n)
for file in $files; do
    $PARSE_SCRIPT_BDCATS "$file"
done

