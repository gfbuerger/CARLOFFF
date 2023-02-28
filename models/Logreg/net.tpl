layer {
 name: "fc"
    type: "InnerProduct"
    bottom: "data"
    top: "out"
    inner_product_param {
  num_output: NCLASS_tpl
      }
}
