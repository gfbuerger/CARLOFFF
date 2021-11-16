layer {
  name: "accuracy"
  type: "Accuracy"
  bottom: "out"
  bottom: "label"
  top: "accuracy"
}
layer {
  name: "loss"
  type: "SoftmaxWithLoss"
  bottom: "out"
  bottom: "label"
  top: "loss"
  loss_weight: 1
}
