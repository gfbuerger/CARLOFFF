name: "PROTO_tpl"
state {
  phase: TRAIN
  level: 0
  stage: ""
}
layer {
  name: "CAL"
  type: "HDF5Data"
  top: "data"
  top: "label"
  include {
    phase: TRAIN
  }
  hdf5_data_param {
    source: "data/REG_tpl_PDD_tpl.CAL.txt"
    batch_size: 64
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
    source: "data/REG_tpl_PDD_tpl.VAL.txt"
    batch_size: 64
  }
}
##layer {
##  name: "H"
##  type: "HDF5Data"
##  top: "H"
##  include {
##    phase: TRAIN
##  }
##  hdf5_data_param {
##    source: "data/REG_tpl_H.txt"
##    batch_size: 1
##  }
##}
