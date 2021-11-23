name: "PROTO_tpl"
layer {
  name: "CAL"
  type: "HDF5Data"
  top: "data"
  top: "label"
  include {
    phase: TRAIN
  }
  hdf5_data_param {
    source: "DATA_tpl/PDD_tpl.CAL.txt"
    batch_size: 100
  }
}
layer {
  name: "VAL"
  type: "HDF5Data"
  top: "data"
  top: "label"
  include {
    phase: TEST
  }
  hdf5_data_param {
    source: "DATA_tpl/PDD_tpl.VAL.txt"
    batch_size: 100
  }
}
