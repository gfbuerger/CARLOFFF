layer {
  name: "ip1"
  type: "InnerProduct"
  bottom: "data"
  top: "ip1"
  inner_product_param {
    num_output: 7
    weight_filler {
      type: "gaussian"
      std: 0.1
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "ip2"
  type: "InnerProduct"
  bottom: "ip1"
  top: "ip2"
  inner_product_param {
    num_output: 3
    weight_filler {
      type: "gaussian"
      std: 0.1
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "ip3"
  type: "InnerProduct"
  bottom: "ip2"
  top: "out"
  inner_product_param {
    num_output: NCLASS_tpl
    weight_filler {
      type: "gaussian"
      std: 0.1
    }
    bias_filler {
      type: "constant"
    }
  }
}
