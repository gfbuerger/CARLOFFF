#!/usr/bin/env sh
# This script converts the CARLOFFF data into lmdb/leveldb format,
# depending on the value assigned to $BACKEND.
set -e

BUILD=/opt/src/caffe/build/examples/CARLOFFF

BACKEND="lmdb"

rm -rf data/Nord_CAL_${BACKEND} data/Nord_VAL_${BACKEND}

$BUILD/convert_CARLOFFF_data.bin --backend=${BACKEND} data/Nord_CAL-images-idx3-ubyte \
  data/Nord_CAL-labels-idx1-ubyte data/Nord_CAL_${BACKEND}
$BUILD/convert_CARLOFFF_data.bin --backend=${BACKEND} data/Nord_VAL-images-idx3-ubyte \
  data/Nord_VAL-labels-idx1-ubyte data/Nord_VAL_${BACKEND}
