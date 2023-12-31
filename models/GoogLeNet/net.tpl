# https://github.com/lim0606/caffe-googlenet-bn

layer {
 bottom: "data"
  top: "conv1/7x7_s2"
  name: "conv1/7x7_s2"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 3
    kernel_size: 7
    stride: 2
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "conv1/7x7_s2"
  name: "conv1/7x7_s2/bn"
  top: "conv1/7x7_s2/bn"
  type: "BatchNorm"
}
layer {
  bottom: "conv1/7x7_s2/bn"
  top: "conv1/7x7_s2/bn/sc"
  name: "conv1/7x7_s2/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "conv1/7x7_s2/bn/sc"
  top: "conv1/7x7_s2/bn/sc"
  name: "conv1/7x7_s2/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "conv1/7x7_s2/bn/sc"
  top: "pool1/3x3_s2"
  name: "pool1/3x3_s2"
  type: "Pooling"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
 bottom: "pool1/3x3_s2"
  top: "conv2/3x3_reduce"
  name: "conv2/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "conv2/3x3_reduce"
  name: "conv2/3x3_reduce/bn"
  top: "conv2/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "conv2/3x3_reduce/bn"
  top: "conv2/3x3_reduce/bn/sc"
  name: "conv2/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "conv2/3x3_reduce/bn/sc"
  top: "conv2/3x3_reduce/bn/sc"
  name: "conv2/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "conv2/3x3_reduce/bn/sc"
  top: "conv2/3x3"
  name: "conv2/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "conv2/3x3"
  name: "conv2/3x3/bn"
  top: "conv2/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "conv2/3x3/bn"
  top: "conv2/3x3/bn/sc"
  name: "conv2/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "conv2/3x3/bn/sc"
  top: "conv2/3x3/bn/sc"
  name: "conv2/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "conv2/3x3/bn/sc"
  top: "pool2/3x3_s2"
  name: "pool2/3x3_s2"
  type: "Pooling"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
 bottom: "pool2/3x3_s2"
  top: "inception_3a/1x1"
  name: "inception_3a/1x1"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3a/1x1"
  name: "inception_3a/1x1/bn"
  top: "inception_3a/1x1/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3a/1x1/bn"
  top: "inception_3a/1x1/bn/sc"
  name: "inception_3a/1x1/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3a/1x1/bn/sc"
  top: "inception_3a/1x1/bn/sc"
  name: "inception_3a/1x1/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "pool2/3x3_s2"
  top: "inception_3a/3x3_reduce"
  name: "inception_3a/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3a/3x3_reduce"
  name: "inception_3a/3x3_reduce/bn"
  top: "inception_3a/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3a/3x3_reduce/bn"
  top: "inception_3a/3x3_reduce/bn/sc"
  name: "inception_3a/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3a/3x3_reduce/bn/sc"
  top: "inception_3a/3x3_reduce/bn/sc"
  name: "inception_3a/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3a/3x3_reduce/bn/sc"
  top: "inception_3a/3x3"
  name: "inception_3a/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3a/3x3"
  name: "inception_3a/3x3/bn"
  top: "inception_3a/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3a/3x3/bn"
  top: "inception_3a/3x3/bn/sc"
  name: "inception_3a/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3a/3x3/bn/sc"
  top: "inception_3a/3x3/bn/sc"
  name: "inception_3a/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "pool2/3x3_s2"
  top: "inception_3a/double3x3_reduce"
  name: "inception_3a/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3a/double3x3_reduce"
  name: "inception_3a/double3x3_reduce/bn"
  top: "inception_3a/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3a/double3x3_reduce/bn"
  top: "inception_3a/double3x3_reduce/bn/sc"
  name: "inception_3a/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3a/double3x3_reduce/bn/sc"
  top: "inception_3a/double3x3_reduce/bn/sc"
  name: "inception_3a/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3a/double3x3_reduce/bn/sc"
  top: "inception_3a/double3x3a"
  name: "inception_3a/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3a/double3x3a"
  name: "inception_3a/double3x3a/bn"
  top: "inception_3a/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3a/double3x3a/bn"
  top: "inception_3a/double3x3a/bn/sc"
  name: "inception_3a/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3a/double3x3a/bn/sc"
  top: "inception_3a/double3x3a/bn/sc"
  name: "inception_3a/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3a/double3x3a/bn/sc"
  top: "inception_3a/double3x3b"
  name: "inception_3a/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3a/double3x3b"
  name: "inception_3a/double3x3b/bn"
  top: "inception_3a/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3a/double3x3b/bn"
  top: "inception_3a/double3x3b/bn/sc"
  name: "inception_3a/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3a/double3x3b/bn/sc"
  top: "inception_3a/double3x3b/bn/sc"
  name: "inception_3a/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "pool2/3x3_s2"
  top: "inception_3a/pool"
  name: "inception_3a/pool"
  type: "Pooling"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
 bottom: "inception_3a/pool"
  top: "inception_3a/pool_proj"
  name: "inception_3a/pool_proj"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 32
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3a/pool_proj"
  name: "inception_3a/pool_proj/bn"
  top: "inception_3a/pool_proj/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3a/pool_proj/bn"
  top: "inception_3a/pool_proj/bn/sc"
  name: "inception_3a/pool_proj/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3a/pool_proj/bn/sc"
  top: "inception_3a/pool_proj/bn/sc"
  name: "inception_3a/pool_proj/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_3a/1x1/bn/sc"
  bottom: "inception_3a/3x3/bn/sc"
  bottom: "inception_3a/double3x3b/bn/sc"
  bottom: "inception_3a/pool_proj/bn/sc"
  top: "inception_3a/output"
  name: "inception_3a/output"
  type: "Concat"
}
layer {
 bottom: "inception_3a/output"
  top: "inception_3b/1x1"
  name: "inception_3b/1x1"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3b/1x1"
  name: "inception_3b/1x1/bn"
  top: "inception_3b/1x1/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3b/1x1/bn"
  top: "inception_3b/1x1/bn/sc"
  name: "inception_3b/1x1/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3b/1x1/bn/sc"
  top: "inception_3b/1x1/bn/sc"
  name: "inception_3b/1x1/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3a/output"
  top: "inception_3b/3x3_reduce"
  name: "inception_3b/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3b/3x3_reduce"
  name: "inception_3b/3x3_reduce/bn"
  top: "inception_3b/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3b/3x3_reduce/bn"
  top: "inception_3b/3x3_reduce/bn/sc"
  name: "inception_3b/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3b/3x3_reduce/bn/sc"
  top: "inception_3b/3x3_reduce/bn/sc"
  name: "inception_3b/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3b/3x3_reduce/bn/sc"
  top: "inception_3b/3x3"
  name: "inception_3b/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3b/3x3"
  name: "inception_3b/3x3/bn"
  top: "inception_3b/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3b/3x3/bn"
  top: "inception_3b/3x3/bn/sc"
  name: "inception_3b/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3b/3x3/bn/sc"
  top: "inception_3b/3x3/bn/sc"
  name: "inception_3b/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3a/output"
  top: "inception_3b/double3x3_reduce"
  name: "inception_3b/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3b/double3x3_reduce"
  name: "inception_3b/double3x3_reduce/bn"
  top: "inception_3b/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3b/double3x3_reduce/bn"
  top: "inception_3b/double3x3_reduce/bn/sc"
  name: "inception_3b/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3b/double3x3_reduce/bn/sc"
  top: "inception_3b/double3x3_reduce/bn/sc"
  name: "inception_3b/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3b/double3x3_reduce/bn/sc"
  top: "inception_3b/double3x3a"
  name: "inception_3b/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3b/double3x3a"
  name: "inception_3b/double3x3a/bn"
  top: "inception_3b/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3b/double3x3a/bn"
  top: "inception_3b/double3x3a/bn/sc"
  name: "inception_3b/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3b/double3x3a/bn/sc"
  top: "inception_3b/double3x3a/bn/sc"
  name: "inception_3b/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3b/double3x3a/bn/sc"
  top: "inception_3b/double3x3b"
  name: "inception_3b/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3b/double3x3b"
  name: "inception_3b/double3x3b/bn"
  top: "inception_3b/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3b/double3x3b/bn"
  top: "inception_3b/double3x3b/bn/sc"
  name: "inception_3b/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3b/double3x3b/bn/sc"
  top: "inception_3b/double3x3b/bn/sc"
  name: "inception_3b/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_3a/output"
  top: "inception_3b/pool"
  name: "inception_3b/pool"
  type: "Pooling"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
 bottom: "inception_3b/pool"
  top: "inception_3b/pool_proj"
  name: "inception_3b/pool_proj"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3b/pool_proj"
  name: "inception_3b/pool_proj/bn"
  top: "inception_3b/pool_proj/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3b/pool_proj/bn"
  top: "inception_3b/pool_proj/bn/sc"
  name: "inception_3b/pool_proj/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3b/pool_proj/bn/sc"
  top: "inception_3b/pool_proj/bn/sc"
  name: "inception_3b/pool_proj/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_3b/1x1/bn/sc"
  bottom: "inception_3b/3x3/bn/sc"
  bottom: "inception_3b/double3x3b/bn/sc"
  bottom: "inception_3b/pool_proj/bn/sc"
  top: "inception_3b/output"
  name: "inception_3b/output"
  type: "Concat"
}
layer {
 bottom: "inception_3b/output"
  top: "inception_3c/3x3_reduce"
  name: "inception_3c/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3c/3x3_reduce"
  name: "inception_3c/3x3_reduce/bn"
  top: "inception_3c/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3c/3x3_reduce/bn"
  top: "inception_3c/3x3_reduce/bn/sc"
  name: "inception_3c/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3c/3x3_reduce/bn/sc"
  top: "inception_3c/3x3_reduce/bn/sc"
  name: "inception_3c/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3c/3x3_reduce/bn/sc"
  top: "inception_3c/3x3"
  name: "inception_3c/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 160
    pad: 1
    kernel_size: 3
    stride: 2
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3c/3x3"
  name: "inception_3c/3x3/bn"
  top: "inception_3c/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3c/3x3/bn"
  top: "inception_3c/3x3/bn/sc"
  name: "inception_3c/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3c/3x3/bn/sc"
  top: "inception_3c/3x3/bn/sc"
  name: "inception_3c/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3b/output"
  top: "inception_3c/double3x3_reduce"
  name: "inception_3c/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3c/double3x3_reduce"
  name: "inception_3c/double3x3_reduce/bn"
  top: "inception_3c/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3c/double3x3_reduce/bn"
  top: "inception_3c/double3x3_reduce/bn/sc"
  name: "inception_3c/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3c/double3x3_reduce/bn/sc"
  top: "inception_3c/double3x3_reduce/bn/sc"
  name: "inception_3c/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3c/double3x3_reduce/bn/sc"
  top: "inception_3c/double3x3a"
  name: "inception_3c/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3c/double3x3a"
  name: "inception_3c/double3x3a/bn"
  top: "inception_3c/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3c/double3x3a/bn"
  top: "inception_3c/double3x3a/bn/sc"
  name: "inception_3c/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3c/double3x3a/bn/sc"
  top: "inception_3c/double3x3a/bn/sc"
  name: "inception_3c/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3c/double3x3a/bn/sc"
  top: "inception_3c/double3x3b"
  name: "inception_3c/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 2
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_3c/double3x3b"
  name: "inception_3c/double3x3b/bn"
  top: "inception_3c/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_3c/double3x3b/bn"
  top: "inception_3c/double3x3b/bn/sc"
  name: "inception_3c/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_3c/double3x3b/bn/sc"
  top: "inception_3c/double3x3b/bn/sc"
  name: "inception_3c/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_3b/output"
  top: "inception_3c/pool"
  name: "inception_3c/pool"
  type: "Pooling"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
  bottom: "inception_3c/3x3/bn/sc"
  bottom: "inception_3c/double3x3b/bn/sc"
  bottom: "inception_3c/pool"
  top: "inception_3c/output"
  name: "inception_3c/output"
  type: "Concat"
}
layer {
 bottom: "inception_3c/output"
  top: "inception_4a/1x1"
  name: "inception_4a/1x1"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 224
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4a/1x1"
  name: "inception_4a/1x1/bn"
  top: "inception_4a/1x1/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4a/1x1/bn"
  top: "inception_4a/1x1/bn/sc"
  name: "inception_4a/1x1/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4a/1x1/bn/sc"
  top: "inception_4a/1x1/bn/sc"
  name: "inception_4a/1x1/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3c/output"
  top: "inception_4a/3x3_reduce"
  name: "inception_4a/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4a/3x3_reduce"
  name: "inception_4a/3x3_reduce/bn"
  top: "inception_4a/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4a/3x3_reduce/bn"
  top: "inception_4a/3x3_reduce/bn/sc"
  name: "inception_4a/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4a/3x3_reduce/bn/sc"
  top: "inception_4a/3x3_reduce/bn/sc"
  name: "inception_4a/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4a/3x3_reduce/bn/sc"
  top: "inception_4a/3x3"
  name: "inception_4a/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4a/3x3"
  name: "inception_4a/3x3/bn"
  top: "inception_4a/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4a/3x3/bn"
  top: "inception_4a/3x3/bn/sc"
  name: "inception_4a/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4a/3x3/bn/sc"
  top: "inception_4a/3x3/bn/sc"
  name: "inception_4a/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_3c/output"
  top: "inception_4a/double3x3_reduce"
  name: "inception_4a/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4a/double3x3_reduce"
  name: "inception_4a/double3x3_reduce/bn"
  top: "inception_4a/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4a/double3x3_reduce/bn"
  top: "inception_4a/double3x3_reduce/bn/sc"
  name: "inception_4a/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4a/double3x3_reduce/bn/sc"
  top: "inception_4a/double3x3_reduce/bn/sc"
  name: "inception_4a/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4a/double3x3_reduce/bn/sc"
  top: "inception_4a/double3x3a"
  name: "inception_4a/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4a/double3x3a"
  name: "inception_4a/double3x3a/bn"
  top: "inception_4a/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4a/double3x3a/bn"
  top: "inception_4a/double3x3a/bn/sc"
  name: "inception_4a/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4a/double3x3a/bn/sc"
  top: "inception_4a/double3x3a/bn/sc"
  name: "inception_4a/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4a/double3x3a/bn/sc"
  top: "inception_4a/double3x3b"
  name: "inception_4a/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4a/double3x3b"
  name: "inception_4a/double3x3b/bn"
  top: "inception_4a/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4a/double3x3b/bn"
  top: "inception_4a/double3x3b/bn/sc"
  name: "inception_4a/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4a/double3x3b/bn/sc"
  top: "inception_4a/double3x3b/bn/sc"
  name: "inception_4a/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_3c/output"
  top: "inception_4a/pool"
  name: "inception_4a/pool"
  type: "Pooling"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
 bottom: "inception_4a/pool"
  top: "inception_4a/pool_proj"
  name: "inception_4a/pool_proj"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4a/pool_proj"
  name: "inception_4a/pool_proj/bn"
  top: "inception_4a/pool_proj/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4a/pool_proj/bn"
  top: "inception_4a/pool_proj/bn/sc"
  name: "inception_4a/pool_proj/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4a/pool_proj/bn/sc"
  top: "inception_4a/pool_proj/bn/sc"
  name: "inception_4a/pool_proj/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_4a/1x1/bn/sc"
  bottom: "inception_4a/3x3/bn/sc"
  bottom: "inception_4a/double3x3b/bn/sc"
  bottom: "inception_4a/pool_proj/bn/sc"
  top: "inception_4a/output"
  name: "inception_4a/output"
  type: "Concat"
}
layer {
 bottom: "inception_4a/output"
  top: "inception_4b/1x1"
  name: "inception_4b/1x1"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4b/1x1"
  name: "inception_4b/1x1/bn"
  top: "inception_4b/1x1/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4b/1x1/bn"
  top: "inception_4b/1x1/bn/sc"
  name: "inception_4b/1x1/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4b/1x1/bn/sc"
  top: "inception_4b/1x1/bn/sc"
  name: "inception_4b/1x1/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4a/output"
  top: "inception_4b/3x3_reduce"
  name: "inception_4b/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4b/3x3_reduce"
  name: "inception_4b/3x3_reduce/bn"
  top: "inception_4b/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4b/3x3_reduce/bn"
  top: "inception_4b/3x3_reduce/bn/sc"
  name: "inception_4b/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4b/3x3_reduce/bn/sc"
  top: "inception_4b/3x3_reduce/bn/sc"
  name: "inception_4b/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4b/3x3_reduce/bn/sc"
  top: "inception_4b/3x3"
  name: "inception_4b/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4b/3x3"
  name: "inception_4b/3x3/bn"
  top: "inception_4b/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4b/3x3/bn"
  top: "inception_4b/3x3/bn/sc"
  name: "inception_4b/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4b/3x3/bn/sc"
  top: "inception_4b/3x3/bn/sc"
  name: "inception_4b/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4a/output"
  top: "inception_4b/double3x3_reduce"
  name: "inception_4b/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4b/double3x3_reduce"
  name: "inception_4b/double3x3_reduce/bn"
  top: "inception_4b/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4b/double3x3_reduce/bn"
  top: "inception_4b/double3x3_reduce/bn/sc"
  name: "inception_4b/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4b/double3x3_reduce/bn/sc"
  top: "inception_4b/double3x3_reduce/bn/sc"
  name: "inception_4b/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4b/double3x3_reduce/bn/sc"
  top: "inception_4b/double3x3a"
  name: "inception_4b/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4b/double3x3a"
  name: "inception_4b/double3x3a/bn"
  top: "inception_4b/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4b/double3x3a/bn"
  top: "inception_4b/double3x3a/bn/sc"
  name: "inception_4b/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4b/double3x3a/bn/sc"
  top: "inception_4b/double3x3a/bn/sc"
  name: "inception_4b/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4b/double3x3a/bn/sc"
  top: "inception_4b/double3x3b"
  name: "inception_4b/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4b/double3x3b"
  name: "inception_4b/double3x3b/bn"
  top: "inception_4b/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4b/double3x3b/bn"
  top: "inception_4b/double3x3b/bn/sc"
  name: "inception_4b/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4b/double3x3b/bn/sc"
  top: "inception_4b/double3x3b/bn/sc"
  name: "inception_4b/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_4a/output"
  top: "inception_4b/pool"
  name: "inception_4b/pool"
  type: "Pooling"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
 bottom: "inception_4b/pool"
  top: "inception_4b/pool_proj"
  name: "inception_4b/pool_proj"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4b/pool_proj"
  name: "inception_4b/pool_proj/bn"
  top: "inception_4b/pool_proj/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4b/pool_proj/bn"
  top: "inception_4b/pool_proj/bn/sc"
  name: "inception_4b/pool_proj/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4b/pool_proj/bn/sc"
  top: "inception_4b/pool_proj/bn/sc"
  name: "inception_4b/pool_proj/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_4b/1x1/bn/sc"
  bottom: "inception_4b/3x3/bn/sc"
  bottom: "inception_4b/double3x3b/bn/sc"
  bottom: "inception_4b/pool_proj/bn/sc"
  top: "inception_4b/output"
  name: "inception_4b/output"
  type: "Concat"
}
layer {
 bottom: "inception_4b/output"
  top: "inception_4c/1x1"
  name: "inception_4c/1x1"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 160
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4c/1x1"
  name: "inception_4c/1x1/bn"
  top: "inception_4c/1x1/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4c/1x1/bn"
  top: "inception_4c/1x1/bn/sc"
  name: "inception_4c/1x1/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4c/1x1/bn/sc"
  top: "inception_4c/1x1/bn/sc"
  name: "inception_4c/1x1/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4b/output"
  top: "inception_4c/3x3_reduce"
  name: "inception_4c/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4c/3x3_reduce"
  name: "inception_4c/3x3_reduce/bn"
  top: "inception_4c/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4c/3x3_reduce/bn"
  top: "inception_4c/3x3_reduce/bn/sc"
  name: "inception_4c/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4c/3x3_reduce/bn/sc"
  top: "inception_4c/3x3_reduce/bn/sc"
  name: "inception_4c/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4c/3x3_reduce/bn/sc"
  top: "inception_4c/3x3"
  name: "inception_4c/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 160
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4c/3x3"
  name: "inception_4c/3x3/bn"
  top: "inception_4c/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4c/3x3/bn"
  top: "inception_4c/3x3/bn/sc"
  name: "inception_4c/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4c/3x3/bn/sc"
  top: "inception_4c/3x3/bn/sc"
  name: "inception_4c/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4b/output"
  top: "inception_4c/double3x3_reduce"
  name: "inception_4c/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4c/double3x3_reduce"
  name: "inception_4c/double3x3_reduce/bn"
  top: "inception_4c/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4c/double3x3_reduce/bn"
  top: "inception_4c/double3x3_reduce/bn/sc"
  name: "inception_4c/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4c/double3x3_reduce/bn/sc"
  top: "inception_4c/double3x3_reduce/bn/sc"
  name: "inception_4c/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4c/double3x3_reduce/bn/sc"
  top: "inception_4c/double3x3a"
  name: "inception_4c/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 160
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4c/double3x3a"
  name: "inception_4c/double3x3a/bn"
  top: "inception_4c/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4c/double3x3a/bn"
  top: "inception_4c/double3x3a/bn/sc"
  name: "inception_4c/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4c/double3x3a/bn/sc"
  top: "inception_4c/double3x3a/bn/sc"
  name: "inception_4c/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4c/double3x3a/bn/sc"
  top: "inception_4c/double3x3b"
  name: "inception_4c/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 160
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4c/double3x3b"
  name: "inception_4c/double3x3b/bn"
  top: "inception_4c/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4c/double3x3b/bn"
  top: "inception_4c/double3x3b/bn/sc"
  name: "inception_4c/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4c/double3x3b/bn/sc"
  top: "inception_4c/double3x3b/bn/sc"
  name: "inception_4c/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_4b/output"
  top: "inception_4c/pool"
  name: "inception_4c/pool"
  type: "Pooling"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
 bottom: "inception_4c/pool"
  top: "inception_4c/pool_proj"
  name: "inception_4c/pool_proj"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4c/pool_proj"
  name: "inception_4c/pool_proj/bn"
  top: "inception_4c/pool_proj/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4c/pool_proj/bn"
  top: "inception_4c/pool_proj/bn/sc"
  name: "inception_4c/pool_proj/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4c/pool_proj/bn/sc"
  top: "inception_4c/pool_proj/bn/sc"
  name: "inception_4c/pool_proj/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_4c/1x1/bn/sc"
  bottom: "inception_4c/3x3/bn/sc"
  bottom: "inception_4c/double3x3b/bn/sc"
  bottom: "inception_4c/pool_proj/bn/sc"
  top: "inception_4c/output"
  name: "inception_4c/output"
  type: "Concat"
}
layer {
 bottom: "inception_4c/output"
  top: "inception_4d/1x1"
  name: "inception_4d/1x1"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4d/1x1"
  name: "inception_4d/1x1/bn"
  top: "inception_4d/1x1/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4d/1x1/bn"
  top: "inception_4d/1x1/bn/sc"
  name: "inception_4d/1x1/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4d/1x1/bn/sc"
  top: "inception_4d/1x1/bn/sc"
  name: "inception_4d/1x1/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4c/output"
  top: "inception_4d/3x3_reduce"
  name: "inception_4d/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4d/3x3_reduce"
  name: "inception_4d/3x3_reduce/bn"
  top: "inception_4d/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4d/3x3_reduce/bn"
  top: "inception_4d/3x3_reduce/bn/sc"
  name: "inception_4d/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4d/3x3_reduce/bn/sc"
  top: "inception_4d/3x3_reduce/bn/sc"
  name: "inception_4d/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4d/3x3_reduce/bn/sc"
  top: "inception_4d/3x3"
  name: "inception_4d/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4d/3x3"
  name: "inception_4d/3x3/bn"
  top: "inception_4d/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4d/3x3/bn"
  top: "inception_4d/3x3/bn/sc"
  name: "inception_4d/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4d/3x3/bn/sc"
  top: "inception_4d/3x3/bn/sc"
  name: "inception_4d/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4c/output"
  top: "inception_4d/double3x3_reduce"
  name: "inception_4d/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 160
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4d/double3x3_reduce"
  name: "inception_4d/double3x3_reduce/bn"
  top: "inception_4d/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4d/double3x3_reduce/bn"
  top: "inception_4d/double3x3_reduce/bn/sc"
  name: "inception_4d/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4d/double3x3_reduce/bn/sc"
  top: "inception_4d/double3x3_reduce/bn/sc"
  name: "inception_4d/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4d/double3x3_reduce/bn/sc"
  top: "inception_4d/double3x3a"
  name: "inception_4d/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4d/double3x3a"
  name: "inception_4d/double3x3a/bn"
  top: "inception_4d/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4d/double3x3a/bn"
  top: "inception_4d/double3x3a/bn/sc"
  name: "inception_4d/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4d/double3x3a/bn/sc"
  top: "inception_4d/double3x3a/bn/sc"
  name: "inception_4d/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4d/double3x3a/bn/sc"
  top: "inception_4d/double3x3b"
  name: "inception_4d/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4d/double3x3b"
  name: "inception_4d/double3x3b/bn"
  top: "inception_4d/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4d/double3x3b/bn"
  top: "inception_4d/double3x3b/bn/sc"
  name: "inception_4d/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4d/double3x3b/bn/sc"
  top: "inception_4d/double3x3b/bn/sc"
  name: "inception_4d/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_4c/output"
  top: "inception_4d/pool"
  name: "inception_4d/pool"
  type: "Pooling"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
 bottom: "inception_4d/pool"
  top: "inception_4d/pool_proj"
  name: "inception_4d/pool_proj"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4d/pool_proj"
  name: "inception_4d/pool_proj/bn"
  top: "inception_4d/pool_proj/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4d/pool_proj/bn"
  top: "inception_4d/pool_proj/bn/sc"
  name: "inception_4d/pool_proj/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4d/pool_proj/bn/sc"
  top: "inception_4d/pool_proj/bn/sc"
  name: "inception_4d/pool_proj/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_4d/1x1/bn/sc"
  bottom: "inception_4d/3x3/bn/sc"
  bottom: "inception_4d/double3x3b/bn/sc"
  bottom: "inception_4d/pool_proj/bn/sc"
  top: "inception_4d/output"
  name: "inception_4d/output"
  type: "Concat"
}
layer {
 bottom: "inception_4d/output"
  top: "inception_4e/3x3_reduce"
  name: "inception_4e/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4e/3x3_reduce"
  name: "inception_4e/3x3_reduce/bn"
  top: "inception_4e/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4e/3x3_reduce/bn"
  top: "inception_4e/3x3_reduce/bn/sc"
  name: "inception_4e/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4e/3x3_reduce/bn/sc"
  top: "inception_4e/3x3_reduce/bn/sc"
  name: "inception_4e/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4e/3x3_reduce/bn/sc"
  top: "inception_4e/3x3"
  name: "inception_4e/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 1
    kernel_size: 3
    stride: 2
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4e/3x3"
  name: "inception_4e/3x3/bn"
  top: "inception_4e/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4e/3x3/bn"
  top: "inception_4e/3x3/bn/sc"
  name: "inception_4e/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4e/3x3/bn/sc"
  top: "inception_4e/3x3/bn/sc"
  name: "inception_4e/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4d/output"
  top: "inception_4e/double3x3_reduce"
  name: "inception_4e/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4e/double3x3_reduce"
  name: "inception_4e/double3x3_reduce/bn"
  top: "inception_4e/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4e/double3x3_reduce/bn"
  top: "inception_4e/double3x3_reduce/bn/sc"
  name: "inception_4e/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4e/double3x3_reduce/bn/sc"
  top: "inception_4e/double3x3_reduce/bn/sc"
  name: "inception_4e/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4e/double3x3_reduce/bn/sc"
  top: "inception_4e/double3x3a"
  name: "inception_4e/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 256
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4e/double3x3a"
  name: "inception_4e/double3x3a/bn"
  top: "inception_4e/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4e/double3x3a/bn"
  top: "inception_4e/double3x3a/bn/sc"
  name: "inception_4e/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4e/double3x3a/bn/sc"
  top: "inception_4e/double3x3a/bn/sc"
  name: "inception_4e/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4e/double3x3a/bn/sc"
  top: "inception_4e/double3x3b"
  name: "inception_4e/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 256
    pad: 1
    kernel_size: 3
    stride: 2
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_4e/double3x3b"
  name: "inception_4e/double3x3b/bn"
  top: "inception_4e/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_4e/double3x3b/bn"
  top: "inception_4e/double3x3b/bn/sc"
  name: "inception_4e/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_4e/double3x3b/bn/sc"
  top: "inception_4e/double3x3b/bn/sc"
  name: "inception_4e/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_4d/output"
  top: "inception_4e/pool"
  name: "inception_4e/pool"
  type: "Pooling"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
  bottom: "inception_4e/3x3/bn/sc"
  bottom: "inception_4e/double3x3b/bn/sc"
  bottom: "inception_4e/pool"
  top: "inception_4e/output"
  name: "inception_4e/output"
  type: "Concat"
}
layer {
 bottom: "inception_4e/output"
  top: "inception_5a/1x1"
  name: "inception_5a/1x1"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 352
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5a/1x1"
  name: "inception_5a/1x1/bn"
  top: "inception_5a/1x1/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5a/1x1/bn"
  top: "inception_5a/1x1/bn/sc"
  name: "inception_5a/1x1/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5a/1x1/bn/sc"
  top: "inception_5a/1x1/bn/sc"
  name: "inception_5a/1x1/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4e/output"
  top: "inception_5a/3x3_reduce"
  name: "inception_5a/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5a/3x3_reduce"
  name: "inception_5a/3x3_reduce/bn"
  top: "inception_5a/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5a/3x3_reduce/bn"
  top: "inception_5a/3x3_reduce/bn/sc"
  name: "inception_5a/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5a/3x3_reduce/bn/sc"
  top: "inception_5a/3x3_reduce/bn/sc"
  name: "inception_5a/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_5a/3x3_reduce/bn/sc"
  top: "inception_5a/3x3"
  name: "inception_5a/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 320
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5a/3x3"
  name: "inception_5a/3x3/bn"
  top: "inception_5a/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5a/3x3/bn"
  top: "inception_5a/3x3/bn/sc"
  name: "inception_5a/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5a/3x3/bn/sc"
  top: "inception_5a/3x3/bn/sc"
  name: "inception_5a/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_4e/output"
  top: "inception_5a/double3x3_reduce"
  name: "inception_5a/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 160
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5a/double3x3_reduce"
  name: "inception_5a/double3x3_reduce/bn"
  top: "inception_5a/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5a/double3x3_reduce/bn"
  top: "inception_5a/double3x3_reduce/bn/sc"
  name: "inception_5a/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5a/double3x3_reduce/bn/sc"
  top: "inception_5a/double3x3_reduce/bn/sc"
  name: "inception_5a/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_5a/double3x3_reduce/bn/sc"
  top: "inception_5a/double3x3a"
  name: "inception_5a/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 224
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5a/double3x3a"
  name: "inception_5a/double3x3a/bn"
  top: "inception_5a/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5a/double3x3a/bn"
  top: "inception_5a/double3x3a/bn/sc"
  name: "inception_5a/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5a/double3x3a/bn/sc"
  top: "inception_5a/double3x3a/bn/sc"
  name: "inception_5a/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_5a/double3x3a/bn/sc"
  top: "inception_5a/double3x3b"
  name: "inception_5a/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 224
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5a/double3x3b"
  name: "inception_5a/double3x3b/bn"
  top: "inception_5a/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5a/double3x3b/bn"
  top: "inception_5a/double3x3b/bn/sc"
  name: "inception_5a/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5a/double3x3b/bn/sc"
  top: "inception_5a/double3x3b/bn/sc"
  name: "inception_5a/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_4e/output"
  top: "inception_5a/pool"
  name: "inception_5a/pool"
  type: "Pooling"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
 bottom: "inception_5a/pool"
  top: "inception_5a/pool_proj"
  name: "inception_5a/pool_proj"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5a/pool_proj"
  name: "inception_5a/pool_proj/bn"
  top: "inception_5a/pool_proj/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5a/pool_proj/bn"
  top: "inception_5a/pool_proj/bn/sc"
  name: "inception_5a/pool_proj/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5a/pool_proj/bn/sc"
  top: "inception_5a/pool_proj/bn/sc"
  name: "inception_5a/pool_proj/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_5a/1x1/bn/sc"
  bottom: "inception_5a/3x3/bn/sc"
  bottom: "inception_5a/double3x3b/bn/sc"
  bottom: "inception_5a/pool_proj/bn/sc"
  top: "inception_5a/output"
  name: "inception_5a/output"
  type: "Concat"
}
layer {
 bottom: "inception_5a/output"
  top: "inception_5b/1x1"
  name: "inception_5b/1x1"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 352
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5b/1x1"
  name: "inception_5b/1x1/bn"
  top: "inception_5b/1x1/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5b/1x1/bn"
  top: "inception_5b/1x1/bn/sc"
  name: "inception_5b/1x1/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5b/1x1/bn/sc"
  top: "inception_5b/1x1/bn/sc"
  name: "inception_5b/1x1/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_5a/output"
  top: "inception_5b/3x3_reduce"
  name: "inception_5b/3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5b/3x3_reduce"
  name: "inception_5b/3x3_reduce/bn"
  top: "inception_5b/3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5b/3x3_reduce/bn"
  top: "inception_5b/3x3_reduce/bn/sc"
  name: "inception_5b/3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5b/3x3_reduce/bn/sc"
  top: "inception_5b/3x3_reduce/bn/sc"
  name: "inception_5b/3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_5b/3x3_reduce/bn/sc"
  top: "inception_5b/3x3"
  name: "inception_5b/3x3"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 320
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5b/3x3"
  name: "inception_5b/3x3/bn"
  top: "inception_5b/3x3/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5b/3x3/bn"
  top: "inception_5b/3x3/bn/sc"
  name: "inception_5b/3x3/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5b/3x3/bn/sc"
  top: "inception_5b/3x3/bn/sc"
  name: "inception_5b/3x3/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_5a/output"
  top: "inception_5b/double3x3_reduce"
  name: "inception_5b/double3x3_reduce"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5b/double3x3_reduce"
  name: "inception_5b/double3x3_reduce/bn"
  top: "inception_5b/double3x3_reduce/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5b/double3x3_reduce/bn"
  top: "inception_5b/double3x3_reduce/bn/sc"
  name: "inception_5b/double3x3_reduce/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5b/double3x3_reduce/bn/sc"
  top: "inception_5b/double3x3_reduce/bn/sc"
  name: "inception_5b/double3x3_reduce/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_5b/double3x3_reduce/bn/sc"
  top: "inception_5b/double3x3a"
  name: "inception_5b/double3x3a"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 224
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5b/double3x3a"
  name: "inception_5b/double3x3a/bn"
  top: "inception_5b/double3x3a/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5b/double3x3a/bn"
  top: "inception_5b/double3x3a/bn/sc"
  name: "inception_5b/double3x3a/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5b/double3x3a/bn/sc"
  top: "inception_5b/double3x3a/bn/sc"
  name: "inception_5b/double3x3a/bn/sc/relu"
  type: "ReLU"
}
layer {
 bottom: "inception_5b/double3x3a/bn/sc"
  top: "inception_5b/double3x3b"
  name: "inception_5b/double3x3b"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 224
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5b/double3x3b"
  name: "inception_5b/double3x3b/bn"
  top: "inception_5b/double3x3b/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5b/double3x3b/bn"
  top: "inception_5b/double3x3b/bn/sc"
  name: "inception_5b/double3x3b/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5b/double3x3b/bn/sc"
  top: "inception_5b/double3x3b/bn/sc"
  name: "inception_5b/double3x3b/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_5a/output"
  top: "inception_5b/pool"
  name: "inception_5b/pool"
  type: "Pooling"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
 bottom: "inception_5b/pool"
  top: "inception_5b/pool_proj"
  name: "inception_5b/pool_proj"
  type: "Convolution"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "xavier"
    }
    bias_term: false
  }
}
layer {
  bottom: "inception_5b/pool_proj"
  name: "inception_5b/pool_proj/bn"
  top: "inception_5b/pool_proj/bn"
  type: "BatchNorm"
}
layer {
  bottom: "inception_5b/pool_proj/bn"
  top: "inception_5b/pool_proj/bn/sc"
  name: "inception_5b/pool_proj/bn/sc"
  type: "Scale"
  scale_param {
    bias_term: true
  }
}
layer {
  bottom: "inception_5b/pool_proj/bn/sc"
  top: "inception_5b/pool_proj/bn/sc"
  name: "inception_5b/pool_proj/bn/sc/relu"
  type: "ReLU"
}
layer {
  bottom: "inception_5b/1x1/bn/sc"
  bottom: "inception_5b/3x3/bn/sc"
  bottom: "inception_5b/double3x3b/bn/sc"
  bottom: "inception_5b/pool_proj/bn/sc"
  top: "inception_5b/output"
  name: "inception_5b/output"
  type: "Concat"
}
layer {
  bottom: "inception_5b/output"
  top: "pool5/7x7_s1"
  name: "pool5/7x7_s1"
  type: "Pooling"
  pooling_param {
    pool: AVE
    kernel_size: 7
    stride: 1
  }
}
layer {
  bottom: "pool5/7x7_s1"
  top: "out"
  name: "loss3/classifier"
  type: "InnerProduct"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  inner_product_param {
    num_output: NCLASS_tpl
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
