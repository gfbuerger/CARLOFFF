layer {
  name: "drop1"
  type: "Dropout"
  bottom: "data"
  top: "data"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "conv1"
  type: "Convolution"
  bottom: "data"
  top: "conv1"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 1
  }
  convolution_param {
    num_output: 96
    kernel_size: 3
    pad: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
layer {
  name: "relu1"
  type: "ReLU"
  bottom: "conv1"
  top: "conv1"
}
layer {
  name: "conv2"
  type: "Convolution"
  bottom: "conv1"
  top: "conv2"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 1
  }
  convolution_param {
    num_output: 96
    kernel_size: 3
    pad: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
layer {
  name: "relu2"
  type: "ReLU"
  bottom: "conv2"
  top: "conv2"
}
layer {
  name: "conv3"
  type: "Convolution"
  bottom: "conv2"
  top: "conv3"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 1
  }
  convolution_param {
    num_output: 96
    kernel_size: 3
    pad: 1
    stride: 2
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
layer {
  name: "relu3"
  type: "ReLU"
  bottom: "conv3"
  top: "conv3"
}
layer {
  name: "drop2"
  type: "Dropout"
  bottom: "conv3"
  top: "conv3"
  dropout_param {
    dropout_ratio: 0.5
  }
}
layer {
  name: "conv4"
  type: "Convolution"
  bottom: "conv3"
  top: "conv4"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 1
  }
  convolution_param {
    num_output: 192
    kernel_size: 3
    pad: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
layer {
  name: "relu4"
  type: "ReLU"
  bottom: "conv4"
  top: "conv4"
}
layer {
  name: "conv5"
  type: "Convolution"
  bottom: "conv4"
  top: "conv5"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 1
  }
  convolution_param {
    num_output: 192
    kernel_size: 3
    pad: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
layer {
  name: "relu5"
  type: "ReLU"
  bottom: "conv5"
  top: "conv5"
}
layer {
  name: "conv6"
  type: "Convolution"
  bottom: "conv5"
  top: "conv6"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 1
  }
  convolution_param {
    num_output: 192
    kernel_size: 3
    pad: 1
    stride: 2
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
layer {
  name: "relu6"
  type: "ReLU"
  bottom: "conv6"
  top: "conv6"
}
layer {
  name: "drop3"
  type: "Dropout"
  bottom: "conv6"
  top: "conv6"
  dropout_param {
    dropout_ratio: 0.5
  }
}
layer {
  name: "conv7"
  type: "Convolution"
  bottom: "conv6"
  top: "conv7"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 1
  }
  convolution_param {
    num_output: 192
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
layer {
  name: "relu7"
  type: "ReLU"
  bottom: "conv7"
  top: "conv7"
}
layer {
  name: "conv8"
  type: "Convolution"
  bottom: "conv7"
  top: "conv8"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 1
  }
  convolution_param {
    num_output: 192
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
layer {
  name: "relu8"
  type: "ReLU"
  bottom: "conv8"
  top: "conv8"
}
layer {
  name: "conv9"
  type: "Convolution"
  bottom: "conv8"
  top: "conv9"
  param {
    lr_mult: 1
  }
  param {
    lr_mult: 1
  }
  convolution_param {
    num_output: 2
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
layer {
  name: "relu9"
  type: "ReLU"
  bottom: "conv9"
  top: "conv9"
}
layer {
  name: "pool"
  type: "Pooling"
  bottom: "conv9"
  top: "out"
  pooling_param {
    pool: AVE
    global_pooling: true
  }
}
