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
##layer {
##  name: "Softmax"
##  type: "Softmax"
##  bottom: "out"
##  top: "prob"
##}
##layer {
##  bottom: "out"
##  bottom: "label"
###  bottom: "H"
##  top: "infoGainLoss"
##  name: "infoGainLoss"
##  type: "InfogainLoss"
##  loss_weight: 0
##  infogain_loss_param {
##    source: "data/infogainH.binaryproto"
##  }
##}
##layer {
##    name: "computeH"
##    bottom: "label"
##    top: "H"
##    type: "Python"
##    python_param {
##        module: "computeH"
##        layer: "ComputeH"
##        param_str: '{"n_classes": 2}'
##    }
##    exclude { stage: "deploy" }
##}
##layer {
##  name: "IGloss"
##  type: "InfogainLoss"
##  bottom: "prob"
##  bottom: "label"
##  bottom: "H"
##  top: "IGloss"
##  infogain_loss_param {
##    axis: 1  # compute loss and probability along axis
##  }
##  loss_param {
##      normalization: 0
##  }
##  exclude {
##    stage: "deploy"
##  }
##  loss_weight: 1
##}
