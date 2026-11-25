#!/bin/bash
# Build Mercury and PDC on Perlmutter (login node).
#   build/perlmutter/build.sh [mercury] [tf] [pdc]    default: all
# libfabric is the system one from the default environment (cxi and tcp providers): the
# docs' libfabric 1.18.0 has no cxi provider. Mercury 2.2.0 cannot use cxi (it
# sets av_attr.rx_ctx_bits, which cxi rejects) and 2.4.0 does not compile
# against libfabric 2.x, so this builds 2.4.1 (MERCURY_REF), which also takes
# the CXI service/VNI from Slurm's SLINGSHOT_* variables. PDC needs its ofi+cxi
# endpoint setup (cxi0:<pid>), which the default branch in ../common.sh has.
set -euo pipefail
source "$(dirname "$0")/env.sh"
source "$(dirname "$0")/../common.sh"
MERCURY_REF=${MERCURY_REF:-v2.4.1}
J=${J:-16}
SRC=$PDC_PREFIX/src
mkdir -p "$SRC"
pkg-config --exists libfabric || { echo "libfabric from the default environment not found by pkg-config" >&2; exit 1; }

build_mercury() {
  [ -d "$SRC/mercury" ] || git clone -q --recurse-submodules https://github.com/mercury-hpc/mercury.git "$SRC/mercury"
  git -C "$SRC/mercury" fetch -q --tags && git -C "$SRC/mercury" checkout -q "$MERCURY_REF"
  git -C "$SRC/mercury" submodule update -q --init --recursive
  rm -rf "$SRC/build-mercury"
  cmake -S "$SRC/mercury" -B "$SRC/build-mercury" -DCMAKE_C_COMPILER=cc -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$MERCURY_DIR" -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF \
    -DMERCURY_USE_BOOST_PP=ON -DMERCURY_USE_CHECKSUMS=OFF -DNA_USE_OFI=ON -DNA_USE_SM=OFF
  cmake --build "$SRC/build-mercury" -j"$J"
  rm -rf "$MERCURY_DIR" && cmake --install "$SRC/build-mercury"
  # PDC's pdc_private.h includes mercury_list.h, which Mercury stopped
  # shipping after 2.3. Install the 2.3.1 copy.
  [ -e "$MERCURY_DIR/include/mercury_list.h" ] ||
    git -C "$SRC/mercury" show v2.3.1:src/util/mercury_list.h > "$MERCURY_DIR/include/mercury_list.h"
}

build_pdc() {
  need "$MERCURY_DIR/include/mercury.h" mercury
  # shellcheck disable=SC2046
  pdc_build "$SRC/build-pdc" "$PDC_DIR" -DCMAKE_C_COMPILER=cc -DPDC_ENABLE_LUSTRE=ON -DMPI_RUN_CMD=srun $(mercury_args "$MERCURY_DIR")
  # A PDC setup script in the login shell can point CMake at another Mercury.
  grep -q "^MERCURY_DIR:[A-Z]*=$MERCURY_DIR/" "$SRC/build-pdc/CMakeCache.txt" ||
    { echo "PDC configured against $(grep '^MERCURY_DIR:' "$SRC/build-pdc/CMakeCache.txt")" >&2; exit 1; }
}

for c in ${*:-mercury tf pdc}; do
  echo "=== $c"
  "build_$c"
done
