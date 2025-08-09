#!/bin/bash
#SBATCH --nodes=512
#SBATCH --ntasks-per-node=33
#SBATCH --cpus-per-task=1
#SBATCH --account=m2621
#SBATCH --time=00:30:00
#SBATCH --constraint=cpu
#SBATCH --qos=regular

set -x

export NUM_NODES=512
export TASKS_PER_NODE=32

echo "going to pdc"
gopdc

echo "removing old .txt"
rm *.txt

echo "launching server"
./srun_server.sh &

echo "sleeping 20"
sleep 20

echo "lauching client"
./srun_client.sh
