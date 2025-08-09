#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 logfile"
  exit 1
fi

logfile="$1"

echo "Step,Obj create time,Transfer create time,Transfer start time,Transfer wait time,Transfer close time,Obj close time,Total time"

awk '
  /\#Step[ \t]*[0-9]+/ {
    match($0, /\#Step[ \t]*([0-9]+)/, arr)
    step = arr[1]
    next
  }

  /Obj create time:/ {
    match($0, /Obj create time: ([0-9.eE+-]+)/, m)
    obj_create = m[1]
    next
  }

  /Transfer create time:/ {
    match($0, /Transfer create time: ([0-9.eE+-]+)/, m)
    transfer_create = m[1]
    next
  }

  /Transfer start time:/ {
    match($0, /Transfer start time: ([0-9.eE+-]+)/, m)
    transfer_start = m[1]
    next
  }

  /Sleep start:/ { next }
  /Sleep end:/ { next }

  /Transfer wait time:/ {
    match($0, /Transfer wait time: ([0-9.eE+-]+)/, m)
    transfer_wait = m[1]
    next
  }

  /Transfer close time:/ {
    match($0, /Transfer close time: ([0-9.eE+-]+)/, m)
    transfer_close = m[1]
    next
  }

  /Obj close time:/ {
    match($0, /Obj close time: ([0-9.eE+-]+)/, m)
    obj_close = m[1]

    total = obj_create + transfer_create + transfer_start + transfer_wait + transfer_close + obj_close

    printf "%s,%s,%s,%s,%s,%s,%s,%s\n", step, obj_create, transfer_create, transfer_start, transfer_wait, transfer_close, obj_close, total
    next
  }
' "$logfile"

