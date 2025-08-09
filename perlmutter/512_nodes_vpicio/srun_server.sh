set -x
set -u

if [ -z "${NUM_NODES}" ]; then
	echo "Error: NUM_NODES is not set"
	exit 1
fi

pushd ./build/bin
rm server_output.txt || true
srun -N$NUM_NODES -n$NUM_NODES --ntasks-per-node=1 pkill pdc_server
srun -N$NUM_NODES -n$NUM_NODES --ntasks-per-node=1 ./pdc_server 2>&1 | tee server_output.txt
popd
