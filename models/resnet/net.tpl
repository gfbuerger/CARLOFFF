layer {
  name: "conv_0"
  type: "Convolution"
  bottom: "data"
  top: "conv_0"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 16
    pad: 1
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
  name: "norm_0"
  type: "BatchNorm"
  bottom: "conv_0"
  top: "conv_0"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_0"
  type: "Scale"
  bottom: "conv_0"
  top: "conv_0"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_0"
  type: "ReLU"
  bottom: "conv_0"
  top: "conv_0"
}
layer {
  name: "conv_1"
  type: "Convolution"
  bottom: "conv_0"
  top: "conv_1"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 16
    pad: 1
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
  name: "norm_1"
  type: "BatchNorm"
  bottom: "conv_1"
  top: "conv_1"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_1"
  type: "Scale"
  bottom: "conv_1"
  top: "conv_1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_1"
  type: "ReLU"
  bottom: "conv_1"
  top: "conv_1"
}
layer {
  name: "conv_2"
  type: "Convolution"
  bottom: "conv_1"
  top: "conv_2"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 16
    pad: 1
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
  name: "norm_2"
  type: "BatchNorm"
  bottom: "conv_2"
  top: "conv_2"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_2"
  type: "Scale"
  bottom: "conv_2"
  top: "conv_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "elem_2"
  type: "Eltwise"
  bottom: "conv_2"
  bottom: "conv_0"
  top: "elem_2"
  eltwise_param {
    operation: SUM
  }
}

layer {
  name: "conv_3"
  type: "Convolution"
  bottom: "elem_2"
  top: "conv_3"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 16
    pad: 1
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
  name: "norm_3"
  type: "BatchNorm"
  bottom: "conv_3"
  top: "conv_3"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_3"
  type: "Scale"
  bottom: "conv_3"
  top: "conv_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_3"
  type: "ReLU"
  bottom: "conv_3"
  top: "conv_3"
}
layer {
  name: "conv_4"
  type: "Convolution"
  bottom: "conv_3"
  top: "conv_4"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 16
    pad: 1
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
  name: "norm_4"
  type: "BatchNorm"
  bottom: "conv_4"
  top: "conv_4"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_4"
  type: "Scale"
  bottom: "conv_4"
  top: "conv_4"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "elem_4"
  type: "Eltwise"
  bottom: "conv_4"
  bottom: "elem_2"
  top: "elem_4"
  eltwise_param {
    operation: SUM
  }
}

layer {
  name: "conv_5"
  type: "Convolution"
  bottom: "elem_4"
  top: "conv_5"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 16
    pad: 1
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
  name: "norm_5"
  type: "BatchNorm"
  bottom: "conv_5"
  top: "conv_5"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_5"
  type: "Scale"
  bottom: "conv_5"
  top: "conv_5"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_5"
  type: "ReLU"
  bottom: "conv_5"
  top: "conv_5"
}
layer {
  name: "conv_6"
  type: "Convolution"
  bottom: "conv_5"
  top: "conv_6"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 16
    pad: 1
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
  name: "norm_6"
  type: "BatchNorm"
  bottom: "conv_6"
  top: "conv_6"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_6"
  type: "Scale"
  bottom: "conv_6"
  top: "conv_6"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "elem_6"
  type: "Eltwise"
  bottom: "conv_6"
  bottom: "elem_4"
  top: "elem_6"
  eltwise_param {
    operation: SUM
  }
}

layer {
  name: "conv_7"
  type: "Convolution"
  bottom: "elem_6"
  top: "conv_7"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 32
    pad: 1
    kernel_size: 3
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
  name: "norm_7"
  type: "BatchNorm"
  bottom: "conv_7"
  top: "conv_7"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_7"
  type: "Scale"
  bottom: "conv_7"
  top: "conv_7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_7"
  type: "ReLU"
  bottom: "conv_7"
  top: "conv_7"
}
layer {
  name: "conv_8"
  type: "Convolution"
  bottom: "conv_7"
  top: "conv_8"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 32
    pad: 1
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
  name: "norm_8"
  type: "BatchNorm"
  bottom: "conv_8"
  top: "conv_8"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_8"
  type: "Scale"
  bottom: "conv_8"
  top: "conv_8"
  scale_param {
    bias_term: true
  }
}


layer {
  name: "proj_7"
  type: "Convolution"
  bottom: "elem_6"
  top: "proj_7"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 32
    pad: 0
    kernel_size: 2
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
  name: "proj_norm_7"
  type: "BatchNorm"
  bottom: "proj_7"
  top: "proj_7"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "proj_scale_7"
  type: "Scale"
  bottom: "proj_7"
  top: "proj_7"
  scale_param {
    bias_term: true
  }
}

layer {
  name: "elem_8"
  type: "Eltwise"
  bottom: "conv_8"
  bottom: "proj_7"
  top: "elem_8"
  eltwise_param {
    operation: SUM
  }
}

layer {
  name: "conv_9"
  type: "Convolution"
  bottom: "elem_8"
  top: "conv_9"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 32
    pad: 1
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
  name: "norm_9"
  type: "BatchNorm"
  bottom: "conv_9"
  top: "conv_9"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_9"
  type: "Scale"
  bottom: "conv_9"
  top: "conv_9"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_9"
  type: "ReLU"
  bottom: "conv_9"
  top: "conv_9"
}
layer {
  name: "conv_10"
  type: "Convolution"
  bottom: "conv_9"
  top: "conv_10"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 32
    pad: 1
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
  name: "norm_10"
  type: "BatchNorm"
  bottom: "conv_10"
  top: "conv_10"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_10"
  type: "Scale"
  bottom: "conv_10"
  top: "conv_10"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "elem_10"
  type: "Eltwise"
  bottom: "conv_10"
  bottom: "elem_8"
  top: "elem_10"
  eltwise_param {
    operation: SUM
  }
}

