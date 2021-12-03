# https://github.com/zhanglaplace/caffe-cifar10/tree/master/DenseNet

layer {
  name: "Convolution1"
  type: "Convolution"
  bottom: "data"
  top: "Convolution1"
  convolution_param {
    num_output: 16
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "BatchNorm1"
  type: "BatchNorm"
  bottom: "Convolution1"
  top: "BatchNorm1"
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
  name: "Scale1"
  type: "Scale"
  bottom: "BatchNorm1"
  top: "BatchNorm1"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU1"
  type: "ReLU"
  bottom: "BatchNorm1"
  top: "BatchNorm1"
}
layer {
  name: "Convolution2"
  type: "Convolution"
  bottom: "BatchNorm1"
  top: "Convolution2"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout1"
  type: "Dropout"
  bottom: "Convolution2"
  top: "Dropout1"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat1"
  type: "Concat"
  bottom: "Convolution1"
  bottom: "Dropout1"
  top: "Concat1"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm2"
  type: "BatchNorm"
  bottom: "Concat1"
  top: "BatchNorm2"
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
  name: "Scale2"
  type: "Scale"
  bottom: "BatchNorm2"
  top: "BatchNorm2"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU2"
  type: "ReLU"
  bottom: "BatchNorm2"
  top: "BatchNorm2"
}
layer {
  name: "Convolution3"
  type: "Convolution"
  bottom: "BatchNorm2"
  top: "Convolution3"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout2"
  type: "Dropout"
  bottom: "Convolution3"
  top: "Dropout2"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat2"
  type: "Concat"
  bottom: "Concat1"
  bottom: "Dropout2"
  top: "Concat2"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm3"
  type: "BatchNorm"
  bottom: "Concat2"
  top: "BatchNorm3"
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
  name: "Scale3"
  type: "Scale"
  bottom: "BatchNorm3"
  top: "BatchNorm3"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU3"
  type: "ReLU"
  bottom: "BatchNorm3"
  top: "BatchNorm3"
}
layer {
  name: "Convolution4"
  type: "Convolution"
  bottom: "BatchNorm3"
  top: "Convolution4"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout3"
  type: "Dropout"
  bottom: "Convolution4"
  top: "Dropout3"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat3"
  type: "Concat"
  bottom: "Concat2"
  bottom: "Dropout3"
  top: "Concat3"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm4"
  type: "BatchNorm"
  bottom: "Concat3"
  top: "BatchNorm4"
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
  name: "Scale4"
  type: "Scale"
  bottom: "BatchNorm4"
  top: "BatchNorm4"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU4"
  type: "ReLU"
  bottom: "BatchNorm4"
  top: "BatchNorm4"
}
layer {
  name: "Convolution5"
  type: "Convolution"
  bottom: "BatchNorm4"
  top: "Convolution5"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout4"
  type: "Dropout"
  bottom: "Convolution5"
  top: "Dropout4"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat4"
  type: "Concat"
  bottom: "Concat3"
  bottom: "Dropout4"
  top: "Concat4"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm5"
  type: "BatchNorm"
  bottom: "Concat4"
  top: "BatchNorm5"
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
  name: "Scale5"
  type: "Scale"
  bottom: "BatchNorm5"
  top: "BatchNorm5"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU5"
  type: "ReLU"
  bottom: "BatchNorm5"
  top: "BatchNorm5"
}
layer {
  name: "Convolution6"
  type: "Convolution"
  bottom: "BatchNorm5"
  top: "Convolution6"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout5"
  type: "Dropout"
  bottom: "Convolution6"
  top: "Dropout5"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat5"
  type: "Concat"
  bottom: "Concat4"
  bottom: "Dropout5"
  top: "Concat5"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm6"
  type: "BatchNorm"
  bottom: "Concat5"
  top: "BatchNorm6"
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
  name: "Scale6"
  type: "Scale"
  bottom: "BatchNorm6"
  top: "BatchNorm6"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU6"
  type: "ReLU"
  bottom: "BatchNorm6"
  top: "BatchNorm6"
}
layer {
  name: "Convolution7"
  type: "Convolution"
  bottom: "BatchNorm6"
  top: "Convolution7"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout6"
  type: "Dropout"
  bottom: "Convolution7"
  top: "Dropout6"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat6"
  type: "Concat"
  bottom: "Concat5"
  bottom: "Dropout6"
  top: "Concat6"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm7"
  type: "BatchNorm"
  bottom: "Concat6"
  top: "BatchNorm7"
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
  name: "Scale7"
  type: "Scale"
  bottom: "BatchNorm7"
  top: "BatchNorm7"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU7"
  type: "ReLU"
  bottom: "BatchNorm7"
  top: "BatchNorm7"
}
layer {
  name: "Convolution8"
  type: "Convolution"
  bottom: "BatchNorm7"
  top: "Convolution8"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout7"
  type: "Dropout"
  bottom: "Convolution8"
  top: "Dropout7"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat7"
  type: "Concat"
  bottom: "Concat6"
  bottom: "Dropout7"
  top: "Concat7"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm8"
  type: "BatchNorm"
  bottom: "Concat7"
  top: "BatchNorm8"
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
  name: "Scale8"
  type: "Scale"
  bottom: "BatchNorm8"
  top: "BatchNorm8"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU8"
  type: "ReLU"
  bottom: "BatchNorm8"
  top: "BatchNorm8"
}
layer {
  name: "Convolution9"
  type: "Convolution"
  bottom: "BatchNorm8"
  top: "Convolution9"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout8"
  type: "Dropout"
  bottom: "Convolution9"
  top: "Dropout8"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat8"
  type: "Concat"
  bottom: "Concat7"
  bottom: "Dropout8"
  top: "Concat8"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm9"
  type: "BatchNorm"
  bottom: "Concat8"
  top: "BatchNorm9"
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
  name: "Scale9"
  type: "Scale"
  bottom: "BatchNorm9"
  top: "BatchNorm9"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU9"
  type: "ReLU"
  bottom: "BatchNorm9"
  top: "BatchNorm9"
}
layer {
  name: "Convolution10"
  type: "Convolution"
  bottom: "BatchNorm9"
  top: "Convolution10"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout9"
  type: "Dropout"
  bottom: "Convolution10"
  top: "Dropout9"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat9"
  type: "Concat"
  bottom: "Concat8"
  bottom: "Dropout9"
  top: "Concat9"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm10"
  type: "BatchNorm"
  bottom: "Concat9"
  top: "BatchNorm10"
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
  name: "Scale10"
  type: "Scale"
  bottom: "BatchNorm10"
  top: "BatchNorm10"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU10"
  type: "ReLU"
  bottom: "BatchNorm10"
  top: "BatchNorm10"
}
layer {
  name: "Convolution11"
  type: "Convolution"
  bottom: "BatchNorm10"
  top: "Convolution11"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout10"
  type: "Dropout"
  bottom: "Convolution11"
  top: "Dropout10"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat10"
  type: "Concat"
  bottom: "Concat9"
  bottom: "Dropout10"
  top: "Concat10"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm11"
  type: "BatchNorm"
  bottom: "Concat10"
  top: "BatchNorm11"
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
  name: "Scale11"
  type: "Scale"
  bottom: "BatchNorm11"
  top: "BatchNorm11"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU11"
  type: "ReLU"
  bottom: "BatchNorm11"
  top: "BatchNorm11"
}
layer {
  name: "Convolution12"
  type: "Convolution"
  bottom: "BatchNorm11"
  top: "Convolution12"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout11"
  type: "Dropout"
  bottom: "Convolution12"
  top: "Dropout11"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat11"
  type: "Concat"
  bottom: "Concat10"
  bottom: "Dropout11"
  top: "Concat11"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm12"
  type: "BatchNorm"
  bottom: "Concat11"
  top: "BatchNorm12"
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
  name: "Scale12"
  type: "Scale"
  bottom: "BatchNorm12"
  top: "BatchNorm12"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU12"
  type: "ReLU"
  bottom: "BatchNorm12"
  top: "BatchNorm12"
}
layer {
  name: "Convolution13"
  type: "Convolution"
  bottom: "BatchNorm12"
  top: "Convolution13"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout12"
  type: "Dropout"
  bottom: "Convolution13"
  top: "Dropout12"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat12"
  type: "Concat"
  bottom: "Concat11"
  bottom: "Dropout12"
  top: "Concat12"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm13"
  type: "BatchNorm"
  bottom: "Concat12"
  top: "BatchNorm13"
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
  name: "Scale13"
  type: "Scale"
  bottom: "BatchNorm13"
  top: "BatchNorm13"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU13"
  type: "ReLU"
  bottom: "BatchNorm13"
  top: "BatchNorm13"
}
layer {
  name: "Convolution14"
  type: "Convolution"
  bottom: "BatchNorm13"
  top: "Convolution14"
  convolution_param {
    num_output: 160
    bias_term: false
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout13"
  type: "Dropout"
  bottom: "Convolution14"
  top: "Dropout13"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Pooling1"
  type: "Pooling"
  bottom: "Dropout13"
  top: "Pooling1"
  pooling_param {
    pool: AVE
    kernel_size: 2
    stride: 2
  }
}
layer {
  name: "BatchNorm14"
  type: "BatchNorm"
  bottom: "Pooling1"
  top: "BatchNorm14"
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
  name: "Scale14"
  type: "Scale"
  bottom: "BatchNorm14"
  top: "BatchNorm14"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU14"
  type: "ReLU"
  bottom: "BatchNorm14"
  top: "BatchNorm14"
}
layer {
  name: "Convolution15"
  type: "Convolution"
  bottom: "BatchNorm14"
  top: "Convolution15"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout14"
  type: "Dropout"
  bottom: "Convolution15"
  top: "Dropout14"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat13"
  type: "Concat"
  bottom: "Pooling1"
  bottom: "Dropout14"
  top: "Concat13"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm15"
  type: "BatchNorm"
  bottom: "Concat13"
  top: "BatchNorm15"
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
  name: "Scale15"
  type: "Scale"
  bottom: "BatchNorm15"
  top: "BatchNorm15"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU15"
  type: "ReLU"
  bottom: "BatchNorm15"
  top: "BatchNorm15"
}
layer {
  name: "Convolution16"
  type: "Convolution"
  bottom: "BatchNorm15"
  top: "Convolution16"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout15"
  type: "Dropout"
  bottom: "Convolution16"
  top: "Dropout15"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat14"
  type: "Concat"
  bottom: "Concat13"
  bottom: "Dropout15"
  top: "Concat14"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm16"
  type: "BatchNorm"
  bottom: "Concat14"
  top: "BatchNorm16"
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
  name: "Scale16"
  type: "Scale"
  bottom: "BatchNorm16"
  top: "BatchNorm16"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU16"
  type: "ReLU"
  bottom: "BatchNorm16"
  top: "BatchNorm16"
}
layer {
  name: "Convolution17"
  type: "Convolution"
  bottom: "BatchNorm16"
  top: "Convolution17"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout16"
  type: "Dropout"
  bottom: "Convolution17"
  top: "Dropout16"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat15"
  type: "Concat"
  bottom: "Concat14"
  bottom: "Dropout16"
  top: "Concat15"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm17"
  type: "BatchNorm"
  bottom: "Concat15"
  top: "BatchNorm17"
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
  name: "Scale17"
  type: "Scale"
  bottom: "BatchNorm17"
  top: "BatchNorm17"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU17"
  type: "ReLU"
  bottom: "BatchNorm17"
  top: "BatchNorm17"
}
layer {
  name: "Convolution18"
  type: "Convolution"
  bottom: "BatchNorm17"
  top: "Convolution18"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout17"
  type: "Dropout"
  bottom: "Convolution18"
  top: "Dropout17"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat16"
  type: "Concat"
  bottom: "Concat15"
  bottom: "Dropout17"
  top: "Concat16"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm18"
  type: "BatchNorm"
  bottom: "Concat16"
  top: "BatchNorm18"
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
  name: "Scale18"
  type: "Scale"
  bottom: "BatchNorm18"
  top: "BatchNorm18"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU18"
  type: "ReLU"
  bottom: "BatchNorm18"
  top: "BatchNorm18"
}
layer {
  name: "Convolution19"
  type: "Convolution"
  bottom: "BatchNorm18"
  top: "Convolution19"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout18"
  type: "Dropout"
  bottom: "Convolution19"
  top: "Dropout18"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat17"
  type: "Concat"
  bottom: "Concat16"
  bottom: "Dropout18"
  top: "Concat17"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm19"
  type: "BatchNorm"
  bottom: "Concat17"
  top: "BatchNorm19"
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
  name: "Scale19"
  type: "Scale"
  bottom: "BatchNorm19"
  top: "BatchNorm19"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU19"
  type: "ReLU"
  bottom: "BatchNorm19"
  top: "BatchNorm19"
}
layer {
  name: "Convolution20"
  type: "Convolution"
  bottom: "BatchNorm19"
  top: "Convolution20"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout19"
  type: "Dropout"
  bottom: "Convolution20"
  top: "Dropout19"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat18"
  type: "Concat"
  bottom: "Concat17"
  bottom: "Dropout19"
  top: "Concat18"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm20"
  type: "BatchNorm"
  bottom: "Concat18"
  top: "BatchNorm20"
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
  name: "Scale20"
  type: "Scale"
  bottom: "BatchNorm20"
  top: "BatchNorm20"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU20"
  type: "ReLU"
  bottom: "BatchNorm20"
  top: "BatchNorm20"
}
layer {
  name: "Convolution21"
  type: "Convolution"
  bottom: "BatchNorm20"
  top: "Convolution21"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout20"
  type: "Dropout"
  bottom: "Convolution21"
  top: "Dropout20"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat19"
  type: "Concat"
  bottom: "Concat18"
  bottom: "Dropout20"
  top: "Concat19"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm21"
  type: "BatchNorm"
  bottom: "Concat19"
  top: "BatchNorm21"
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
  name: "Scale21"
  type: "Scale"
  bottom: "BatchNorm21"
  top: "BatchNorm21"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU21"
  type: "ReLU"
  bottom: "BatchNorm21"
  top: "BatchNorm21"
}
layer {
  name: "Convolution22"
  type: "Convolution"
  bottom: "BatchNorm21"
  top: "Convolution22"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout21"
  type: "Dropout"
  bottom: "Convolution22"
  top: "Dropout21"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat20"
  type: "Concat"
  bottom: "Concat19"
  bottom: "Dropout21"
  top: "Concat20"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm22"
  type: "BatchNorm"
  bottom: "Concat20"
  top: "BatchNorm22"
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
  name: "Scale22"
  type: "Scale"
  bottom: "BatchNorm22"
  top: "BatchNorm22"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU22"
  type: "ReLU"
  bottom: "BatchNorm22"
  top: "BatchNorm22"
}
layer {
  name: "Convolution23"
  type: "Convolution"
  bottom: "BatchNorm22"
  top: "Convolution23"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout22"
  type: "Dropout"
  bottom: "Convolution23"
  top: "Dropout22"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat21"
  type: "Concat"
  bottom: "Concat20"
  bottom: "Dropout22"
  top: "Concat21"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm23"
  type: "BatchNorm"
  bottom: "Concat21"
  top: "BatchNorm23"
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
  name: "Scale23"
  type: "Scale"
  bottom: "BatchNorm23"
  top: "BatchNorm23"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU23"
  type: "ReLU"
  bottom: "BatchNorm23"
  top: "BatchNorm23"
}
layer {
  name: "Convolution24"
  type: "Convolution"
  bottom: "BatchNorm23"
  top: "Convolution24"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout23"
  type: "Dropout"
  bottom: "Convolution24"
  top: "Dropout23"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat22"
  type: "Concat"
  bottom: "Concat21"
  bottom: "Dropout23"
  top: "Concat22"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm24"
  type: "BatchNorm"
  bottom: "Concat22"
  top: "BatchNorm24"
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
  name: "Scale24"
  type: "Scale"
  bottom: "BatchNorm24"
  top: "BatchNorm24"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU24"
  type: "ReLU"
  bottom: "BatchNorm24"
  top: "BatchNorm24"
}
layer {
  name: "Convolution25"
  type: "Convolution"
  bottom: "BatchNorm24"
  top: "Convolution25"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout24"
  type: "Dropout"
  bottom: "Convolution25"
  top: "Dropout24"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat23"
  type: "Concat"
  bottom: "Concat22"
  bottom: "Dropout24"
  top: "Concat23"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm25"
  type: "BatchNorm"
  bottom: "Concat23"
  top: "BatchNorm25"
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
  name: "Scale25"
  type: "Scale"
  bottom: "BatchNorm25"
  top: "BatchNorm25"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU25"
  type: "ReLU"
  bottom: "BatchNorm25"
  top: "BatchNorm25"
}
layer {
  name: "Convolution26"
  type: "Convolution"
  bottom: "BatchNorm25"
  top: "Convolution26"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout25"
  type: "Dropout"
  bottom: "Convolution26"
  top: "Dropout25"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat24"
  type: "Concat"
  bottom: "Concat23"
  bottom: "Dropout25"
  top: "Concat24"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm26"
  type: "BatchNorm"
  bottom: "Concat24"
  top: "BatchNorm26"
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
  name: "Scale26"
  type: "Scale"
  bottom: "BatchNorm26"
  top: "BatchNorm26"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU26"
  type: "ReLU"
  bottom: "BatchNorm26"
  top: "BatchNorm26"
}
layer {
  name: "Convolution27"
  type: "Convolution"
  bottom: "BatchNorm26"
  top: "Convolution27"
  convolution_param {
    num_output: 304
    bias_term: false
    pad: 0
    kernel_size: 1
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout26"
  type: "Dropout"
  bottom: "Convolution27"
  top: "Dropout26"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Pooling2"
  type: "Pooling"
  bottom: "Dropout26"
  top: "Pooling2"
  pooling_param {
    pool: AVE
    kernel_size: 2
    stride: 2
  }
}
layer {
  name: "BatchNorm27"
  type: "BatchNorm"
  bottom: "Pooling2"
  top: "BatchNorm27"
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
  name: "Scale27"
  type: "Scale"
  bottom: "BatchNorm27"
  top: "BatchNorm27"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU27"
  type: "ReLU"
  bottom: "BatchNorm27"
  top: "BatchNorm27"
}
layer {
  name: "Convolution28"
  type: "Convolution"
  bottom: "BatchNorm27"
  top: "Convolution28"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout27"
  type: "Dropout"
  bottom: "Convolution28"
  top: "Dropout27"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat25"
  type: "Concat"
  bottom: "Pooling2"
  bottom: "Dropout27"
  top: "Concat25"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm28"
  type: "BatchNorm"
  bottom: "Concat25"
  top: "BatchNorm28"
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
  name: "Scale28"
  type: "Scale"
  bottom: "BatchNorm28"
  top: "BatchNorm28"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU28"
  type: "ReLU"
  bottom: "BatchNorm28"
  top: "BatchNorm28"
}
layer {
  name: "Convolution29"
  type: "Convolution"
  bottom: "BatchNorm28"
  top: "Convolution29"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout28"
  type: "Dropout"
  bottom: "Convolution29"
  top: "Dropout28"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat26"
  type: "Concat"
  bottom: "Concat25"
  bottom: "Dropout28"
  top: "Concat26"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm29"
  type: "BatchNorm"
  bottom: "Concat26"
  top: "BatchNorm29"
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
  name: "Scale29"
  type: "Scale"
  bottom: "BatchNorm29"
  top: "BatchNorm29"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU29"
  type: "ReLU"
  bottom: "BatchNorm29"
  top: "BatchNorm29"
}
layer {
  name: "Convolution30"
  type: "Convolution"
  bottom: "BatchNorm29"
  top: "Convolution30"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout29"
  type: "Dropout"
  bottom: "Convolution30"
  top: "Dropout29"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat27"
  type: "Concat"
  bottom: "Concat26"
  bottom: "Dropout29"
  top: "Concat27"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm30"
  type: "BatchNorm"
  bottom: "Concat27"
  top: "BatchNorm30"
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
  name: "Scale30"
  type: "Scale"
  bottom: "BatchNorm30"
  top: "BatchNorm30"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU30"
  type: "ReLU"
  bottom: "BatchNorm30"
  top: "BatchNorm30"
}
layer {
  name: "Convolution31"
  type: "Convolution"
  bottom: "BatchNorm30"
  top: "Convolution31"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout30"
  type: "Dropout"
  bottom: "Convolution31"
  top: "Dropout30"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat28"
  type: "Concat"
  bottom: "Concat27"
  bottom: "Dropout30"
  top: "Concat28"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm31"
  type: "BatchNorm"
  bottom: "Concat28"
  top: "BatchNorm31"
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
  name: "Scale31"
  type: "Scale"
  bottom: "BatchNorm31"
  top: "BatchNorm31"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU31"
  type: "ReLU"
  bottom: "BatchNorm31"
  top: "BatchNorm31"
}
layer {
  name: "Convolution32"
  type: "Convolution"
  bottom: "BatchNorm31"
  top: "Convolution32"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout31"
  type: "Dropout"
  bottom: "Convolution32"
  top: "Dropout31"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat29"
  type: "Concat"
  bottom: "Concat28"
  bottom: "Dropout31"
  top: "Concat29"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm32"
  type: "BatchNorm"
  bottom: "Concat29"
  top: "BatchNorm32"
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
  name: "Scale32"
  type: "Scale"
  bottom: "BatchNorm32"
  top: "BatchNorm32"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU32"
  type: "ReLU"
  bottom: "BatchNorm32"
  top: "BatchNorm32"
}
layer {
  name: "Convolution33"
  type: "Convolution"
  bottom: "BatchNorm32"
  top: "Convolution33"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout32"
  type: "Dropout"
  bottom: "Convolution33"
  top: "Dropout32"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat30"
  type: "Concat"
  bottom: "Concat29"
  bottom: "Dropout32"
  top: "Concat30"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm33"
  type: "BatchNorm"
  bottom: "Concat30"
  top: "BatchNorm33"
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
  name: "Scale33"
  type: "Scale"
  bottom: "BatchNorm33"
  top: "BatchNorm33"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU33"
  type: "ReLU"
  bottom: "BatchNorm33"
  top: "BatchNorm33"
}
layer {
  name: "Convolution34"
  type: "Convolution"
  bottom: "BatchNorm33"
  top: "Convolution34"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout33"
  type: "Dropout"
  bottom: "Convolution34"
  top: "Dropout33"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat31"
  type: "Concat"
  bottom: "Concat30"
  bottom: "Dropout33"
  top: "Concat31"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm34"
  type: "BatchNorm"
  bottom: "Concat31"
  top: "BatchNorm34"
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
  name: "Scale34"
  type: "Scale"
  bottom: "BatchNorm34"
  top: "BatchNorm34"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU34"
  type: "ReLU"
  bottom: "BatchNorm34"
  top: "BatchNorm34"
}
layer {
  name: "Convolution35"
  type: "Convolution"
  bottom: "BatchNorm34"
  top: "Convolution35"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout34"
  type: "Dropout"
  bottom: "Convolution35"
  top: "Dropout34"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat32"
  type: "Concat"
  bottom: "Concat31"
  bottom: "Dropout34"
  top: "Concat32"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm35"
  type: "BatchNorm"
  bottom: "Concat32"
  top: "BatchNorm35"
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
  name: "Scale35"
  type: "Scale"
  bottom: "BatchNorm35"
  top: "BatchNorm35"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU35"
  type: "ReLU"
  bottom: "BatchNorm35"
  top: "BatchNorm35"
}
layer {
  name: "Convolution36"
  type: "Convolution"
  bottom: "BatchNorm35"
  top: "Convolution36"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout35"
  type: "Dropout"
  bottom: "Convolution36"
  top: "Dropout35"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat33"
  type: "Concat"
  bottom: "Concat32"
  bottom: "Dropout35"
  top: "Concat33"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm36"
  type: "BatchNorm"
  bottom: "Concat33"
  top: "BatchNorm36"
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
  name: "Scale36"
  type: "Scale"
  bottom: "BatchNorm36"
  top: "BatchNorm36"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU36"
  type: "ReLU"
  bottom: "BatchNorm36"
  top: "BatchNorm36"
}
layer {
  name: "Convolution37"
  type: "Convolution"
  bottom: "BatchNorm36"
  top: "Convolution37"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout36"
  type: "Dropout"
  bottom: "Convolution37"
  top: "Dropout36"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat34"
  type: "Concat"
  bottom: "Concat33"
  bottom: "Dropout36"
  top: "Concat34"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm37"
  type: "BatchNorm"
  bottom: "Concat34"
  top: "BatchNorm37"
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
  name: "Scale37"
  type: "Scale"
  bottom: "BatchNorm37"
  top: "BatchNorm37"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU37"
  type: "ReLU"
  bottom: "BatchNorm37"
  top: "BatchNorm37"
}
layer {
  name: "Convolution38"
  type: "Convolution"
  bottom: "BatchNorm37"
  top: "Convolution38"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout37"
  type: "Dropout"
  bottom: "Convolution38"
  top: "Dropout37"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat35"
  type: "Concat"
  bottom: "Concat34"
  bottom: "Dropout37"
  top: "Concat35"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm38"
  type: "BatchNorm"
  bottom: "Concat35"
  top: "BatchNorm38"
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
  name: "Scale38"
  type: "Scale"
  bottom: "BatchNorm38"
  top: "BatchNorm38"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU38"
  type: "ReLU"
  bottom: "BatchNorm38"
  top: "BatchNorm38"
}
layer {
  name: "Convolution39"
  type: "Convolution"
  bottom: "BatchNorm38"
  top: "Convolution39"
  convolution_param {
    num_output: 12
    bias_term: false
    pad: 1
    kernel_size: 3
    stride: 1
    weight_filler {
      type: "msra"
    }
    bias_filler {
      type: "constant"
    }
  }
}
layer {
  name: "Dropout38"
  type: "Dropout"
  bottom: "Convolution39"
  top: "Dropout38"
  dropout_param {
    dropout_ratio: 0.2
  }
}
layer {
  name: "Concat36"
  type: "Concat"
  bottom: "Concat35"
  bottom: "Dropout38"
  top: "Concat36"
  concat_param {
    axis: 1
  }
}
layer {
  name: "BatchNorm39"
  type: "BatchNorm"
  bottom: "Concat36"
  top: "BatchNorm39"
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
  name: "Scale39"
  type: "Scale"
  bottom: "BatchNorm39"
  top: "BatchNorm39"
  scale_param {
    filler {
      value: 1
    }
    bias_term: true
    bias_filler {
      value: 0
    }
  }
}
layer {
  name: "ReLU39"
  type: "ReLU"
  bottom: "BatchNorm39"
  top: "BatchNorm39"
}
layer {
  name: "Pooling3"
  type: "Pooling"
  bottom: "BatchNorm39"
  top: "Pooling3"
  pooling_param {
    pool: AVE
    global_pooling: true
  }
}
layer {
  name: "InnerProduct1"
  type: "InnerProduct"
  bottom: "Pooling3"
  top: "out"
  inner_product_param {
    num_output: 2
    bias_term: true
    weight_filler {
      type: "xavier"
    }
    bias_filler {
      type: "constant"
    }
  }
}
