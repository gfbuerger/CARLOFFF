layer {
  name: "loss"
  type: "Softmax"
  bottom: "out"
  top: "loss"
}
