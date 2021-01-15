#!/usr/bin/env sh
# This script converts the CARLOFFF data into lmdb/leveldb format,
# depending on the value assigned to $BACKEND.
set -e

BUILD=/opt/src/caffe/build/examples/CARLOFFF

rm -rf data/Nord_CAL_lmdb data/Nord_VAL_lmdb

$BUILD/convert_CARLOFFF_data.bin --backend=lmdb data/Nord_CAL-images-idx3-ubyte \
  data/Nord_CAL-labels-idx1-ubyte data/Nord_CAL_lmdb
$BUILD/convert_CARLOFFF_data.bin --backend=lmdb data/Nord_VAL-images-idx3-ubyte \
  data/Nord_VAL-labels-idx1-ubyte data/Nord_VAL_lmdb
