# https://github.com/forresti/SqueezeNet/tree/master/SqueezeNet_v1.1

layer {
  name: "conv1"
  type: "Convolution"
  bottom: "data"
  top: "conv1"
  convolution_param {
    num_output: 64
    kernel_size: 3
    stride: 2
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "relu_conv1"
  type: "ReLU"
  bottom: "conv1"
  top: "conv1"
}
layer {
  name: "pool1"
  type: "Pooling"
  bottom: "conv1"
  top: "pool1"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "fire2/squeeze1x1"
  type: "Convolution"
  bottom: "pool1"
  top: "fire2/squeeze1x1"
  convolution_param {
    num_output: 16
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire2/relu_squeeze1x1"
  type: "ReLU"
  bottom: "fire2/squeeze1x1"
  top: "fire2/squeeze1x1"
}
layer {
  name: "fire2/expand1x1"
  type: "Convolution"
  bottom: "fire2/squeeze1x1"
  top: "fire2/expand1x1"
  convolution_param {
    num_output: 64
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire2/relu_expand1x1"
  type: "ReLU"
  bottom: "fire2/expand1x1"
  top: "fire2/expand1x1"
}
layer {
  name: "fire2/expand3x3"
  type: "Convolution"
  bottom: "fire2/squeeze1x1"
  top: "fire2/expand3x3"
  convolution_param {
    num_output: 64
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire2/relu_expand3x3"
  type: "ReLU"
  bottom: "fire2/expand3x3"
  top: "fire2/expand3x3"
}
layer {
  name: "fire2/concat"
  type: "Concat"
  bottom: "fire2/expand1x1"
  bottom: "fire2/expand3x3"
  top: "fire2/concat"
}
layer {
  name: "fire3/squeeze1x1"
  type: "Convolution"
  bottom: "fire2/concat"
  top: "fire3/squeeze1x1"
  convolution_param {
    num_output: 16
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire3/relu_squeeze1x1"
  type: "ReLU"
  bottom: "fire3/squeeze1x1"
  top: "fire3/squeeze1x1"
}
layer {
  name: "fire3/expand1x1"
  type: "Convolution"
  bottom: "fire3/squeeze1x1"
  top: "fire3/expand1x1"
  convolution_param {
    num_output: 64
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire3/relu_expand1x1"
  type: "ReLU"
  bottom: "fire3/expand1x1"
  top: "fire3/expand1x1"
}
layer {
  name: "fire3/expand3x3"
  type: "Convolution"
  bottom: "fire3/squeeze1x1"
  top: "fire3/expand3x3"
  convolution_param {
    num_output: 64
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire3/relu_expand3x3"
  type: "ReLU"
  bottom: "fire3/expand3x3"
  top: "fire3/expand3x3"
}
layer {
  name: "fire3/concat"
  type: "Concat"
  bottom: "fire3/expand1x1"
  bottom: "fire3/expand3x3"
  top: "fire3/concat"
}
layer {
  name: "pool3"
  type: "Pooling"
  bottom: "fire3/concat"
  top: "pool3"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "fire4/squeeze1x1"
  type: "Convolution"
  bottom: "pool3"
  top: "fire4/squeeze1x1"
  convolution_param {
    num_output: 32
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire4/relu_squeeze1x1"
  type: "ReLU"
  bottom: "fire4/squeeze1x1"
  top: "fire4/squeeze1x1"
}
layer {
  name: "fire4/expand1x1"
  type: "Convolution"
  bottom: "fire4/squeeze1x1"
  top: "fire4/expand1x1"
  convolution_param {
    num_output: 128
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire4/relu_expand1x1"
  type: "ReLU"
  bottom: "fire4/expand1x1"
  top: "fire4/expand1x1"
}
layer {
  name: "fire4/expand3x3"
  type: "Convolution"
  bottom: "fire4/squeeze1x1"
  top: "fire4/expand3x3"
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire4/relu_expand3x3"
  type: "ReLU"
  bottom: "fire4/expand3x3"
  top: "fire4/expand3x3"
}
layer {
  name: "fire4/concat"
  type: "Concat"
  bottom: "fire4/expand1x1"
  bottom: "fire4/expand3x3"
  top: "fire4/concat"
}
layer {
  name: "fire5/squeeze1x1"
  type: "Convolution"
  bottom: "fire4/concat"
  top: "fire5/squeeze1x1"
  convolution_param {
    num_output: 32
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire5/relu_squeeze1x1"
  type: "ReLU"
  bottom: "fire5/squeeze1x1"
  top: "fire5/squeeze1x1"
}
layer {
  name: "fire5/expand1x1"
  type: "Convolution"
  bottom: "fire5/squeeze1x1"
  top: "fire5/expand1x1"
  convolution_param {
    num_output: 128
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire5/relu_expand1x1"
  type: "ReLU"
  bottom: "fire5/expand1x1"
  top: "fire5/expand1x1"
}
layer {
  name: "fire5/expand3x3"
  type: "Convolution"
  bottom: "fire5/squeeze1x1"
  top: "fire5/expand3x3"
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire5/relu_expand3x3"
  type: "ReLU"
  bottom: "fire5/expand3x3"
  top: "fire5/expand3x3"
}
layer {
  name: "fire5/concat"
  type: "Concat"
  bottom: "fire5/expand1x1"
  bottom: "fire5/expand3x3"
  top: "fire5/concat"
}
layer {
  name: "pool5"
  type: "Pooling"
  bottom: "fire5/concat"
  top: "pool5"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "fire6/squeeze1x1"
  type: "Convolution"
  bottom: "pool5"
  top: "fire6/squeeze1x1"
  convolution_param {
    num_output: 48
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire6/relu_squeeze1x1"
  type: "ReLU"
  bottom: "fire6/squeeze1x1"
  top: "fire6/squeeze1x1"
}
layer {
  name: "fire6/expand1x1"
  type: "Convolution"
  bottom: "fire6/squeeze1x1"
  top: "fire6/expand1x1"
  convolution_param {
    num_output: 192
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire6/relu_expand1x1"
  type: "ReLU"
  bottom: "fire6/expand1x1"
  top: "fire6/expand1x1"
}
layer {
  name: "fire6/expand3x3"
  type: "Convolution"
  bottom: "fire6/squeeze1x1"
  top: "fire6/expand3x3"
  convolution_param {
    num_output: 192
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire6/relu_expand3x3"
  type: "ReLU"
  bottom: "fire6/expand3x3"
  top: "fire6/expand3x3"
}
layer {
  name: "fire6/concat"
  type: "Concat"
  bottom: "fire6/expand1x1"
  bottom: "fire6/expand3x3"
  top: "fire6/concat"
}
layer {
  name: "fire7/squeeze1x1"
  type: "Convolution"
  bottom: "fire6/concat"
  top: "fire7/squeeze1x1"
  convolution_param {
    num_output: 48
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire7/relu_squeeze1x1"
  type: "ReLU"
  bottom: "fire7/squeeze1x1"
  top: "fire7/squeeze1x1"
}
layer {
  name: "fire7/expand1x1"
  type: "Convolution"
  bottom: "fire7/squeeze1x1"
  top: "fire7/expand1x1"
  convolution_param {
    num_output: 192
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire7/relu_expand1x1"
  type: "ReLU"
  bottom: "fire7/expand1x1"
  top: "fire7/expand1x1"
}
layer {
  name: "fire7/expand3x3"
  type: "Convolution"
  bottom: "fire7/squeeze1x1"
  top: "fire7/expand3x3"
  convolution_param {
    num_output: 192
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire7/relu_expand3x3"
  type: "ReLU"
  bottom: "fire7/expand3x3"
  top: "fire7/expand3x3"
}
layer {
  name: "fire7/concat"
  type: "Concat"
  bottom: "fire7/expand1x1"
  bottom: "fire7/expand3x3"
  top: "fire7/concat"
}
layer {
  name: "fire8/squeeze1x1"
  type: "Convolution"
  bottom: "fire7/concat"
  top: "fire8/squeeze1x1"
  convolution_param {
    num_output: 64
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire8/relu_squeeze1x1"
  type: "ReLU"
  bottom: "fire8/squeeze1x1"
  top: "fire8/squeeze1x1"
}
layer {
  name: "fire8/expand1x1"
  type: "Convolution"
  bottom: "fire8/squeeze1x1"
  top: "fire8/expand1x1"
  convolution_param {
    num_output: 256
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire8/relu_expand1x1"
  type: "ReLU"
  bottom: "fire8/expand1x1"
  top: "fire8/expand1x1"
}
layer {
  name: "fire8/expand3x3"
  type: "Convolution"
  bottom: "fire8/squeeze1x1"
  top: "fire8/expand3x3"
  convolution_param {
    num_output: 256
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire8/relu_expand3x3"
  type: "ReLU"
  bottom: "fire8/expand3x3"
  top: "fire8/expand3x3"
}
layer {
  name: "fire8/concat"
  type: "Concat"
  bottom: "fire8/expand1x1"
  bottom: "fire8/expand3x3"
  top: "fire8/concat"
}
layer {
  name: "fire9/squeeze1x1"
  type: "Convolution"
  bottom: "fire8/concat"
  top: "fire9/squeeze1x1"
  convolution_param {
    num_output: 64
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire9/relu_squeeze1x1"
  type: "ReLU"
  bottom: "fire9/squeeze1x1"
  top: "fire9/squeeze1x1"
}
layer {
  name: "fire9/expand1x1"
  type: "Convolution"
  bottom: "fire9/squeeze1x1"
  top: "fire9/expand1x1"
  convolution_param {
    num_output: 256
    kernel_size: 1
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire9/relu_expand1x1"
  type: "ReLU"
  bottom: "fire9/expand1x1"
  top: "fire9/expand1x1"
}
layer {
  name: "fire9/expand3x3"
  type: "Convolution"
  bottom: "fire9/squeeze1x1"
  top: "fire9/expand3x3"
  convolution_param {
    num_output: 256
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "xavier"
    }
  }
}
layer {
  name: "fire9/relu_expand3x3"
  type: "ReLU"
  bottom: "fire9/expand3x3"
  top: "fire9/expand3x3"
}
layer {
  name: "fire9/concat"
  type: "Concat"
  bottom: "fire9/expand1x1"
  bottom: "fire9/expand3x3"
  top: "fire9/concat"
}
layer {
  name: "drop9"
  type: "Dropout"
  bottom: "fire9/concat"
  top: "fire9/concat"
  dropout_param {
    dropout_ratio: 0.5
  }
}
layer {
  name: "conv10"
  type: "Convolution"
  bottom: "fire9/concat"
  top: "conv10"
  convolution_param {
    num_output: 2
    kernel_size: 1
    weight_filler {
      type: "gaussian"
      mean: 0.0
      std: 0.01
    }
  }
}
layer {
  name: "relu_conv10"
  type: "ReLU"
  bottom: "conv10"
  top: "conv10"
}
layer {
  name: "pool10"
  type: "Pooling"
  bottom: "conv10"
  top: "out"
  pooling_param {
    pool: AVE
    global_pooling: true
  }
}