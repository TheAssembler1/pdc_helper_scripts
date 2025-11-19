#!/bin/bash

./rebuild.sh  # Rebuild project

pushd ./build/bin || exit 1  # Exit if cd fails
export PDC_DEBUG=1
"./vpicio_mts" 8388608 5 20 $1
popd
