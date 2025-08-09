#!/bin/bash

set -xe

./parse_time.sh node_local_client_output.txt > node_local.csv
./parse_time.sh region_dynamic_client_output.txt > region_dynamic.csv
./parse_time.sh obj_static_client_output.txt > obj_static.csv
./parse_time.sh region_static_client_output.txt > region_static.csv