layer {
  name: "conv_11"
  type: "Convolution"
  bottom: "elem_10"
  top: "conv_11"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 32
    pad: 1
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
  name: "norm_11"
  type: "BatchNorm"
  bottom: "conv_11"
  top: "conv_11"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_11"
  type: "Scale"
  bottom: "conv_11"
  top: "conv_11"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_11"
  type: "ReLU"
  bottom: "conv_11"
  top: "conv_11"
}
layer {
  name: "conv_12"
  type: "Convolution"
  bottom: "conv_11"
  top: "conv_12"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 32
    pad: 1
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
  name: "norm_12"
  type: "BatchNorm"
  bottom: "conv_12"
  top: "conv_12"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_12"
  type: "Scale"
  bottom: "conv_12"
  top: "conv_12"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "elem_12"
  type: "Eltwise"
  bottom: "conv_12"
  bottom: "elem_10"
  top: "elem_12"
  eltwise_param {
    operation: SUM
  }
}

layer {
  name: "conv_13"
  type: "Convolution"
  bottom: "elem_12"
  top: "conv_13"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 64
    pad: 1
    kernel_size: 3
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
  name: "norm_13"
  type: "BatchNorm"
  bottom: "conv_13"
  top: "conv_13"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_13"
  type: "Scale"
  bottom: "conv_13"
  top: "conv_13"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_13"
  type: "ReLU"
  bottom: "conv_13"
  top: "conv_13"
}
layer {
  name: "conv_14"
  type: "Convolution"
  bottom: "conv_13"
  top: "conv_14"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 64
    pad: 1
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
  name: "norm_14"
  type: "BatchNorm"
  bottom: "conv_14"
  top: "conv_14"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_14"
  type: "Scale"
  bottom: "conv_14"
  top: "conv_14"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "proj_13"
  type: "Convolution"
  bottom: "elem_12"
  top: "proj_13"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 2
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
  name: "proj_norm_13"
  type: "BatchNorm"
  bottom: "proj_13"
  top: "proj_13"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "proj_scale_13"
  type: "Scale"
  bottom: "proj_13"
  top: "proj_13"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "elem_14"
  type: "Eltwise"
  bottom: "conv_14"
  bottom: "proj_13"
  top: "elem_14"
  eltwise_param {
    operation: SUM
  }
}


layer {
  name: "conv_15"
  type: "Convolution"
  bottom: "elem_14"
  top: "conv_15"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 64
    pad: 1
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
  name: "norm_15"
  type: "BatchNorm"
  bottom: "conv_15"
  top: "conv_15"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_15"
  type: "Scale"
  bottom: "conv_15"
  top: "conv_15"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_15"
  type: "ReLU"
  bottom: "conv_15"
  top: "conv_15"
}
layer {
  name: "conv_16"
  type: "Convolution"
  bottom: "conv_15"
  top: "conv_16"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 64
    pad: 1
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
  name: "norm_16"
  type: "BatchNorm"
  bottom: "conv_16"
  top: "conv_16"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_16"
  type: "Scale"
  bottom: "conv_16"
  top: "conv_16"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "elem_16"
  type: "Eltwise"
  bottom: "conv_16"
  bottom: "elem_14"
  top: "elem_16"
  eltwise_param {
    operation: SUM
  }
}

layer {
  name: "conv_17"
  type: "Convolution"
  bottom: "elem_16"
  top: "conv_17"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 64
    pad: 1
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
  name: "norm_17"
  type: "BatchNorm"
  bottom: "conv_17"
  top: "conv_17"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_17"
  type: "Scale"
  bottom: "conv_17"
  top: "conv_17"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "relu_17"
  type: "ReLU"
  bottom: "conv_17"
  top: "conv_17"
}
layer {
  name: "conv_18"
  type: "Convolution"
  bottom: "conv_17"
  top: "conv_18"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  convolution_param {
    num_output: 64
    pad: 1
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
  name: "norm_18"
  type: "BatchNorm"
  bottom: "conv_18"
  top: "conv_18"
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  param {
    lr_mult: 0.0
    decay_mult: 0.0
  }
  batch_norm_param {
    use_global_stats: false
    moving_average_fraction: 0.95
  }
}
layer {
  name: "scale_18"
  type: "Scale"
  bottom: "conv_18"
  top: "conv_18"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "elem_18"
  type: "Eltwise"
  bottom: "conv_18"
  bottom: "elem_16"
  top: "elem_18"
  eltwise_param {
    operation: SUM
  }
}

layer {
  name: "pool_19"
  type: "Pooling"
  bottom: "elem_18"
  top: "pool_19"
  pooling_param {
    pool: AVE
    global_pooling: true
  }
}
layer {
  name: "fc_19"
  type: "InnerProduct"
  bottom: "pool_19"
  top: "out"
  param {
    lr_mult: 1.0
    decay_mult: 2.0
  }
  param {
    lr_mult: 1.0
    decay_mult: 0.0
  }
  inner_product_param {
    num_output: 2
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
