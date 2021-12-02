name: "Inception_v4"
layer {
  name: "data"
  type: "Data"
  top: "data"
  top: "label"
  include {
    phase: TRAIN
  }
  transform_param {
    mirror: true
    crop_size: 299
    mean_file: "mean.binaryproto"
  }
  data_param {
    source: "train_lmdb"
    batch_size: 32
    backend: LMDB
  }
}
layer {
  name: "data"
  type: "Data"
  top: "data"
  top: "label"
  include {
    phase: TEST
  }
  transform_param {
    mirror: false
    crop_size: 299
    mean_file: "mean.binaryproto"
  }
  data_param {
    source: "val_lmdb"
    batch_size: 1
    backend: LMDB
  }
}
layer {
  name: "conv1_3x3_s2"
  type: "Convolution"
  bottom: "data"
  top: "conv1_3x3_s2"
  convolution_param {
    bias_term: false
    num_output: 32
    pad: 0
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "conv1_3x3_s2_bn"
  type: "BatchNorm"
  bottom: "conv1_3x3_s2"
  top: "conv1_3x3_s2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "conv1_3x3_s2_scale"
  type: "Scale"
  bottom: "conv1_3x3_s2"
  top: "conv1_3x3_s2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "conv1_3x3_s2_relu"
  type: "ReLU"
  bottom: "conv1_3x3_s2"
  top: "conv1_3x3_s2"
}
layer {
  name: "conv2_3x3_s1"
  type: "Convolution"
  bottom: "conv1_3x3_s2"
  top: "conv2_3x3_s1"
  convolution_param {
    bias_term: false
    num_output: 32
    pad: 0
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "conv2_3x3_s1_bn"
  type: "BatchNorm"
  bottom: "conv2_3x3_s1"
  top: "conv2_3x3_s1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "conv2_3x3_s1_scale"
  type: "Scale"
  bottom: "conv2_3x3_s1"
  top: "conv2_3x3_s1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "conv2_3x3_s1_relu"
  type: "ReLU"
  bottom: "conv2_3x3_s1"
  top: "conv2_3x3_s1"
}
layer {
  name: "conv3_3x3_s1"
  type: "Convolution"
  bottom: "conv2_3x3_s1"
  top: "conv3_3x3_s1"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "conv3_3x3_s1_bn"
  type: "BatchNorm"
  bottom: "conv3_3x3_s1"
  top: "conv3_3x3_s1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "conv3_3x3_s1_scale"
  type: "Scale"
  bottom: "conv3_3x3_s1"
  top: "conv3_3x3_s1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "conv3_3x3_s1_relu"
  type: "ReLU"
  bottom: "conv3_3x3_s1"
  top: "conv3_3x3_s1"
}
layer {
  name: "inception_stem1_3x3_s2"
  type: "Convolution"
  bottom: "conv3_3x3_s1"
  top: "inception_stem1_3x3_s2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "inception_stem1_3x3_s2_bn"
  type: "BatchNorm"
  bottom: "inception_stem1_3x3_s2"
  top: "inception_stem1_3x3_s2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_stem1_3x3_s2_scale"
  type: "Scale"
  bottom: "inception_stem1_3x3_s2"
  top: "inception_stem1_3x3_s2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_stem1_3x3_s2_relu"
  type: "ReLU"
  bottom: "inception_stem1_3x3_s2"
  top: "inception_stem1_3x3_s2"
}
layer {
  name: "inception_stem1_pool"
  type: "Pooling"
  bottom: "conv3_3x3_s1"
  top: "inception_stem1_pool"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "inception_stem1"
  type: "Concat"
  bottom: "inception_stem1_pool"
  bottom: "inception_stem1_3x3_s2"
  top: "inception_stem1"
}
layer {
  name: "inception_stem2_3x3_reduce"
  type: "Convolution"
  bottom: "inception_stem1"
  top: "inception_stem2_3x3_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_stem2_3x3_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_stem2_3x3_reduce"
  top: "inception_stem2_3x3_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_stem2_3x3_reduce_scale"
  type: "Scale"
  bottom: "inception_stem2_3x3_reduce"
  top: "inception_stem2_3x3_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_stem2_3x3_reduce_relu"
  type: "ReLU"
  bottom: "inception_stem2_3x3_reduce"
  top: "inception_stem2_3x3_reduce"
}
layer {
  name: "inception_stem2_3x3"
  type: "Convolution"
  bottom: "inception_stem2_3x3_reduce"
  top: "inception_stem2_3x3"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_stem2_3x3_bn"
  type: "BatchNorm"
  bottom: "inception_stem2_3x3"
  top: "inception_stem2_3x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_stem2_3x3_scale"
  type: "Scale"
  bottom: "inception_stem2_3x3"
  top: "inception_stem2_3x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_stem2_3x3_relu"
  type: "ReLU"
  bottom: "inception_stem2_3x3"
  top: "inception_stem2_3x3"
}
layer {
  name: "inception_stem2_1x7_reduce"
  type: "Convolution"
  bottom: "inception_stem1"
  top: "inception_stem2_1x7_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_stem2_1x7_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_stem2_1x7_reduce"
  top: "inception_stem2_1x7_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_stem2_1x7_reduce_scale"
  type: "Scale"
  bottom: "inception_stem2_1x7_reduce"
  top: "inception_stem2_1x7_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_stem2_1x7_reduce_relu"
  type: "ReLU"
  bottom: "inception_stem2_1x7_reduce"
  top: "inception_stem2_1x7_reduce"
}
layer {
  name: "inception_stem2_1x7"
  type: "Convolution"
  bottom: "inception_stem2_1x7_reduce"
  top: "inception_stem2_1x7"
  convolution_param {
    bias_term: false
    num_output: 64
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_stem2_1x7_bn"
  type: "BatchNorm"
  bottom: "inception_stem2_1x7"
  top: "inception_stem2_1x7"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_stem2_1x7_scale"
  type: "Scale"
  bottom: "inception_stem2_1x7"
  top: "inception_stem2_1x7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_stem2_1x7_relu"
  type: "ReLU"
  bottom: "inception_stem2_1x7"
  top: "inception_stem2_1x7"
}
layer {
  name: "inception_stem2_7x1"
  type: "Convolution"
  bottom: "inception_stem2_1x7"
  top: "inception_stem2_7x1"
  convolution_param {
    bias_term: false
    num_output: 64
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_stem2_7x1_bn"
  type: "BatchNorm"
  bottom: "inception_stem2_7x1"
  top: "inception_stem2_7x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_stem2_7x1_scale"
  type: "Scale"
  bottom: "inception_stem2_7x1"
  top: "inception_stem2_7x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_stem2_7x1_relu"
  type: "ReLU"
  bottom: "inception_stem2_7x1"
  top: "inception_stem2_7x1"
}
layer {
  name: "inception_stem2_3x3_2"
  type: "Convolution"
  bottom: "inception_stem2_7x1"
  top: "inception_stem2_3x3_2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_stem2_3x3_2_bn"
  type: "BatchNorm"
  bottom: "inception_stem2_3x3_2"
  top: "inception_stem2_3x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_stem2_3x3_2_scale"
  type: "Scale"
  bottom: "inception_stem2_3x3_2"
  top: "inception_stem2_3x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_stem2_3x3_2_relu"
  type: "ReLU"
  bottom: "inception_stem2_3x3_2"
  top: "inception_stem2_3x3_2"
}
layer {
  name: "inception_stem2"
  type: "Concat"
  bottom: "inception_stem2_3x3"
  bottom: "inception_stem2_3x3_2"
  top: "inception_stem2"
}
layer {
  name: "inception_stem3_3x3_s2"
  type: "Convolution"
  bottom: "inception_stem2"
  top: "inception_stem3_3x3_s2"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "inception_stem3_3x3_s2_bn"
  type: "BatchNorm"
  bottom: "inception_stem3_3x3_s2"
  top: "inception_stem3_3x3_s2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_stem3_3x3_s2_scale"
  type: "Scale"
  bottom: "inception_stem3_3x3_s2"
  top: "inception_stem3_3x3_s2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_stem3_3x3_s2_relu"
  type: "ReLU"
  bottom: "inception_stem3_3x3_s2"
  top: "inception_stem3_3x3_s2"
}
layer {
  name: "inception_stem3_pool"
  type: "Pooling"
  bottom: "inception_stem2"
  top: "inception_stem3_pool"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "inception_stem3"
  type: "Concat"
  bottom: "inception_stem3_3x3_s2"
  bottom: "inception_stem3_pool"
  top: "inception_stem3"
}
layer {
  name: "inception_a1_1x1_2"
  type: "Convolution"
  bottom: "inception_stem3"
  top: "inception_a1_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a1_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_a1_1x1_2"
  top: "inception_a1_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a1_1x1_2_scale"
  type: "Scale"
  bottom: "inception_a1_1x1_2"
  top: "inception_a1_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a1_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_a1_1x1_2"
  top: "inception_a1_1x1_2"
}
layer {
  name: "inception_a1_3x3_reduce"
  type: "Convolution"
  bottom: "inception_stem3"
  top: "inception_a1_3x3_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a1_3x3_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_a1_3x3_reduce"
  top: "inception_a1_3x3_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a1_3x3_reduce_scale"
  type: "Scale"
  bottom: "inception_a1_3x3_reduce"
  top: "inception_a1_3x3_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a1_3x3_reduce_relu"
  type: "ReLU"
  bottom: "inception_a1_3x3_reduce"
  top: "inception_a1_3x3_reduce"
}
layer {
  name: "inception_a1_3x3"
  type: "Convolution"
  bottom: "inception_a1_3x3_reduce"
  top: "inception_a1_3x3"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a1_3x3_bn"
  type: "BatchNorm"
  bottom: "inception_a1_3x3"
  top: "inception_a1_3x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a1_3x3_scale"
  type: "Scale"
  bottom: "inception_a1_3x3"
  top: "inception_a1_3x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a1_3x3_relu"
  type: "ReLU"
  bottom: "inception_a1_3x3"
  top: "inception_a1_3x3"
}
layer {
  name: "inception_a1_3x3_2_reduce"
  type: "Convolution"
  bottom: "inception_stem3"
  top: "inception_a1_3x3_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a1_3x3_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_a1_3x3_2_reduce"
  top: "inception_a1_3x3_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a1_3x3_2_reduce_scale"
  type: "Scale"
  bottom: "inception_a1_3x3_2_reduce"
  top: "inception_a1_3x3_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a1_3x3_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_a1_3x3_2_reduce"
  top: "inception_a1_3x3_2_reduce"
}
layer {
  name: "inception_a1_3x3_2"
  type: "Convolution"
  bottom: "inception_a1_3x3_2_reduce"
  top: "inception_a1_3x3_2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a1_3x3_2_bn"
  type: "BatchNorm"
  bottom: "inception_a1_3x3_2"
  top: "inception_a1_3x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a1_3x3_2_scale"
  type: "Scale"
  bottom: "inception_a1_3x3_2"
  top: "inception_a1_3x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a1_3x3_2_relu"
  type: "ReLU"
  bottom: "inception_a1_3x3_2"
  top: "inception_a1_3x3_2"
}
layer {
  name: "inception_a1_3x3_3"
  type: "Convolution"
  bottom: "inception_a1_3x3_2"
  top: "inception_a1_3x3_3"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a1_3x3_3_bn"
  type: "BatchNorm"
  bottom: "inception_a1_3x3_3"
  top: "inception_a1_3x3_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a1_3x3_3_scale"
  type: "Scale"
  bottom: "inception_a1_3x3_3"
  top: "inception_a1_3x3_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a1_3x3_3_relu"
  type: "ReLU"
  bottom: "inception_a1_3x3_3"
  top: "inception_a1_3x3_3"
}
layer {
  name: "inception_a1_pool_ave"
  type: "Pooling"
  bottom: "inception_stem3"
  top: "inception_a1_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_a1_1x1"
  type: "Convolution"
  bottom: "inception_a1_pool_ave"
  top: "inception_a1_1x1"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a1_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_a1_1x1"
  top: "inception_a1_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a1_1x1_scale"
  type: "Scale"
  bottom: "inception_a1_1x1"
  top: "inception_a1_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a1_1x1_relu"
  type: "ReLU"
  bottom: "inception_a1_1x1"
  top: "inception_a1_1x1"
}
layer {
  name: "inception_a1_concat"
  type: "Concat"
  bottom: "inception_a1_1x1_2"
  bottom: "inception_a1_3x3"
  bottom: "inception_a1_3x3_3"
  bottom: "inception_a1_1x1"
  top: "inception_a1_concat"
}
layer {
  name: "inception_a2_1x1_2"
  type: "Convolution"
  bottom: "inception_a1_concat"
  top: "inception_a2_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a2_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_a2_1x1_2"
  top: "inception_a2_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a2_1x1_2_scale"
  type: "Scale"
  bottom: "inception_a2_1x1_2"
  top: "inception_a2_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a2_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_a2_1x1_2"
  top: "inception_a2_1x1_2"
}
layer {
  name: "inception_a2_3x3_reduce"
  type: "Convolution"
  bottom: "inception_a1_concat"
  top: "inception_a2_3x3_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a2_3x3_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_a2_3x3_reduce"
  top: "inception_a2_3x3_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a2_3x3_reduce_scale"
  type: "Scale"
  bottom: "inception_a2_3x3_reduce"
  top: "inception_a2_3x3_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a2_3x3_reduce_relu"
  type: "ReLU"
  bottom: "inception_a2_3x3_reduce"
  top: "inception_a2_3x3_reduce"
}
layer {
  name: "inception_a2_3x3"
  type: "Convolution"
  bottom: "inception_a2_3x3_reduce"
  top: "inception_a2_3x3"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a2_3x3_bn"
  type: "BatchNorm"
  bottom: "inception_a2_3x3"
  top: "inception_a2_3x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a2_3x3_scale"
  type: "Scale"
  bottom: "inception_a2_3x3"
  top: "inception_a2_3x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a2_3x3_relu"
  type: "ReLU"
  bottom: "inception_a2_3x3"
  top: "inception_a2_3x3"
}
layer {
  name: "inception_a2_3x3_2_reduce"
  type: "Convolution"
  bottom: "inception_a1_concat"
  top: "inception_a2_3x3_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a2_3x3_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_a2_3x3_2_reduce"
  top: "inception_a2_3x3_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a2_3x3_2_reduce_scale"
  type: "Scale"
  bottom: "inception_a2_3x3_2_reduce"
  top: "inception_a2_3x3_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a2_3x3_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_a2_3x3_2_reduce"
  top: "inception_a2_3x3_2_reduce"
}
layer {
  name: "inception_a2_3x3_2"
  type: "Convolution"
  bottom: "inception_a2_3x3_2_reduce"
  top: "inception_a2_3x3_2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a2_3x3_2_bn"
  type: "BatchNorm"
  bottom: "inception_a2_3x3_2"
  top: "inception_a2_3x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a2_3x3_2_scale"
  type: "Scale"
  bottom: "inception_a2_3x3_2"
  top: "inception_a2_3x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a2_3x3_2_relu"
  type: "ReLU"
  bottom: "inception_a2_3x3_2"
  top: "inception_a2_3x3_2"
}
layer {
  name: "inception_a2_3x3_3"
  type: "Convolution"
  bottom: "inception_a2_3x3_2"
  top: "inception_a2_3x3_3"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a2_3x3_3_bn"
  type: "BatchNorm"
  bottom: "inception_a2_3x3_3"
  top: "inception_a2_3x3_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a2_3x3_3_scale"
  type: "Scale"
  bottom: "inception_a2_3x3_3"
  top: "inception_a2_3x3_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a2_3x3_3_relu"
  type: "ReLU"
  bottom: "inception_a2_3x3_3"
  top: "inception_a2_3x3_3"
}
layer {
  name: "inception_a2_pool_ave"
  type: "Pooling"
  bottom: "inception_a1_concat"
  top: "inception_a2_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_a2_1x1"
  type: "Convolution"
  bottom: "inception_a2_pool_ave"
  top: "inception_a2_1x1"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a2_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_a2_1x1"
  top: "inception_a2_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a2_1x1_scale"
  type: "Scale"
  bottom: "inception_a2_1x1"
  top: "inception_a2_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a2_1x1_relu"
  type: "ReLU"
  bottom: "inception_a2_1x1"
  top: "inception_a2_1x1"
}
layer {
  name: "inception_a2_concat"
  type: "Concat"
  bottom: "inception_a2_1x1_2"
  bottom: "inception_a2_3x3"
  bottom: "inception_a2_3x3_3"
  bottom: "inception_a2_1x1"
  top: "inception_a2_concat"
}
layer {
  name: "inception_a3_1x1_2"
  type: "Convolution"
  bottom: "inception_a2_concat"
  top: "inception_a3_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a3_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_a3_1x1_2"
  top: "inception_a3_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a3_1x1_2_scale"
  type: "Scale"
  bottom: "inception_a3_1x1_2"
  top: "inception_a3_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a3_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_a3_1x1_2"
  top: "inception_a3_1x1_2"
}
layer {
  name: "inception_a3_3x3_reduce"
  type: "Convolution"
  bottom: "inception_a2_concat"
  top: "inception_a3_3x3_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a3_3x3_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_a3_3x3_reduce"
  top: "inception_a3_3x3_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a3_3x3_reduce_scale"
  type: "Scale"
  bottom: "inception_a3_3x3_reduce"
  top: "inception_a3_3x3_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a3_3x3_reduce_relu"
  type: "ReLU"
  bottom: "inception_a3_3x3_reduce"
  top: "inception_a3_3x3_reduce"
}
layer {
  name: "inception_a3_3x3"
  type: "Convolution"
  bottom: "inception_a3_3x3_reduce"
  top: "inception_a3_3x3"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a3_3x3_bn"
  type: "BatchNorm"
  bottom: "inception_a3_3x3"
  top: "inception_a3_3x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a3_3x3_scale"
  type: "Scale"
  bottom: "inception_a3_3x3"
  top: "inception_a3_3x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a3_3x3_relu"
  type: "ReLU"
  bottom: "inception_a3_3x3"
  top: "inception_a3_3x3"
}
layer {
  name: "inception_a3_3x3_2_reduce"
  type: "Convolution"
  bottom: "inception_a2_concat"
  top: "inception_a3_3x3_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a3_3x3_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_a3_3x3_2_reduce"
  top: "inception_a3_3x3_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a3_3x3_2_reduce_scale"
  type: "Scale"
  bottom: "inception_a3_3x3_2_reduce"
  top: "inception_a3_3x3_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a3_3x3_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_a3_3x3_2_reduce"
  top: "inception_a3_3x3_2_reduce"
}
layer {
  name: "inception_a3_3x3_2"
  type: "Convolution"
  bottom: "inception_a3_3x3_2_reduce"
  top: "inception_a3_3x3_2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a3_3x3_2_bn"
  type: "BatchNorm"
  bottom: "inception_a3_3x3_2"
  top: "inception_a3_3x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a3_3x3_2_scale"
  type: "Scale"
  bottom: "inception_a3_3x3_2"
  top: "inception_a3_3x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a3_3x3_2_relu"
  type: "ReLU"
  bottom: "inception_a3_3x3_2"
  top: "inception_a3_3x3_2"
}
layer {
  name: "inception_a3_3x3_3"
  type: "Convolution"
  bottom: "inception_a3_3x3_2"
  top: "inception_a3_3x3_3"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a3_3x3_3_bn"
  type: "BatchNorm"
  bottom: "inception_a3_3x3_3"
  top: "inception_a3_3x3_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a3_3x3_3_scale"
  type: "Scale"
  bottom: "inception_a3_3x3_3"
  top: "inception_a3_3x3_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a3_3x3_3_relu"
  type: "ReLU"
  bottom: "inception_a3_3x3_3"
  top: "inception_a3_3x3_3"
}
layer {
  name: "inception_a3_pool_ave"
  type: "Pooling"
  bottom: "inception_a2_concat"
  top: "inception_a3_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_a3_1x1"
  type: "Convolution"
  bottom: "inception_a3_pool_ave"
  top: "inception_a3_1x1"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a3_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_a3_1x1"
  top: "inception_a3_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a3_1x1_scale"
  type: "Scale"
  bottom: "inception_a3_1x1"
  top: "inception_a3_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a3_1x1_relu"
  type: "ReLU"
  bottom: "inception_a3_1x1"
  top: "inception_a3_1x1"
}
layer {
  name: "inception_a3_concat"
  type: "Concat"
  bottom: "inception_a3_1x1_2"
  bottom: "inception_a3_3x3"
  bottom: "inception_a3_3x3_3"
  bottom: "inception_a3_1x1"
  top: "inception_a3_concat"
}
layer {
  name: "inception_a4_1x1_2"
  type: "Convolution"
  bottom: "inception_a3_concat"
  top: "inception_a4_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a4_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_a4_1x1_2"
  top: "inception_a4_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a4_1x1_2_scale"
  type: "Scale"
  bottom: "inception_a4_1x1_2"
  top: "inception_a4_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a4_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_a4_1x1_2"
  top: "inception_a4_1x1_2"
}
layer {
  name: "inception_a4_3x3_reduce"
  type: "Convolution"
  bottom: "inception_a3_concat"
  top: "inception_a4_3x3_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a4_3x3_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_a4_3x3_reduce"
  top: "inception_a4_3x3_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a4_3x3_reduce_scale"
  type: "Scale"
  bottom: "inception_a4_3x3_reduce"
  top: "inception_a4_3x3_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a4_3x3_reduce_relu"
  type: "ReLU"
  bottom: "inception_a4_3x3_reduce"
  top: "inception_a4_3x3_reduce"
}
layer {
  name: "inception_a4_3x3"
  type: "Convolution"
  bottom: "inception_a4_3x3_reduce"
  top: "inception_a4_3x3"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a4_3x3_bn"
  type: "BatchNorm"
  bottom: "inception_a4_3x3"
  top: "inception_a4_3x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a4_3x3_scale"
  type: "Scale"
  bottom: "inception_a4_3x3"
  top: "inception_a4_3x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a4_3x3_relu"
  type: "ReLU"
  bottom: "inception_a4_3x3"
  top: "inception_a4_3x3"
}
layer {
  name: "inception_a4_3x3_2_reduce"
  type: "Convolution"
  bottom: "inception_a3_concat"
  top: "inception_a4_3x3_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 64
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a4_3x3_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_a4_3x3_2_reduce"
  top: "inception_a4_3x3_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a4_3x3_2_reduce_scale"
  type: "Scale"
  bottom: "inception_a4_3x3_2_reduce"
  top: "inception_a4_3x3_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a4_3x3_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_a4_3x3_2_reduce"
  top: "inception_a4_3x3_2_reduce"
}
layer {
  name: "inception_a4_3x3_2"
  type: "Convolution"
  bottom: "inception_a4_3x3_2_reduce"
  top: "inception_a4_3x3_2"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a4_3x3_2_bn"
  type: "BatchNorm"
  bottom: "inception_a4_3x3_2"
  top: "inception_a4_3x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a4_3x3_2_scale"
  type: "Scale"
  bottom: "inception_a4_3x3_2"
  top: "inception_a4_3x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a4_3x3_2_relu"
  type: "ReLU"
  bottom: "inception_a4_3x3_2"
  top: "inception_a4_3x3_2"
}
layer {
  name: "inception_a4_3x3_3"
  type: "Convolution"
  bottom: "inception_a4_3x3_2"
  top: "inception_a4_3x3_3"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "inception_a4_3x3_3_bn"
  type: "BatchNorm"
  bottom: "inception_a4_3x3_3"
  top: "inception_a4_3x3_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a4_3x3_3_scale"
  type: "Scale"
  bottom: "inception_a4_3x3_3"
  top: "inception_a4_3x3_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a4_3x3_3_relu"
  type: "ReLU"
  bottom: "inception_a4_3x3_3"
  top: "inception_a4_3x3_3"
}
layer {
  name: "inception_a4_pool_ave"
  type: "Pooling"
  bottom: "inception_a3_concat"
  top: "inception_a4_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_a4_1x1"
  type: "Convolution"
  bottom: "inception_a4_pool_ave"
  top: "inception_a4_1x1"
  convolution_param {
    bias_term: false
    num_output: 96
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_a4_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_a4_1x1"
  top: "inception_a4_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_a4_1x1_scale"
  type: "Scale"
  bottom: "inception_a4_1x1"
  top: "inception_a4_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_a4_1x1_relu"
  type: "ReLU"
  bottom: "inception_a4_1x1"
  top: "inception_a4_1x1"
}
layer {
  name: "inception_a4_concat"
  type: "Concat"
  bottom: "inception_a4_1x1_2"
  bottom: "inception_a4_3x3"
  bottom: "inception_a4_3x3_3"
  bottom: "inception_a4_1x1"
  top: "inception_a4_concat"
}
layer {
  name: "reduction_a_3x3"
  type: "Convolution"
  bottom: "inception_a4_concat"
  top: "reduction_a_3x3"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "reduction_a_3x3_bn"
  type: "BatchNorm"
  bottom: "reduction_a_3x3"
  top: "reduction_a_3x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_a_3x3_scale"
  type: "Scale"
  bottom: "reduction_a_3x3"
  top: "reduction_a_3x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_a_3x3_relu"
  type: "ReLU"
  bottom: "reduction_a_3x3"
  top: "reduction_a_3x3"
}
layer {
  name: "reduction_a_3x3_2_reduce"
  type: "Convolution"
  bottom: "inception_a4_concat"
  top: "reduction_a_3x3_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "reduction_a_3x3_2_reduce_bn"
  type: "BatchNorm"
  bottom: "reduction_a_3x3_2_reduce"
  top: "reduction_a_3x3_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_a_3x3_2_reduce_scale"
  type: "Scale"
  bottom: "reduction_a_3x3_2_reduce"
  top: "reduction_a_3x3_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_a_3x3_2_reduce_relu"
  type: "ReLU"
  bottom: "reduction_a_3x3_2_reduce"
  top: "reduction_a_3x3_2_reduce"
}
layer {
  name: "reduction_a_3x3_2"
  type: "Convolution"
  bottom: "reduction_a_3x3_2_reduce"
  top: "reduction_a_3x3_2"
  convolution_param {
    bias_term: false
    num_output: 224
    pad: 1
    kernel_size: 3
    stride: 1
  }
}
layer {
  name: "reduction_a_3x3_2_bn"
  type: "BatchNorm"
  bottom: "reduction_a_3x3_2"
  top: "reduction_a_3x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_a_3x3_2_scale"
  type: "Scale"
  bottom: "reduction_a_3x3_2"
  top: "reduction_a_3x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_a_3x3_2_relu"
  type: "ReLU"
  bottom: "reduction_a_3x3_2"
  top: "reduction_a_3x3_2"
}
layer {
  name: "reduction_a_3x3_3"
  type: "Convolution"
  bottom: "reduction_a_3x3_2"
  top: "reduction_a_3x3_3"
  convolution_param {
    bias_term: false
    num_output: 256
    pad: 0
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "reduction_a_3x3_3_bn"
  type: "BatchNorm"
  bottom: "reduction_a_3x3_3"
  top: "reduction_a_3x3_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_a_3x3_3_scale"
  type: "Scale"
  bottom: "reduction_a_3x3_3"
  top: "reduction_a_3x3_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_a_3x3_3_relu"
  type: "ReLU"
  bottom: "reduction_a_3x3_3"
  top: "reduction_a_3x3_3"
}
layer {
  name: "reduction_a_pool"
  type: "Pooling"
  bottom: "inception_a4_concat"
  top: "reduction_a_pool"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "reduction_a_concat"
  type: "Concat"
  bottom: "reduction_a_3x3"
  bottom: "reduction_a_3x3_3"
  bottom: "reduction_a_pool"
  top: "reduction_a_concat"
}
layer {
  name: "inception_b1_1x1_2"
  type: "Convolution"
  bottom: "reduction_a_concat"
  top: "inception_b1_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b1_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b1_1x1_2"
  top: "inception_b1_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_1x1_2_scale"
  type: "Scale"
  bottom: "inception_b1_1x1_2"
  top: "inception_b1_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_b1_1x1_2"
  top: "inception_b1_1x1_2"
}
layer {
  name: "inception_b1_1x7_reduce"
  type: "Convolution"
  bottom: "reduction_a_concat"
  top: "inception_b1_1x7_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b1_1x7_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b1_1x7_reduce"
  top: "inception_b1_1x7_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_1x7_reduce_scale"
  type: "Scale"
  bottom: "inception_b1_1x7_reduce"
  top: "inception_b1_1x7_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_1x7_reduce_relu"
  type: "ReLU"
  bottom: "inception_b1_1x7_reduce"
  top: "inception_b1_1x7_reduce"
}
layer {
  name: "inception_b1_1x7"
  type: "Convolution"
  bottom: "inception_b1_1x7_reduce"
  top: "inception_b1_1x7"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b1_1x7_bn"
  type: "BatchNorm"
  bottom: "inception_b1_1x7"
  top: "inception_b1_1x7"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_1x7_scale"
  type: "Scale"
  bottom: "inception_b1_1x7"
  top: "inception_b1_1x7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_1x7_relu"
  type: "ReLU"
  bottom: "inception_b1_1x7"
  top: "inception_b1_1x7"
}
layer {
  name: "inception_b1_7x1"
  type: "Convolution"
  bottom: "inception_b1_1x7"
  top: "inception_b1_7x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b1_7x1_bn"
  type: "BatchNorm"
  bottom: "inception_b1_7x1"
  top: "inception_b1_7x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_7x1_scale"
  type: "Scale"
  bottom: "inception_b1_7x1"
  top: "inception_b1_7x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_7x1_relu"
  type: "ReLU"
  bottom: "inception_b1_7x1"
  top: "inception_b1_7x1"
}
layer {
  name: "inception_b1_7x1_2_reduce"
  type: "Convolution"
  bottom: "reduction_a_concat"
  top: "inception_b1_7x1_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b1_7x1_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b1_7x1_2_reduce"
  top: "inception_b1_7x1_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_7x1_2_reduce_scale"
  type: "Scale"
  bottom: "inception_b1_7x1_2_reduce"
  top: "inception_b1_7x1_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_7x1_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_b1_7x1_2_reduce"
  top: "inception_b1_7x1_2_reduce"
}
layer {
  name: "inception_b1_7x1_2"
  type: "Convolution"
  bottom: "inception_b1_7x1_2_reduce"
  top: "inception_b1_7x1_2"
  convolution_param {
    bias_term: false
    num_output: 192
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b1_7x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b1_7x1_2"
  top: "inception_b1_7x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_7x1_2_scale"
  type: "Scale"
  bottom: "inception_b1_7x1_2"
  top: "inception_b1_7x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_7x1_2_relu"
  type: "ReLU"
  bottom: "inception_b1_7x1_2"
  top: "inception_b1_7x1_2"
}
layer {
  name: "inception_b1_1x7_2"
  type: "Convolution"
  bottom: "inception_b1_7x1_2"
  top: "inception_b1_1x7_2"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b1_1x7_2_bn"
  type: "BatchNorm"
  bottom: "inception_b1_1x7_2"
  top: "inception_b1_1x7_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_1x7_2_scale"
  type: "Scale"
  bottom: "inception_b1_1x7_2"
  top: "inception_b1_1x7_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_1x7_2_relu"
  type: "ReLU"
  bottom: "inception_b1_1x7_2"
  top: "inception_b1_1x7_2"
}
layer {
  name: "inception_b1_7x1_3"
  type: "Convolution"
  bottom: "inception_b1_1x7_2"
  top: "inception_b1_7x1_3"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b1_7x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_b1_7x1_3"
  top: "inception_b1_7x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_7x1_3_scale"
  type: "Scale"
  bottom: "inception_b1_7x1_3"
  top: "inception_b1_7x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_7x1_3_relu"
  type: "ReLU"
  bottom: "inception_b1_7x1_3"
  top: "inception_b1_7x1_3"
}
layer {
  name: "inception_b1_1x7_3"
  type: "Convolution"
  bottom: "inception_b1_7x1_3"
  top: "inception_b1_1x7_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b1_1x7_3_bn"
  type: "BatchNorm"
  bottom: "inception_b1_1x7_3"
  top: "inception_b1_1x7_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_1x7_3_scale"
  type: "Scale"
  bottom: "inception_b1_1x7_3"
  top: "inception_b1_1x7_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_1x7_3_relu"
  type: "ReLU"
  bottom: "inception_b1_1x7_3"
  top: "inception_b1_1x7_3"
}
layer {
  name: "inception_b1_pool_ave"
  type: "Pooling"
  bottom: "reduction_a_concat"
  top: "inception_b1_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_b1_1x1"
  type: "Convolution"
  bottom: "inception_b1_pool_ave"
  top: "inception_b1_1x1"
  convolution_param {
    bias_term: false
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b1_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_b1_1x1"
  top: "inception_b1_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b1_1x1_scale"
  type: "Scale"
  bottom: "inception_b1_1x1"
  top: "inception_b1_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b1_1x1_relu"
  type: "ReLU"
  bottom: "inception_b1_1x1"
  top: "inception_b1_1x1"
}
layer {
  name: "inception_b1_concat"
  type: "Concat"
  bottom: "inception_b1_1x1_2"
  bottom: "inception_b1_7x1"
  bottom: "inception_b1_1x7_3"
  bottom: "inception_b1_1x1"
  top: "inception_b1_concat"
}
layer {
  name: "inception_b2_1x1_2"
  type: "Convolution"
  bottom: "inception_b1_concat"
  top: "inception_b2_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b2_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b2_1x1_2"
  top: "inception_b2_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_1x1_2_scale"
  type: "Scale"
  bottom: "inception_b2_1x1_2"
  top: "inception_b2_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_b2_1x1_2"
  top: "inception_b2_1x1_2"
}
layer {
  name: "inception_b2_1x7_reduce"
  type: "Convolution"
  bottom: "inception_b1_concat"
  top: "inception_b2_1x7_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b2_1x7_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b2_1x7_reduce"
  top: "inception_b2_1x7_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_1x7_reduce_scale"
  type: "Scale"
  bottom: "inception_b2_1x7_reduce"
  top: "inception_b2_1x7_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_1x7_reduce_relu"
  type: "ReLU"
  bottom: "inception_b2_1x7_reduce"
  top: "inception_b2_1x7_reduce"
}
layer {
  name: "inception_b2_1x7"
  type: "Convolution"
  bottom: "inception_b2_1x7_reduce"
  top: "inception_b2_1x7"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b2_1x7_bn"
  type: "BatchNorm"
  bottom: "inception_b2_1x7"
  top: "inception_b2_1x7"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_1x7_scale"
  type: "Scale"
  bottom: "inception_b2_1x7"
  top: "inception_b2_1x7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_1x7_relu"
  type: "ReLU"
  bottom: "inception_b2_1x7"
  top: "inception_b2_1x7"
}
layer {
  name: "inception_b2_7x1"
  type: "Convolution"
  bottom: "inception_b2_1x7"
  top: "inception_b2_7x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b2_7x1_bn"
  type: "BatchNorm"
  bottom: "inception_b2_7x1"
  top: "inception_b2_7x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_7x1_scale"
  type: "Scale"
  bottom: "inception_b2_7x1"
  top: "inception_b2_7x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_7x1_relu"
  type: "ReLU"
  bottom: "inception_b2_7x1"
  top: "inception_b2_7x1"
}
layer {
  name: "inception_b2_7x1_2_reduce"
  type: "Convolution"
  bottom: "inception_b1_concat"
  top: "inception_b2_7x1_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b2_7x1_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b2_7x1_2_reduce"
  top: "inception_b2_7x1_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_7x1_2_reduce_scale"
  type: "Scale"
  bottom: "inception_b2_7x1_2_reduce"
  top: "inception_b2_7x1_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_7x1_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_b2_7x1_2_reduce"
  top: "inception_b2_7x1_2_reduce"
}
layer {
  name: "inception_b2_7x1_2"
  type: "Convolution"
  bottom: "inception_b2_7x1_2_reduce"
  top: "inception_b2_7x1_2"
  convolution_param {
    bias_term: false
    num_output: 192
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b2_7x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b2_7x1_2"
  top: "inception_b2_7x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_7x1_2_scale"
  type: "Scale"
  bottom: "inception_b2_7x1_2"
  top: "inception_b2_7x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_7x1_2_relu"
  type: "ReLU"
  bottom: "inception_b2_7x1_2"
  top: "inception_b2_7x1_2"
}
layer {
  name: "inception_b2_1x7_2"
  type: "Convolution"
  bottom: "inception_b2_7x1_2"
  top: "inception_b2_1x7_2"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b2_1x7_2_bn"
  type: "BatchNorm"
  bottom: "inception_b2_1x7_2"
  top: "inception_b2_1x7_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_1x7_2_scale"
  type: "Scale"
  bottom: "inception_b2_1x7_2"
  top: "inception_b2_1x7_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_1x7_2_relu"
  type: "ReLU"
  bottom: "inception_b2_1x7_2"
  top: "inception_b2_1x7_2"
}
layer {
  name: "inception_b2_7x1_3"
  type: "Convolution"
  bottom: "inception_b2_1x7_2"
  top: "inception_b2_7x1_3"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b2_7x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_b2_7x1_3"
  top: "inception_b2_7x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_7x1_3_scale"
  type: "Scale"
  bottom: "inception_b2_7x1_3"
  top: "inception_b2_7x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_7x1_3_relu"
  type: "ReLU"
  bottom: "inception_b2_7x1_3"
  top: "inception_b2_7x1_3"
}
layer {
  name: "inception_b2_1x7_3"
  type: "Convolution"
  bottom: "inception_b2_7x1_3"
  top: "inception_b2_1x7_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b2_1x7_3_bn"
  type: "BatchNorm"
  bottom: "inception_b2_1x7_3"
  top: "inception_b2_1x7_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_1x7_3_scale"
  type: "Scale"
  bottom: "inception_b2_1x7_3"
  top: "inception_b2_1x7_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_1x7_3_relu"
  type: "ReLU"
  bottom: "inception_b2_1x7_3"
  top: "inception_b2_1x7_3"
}
layer {
  name: "inception_b2_pool_ave"
  type: "Pooling"
  bottom: "inception_b1_concat"
  top: "inception_b2_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_b2_1x1"
  type: "Convolution"
  bottom: "inception_b2_pool_ave"
  top: "inception_b2_1x1"
  convolution_param {
    bias_term: false
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b2_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_b2_1x1"
  top: "inception_b2_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b2_1x1_scale"
  type: "Scale"
  bottom: "inception_b2_1x1"
  top: "inception_b2_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b2_1x1_relu"
  type: "ReLU"
  bottom: "inception_b2_1x1"
  top: "inception_b2_1x1"
}
layer {
  name: "inception_b2_concat"
  type: "Concat"
  bottom: "inception_b2_1x1_2"
  bottom: "inception_b2_7x1"
  bottom: "inception_b2_1x7_3"
  bottom: "inception_b2_1x1"
  top: "inception_b2_concat"
}
layer {
  name: "inception_b3_1x1_2"
  type: "Convolution"
  bottom: "inception_b2_concat"
  top: "inception_b3_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b3_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b3_1x1_2"
  top: "inception_b3_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_1x1_2_scale"
  type: "Scale"
  bottom: "inception_b3_1x1_2"
  top: "inception_b3_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_b3_1x1_2"
  top: "inception_b3_1x1_2"
}
layer {
  name: "inception_b3_1x7_reduce"
  type: "Convolution"
  bottom: "inception_b2_concat"
  top: "inception_b3_1x7_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b3_1x7_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b3_1x7_reduce"
  top: "inception_b3_1x7_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_1x7_reduce_scale"
  type: "Scale"
  bottom: "inception_b3_1x7_reduce"
  top: "inception_b3_1x7_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_1x7_reduce_relu"
  type: "ReLU"
  bottom: "inception_b3_1x7_reduce"
  top: "inception_b3_1x7_reduce"
}
layer {
  name: "inception_b3_1x7"
  type: "Convolution"
  bottom: "inception_b3_1x7_reduce"
  top: "inception_b3_1x7"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b3_1x7_bn"
  type: "BatchNorm"
  bottom: "inception_b3_1x7"
  top: "inception_b3_1x7"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_1x7_scale"
  type: "Scale"
  bottom: "inception_b3_1x7"
  top: "inception_b3_1x7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_1x7_relu"
  type: "ReLU"
  bottom: "inception_b3_1x7"
  top: "inception_b3_1x7"
}
layer {
  name: "inception_b3_7x1"
  type: "Convolution"
  bottom: "inception_b3_1x7"
  top: "inception_b3_7x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b3_7x1_bn"
  type: "BatchNorm"
  bottom: "inception_b3_7x1"
  top: "inception_b3_7x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_7x1_scale"
  type: "Scale"
  bottom: "inception_b3_7x1"
  top: "inception_b3_7x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_7x1_relu"
  type: "ReLU"
  bottom: "inception_b3_7x1"
  top: "inception_b3_7x1"
}
layer {
  name: "inception_b3_7x1_2_reduce"
  type: "Convolution"
  bottom: "inception_b2_concat"
  top: "inception_b3_7x1_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b3_7x1_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b3_7x1_2_reduce"
  top: "inception_b3_7x1_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_7x1_2_reduce_scale"
  type: "Scale"
  bottom: "inception_b3_7x1_2_reduce"
  top: "inception_b3_7x1_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_7x1_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_b3_7x1_2_reduce"
  top: "inception_b3_7x1_2_reduce"
}
layer {
  name: "inception_b3_7x1_2"
  type: "Convolution"
  bottom: "inception_b3_7x1_2_reduce"
  top: "inception_b3_7x1_2"
  convolution_param {
    bias_term: false
    num_output: 192
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b3_7x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b3_7x1_2"
  top: "inception_b3_7x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_7x1_2_scale"
  type: "Scale"
  bottom: "inception_b3_7x1_2"
  top: "inception_b3_7x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_7x1_2_relu"
  type: "ReLU"
  bottom: "inception_b3_7x1_2"
  top: "inception_b3_7x1_2"
}
layer {
  name: "inception_b3_1x7_2"
  type: "Convolution"
  bottom: "inception_b3_7x1_2"
  top: "inception_b3_1x7_2"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b3_1x7_2_bn"
  type: "BatchNorm"
  bottom: "inception_b3_1x7_2"
  top: "inception_b3_1x7_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_1x7_2_scale"
  type: "Scale"
  bottom: "inception_b3_1x7_2"
  top: "inception_b3_1x7_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_1x7_2_relu"
  type: "ReLU"
  bottom: "inception_b3_1x7_2"
  top: "inception_b3_1x7_2"
}
layer {
  name: "inception_b3_7x1_3"
  type: "Convolution"
  bottom: "inception_b3_1x7_2"
  top: "inception_b3_7x1_3"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b3_7x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_b3_7x1_3"
  top: "inception_b3_7x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_7x1_3_scale"
  type: "Scale"
  bottom: "inception_b3_7x1_3"
  top: "inception_b3_7x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_7x1_3_relu"
  type: "ReLU"
  bottom: "inception_b3_7x1_3"
  top: "inception_b3_7x1_3"
}
layer {
  name: "inception_b3_1x7_3"
  type: "Convolution"
  bottom: "inception_b3_7x1_3"
  top: "inception_b3_1x7_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b3_1x7_3_bn"
  type: "BatchNorm"
  bottom: "inception_b3_1x7_3"
  top: "inception_b3_1x7_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_1x7_3_scale"
  type: "Scale"
  bottom: "inception_b3_1x7_3"
  top: "inception_b3_1x7_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_1x7_3_relu"
  type: "ReLU"
  bottom: "inception_b3_1x7_3"
  top: "inception_b3_1x7_3"
}
layer {
  name: "inception_b3_pool_ave"
  type: "Pooling"
  bottom: "inception_b2_concat"
  top: "inception_b3_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_b3_1x1"
  type: "Convolution"
  bottom: "inception_b3_pool_ave"
  top: "inception_b3_1x1"
  convolution_param {
    bias_term: false
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b3_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_b3_1x1"
  top: "inception_b3_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b3_1x1_scale"
  type: "Scale"
  bottom: "inception_b3_1x1"
  top: "inception_b3_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b3_1x1_relu"
  type: "ReLU"
  bottom: "inception_b3_1x1"
  top: "inception_b3_1x1"
}
layer {
  name: "inception_b3_concat"
  type: "Concat"
  bottom: "inception_b3_1x1_2"
  bottom: "inception_b3_7x1"
  bottom: "inception_b3_1x7_3"
  bottom: "inception_b3_1x1"
  top: "inception_b3_concat"
}
layer {
  name: "inception_b4_1x1_2"
  type: "Convolution"
  bottom: "inception_b3_concat"
  top: "inception_b4_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b4_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b4_1x1_2"
  top: "inception_b4_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_1x1_2_scale"
  type: "Scale"
  bottom: "inception_b4_1x1_2"
  top: "inception_b4_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_b4_1x1_2"
  top: "inception_b4_1x1_2"
}
layer {
  name: "inception_b4_1x7_reduce"
  type: "Convolution"
  bottom: "inception_b3_concat"
  top: "inception_b4_1x7_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b4_1x7_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b4_1x7_reduce"
  top: "inception_b4_1x7_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_1x7_reduce_scale"
  type: "Scale"
  bottom: "inception_b4_1x7_reduce"
  top: "inception_b4_1x7_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_1x7_reduce_relu"
  type: "ReLU"
  bottom: "inception_b4_1x7_reduce"
  top: "inception_b4_1x7_reduce"
}
layer {
  name: "inception_b4_1x7"
  type: "Convolution"
  bottom: "inception_b4_1x7_reduce"
  top: "inception_b4_1x7"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b4_1x7_bn"
  type: "BatchNorm"
  bottom: "inception_b4_1x7"
  top: "inception_b4_1x7"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_1x7_scale"
  type: "Scale"
  bottom: "inception_b4_1x7"
  top: "inception_b4_1x7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_1x7_relu"
  type: "ReLU"
  bottom: "inception_b4_1x7"
  top: "inception_b4_1x7"
}
layer {
  name: "inception_b4_7x1"
  type: "Convolution"
  bottom: "inception_b4_1x7"
  top: "inception_b4_7x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b4_7x1_bn"
  type: "BatchNorm"
  bottom: "inception_b4_7x1"
  top: "inception_b4_7x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_7x1_scale"
  type: "Scale"
  bottom: "inception_b4_7x1"
  top: "inception_b4_7x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_7x1_relu"
  type: "ReLU"
  bottom: "inception_b4_7x1"
  top: "inception_b4_7x1"
}
layer {
  name: "inception_b4_7x1_2_reduce"
  type: "Convolution"
  bottom: "inception_b3_concat"
  top: "inception_b4_7x1_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b4_7x1_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b4_7x1_2_reduce"
  top: "inception_b4_7x1_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_7x1_2_reduce_scale"
  type: "Scale"
  bottom: "inception_b4_7x1_2_reduce"
  top: "inception_b4_7x1_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_7x1_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_b4_7x1_2_reduce"
  top: "inception_b4_7x1_2_reduce"
}
layer {
  name: "inception_b4_7x1_2"
  type: "Convolution"
  bottom: "inception_b4_7x1_2_reduce"
  top: "inception_b4_7x1_2"
  convolution_param {
    bias_term: false
    num_output: 192
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b4_7x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b4_7x1_2"
  top: "inception_b4_7x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_7x1_2_scale"
  type: "Scale"
  bottom: "inception_b4_7x1_2"
  top: "inception_b4_7x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_7x1_2_relu"
  type: "ReLU"
  bottom: "inception_b4_7x1_2"
  top: "inception_b4_7x1_2"
}
layer {
  name: "inception_b4_1x7_2"
  type: "Convolution"
  bottom: "inception_b4_7x1_2"
  top: "inception_b4_1x7_2"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b4_1x7_2_bn"
  type: "BatchNorm"
  bottom: "inception_b4_1x7_2"
  top: "inception_b4_1x7_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_1x7_2_scale"
  type: "Scale"
  bottom: "inception_b4_1x7_2"
  top: "inception_b4_1x7_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_1x7_2_relu"
  type: "ReLU"
  bottom: "inception_b4_1x7_2"
  top: "inception_b4_1x7_2"
}
layer {
  name: "inception_b4_7x1_3"
  type: "Convolution"
  bottom: "inception_b4_1x7_2"
  top: "inception_b4_7x1_3"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b4_7x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_b4_7x1_3"
  top: "inception_b4_7x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_7x1_3_scale"
  type: "Scale"
  bottom: "inception_b4_7x1_3"
  top: "inception_b4_7x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_7x1_3_relu"
  type: "ReLU"
  bottom: "inception_b4_7x1_3"
  top: "inception_b4_7x1_3"
}
layer {
  name: "inception_b4_1x7_3"
  type: "Convolution"
  bottom: "inception_b4_7x1_3"
  top: "inception_b4_1x7_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b4_1x7_3_bn"
  type: "BatchNorm"
  bottom: "inception_b4_1x7_3"
  top: "inception_b4_1x7_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_1x7_3_scale"
  type: "Scale"
  bottom: "inception_b4_1x7_3"
  top: "inception_b4_1x7_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_1x7_3_relu"
  type: "ReLU"
  bottom: "inception_b4_1x7_3"
  top: "inception_b4_1x7_3"
}
layer {
  name: "inception_b4_pool_ave"
  type: "Pooling"
  bottom: "inception_b3_concat"
  top: "inception_b4_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_b4_1x1"
  type: "Convolution"
  bottom: "inception_b4_pool_ave"
  top: "inception_b4_1x1"
  convolution_param {
    bias_term: false
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b4_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_b4_1x1"
  top: "inception_b4_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b4_1x1_scale"
  type: "Scale"
  bottom: "inception_b4_1x1"
  top: "inception_b4_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b4_1x1_relu"
  type: "ReLU"
  bottom: "inception_b4_1x1"
  top: "inception_b4_1x1"
}
layer {
  name: "inception_b4_concat"
  type: "Concat"
  bottom: "inception_b4_1x1_2"
  bottom: "inception_b4_7x1"
  bottom: "inception_b4_1x7_3"
  bottom: "inception_b4_1x1"
  top: "inception_b4_concat"
}
layer {
  name: "inception_b5_1x1_2"
  type: "Convolution"
  bottom: "inception_b4_concat"
  top: "inception_b5_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b5_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b5_1x1_2"
  top: "inception_b5_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_1x1_2_scale"
  type: "Scale"
  bottom: "inception_b5_1x1_2"
  top: "inception_b5_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_b5_1x1_2"
  top: "inception_b5_1x1_2"
}
layer {
  name: "inception_b5_1x7_reduce"
  type: "Convolution"
  bottom: "inception_b4_concat"
  top: "inception_b5_1x7_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b5_1x7_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b5_1x7_reduce"
  top: "inception_b5_1x7_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_1x7_reduce_scale"
  type: "Scale"
  bottom: "inception_b5_1x7_reduce"
  top: "inception_b5_1x7_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_1x7_reduce_relu"
  type: "ReLU"
  bottom: "inception_b5_1x7_reduce"
  top: "inception_b5_1x7_reduce"
}
layer {
  name: "inception_b5_1x7"
  type: "Convolution"
  bottom: "inception_b5_1x7_reduce"
  top: "inception_b5_1x7"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b5_1x7_bn"
  type: "BatchNorm"
  bottom: "inception_b5_1x7"
  top: "inception_b5_1x7"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_1x7_scale"
  type: "Scale"
  bottom: "inception_b5_1x7"
  top: "inception_b5_1x7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_1x7_relu"
  type: "ReLU"
  bottom: "inception_b5_1x7"
  top: "inception_b5_1x7"
}
layer {
  name: "inception_b5_7x1"
  type: "Convolution"
  bottom: "inception_b5_1x7"
  top: "inception_b5_7x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b5_7x1_bn"
  type: "BatchNorm"
  bottom: "inception_b5_7x1"
  top: "inception_b5_7x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_7x1_scale"
  type: "Scale"
  bottom: "inception_b5_7x1"
  top: "inception_b5_7x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_7x1_relu"
  type: "ReLU"
  bottom: "inception_b5_7x1"
  top: "inception_b5_7x1"
}
layer {
  name: "inception_b5_7x1_2_reduce"
  type: "Convolution"
  bottom: "inception_b4_concat"
  top: "inception_b5_7x1_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b5_7x1_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b5_7x1_2_reduce"
  top: "inception_b5_7x1_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_7x1_2_reduce_scale"
  type: "Scale"
  bottom: "inception_b5_7x1_2_reduce"
  top: "inception_b5_7x1_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_7x1_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_b5_7x1_2_reduce"
  top: "inception_b5_7x1_2_reduce"
}
layer {
  name: "inception_b5_7x1_2"
  type: "Convolution"
  bottom: "inception_b5_7x1_2_reduce"
  top: "inception_b5_7x1_2"
  convolution_param {
    bias_term: false
    num_output: 192
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b5_7x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b5_7x1_2"
  top: "inception_b5_7x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_7x1_2_scale"
  type: "Scale"
  bottom: "inception_b5_7x1_2"
  top: "inception_b5_7x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_7x1_2_relu"
  type: "ReLU"
  bottom: "inception_b5_7x1_2"
  top: "inception_b5_7x1_2"
}
layer {
  name: "inception_b5_1x7_2"
  type: "Convolution"
  bottom: "inception_b5_7x1_2"
  top: "inception_b5_1x7_2"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b5_1x7_2_bn"
  type: "BatchNorm"
  bottom: "inception_b5_1x7_2"
  top: "inception_b5_1x7_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_1x7_2_scale"
  type: "Scale"
  bottom: "inception_b5_1x7_2"
  top: "inception_b5_1x7_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_1x7_2_relu"
  type: "ReLU"
  bottom: "inception_b5_1x7_2"
  top: "inception_b5_1x7_2"
}
layer {
  name: "inception_b5_7x1_3"
  type: "Convolution"
  bottom: "inception_b5_1x7_2"
  top: "inception_b5_7x1_3"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b5_7x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_b5_7x1_3"
  top: "inception_b5_7x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_7x1_3_scale"
  type: "Scale"
  bottom: "inception_b5_7x1_3"
  top: "inception_b5_7x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_7x1_3_relu"
  type: "ReLU"
  bottom: "inception_b5_7x1_3"
  top: "inception_b5_7x1_3"
}
layer {
  name: "inception_b5_1x7_3"
  type: "Convolution"
  bottom: "inception_b5_7x1_3"
  top: "inception_b5_1x7_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b5_1x7_3_bn"
  type: "BatchNorm"
  bottom: "inception_b5_1x7_3"
  top: "inception_b5_1x7_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_1x7_3_scale"
  type: "Scale"
  bottom: "inception_b5_1x7_3"
  top: "inception_b5_1x7_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_1x7_3_relu"
  type: "ReLU"
  bottom: "inception_b5_1x7_3"
  top: "inception_b5_1x7_3"
}
layer {
  name: "inception_b5_pool_ave"
  type: "Pooling"
  bottom: "inception_b4_concat"
  top: "inception_b5_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_b5_1x1"
  type: "Convolution"
  bottom: "inception_b5_pool_ave"
  top: "inception_b5_1x1"
  convolution_param {
    bias_term: false
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b5_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_b5_1x1"
  top: "inception_b5_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b5_1x1_scale"
  type: "Scale"
  bottom: "inception_b5_1x1"
  top: "inception_b5_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b5_1x1_relu"
  type: "ReLU"
  bottom: "inception_b5_1x1"
  top: "inception_b5_1x1"
}
layer {
  name: "inception_b5_concat"
  type: "Concat"
  bottom: "inception_b5_1x1_2"
  bottom: "inception_b5_7x1"
  bottom: "inception_b5_1x7_3"
  bottom: "inception_b5_1x1"
  top: "inception_b5_concat"
}
layer {
  name: "inception_b6_1x1_2"
  type: "Convolution"
  bottom: "inception_b5_concat"
  top: "inception_b6_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b6_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b6_1x1_2"
  top: "inception_b6_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_1x1_2_scale"
  type: "Scale"
  bottom: "inception_b6_1x1_2"
  top: "inception_b6_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_b6_1x1_2"
  top: "inception_b6_1x1_2"
}
layer {
  name: "inception_b6_1x7_reduce"
  type: "Convolution"
  bottom: "inception_b5_concat"
  top: "inception_b6_1x7_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b6_1x7_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b6_1x7_reduce"
  top: "inception_b6_1x7_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_1x7_reduce_scale"
  type: "Scale"
  bottom: "inception_b6_1x7_reduce"
  top: "inception_b6_1x7_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_1x7_reduce_relu"
  type: "ReLU"
  bottom: "inception_b6_1x7_reduce"
  top: "inception_b6_1x7_reduce"
}
layer {
  name: "inception_b6_1x7"
  type: "Convolution"
  bottom: "inception_b6_1x7_reduce"
  top: "inception_b6_1x7"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b6_1x7_bn"
  type: "BatchNorm"
  bottom: "inception_b6_1x7"
  top: "inception_b6_1x7"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_1x7_scale"
  type: "Scale"
  bottom: "inception_b6_1x7"
  top: "inception_b6_1x7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_1x7_relu"
  type: "ReLU"
  bottom: "inception_b6_1x7"
  top: "inception_b6_1x7"
}
layer {
  name: "inception_b6_7x1"
  type: "Convolution"
  bottom: "inception_b6_1x7"
  top: "inception_b6_7x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b6_7x1_bn"
  type: "BatchNorm"
  bottom: "inception_b6_7x1"
  top: "inception_b6_7x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_7x1_scale"
  type: "Scale"
  bottom: "inception_b6_7x1"
  top: "inception_b6_7x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_7x1_relu"
  type: "ReLU"
  bottom: "inception_b6_7x1"
  top: "inception_b6_7x1"
}
layer {
  name: "inception_b6_7x1_2_reduce"
  type: "Convolution"
  bottom: "inception_b5_concat"
  top: "inception_b6_7x1_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b6_7x1_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b6_7x1_2_reduce"
  top: "inception_b6_7x1_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_7x1_2_reduce_scale"
  type: "Scale"
  bottom: "inception_b6_7x1_2_reduce"
  top: "inception_b6_7x1_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_7x1_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_b6_7x1_2_reduce"
  top: "inception_b6_7x1_2_reduce"
}
layer {
  name: "inception_b6_7x1_2"
  type: "Convolution"
  bottom: "inception_b6_7x1_2_reduce"
  top: "inception_b6_7x1_2"
  convolution_param {
    bias_term: false
    num_output: 192
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b6_7x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b6_7x1_2"
  top: "inception_b6_7x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_7x1_2_scale"
  type: "Scale"
  bottom: "inception_b6_7x1_2"
  top: "inception_b6_7x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_7x1_2_relu"
  type: "ReLU"
  bottom: "inception_b6_7x1_2"
  top: "inception_b6_7x1_2"
}
layer {
  name: "inception_b6_1x7_2"
  type: "Convolution"
  bottom: "inception_b6_7x1_2"
  top: "inception_b6_1x7_2"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b6_1x7_2_bn"
  type: "BatchNorm"
  bottom: "inception_b6_1x7_2"
  top: "inception_b6_1x7_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_1x7_2_scale"
  type: "Scale"
  bottom: "inception_b6_1x7_2"
  top: "inception_b6_1x7_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_1x7_2_relu"
  type: "ReLU"
  bottom: "inception_b6_1x7_2"
  top: "inception_b6_1x7_2"
}
layer {
  name: "inception_b6_7x1_3"
  type: "Convolution"
  bottom: "inception_b6_1x7_2"
  top: "inception_b6_7x1_3"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b6_7x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_b6_7x1_3"
  top: "inception_b6_7x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_7x1_3_scale"
  type: "Scale"
  bottom: "inception_b6_7x1_3"
  top: "inception_b6_7x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_7x1_3_relu"
  type: "ReLU"
  bottom: "inception_b6_7x1_3"
  top: "inception_b6_7x1_3"
}
layer {
  name: "inception_b6_1x7_3"
  type: "Convolution"
  bottom: "inception_b6_7x1_3"
  top: "inception_b6_1x7_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b6_1x7_3_bn"
  type: "BatchNorm"
  bottom: "inception_b6_1x7_3"
  top: "inception_b6_1x7_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_1x7_3_scale"
  type: "Scale"
  bottom: "inception_b6_1x7_3"
  top: "inception_b6_1x7_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_1x7_3_relu"
  type: "ReLU"
  bottom: "inception_b6_1x7_3"
  top: "inception_b6_1x7_3"
}
layer {
  name: "inception_b6_pool_ave"
  type: "Pooling"
  bottom: "inception_b5_concat"
  top: "inception_b6_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_b6_1x1"
  type: "Convolution"
  bottom: "inception_b6_pool_ave"
  top: "inception_b6_1x1"
  convolution_param {
    bias_term: false
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b6_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_b6_1x1"
  top: "inception_b6_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b6_1x1_scale"
  type: "Scale"
  bottom: "inception_b6_1x1"
  top: "inception_b6_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b6_1x1_relu"
  type: "ReLU"
  bottom: "inception_b6_1x1"
  top: "inception_b6_1x1"
}
layer {
  name: "inception_b6_concat"
  type: "Concat"
  bottom: "inception_b6_1x1_2"
  bottom: "inception_b6_7x1"
  bottom: "inception_b6_1x7_3"
  bottom: "inception_b6_1x1"
  top: "inception_b6_concat"
}
layer {
  name: "inception_b7_1x1_2"
  type: "Convolution"
  bottom: "inception_b6_concat"
  top: "inception_b7_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b7_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b7_1x1_2"
  top: "inception_b7_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_1x1_2_scale"
  type: "Scale"
  bottom: "inception_b7_1x1_2"
  top: "inception_b7_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_b7_1x1_2"
  top: "inception_b7_1x1_2"
}
layer {
  name: "inception_b7_1x7_reduce"
  type: "Convolution"
  bottom: "inception_b6_concat"
  top: "inception_b7_1x7_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b7_1x7_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b7_1x7_reduce"
  top: "inception_b7_1x7_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_1x7_reduce_scale"
  type: "Scale"
  bottom: "inception_b7_1x7_reduce"
  top: "inception_b7_1x7_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_1x7_reduce_relu"
  type: "ReLU"
  bottom: "inception_b7_1x7_reduce"
  top: "inception_b7_1x7_reduce"
}
layer {
  name: "inception_b7_1x7"
  type: "Convolution"
  bottom: "inception_b7_1x7_reduce"
  top: "inception_b7_1x7"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b7_1x7_bn"
  type: "BatchNorm"
  bottom: "inception_b7_1x7"
  top: "inception_b7_1x7"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_1x7_scale"
  type: "Scale"
  bottom: "inception_b7_1x7"
  top: "inception_b7_1x7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_1x7_relu"
  type: "ReLU"
  bottom: "inception_b7_1x7"
  top: "inception_b7_1x7"
}
layer {
  name: "inception_b7_7x1"
  type: "Convolution"
  bottom: "inception_b7_1x7"
  top: "inception_b7_7x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b7_7x1_bn"
  type: "BatchNorm"
  bottom: "inception_b7_7x1"
  top: "inception_b7_7x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_7x1_scale"
  type: "Scale"
  bottom: "inception_b7_7x1"
  top: "inception_b7_7x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_7x1_relu"
  type: "ReLU"
  bottom: "inception_b7_7x1"
  top: "inception_b7_7x1"
}
layer {
  name: "inception_b7_7x1_2_reduce"
  type: "Convolution"
  bottom: "inception_b6_concat"
  top: "inception_b7_7x1_2_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b7_7x1_2_reduce_bn"
  type: "BatchNorm"
  bottom: "inception_b7_7x1_2_reduce"
  top: "inception_b7_7x1_2_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_7x1_2_reduce_scale"
  type: "Scale"
  bottom: "inception_b7_7x1_2_reduce"
  top: "inception_b7_7x1_2_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_7x1_2_reduce_relu"
  type: "ReLU"
  bottom: "inception_b7_7x1_2_reduce"
  top: "inception_b7_7x1_2_reduce"
}
layer {
  name: "inception_b7_7x1_2"
  type: "Convolution"
  bottom: "inception_b7_7x1_2_reduce"
  top: "inception_b7_7x1_2"
  convolution_param {
    bias_term: false
    num_output: 192
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b7_7x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_b7_7x1_2"
  top: "inception_b7_7x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_7x1_2_scale"
  type: "Scale"
  bottom: "inception_b7_7x1_2"
  top: "inception_b7_7x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_7x1_2_relu"
  type: "ReLU"
  bottom: "inception_b7_7x1_2"
  top: "inception_b7_7x1_2"
}
layer {
  name: "inception_b7_1x7_2"
  type: "Convolution"
  bottom: "inception_b7_7x1_2"
  top: "inception_b7_1x7_2"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b7_1x7_2_bn"
  type: "BatchNorm"
  bottom: "inception_b7_1x7_2"
  top: "inception_b7_1x7_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_1x7_2_scale"
  type: "Scale"
  bottom: "inception_b7_1x7_2"
  top: "inception_b7_1x7_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_1x7_2_relu"
  type: "ReLU"
  bottom: "inception_b7_1x7_2"
  top: "inception_b7_1x7_2"
}
layer {
  name: "inception_b7_7x1_3"
  type: "Convolution"
  bottom: "inception_b7_1x7_2"
  top: "inception_b7_7x1_3"
  convolution_param {
    bias_term: false
    num_output: 224
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "inception_b7_7x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_b7_7x1_3"
  top: "inception_b7_7x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_7x1_3_scale"
  type: "Scale"
  bottom: "inception_b7_7x1_3"
  top: "inception_b7_7x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_7x1_3_relu"
  type: "ReLU"
  bottom: "inception_b7_7x1_3"
  top: "inception_b7_7x1_3"
}
layer {
  name: "inception_b7_1x7_3"
  type: "Convolution"
  bottom: "inception_b7_7x1_3"
  top: "inception_b7_1x7_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "inception_b7_1x7_3_bn"
  type: "BatchNorm"
  bottom: "inception_b7_1x7_3"
  top: "inception_b7_1x7_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_1x7_3_scale"
  type: "Scale"
  bottom: "inception_b7_1x7_3"
  top: "inception_b7_1x7_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_1x7_3_relu"
  type: "ReLU"
  bottom: "inception_b7_1x7_3"
  top: "inception_b7_1x7_3"
}
layer {
  name: "inception_b7_pool_ave"
  type: "Pooling"
  bottom: "inception_b6_concat"
  top: "inception_b7_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_b7_1x1"
  type: "Convolution"
  bottom: "inception_b7_pool_ave"
  top: "inception_b7_1x1"
  convolution_param {
    bias_term: false
    num_output: 128
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_b7_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_b7_1x1"
  top: "inception_b7_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_b7_1x1_scale"
  type: "Scale"
  bottom: "inception_b7_1x1"
  top: "inception_b7_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_b7_1x1_relu"
  type: "ReLU"
  bottom: "inception_b7_1x1"
  top: "inception_b7_1x1"
}
layer {
  name: "inception_b7_concat"
  type: "Concat"
  bottom: "inception_b7_1x1_2"
  bottom: "inception_b7_7x1"
  bottom: "inception_b7_1x7_3"
  bottom: "inception_b7_1x1"
  top: "inception_b7_concat"
}
layer {
  name: "reduction_b_3x3_reduce"
  type: "Convolution"
  bottom: "inception_b7_concat"
  top: "reduction_b_3x3_reduce"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "reduction_b_3x3_reduce_bn"
  type: "BatchNorm"
  bottom: "reduction_b_3x3_reduce"
  top: "reduction_b_3x3_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_b_3x3_reduce_scale"
  type: "Scale"
  bottom: "reduction_b_3x3_reduce"
  top: "reduction_b_3x3_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_b_3x3_reduce_relu"
  type: "ReLU"
  bottom: "reduction_b_3x3_reduce"
  top: "reduction_b_3x3_reduce"
}
layer {
  name: "reduction_b_3x3"
  type: "Convolution"
  bottom: "reduction_b_3x3_reduce"
  top: "reduction_b_3x3"
  convolution_param {
    bias_term: false
    num_output: 192
    pad: 0
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "reduction_b_3x3_bn"
  type: "BatchNorm"
  bottom: "reduction_b_3x3"
  top: "reduction_b_3x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_b_3x3_scale"
  type: "Scale"
  bottom: "reduction_b_3x3"
  top: "reduction_b_3x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_b_3x3_relu"
  type: "ReLU"
  bottom: "reduction_b_3x3"
  top: "reduction_b_3x3"
}
layer {
  name: "reduction_b_1x7_reduce"
  type: "Convolution"
  bottom: "inception_b7_concat"
  top: "reduction_b_1x7_reduce"
  convolution_param {
    bias_term: false
    num_output: 256
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "reduction_b_1x7_reduce_bn"
  type: "BatchNorm"
  bottom: "reduction_b_1x7_reduce"
  top: "reduction_b_1x7_reduce"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_b_1x7_reduce_scale"
  type: "Scale"
  bottom: "reduction_b_1x7_reduce"
  top: "reduction_b_1x7_reduce"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_b_1x7_reduce_relu"
  type: "ReLU"
  bottom: "reduction_b_1x7_reduce"
  top: "reduction_b_1x7_reduce"
}
layer {
  name: "reduction_b_1x7"
  type: "Convolution"
  bottom: "reduction_b_1x7_reduce"
  top: "reduction_b_1x7"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 3
    kernel_h: 1
    kernel_w: 7
  }
}
layer {
  name: "reduction_b_1x7_bn"
  type: "BatchNorm"
  bottom: "reduction_b_1x7"
  top: "reduction_b_1x7"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_b_1x7_scale"
  type: "Scale"
  bottom: "reduction_b_1x7"
  top: "reduction_b_1x7"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_b_1x7_relu"
  type: "ReLU"
  bottom: "reduction_b_1x7"
  top: "reduction_b_1x7"
}
layer {
  name: "reduction_b_7x1"
  type: "Convolution"
  bottom: "reduction_b_1x7"
  top: "reduction_b_7x1"
  convolution_param {
    bias_term: false
    num_output: 320
    stride: 1
    pad_h: 3
    pad_w: 0
    kernel_h: 7
    kernel_w: 1
  }
}
layer {
  name: "reduction_b_7x1_bn"
  type: "BatchNorm"
  bottom: "reduction_b_7x1"
  top: "reduction_b_7x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_b_7x1_scale"
  type: "Scale"
  bottom: "reduction_b_7x1"
  top: "reduction_b_7x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_b_7x1_relu"
  type: "ReLU"
  bottom: "reduction_b_7x1"
  top: "reduction_b_7x1"
}
layer {
  name: "reduction_b_3x3_2"
  type: "Convolution"
  bottom: "reduction_b_7x1"
  top: "reduction_b_3x3_2"
  convolution_param {
    bias_term: false
    num_output: 320
    pad: 0
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "reduction_b_3x3_2_bn"
  type: "BatchNorm"
  bottom: "reduction_b_3x3_2"
  top: "reduction_b_3x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "reduction_b_3x3_2_scale"
  type: "Scale"
  bottom: "reduction_b_3x3_2"
  top: "reduction_b_3x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "reduction_b_3x3_2_relu"
  type: "ReLU"
  bottom: "reduction_b_3x3_2"
  top: "reduction_b_3x3_2"
}
layer {
  name: "reduction_b_pool"
  type: "Pooling"
  bottom: "inception_b7_concat"
  top: "reduction_b_pool"
  pooling_param {
    pool: MAX
    kernel_size: 3
    stride: 2
  }
}
layer {
  name: "reduction_b_concat"
  type: "Concat"
  bottom: "reduction_b_3x3"
  bottom: "reduction_b_3x3_2"
  bottom: "reduction_b_pool"
  top: "reduction_b_concat"
}
layer {
  name: "inception_c1_1x1_2"
  type: "Convolution"
  bottom: "reduction_b_concat"
  top: "inception_c1_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 256
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c1_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_c1_1x1_2"
  top: "inception_c1_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_1x1_2_scale"
  type: "Scale"
  bottom: "inception_c1_1x1_2"
  top: "inception_c1_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_c1_1x1_2"
  top: "inception_c1_1x1_2"
}
layer {
  name: "inception_c1_1x1_3"
  type: "Convolution"
  bottom: "reduction_b_concat"
  top: "inception_c1_1x1_3"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c1_1x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_c1_1x1_3"
  top: "inception_c1_1x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_1x1_3_scale"
  type: "Scale"
  bottom: "inception_c1_1x1_3"
  top: "inception_c1_1x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_1x1_3_relu"
  type: "ReLU"
  bottom: "inception_c1_1x1_3"
  top: "inception_c1_1x1_3"
}
layer {
  name: "inception_c1_1x3"
  type: "Convolution"
  bottom: "inception_c1_1x1_3"
  top: "inception_c1_1x3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 1
    kernel_h: 1
    kernel_w: 3
  }
}
layer {
  name: "inception_c1_1x3_bn"
  type: "BatchNorm"
  bottom: "inception_c1_1x3"
  top: "inception_c1_1x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_1x3_scale"
  type: "Scale"
  bottom: "inception_c1_1x3"
  top: "inception_c1_1x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_1x3_relu"
  type: "ReLU"
  bottom: "inception_c1_1x3"
  top: "inception_c1_1x3"
}
layer {
  name: "inception_c1_3x1"
  type: "Convolution"
  bottom: "inception_c1_1x1_3"
  top: "inception_c1_3x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 1
    pad_w: 0
    kernel_h: 3
    kernel_w: 1
  }
}
layer {
  name: "inception_c1_3x1_bn"
  type: "BatchNorm"
  bottom: "inception_c1_3x1"
  top: "inception_c1_3x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_3x1_scale"
  type: "Scale"
  bottom: "inception_c1_3x1"
  top: "inception_c1_3x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_3x1_relu"
  type: "ReLU"
  bottom: "inception_c1_3x1"
  top: "inception_c1_3x1"
}
layer {
  name: "inception_c1_1x1_4"
  type: "Convolution"
  bottom: "reduction_b_concat"
  top: "inception_c1_1x1_4"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c1_1x1_4_bn"
  type: "BatchNorm"
  bottom: "inception_c1_1x1_4"
  top: "inception_c1_1x1_4"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_1x1_4_scale"
  type: "Scale"
  bottom: "inception_c1_1x1_4"
  top: "inception_c1_1x1_4"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_1x1_4_relu"
  type: "ReLU"
  bottom: "inception_c1_1x1_4"
  top: "inception_c1_1x1_4"
}
layer {
  name: "inception_c1_3x1_2"
  type: "Convolution"
  bottom: "inception_c1_1x1_4"
  top: "inception_c1_3x1_2"
  convolution_param {
    bias_term: false
    num_output: 448
    stride: 1
    pad_h: 1
    pad_w: 0
    kernel_h: 3
    kernel_w: 1
  }
}
layer {
  name: "inception_c1_3x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_c1_3x1_2"
  top: "inception_c1_3x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_3x1_2_scale"
  type: "Scale"
  bottom: "inception_c1_3x1_2"
  top: "inception_c1_3x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_3x1_2_relu"
  type: "ReLU"
  bottom: "inception_c1_3x1_2"
  top: "inception_c1_3x1_2"
}
layer {
  name: "inception_c1_1x3_2"
  type: "Convolution"
  bottom: "inception_c1_3x1_2"
  top: "inception_c1_1x3_2"
  convolution_param {
    bias_term: false
    num_output: 512
    stride: 1
    pad_h: 0
    pad_w: 1
    kernel_h: 1
    kernel_w: 3
  }
}
layer {
  name: "inception_c1_1x3_2_bn"
  type: "BatchNorm"
  bottom: "inception_c1_1x3_2"
  top: "inception_c1_1x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_1x3_2_scale"
  type: "Scale"
  bottom: "inception_c1_1x3_2"
  top: "inception_c1_1x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_1x3_2_relu"
  type: "ReLU"
  bottom: "inception_c1_1x3_2"
  top: "inception_c1_1x3_2"
}
layer {
  name: "inception_c1_1x3_3"
  type: "Convolution"
  bottom: "inception_c1_1x3_2"
  top: "inception_c1_1x3_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 1
    kernel_h: 1
    kernel_w: 3
  }
}
layer {
  name: "inception_c1_1x3_3_bn"
  type: "BatchNorm"
  bottom: "inception_c1_1x3_3"
  top: "inception_c1_1x3_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_1x3_3_scale"
  type: "Scale"
  bottom: "inception_c1_1x3_3"
  top: "inception_c1_1x3_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_1x3_3_relu"
  type: "ReLU"
  bottom: "inception_c1_1x3_3"
  top: "inception_c1_1x3_3"
}
layer {
  name: "inception_c1_3x1_3"
  type: "Convolution"
  bottom: "inception_c1_1x3_2"
  top: "inception_c1_3x1_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 1
    pad_w: 0
    kernel_h: 3
    kernel_w: 1
  }
}
layer {
  name: "inception_c1_3x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_c1_3x1_3"
  top: "inception_c1_3x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_3x1_3_scale"
  type: "Scale"
  bottom: "inception_c1_3x1_3"
  top: "inception_c1_3x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_3x1_3_relu"
  type: "ReLU"
  bottom: "inception_c1_3x1_3"
  top: "inception_c1_3x1_3"
}
layer {
  name: "inception_c1_pool_ave"
  type: "Pooling"
  bottom: "reduction_b_concat"
  top: "inception_c1_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_c1_1x1"
  type: "Convolution"
  bottom: "inception_c1_pool_ave"
  top: "inception_c1_1x1"
  convolution_param {
    bias_term: false
    num_output: 256
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c1_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_c1_1x1"
  top: "inception_c1_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c1_1x1_scale"
  type: "Scale"
  bottom: "inception_c1_1x1"
  top: "inception_c1_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c1_1x1_relu"
  type: "ReLU"
  bottom: "inception_c1_1x1"
  top: "inception_c1_1x1"
}
layer {
  name: "inception_c1_concat"
  type: "Concat"
  bottom: "inception_c1_1x1_2"
  bottom: "inception_c1_1x3"
  bottom: "inception_c1_3x1"
  bottom: "inception_c1_1x3_3"
  bottom: "inception_c1_3x1_3"
  bottom: "inception_c1_1x1"
  top: "inception_c1_concat"
}
layer {
  name: "inception_c2_1x1_2"
  type: "Convolution"
  bottom: "inception_c1_concat"
  top: "inception_c2_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 256
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c2_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_c2_1x1_2"
  top: "inception_c2_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_1x1_2_scale"
  type: "Scale"
  bottom: "inception_c2_1x1_2"
  top: "inception_c2_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_c2_1x1_2"
  top: "inception_c2_1x1_2"
}
layer {
  name: "inception_c2_1x1_3"
  type: "Convolution"
  bottom: "inception_c1_concat"
  top: "inception_c2_1x1_3"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c2_1x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_c2_1x1_3"
  top: "inception_c2_1x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_1x1_3_scale"
  type: "Scale"
  bottom: "inception_c2_1x1_3"
  top: "inception_c2_1x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_1x1_3_relu"
  type: "ReLU"
  bottom: "inception_c2_1x1_3"
  top: "inception_c2_1x1_3"
}
layer {
  name: "inception_c2_1x3"
  type: "Convolution"
  bottom: "inception_c2_1x1_3"
  top: "inception_c2_1x3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 1
    kernel_h: 1
    kernel_w: 3
  }
}
layer {
  name: "inception_c2_1x3_bn"
  type: "BatchNorm"
  bottom: "inception_c2_1x3"
  top: "inception_c2_1x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_1x3_scale"
  type: "Scale"
  bottom: "inception_c2_1x3"
  top: "inception_c2_1x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_1x3_relu"
  type: "ReLU"
  bottom: "inception_c2_1x3"
  top: "inception_c2_1x3"
}
layer {
  name: "inception_c2_3x1"
  type: "Convolution"
  bottom: "inception_c2_1x1_3"
  top: "inception_c2_3x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 1
    pad_w: 0
    kernel_h: 3
    kernel_w: 1
  }
}
layer {
  name: "inception_c2_3x1_bn"
  type: "BatchNorm"
  bottom: "inception_c2_3x1"
  top: "inception_c2_3x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_3x1_scale"
  type: "Scale"
  bottom: "inception_c2_3x1"
  top: "inception_c2_3x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_3x1_relu"
  type: "ReLU"
  bottom: "inception_c2_3x1"
  top: "inception_c2_3x1"
}
layer {
  name: "inception_c2_1x1_4"
  type: "Convolution"
  bottom: "inception_c1_concat"
  top: "inception_c2_1x1_4"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c2_1x1_4_bn"
  type: "BatchNorm"
  bottom: "inception_c2_1x1_4"
  top: "inception_c2_1x1_4"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_1x1_4_scale"
  type: "Scale"
  bottom: "inception_c2_1x1_4"
  top: "inception_c2_1x1_4"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_1x1_4_relu"
  type: "ReLU"
  bottom: "inception_c2_1x1_4"
  top: "inception_c2_1x1_4"
}
layer {
  name: "inception_c2_3x1_2"
  type: "Convolution"
  bottom: "inception_c2_1x1_4"
  top: "inception_c2_3x1_2"
  convolution_param {
    bias_term: false
    num_output: 448
    stride: 1
    pad_h: 1
    pad_w: 0
    kernel_h: 3
    kernel_w: 1
  }
}
layer {
  name: "inception_c2_3x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_c2_3x1_2"
  top: "inception_c2_3x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_3x1_2_scale"
  type: "Scale"
  bottom: "inception_c2_3x1_2"
  top: "inception_c2_3x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_3x1_2_relu"
  type: "ReLU"
  bottom: "inception_c2_3x1_2"
  top: "inception_c2_3x1_2"
}
layer {
  name: "inception_c2_1x3_2"
  type: "Convolution"
  bottom: "inception_c2_3x1_2"
  top: "inception_c2_1x3_2"
  convolution_param {
    bias_term: false
    num_output: 512
    stride: 1
    pad_h: 0
    pad_w: 1
    kernel_h: 1
    kernel_w: 3
  }
}
layer {
  name: "inception_c2_1x3_2_bn"
  type: "BatchNorm"
  bottom: "inception_c2_1x3_2"
  top: "inception_c2_1x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_1x3_2_scale"
  type: "Scale"
  bottom: "inception_c2_1x3_2"
  top: "inception_c2_1x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_1x3_2_relu"
  type: "ReLU"
  bottom: "inception_c2_1x3_2"
  top: "inception_c2_1x3_2"
}
layer {
  name: "inception_c2_1x3_3"
  type: "Convolution"
  bottom: "inception_c2_1x3_2"
  top: "inception_c2_1x3_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 1
    kernel_h: 1
    kernel_w: 3
  }
}
layer {
  name: "inception_c2_1x3_3_bn"
  type: "BatchNorm"
  bottom: "inception_c2_1x3_3"
  top: "inception_c2_1x3_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_1x3_3_scale"
  type: "Scale"
  bottom: "inception_c2_1x3_3"
  top: "inception_c2_1x3_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_1x3_3_relu"
  type: "ReLU"
  bottom: "inception_c2_1x3_3"
  top: "inception_c2_1x3_3"
}
layer {
  name: "inception_c2_3x1_3"
  type: "Convolution"
  bottom: "inception_c2_1x3_2"
  top: "inception_c2_3x1_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 1
    pad_w: 0
    kernel_h: 3
    kernel_w: 1
  }
}
layer {
  name: "inception_c2_3x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_c2_3x1_3"
  top: "inception_c2_3x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_3x1_3_scale"
  type: "Scale"
  bottom: "inception_c2_3x1_3"
  top: "inception_c2_3x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_3x1_3_relu"
  type: "ReLU"
  bottom: "inception_c2_3x1_3"
  top: "inception_c2_3x1_3"
}
layer {
  name: "inception_c2_pool_ave"
  type: "Pooling"
  bottom: "inception_c1_concat"
  top: "inception_c2_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_c2_1x1"
  type: "Convolution"
  bottom: "inception_c2_pool_ave"
  top: "inception_c2_1x1"
  convolution_param {
    bias_term: false
    num_output: 256
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c2_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_c2_1x1"
  top: "inception_c2_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c2_1x1_scale"
  type: "Scale"
  bottom: "inception_c2_1x1"
  top: "inception_c2_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c2_1x1_relu"
  type: "ReLU"
  bottom: "inception_c2_1x1"
  top: "inception_c2_1x1"
}
layer {
  name: "inception_c2_concat"
  type: "Concat"
  bottom: "inception_c2_1x1_2"
  bottom: "inception_c2_1x3"
  bottom: "inception_c2_3x1"
  bottom: "inception_c2_1x3_3"
  bottom: "inception_c2_3x1_3"
  bottom: "inception_c2_1x1"
  top: "inception_c2_concat"
}
layer {
  name: "inception_c3_1x1_2"
  type: "Convolution"
  bottom: "inception_c2_concat"
  top: "inception_c3_1x1_2"
  convolution_param {
    bias_term: false
    num_output: 256
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c3_1x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_c3_1x1_2"
  top: "inception_c3_1x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_1x1_2_scale"
  type: "Scale"
  bottom: "inception_c3_1x1_2"
  top: "inception_c3_1x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_1x1_2_relu"
  type: "ReLU"
  bottom: "inception_c3_1x1_2"
  top: "inception_c3_1x1_2"
}
layer {
  name: "inception_c3_1x1_3"
  type: "Convolution"
  bottom: "inception_c2_concat"
  top: "inception_c3_1x1_3"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c3_1x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_c3_1x1_3"
  top: "inception_c3_1x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_1x1_3_scale"
  type: "Scale"
  bottom: "inception_c3_1x1_3"
  top: "inception_c3_1x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_1x1_3_relu"
  type: "ReLU"
  bottom: "inception_c3_1x1_3"
  top: "inception_c3_1x1_3"
}
layer {
  name: "inception_c3_1x3"
  type: "Convolution"
  bottom: "inception_c3_1x1_3"
  top: "inception_c3_1x3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 1
    kernel_h: 1
    kernel_w: 3
  }
}
layer {
  name: "inception_c3_1x3_bn"
  type: "BatchNorm"
  bottom: "inception_c3_1x3"
  top: "inception_c3_1x3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_1x3_scale"
  type: "Scale"
  bottom: "inception_c3_1x3"
  top: "inception_c3_1x3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_1x3_relu"
  type: "ReLU"
  bottom: "inception_c3_1x3"
  top: "inception_c3_1x3"
}
layer {
  name: "inception_c3_3x1"
  type: "Convolution"
  bottom: "inception_c3_1x1_3"
  top: "inception_c3_3x1"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 1
    pad_w: 0
    kernel_h: 3
    kernel_w: 1
  }
}
layer {
  name: "inception_c3_3x1_bn"
  type: "BatchNorm"
  bottom: "inception_c3_3x1"
  top: "inception_c3_3x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_3x1_scale"
  type: "Scale"
  bottom: "inception_c3_3x1"
  top: "inception_c3_3x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_3x1_relu"
  type: "ReLU"
  bottom: "inception_c3_3x1"
  top: "inception_c3_3x1"
}
layer {
  name: "inception_c3_1x1_4"
  type: "Convolution"
  bottom: "inception_c2_concat"
  top: "inception_c3_1x1_4"
  convolution_param {
    bias_term: false
    num_output: 384
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c3_1x1_4_bn"
  type: "BatchNorm"
  bottom: "inception_c3_1x1_4"
  top: "inception_c3_1x1_4"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_1x1_4_scale"
  type: "Scale"
  bottom: "inception_c3_1x1_4"
  top: "inception_c3_1x1_4"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_1x1_4_relu"
  type: "ReLU"
  bottom: "inception_c3_1x1_4"
  top: "inception_c3_1x1_4"
}
layer {
  name: "inception_c3_3x1_2"
  type: "Convolution"
  bottom: "inception_c3_1x1_4"
  top: "inception_c3_3x1_2"
  convolution_param {
    bias_term: false
    num_output: 448
    stride: 1
    pad_h: 1
    pad_w: 0
    kernel_h: 3
    kernel_w: 1
  }
}
layer {
  name: "inception_c3_3x1_2_bn"
  type: "BatchNorm"
  bottom: "inception_c3_3x1_2"
  top: "inception_c3_3x1_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_3x1_2_scale"
  type: "Scale"
  bottom: "inception_c3_3x1_2"
  top: "inception_c3_3x1_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_3x1_2_relu"
  type: "ReLU"
  bottom: "inception_c3_3x1_2"
  top: "inception_c3_3x1_2"
}
layer {
  name: "inception_c3_1x3_2"
  type: "Convolution"
  bottom: "inception_c3_3x1_2"
  top: "inception_c3_1x3_2"
  convolution_param {
    bias_term: false
    num_output: 512
    stride: 1
    pad_h: 0
    pad_w: 1
    kernel_h: 1
    kernel_w: 3
  }
}
layer {
  name: "inception_c3_1x3_2_bn"
  type: "BatchNorm"
  bottom: "inception_c3_1x3_2"
  top: "inception_c3_1x3_2"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_1x3_2_scale"
  type: "Scale"
  bottom: "inception_c3_1x3_2"
  top: "inception_c3_1x3_2"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_1x3_2_relu"
  type: "ReLU"
  bottom: "inception_c3_1x3_2"
  top: "inception_c3_1x3_2"
}
layer {
  name: "inception_c3_1x3_3"
  type: "Convolution"
  bottom: "inception_c3_1x3_2"
  top: "inception_c3_1x3_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 0
    pad_w: 1
    kernel_h: 1
    kernel_w: 3
  }
}
layer {
  name: "inception_c3_1x3_3_bn"
  type: "BatchNorm"
  bottom: "inception_c3_1x3_3"
  top: "inception_c3_1x3_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_1x3_3_scale"
  type: "Scale"
  bottom: "inception_c3_1x3_3"
  top: "inception_c3_1x3_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_1x3_3_relu"
  type: "ReLU"
  bottom: "inception_c3_1x3_3"
  top: "inception_c3_1x3_3"
}
layer {
  name: "inception_c3_3x1_3"
  type: "Convolution"
  bottom: "inception_c3_1x3_2"
  top: "inception_c3_3x1_3"
  convolution_param {
    bias_term: false
    num_output: 256
    stride: 1
    pad_h: 1
    pad_w: 0
    kernel_h: 3
    kernel_w: 1
  }
}
layer {
  name: "inception_c3_3x1_3_bn"
  type: "BatchNorm"
  bottom: "inception_c3_3x1_3"
  top: "inception_c3_3x1_3"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_3x1_3_scale"
  type: "Scale"
  bottom: "inception_c3_3x1_3"
  top: "inception_c3_3x1_3"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_3x1_3_relu"
  type: "ReLU"
  bottom: "inception_c3_3x1_3"
  top: "inception_c3_3x1_3"
}
layer {
  name: "inception_c3_pool_ave"
  type: "Pooling"
  bottom: "inception_c2_concat"
  top: "inception_c3_pool_ave"
  pooling_param {
    pool: AVE
    kernel_size: 3
    stride: 1
    pad: 1
  }
}
layer {
  name: "inception_c3_1x1"
  type: "Convolution"
  bottom: "inception_c3_pool_ave"
  top: "inception_c3_1x1"
  convolution_param {
    bias_term: false
    num_output: 256
    pad: 0
    kernel_size: 1
    stride: 1
  }
}
layer {
  name: "inception_c3_1x1_bn"
  type: "BatchNorm"
  bottom: "inception_c3_1x1"
  top: "inception_c3_1x1"
  batch_norm_param {
    use_global_stats: true
    eps: 0.001
  }
}
layer {
  name: "inception_c3_1x1_scale"
  type: "Scale"
  bottom: "inception_c3_1x1"
  top: "inception_c3_1x1"
  scale_param {
    bias_term: true
  }
}
layer {
  name: "inception_c3_1x1_relu"
  type: "ReLU"
  bottom: "inception_c3_1x1"
  top: "inception_c3_1x1"
}
layer {
  name: "inception_c3_concat"
  type: "Concat"
  bottom: "inception_c3_1x1_2"
  bottom: "inception_c3_1x3"
  bottom: "inception_c3_3x1"
  bottom: "inception_c3_1x3_3"
  bottom: "inception_c3_3x1_3"
  bottom: "inception_c3_1x1"
  top: "inception_c3_concat"
}
layer {
  name: "pool_8x8_s1"
  type: "Pooling"
  bottom: "inception_c3_concat"
  top: "pool_8x8_s1"
  pooling_param {
    pool: AVE
    global_pooling: true
  }
}
layer {
  name: "pool_8x8_s1_drop"
  type: "Dropout"
  bottom: "pool_8x8_s1"
  top: "pool_8x8_s1_drop"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "my-classifier"
  type: "InnerProduct"
  bottom: "pool_8x8_s1_drop"
  top: "my-classifier"
  param {
    lr_mult: 10
    decay_mult: 1
  }
  param {
    lr_mult: 20
    decay_mult: 0
  }
  inner_product_param {
    num_output: 3
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
      value: 0
    }
  }
}
