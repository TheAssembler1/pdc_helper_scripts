set -x
set -u

if [ -z "${NUM_NODES}" ]; then
	echo "Error: NUM_NODES is not set"
	exit 1
fi
if [ -z "${TASKS_PER_NODE}" ]; then
	echo "Error: TASKS_PER_NODE is not set"
	exit 1
fi

TOTAL_TASKS=$((NUM_NODES * TASKS_PER_NODE))

pushd ./build/bin
rm -f client_output.txt
srun -N"$NUM_NODES" -n"$TOTAL_TASKS" --ntasks-per-node="$TASKS_PER_NODE" ./vpicio_mts 8388608 5 20 > client_output.txt 2>&1
popd

echo "killing servers"
srun -N$NUM_NODES -n$NUM_NODES --ntasks-per-node=1 pkill pdc_server
