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
layer {
  bottom: "out"
  bottom: "label"
  top: "infoGainLoss"
  name: "infoGainLoss"
  type: "InfogainLoss"
  loss_weight: 0
  infogain_loss_param {
    source: "data/infogainH.binaryproto"
  }
}
##layer {
##    name: "computeH"
##    bottom: "label"
##    top: "H"
##    type: "Python"
##    python_param {
##        module: "digits_python_layers"
##        layer: "ComputeH"
##        param_str: '{"n_classes": 10}'
##    }
##    exclude { stage: "deploy" }
##}

##layer {
##  name: "loss"
##  type: "InfogainLoss"
##  bottom: "ip2"
##  bottom: "label2"
##  bottom: "infogain"
##  top: "loss"
##  infogain_loss_param {
##    axis: 1  # compute loss and probability along axis
##  }
##  loss_param {
##      normalization: 0
##  }
##  exclude {
##    stage: "deploy"
##  }
##}
