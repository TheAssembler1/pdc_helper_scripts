set -x
set -u

pushd ./build/bin
rm server_output.txt || true
srun -N$NUM_NODES -n$NUM_NODES --ntasks-per-node=1 ./pdc_server 2>&1 | tee server_output.txt
popd
