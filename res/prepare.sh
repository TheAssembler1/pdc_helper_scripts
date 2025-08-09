#!/bin/bash

set -xe

echo "First parsing times"
sleep 1
./parse.sh

echo "Done parse times now creating gnu plot data"
sleep 1
files=("region_static.csv" "region_dynamic.csv" "obj_static.csv" "node_local.csv")
labels=("region_static" "region_dynamic" "obj_static" "node_local")
metrics=("Obj_create" "Transfer_create" "Transfer_start" "Transfer_wait" "Transfer_close" "Obj_close" "Total")

# Initialize associative arrays to hold sums
declare -A sums

for i in "${!files[@]}"; do
  f=${files[i]}
  label=${labels[i]}

  # Use awk to sum columns from 2 to 8 (skip header)
  result=$(awk -F, 'NR>1 {
    oc+=$2; tc+=$3; ts+=$4; tw+=$5; tcl+=$6; oc_close+=$7; total+=$8
  } END {
    printf "%f %f %f %f %f %f %f", oc, tc, ts, tw, tcl, oc_close, total
  }' "$f")

  read oc tc ts tw tcl oc_close total <<< "$result"

  sums["$label,Obj_create"]=$oc
  sums["$label,Transfer_create"]=$tc
  sums["$label,Transfer_start"]=$ts
  sums["$label,Transfer_wait"]=$tw
  sums["$label,Transfer_close"]=$tcl
  sums["$label,Obj_close"]=$oc_close
  sums["$label,Total"]=$total
done

# Print header line and metric lines into the data file
{
  # Replace underscores with dashes in header labels and separate by tabs
  header_labels=$(printf "%s\t" "${labels[@]}")
  header_labels="${header_labels//_/-}"
  echo -e "Category\t${header_labels}"

  for metric in "${metrics[@]}"; do
    metric_label="${metric//_/-}"
    printf "%s" "$metric_label"
    for label in "${labels[@]}"; do
      printf "\t%.6f" "${sums[$label,$metric]}"
    done
    echo
  done
} > gnuplot_data.dat

