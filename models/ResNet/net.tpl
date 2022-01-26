# https://github.com/yihui-he/resnet-cifar10-caffe/tree/master/resnet-20

layer {
  name: "first_conv"
  type: "Convolution"
  bottom: "data"
  top: "first_conv"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 16
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "first_conv_bn"
  type: "BatchNorm"
  bottom: "first_conv"
  top: "first_conv"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "first_conv_scale"
  type: "Scale"
  bottom: "first_conv"
  top: "first_conv"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "first_conv_relu"
  type: "ReLU"
  bottom: "first_conv"
  top: "first_conv"
}
layer {
  name: "group0_block0_conv0"
  type: "Convolution"
  bottom: "first_conv"
  top: "group0_block0_conv0"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 16
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group0_block0_conv0_bn"
  type: "BatchNorm"
  bottom: "group0_block0_conv0"
  top: "group0_block0_conv0"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group0_block0_conv0_scale"
  type: "Scale"
  bottom: "group0_block0_conv0"
  top: "group0_block0_conv0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group0_block0_conv0_relu"
  type: "ReLU"
  bottom: "group0_block0_conv0"
  top: "group0_block0_conv0"
}
layer {
  name: "group0_block0_conv1"
  type: "Convolution"
  bottom: "group0_block0_conv0"
  top: "group0_block0_conv1"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 16
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group0_block0_conv1_bn"
  type: "BatchNorm"
  bottom: "group0_block0_conv1"
  top: "group0_block0_conv1"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group0_block0_conv1_scale"
  type: "Scale"
  bottom: "group0_block0_conv1"
  top: "group0_block0_conv1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group0_block0_sum"
  type: "Eltwise"
  bottom: "group0_block0_conv1"
  bottom: "first_conv"
  top: "group0_block0_sum"
  eltwise_param {
    operation: SUM
  }
}
layer {
  name: "group0_block0_relu"
  type: "ReLU"
  bottom: "group0_block0_sum"
  top: "group0_block0_sum"
}
layer {
  name: "group0_block1_conv0"
  type: "Convolution"
  bottom: "group0_block0_sum"
  top: "group0_block1_conv0"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 16
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group0_block1_conv0_bn"
  type: "BatchNorm"
  bottom: "group0_block1_conv0"
  top: "group0_block1_conv0"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group0_block1_conv0_scale"
  type: "Scale"
  bottom: "group0_block1_conv0"
  top: "group0_block1_conv0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group0_block1_conv0_relu"
  type: "ReLU"
  bottom: "group0_block1_conv0"
  top: "group0_block1_conv0"
}
layer {
  name: "group0_block1_conv1"
  type: "Convolution"
  bottom: "group0_block1_conv0"
  top: "group0_block1_conv1"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 16
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group0_block1_conv1_bn"
  type: "BatchNorm"
  bottom: "group0_block1_conv1"
  top: "group0_block1_conv1"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group0_block1_conv1_scale"
  type: "Scale"
  bottom: "group0_block1_conv1"
  top: "group0_block1_conv1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group0_block1_sum"
  type: "Eltwise"
  bottom: "group0_block1_conv1"
  bottom: "group0_block0_sum"
  top: "group0_block1_sum"
  eltwise_param {
    operation: SUM
  }
}
layer {
  name: "group0_block1_relu"
  type: "ReLU"
  bottom: "group0_block1_sum"
  top: "group0_block1_sum"
}
layer {
  name: "group0_block2_conv0"
  type: "Convolution"
  bottom: "group0_block1_sum"
  top: "group0_block2_conv0"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 16
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group0_block2_conv0_bn"
  type: "BatchNorm"
  bottom: "group0_block2_conv0"
  top: "group0_block2_conv0"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group0_block2_conv0_scale"
  type: "Scale"
  bottom: "group0_block2_conv0"
  top: "group0_block2_conv0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group0_block2_conv0_relu"
  type: "ReLU"
  bottom: "group0_block2_conv0"
  top: "group0_block2_conv0"
}
layer {
  name: "group0_block2_conv1"
  type: "Convolution"
  bottom: "group0_block2_conv0"
  top: "group0_block2_conv1"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 16
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group0_block2_conv1_bn"
  type: "BatchNorm"
  bottom: "group0_block2_conv1"
  top: "group0_block2_conv1"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group0_block2_conv1_scale"
  type: "Scale"
  bottom: "group0_block2_conv1"
  top: "group0_block2_conv1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group0_block2_sum"
  type: "Eltwise"
  bottom: "group0_block2_conv1"
  bottom: "group0_block1_sum"
  top: "group0_block2_sum"
  eltwise_param {
    operation: SUM
  }
}
layer {
  name: "group0_block2_relu"
  type: "ReLU"
  bottom: "group0_block2_sum"
  top: "group0_block2_sum"
}
layer {
  name: "group1_block0_conv0"
  type: "Convolution"
  bottom: "group0_block2_sum"
  top: "group1_block0_conv0"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 32
    pad: 1
    kernel_size: 3
    stride: 2
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group1_block0_conv0_bn"
  type: "BatchNorm"
  bottom: "group1_block0_conv0"
  top: "group1_block0_conv0"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group1_block0_conv0_scale"
  type: "Scale"
  bottom: "group1_block0_conv0"
  top: "group1_block0_conv0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group1_block0_conv0_relu"
  type: "ReLU"
  bottom: "group1_block0_conv0"
  top: "group1_block0_conv0"
}
layer {
  name: "group1_block0_conv1"
  type: "Convolution"
  bottom: "group1_block0_conv0"
  top: "group1_block0_conv1"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 32
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group1_block0_conv1_bn"
  type: "BatchNorm"
  bottom: "group1_block0_conv1"
  top: "group1_block0_conv1"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group1_block0_conv1_scale"
  type: "Scale"
  bottom: "group1_block0_conv1"
  top: "group1_block0_conv1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group1_block0_proj"
  type: "Convolution"
  bottom: "group0_block2_sum"
  top: "group1_block0_proj"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 32
    pad: 0
    kernel_size: 1
    stride: 2
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group1_block0_proj_bn"
  type: "BatchNorm"
  bottom: "group1_block0_proj"
  top: "group1_block0_proj"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group1_block0_proj_scale"
  type: "Scale"
  bottom: "group1_block0_proj"
  top: "group1_block0_proj"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group1_block0_sum"
  type: "Eltwise"
  bottom: "group1_block0_proj"
  bottom: "group1_block0_conv1"
  top: "group1_block0_sum"
  eltwise_param {
    operation: SUM
  }
}
layer {
  name: "group1_block0_relu"
  type: "ReLU"
  bottom: "group1_block0_sum"
  top: "group1_block0_sum"
}
layer {
  name: "group1_block1_conv0"
  type: "Convolution"
  bottom: "group1_block0_sum"
  top: "group1_block1_conv0"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 32
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group1_block1_conv0_bn"
  type: "BatchNorm"
  bottom: "group1_block1_conv0"
  top: "group1_block1_conv0"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group1_block1_conv0_scale"
  type: "Scale"
  bottom: "group1_block1_conv0"
  top: "group1_block1_conv0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group1_block1_conv0_relu"
  type: "ReLU"
  bottom: "group1_block1_conv0"
  top: "group1_block1_conv0"
}
layer {
  name: "group1_block1_conv1"
  type: "Convolution"
  bottom: "group1_block1_conv0"
  top: "group1_block1_conv1"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 32
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group1_block1_conv1_bn"
  type: "BatchNorm"
  bottom: "group1_block1_conv1"
  top: "group1_block1_conv1"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group1_block1_conv1_scale"
  type: "Scale"
  bottom: "group1_block1_conv1"
  top: "group1_block1_conv1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group1_block1_sum"
  type: "Eltwise"
  bottom: "group1_block1_conv1"
  bottom: "group1_block0_sum"
  top: "group1_block1_sum"
  eltwise_param {
    operation: SUM
  }
}
layer {
  name: "group1_block1_relu"
  type: "ReLU"
  bottom: "group1_block1_sum"
  top: "group1_block1_sum"
}
layer {
  name: "group1_block2_conv0"
  type: "Convolution"
  bottom: "group1_block1_sum"
  top: "group1_block2_conv0"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 32
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group1_block2_conv0_bn"
  type: "BatchNorm"
  bottom: "group1_block2_conv0"
  top: "group1_block2_conv0"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group1_block2_conv0_scale"
  type: "Scale"
  bottom: "group1_block2_conv0"
  top: "group1_block2_conv0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group1_block2_conv0_relu"
  type: "ReLU"
  bottom: "group1_block2_conv0"
  top: "group1_block2_conv0"
}
layer {
  name: "group1_block2_conv1"
  type: "Convolution"
  bottom: "group1_block2_conv0"
  top: "group1_block2_conv1"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 32
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group1_block2_conv1_bn"
  type: "BatchNorm"
  bottom: "group1_block2_conv1"
  top: "group1_block2_conv1"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group1_block2_conv1_scale"
  type: "Scale"
  bottom: "group1_block2_conv1"
  top: "group1_block2_conv1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group1_block2_sum"
  type: "Eltwise"
  bottom: "group1_block2_conv1"
  bottom: "group1_block1_sum"
  top: "group1_block2_sum"
  eltwise_param {
    operation: SUM
  }
}
layer {
  name: "group1_block2_relu"
  type: "ReLU"
  bottom: "group1_block2_sum"
  top: "group1_block2_sum"
}
layer {
  name: "group2_block0_conv0"
  type: "Convolution"
  bottom: "group1_block2_sum"
  top: "group2_block0_conv0"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 1
    kernel_size: 3
    stride: 2
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group2_block0_conv0_bn"
  type: "BatchNorm"
  bottom: "group2_block0_conv0"
  top: "group2_block0_conv0"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group2_block0_conv0_scale"
  type: "Scale"
  bottom: "group2_block0_conv0"
  top: "group2_block0_conv0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group2_block0_conv0_relu"
  type: "ReLU"
  bottom: "group2_block0_conv0"
  top: "group2_block0_conv0"
}
layer {
  name: "group2_block0_conv1"
  type: "Convolution"
  bottom: "group2_block0_conv0"
  top: "group2_block0_conv1"
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
      type: "msra"
    }
  }
}
layer {
  name: "group2_block0_conv1_bn"
  type: "BatchNorm"
  bottom: "group2_block0_conv1"
  top: "group2_block0_conv1"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group2_block0_conv1_scale"
  type: "Scale"
  bottom: "group2_block0_conv1"
  top: "group2_block0_conv1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group2_block0_proj"
  type: "Convolution"
  bottom: "group1_block2_sum"
  top: "group2_block0_proj"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 2
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "group2_block0_proj_bn"
  type: "BatchNorm"
  bottom: "group2_block0_proj"
  top: "group2_block0_proj"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group2_block0_proj_scale"
  type: "Scale"
  bottom: "group2_block0_proj"
  top: "group2_block0_proj"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group2_block0_sum"
  type: "Eltwise"
  bottom: "group2_block0_proj"
  bottom: "group2_block0_conv1"
  top: "group2_block0_sum"
  eltwise_param {
    operation: SUM
  }
}
layer {
  name: "group2_block0_relu"
  type: "ReLU"
  bottom: "group2_block0_sum"
  top: "group2_block0_sum"
}
layer {
  name: "group2_block1_conv0"
  type: "Convolution"
  bottom: "group2_block0_sum"
  top: "group2_block1_conv0"
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
      type: "msra"
    }
  }
}
layer {
  name: "group2_block1_conv0_bn"
  type: "BatchNorm"
  bottom: "group2_block1_conv0"
  top: "group2_block1_conv0"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group2_block1_conv0_scale"
  type: "Scale"
  bottom: "group2_block1_conv0"
  top: "group2_block1_conv0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group2_block1_conv0_relu"
  type: "ReLU"
  bottom: "group2_block1_conv0"
  top: "group2_block1_conv0"
}
layer {
  name: "group2_block1_conv1"
  type: "Convolution"
  bottom: "group2_block1_conv0"
  top: "group2_block1_conv1"
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
      type: "msra"
    }
  }
}
layer {
  name: "group2_block1_conv1_bn"
  type: "BatchNorm"
  bottom: "group2_block1_conv1"
  top: "group2_block1_conv1"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group2_block1_conv1_scale"
  type: "Scale"
  bottom: "group2_block1_conv1"
  top: "group2_block1_conv1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group2_block1_sum"
  type: "Eltwise"
  bottom: "group2_block1_conv1"
  bottom: "group2_block0_sum"
  top: "group2_block1_sum"
  eltwise_param {
    operation: SUM
  }
}
layer {
  name: "group2_block1_relu"
  type: "ReLU"
  bottom: "group2_block1_sum"
  top: "group2_block1_sum"
}
layer {
  name: "group2_block2_conv0"
  type: "Convolution"
  bottom: "group2_block1_sum"
  top: "group2_block2_conv0"
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
      type: "msra"
    }
  }
}
layer {
  name: "group2_block2_conv0_bn"
  type: "BatchNorm"
  bottom: "group2_block2_conv0"
  top: "group2_block2_conv0"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group2_block2_conv0_scale"
  type: "Scale"
  bottom: "group2_block2_conv0"
  top: "group2_block2_conv0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group2_block2_conv0_relu"
  type: "ReLU"
  bottom: "group2_block2_conv0"
  top: "group2_block2_conv0"
}
layer {
  name: "group2_block2_conv1"
  type: "Convolution"
  bottom: "group2_block2_conv0"
  top: "group2_block2_conv1"
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
      type: "msra"
    }
  }
}
layer {
  name: "group2_block2_conv1_bn"
  type: "BatchNorm"
  bottom: "group2_block2_conv1"
  top: "group2_block2_conv1"
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
  param {
    lr_mult: 0
    decay_mult: 0
  }
}
layer {
  name: "group2_block2_conv1_scale"
  type: "Scale"
  bottom: "group2_block2_conv1"
  top: "group2_block2_conv1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "group2_block2_sum"
  type: "Eltwise"
  bottom: "group2_block2_conv1"
  bottom: "group2_block1_sum"
  top: "group2_block2_sum"
  eltwise_param {
    operation: SUM
  }
}
layer {
  name: "group2_block2_relu"
  type: "ReLU"
  bottom: "group2_block2_sum"
  top: "group2_block2_sum"
}
layer {
  name: "global_avg_pool"
  type: "Pooling"
  bottom: "group2_block2_sum"
  top: "global_avg_pool"
  pooling_param {
    pool: AVE
    global_pooling: true
  }
}
layer {
  name: "fc"
  type: "InnerProduct"
  bottom: "global_avg_pool"
  top: "out"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  inner_product_param {
    num_output: 2
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
