set -x
set -u

TOTAL_TASKS=$((NUM_NODES * TASKS_PER_NODE))

pushd ./build/bin
rm -f client_output.txt
srun -N"$NUM_NODES" -n"$TOTAL_TASKS" --ntasks-per-node="$TASKS_PER_NODE" ./vpicio_mts 8388608 5 20 > client_output.txt 2>&1
popd

