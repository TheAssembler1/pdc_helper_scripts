#!/bin/bash

# This script is useful for running vpicio within interactive jobs

set -xue

# Set environment variables
export NUM_NODES=$SLURM_JOB_NUM_NODES
export DATA_SERVERS_PER_NODE=1
export CLIENTS_PER_NODE=32
export SERVER_TOTAL_TASKS=$((NUM_NODES * DATA_SERVERS_PER_NODE))
export CLIENT_TOTAL_TASKS=$((NUM_NODES * CLIENTS_PER_NODE))
export BIN_DIR=/pscratch/sd/n/nlewi26/src/work_space/source/pdc/build/bin
export PDC_DATA_LOC=/pscratch/sd/n/nlewi26/src/work_space/install/pdc

# Print them
echo "NUM_NODES=$NUM_NODES"
echo "DATA_SERVERS_PER_NODE=$DATA_SERVERS_PER_NODE"
echo "CLIENTS_PER_NODE=$CLIENTS_PER_NODE"
echo "SERVER_TOTAL_TASKS=$SERVER_TOTAL_TASKS"
echo "CLIENT_TOTAL_TASKS=$CLIENT_TOTAL_TASKS"
echo "BIN_DIR=$BIN_DIR"
echo "TRANSFORM=$TRANSFORM"
echo "PDC_DATA_LOC=$PDC_DATA_LOC"

echo "running server script"
time ./srun_server.sh vpicio

echo "running client script"
time ./srun_client.sh vpicio

echo "closing server script"
time ./srun_close_server.sh vpicio

echo "logging data dir"
find $PDC_DATA_LOC/pdc_data -type f | wc -l
find $PDC_DATA_LOC/pdc_data -type f -exec stat --printf="%s %n\n" {} \;

echo "running server script"
time ./srun_server.sh bdcats

echo "running client script"
time ./srun_client.sh bdcats

echo "closing server script"
time ./srun_close_server.sh bdcats

mkdir $SLURM_JOB_ID
mv *.out $SLURM_JOB_ID
cp $BIN_DIR/*.out $SLURM_JOB_ID
cp $BIN_DIR/*.err $SLURM_JOB_ID