layer {
  name: "conv_d0a-b"
  type: "Convolution"
  bottom: "data"
  top: "d0b"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
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
  name: "relu_d0b"
  type: "ReLU"
  bottom: "d0b"
  top: "d0b"
}
layer {
  name: "conv_d0b-c"
  type: "Convolution"
  bottom: "d0b"
  top: "d0c"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 64
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}



layer {
  name: "relu_d0c"
  type: "ReLU"
  bottom: "d0c"
  top: "d0c"
}
layer {
  name: "pool_d0c-1a"
  type: "Pooling"
  bottom: "d0c"
  top: "d1a"
  pooling_param {
    pool: MAX
    kernel_size: 2
    stride: 2
  }
}
layer {
  name: "conv_d1a-b"
  type: "Convolution"
  bottom: "d1a"
  top: "d1b"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}



layer {
  name: "relu_d1b"
  type: "ReLU"
  bottom: "d1b"
  top: "d1b"
}
layer {
  name: "conv_d1b-c"
  type: "Convolution"
  bottom: "d1b"
  top: "d1c"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}




layer {
  name: "relu_d1c"
  type: "ReLU"
  bottom: "d1c"
  top: "d1c"
}
layer {
  name: "pool_d1c-2a"
  type: "Pooling"
  bottom: "d1c"
  top: "d2a"
  pooling_param {
    pool: MAX
    kernel_size: 2
    stride: 2
  }
}
layer {
  name: "conv_d2a-b"
  type: "Convolution"
  bottom: "d2a"
  top: "d2b"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 256
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}





layer {
  name: "relu_d2b"
  type: "ReLU"
  bottom: "d2b"
  top: "d2b"
}
layer {
  name: "conv_d2b-c"
  type: "Convolution"
  bottom: "d2b"
  top: "d2c"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 256
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}




layer {
  name: "relu_d2c"
  type: "ReLU"
  bottom: "d2c"
  top: "d2c"
}
layer {
  name: "pool_d2c-3a"
  type: "Pooling"
  bottom: "d2c"
  top: "d3a"
  pooling_param {
    pool: MAX
    kernel_size: 2
    stride: 2
  }
}
layer {
  name: "conv_d3a-b"
  type: "Convolution"
  bottom: "d3a"
  top: "d3b"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 512
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}




layer {
  name: "relu_d3b"
  type: "ReLU"
  bottom: "d3b"
  top: "d3b"
}
layer {
  name: "conv_d3b-c"
  type: "Convolution"
  bottom: "d3b"
  top: "d3c"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 512
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}



layer {
  name: "relu_d3c"
  type: "ReLU"
  bottom: "d3c"
  top: "d3c"
}


  
  
layer {
  name: "pool_d3c-4a"
  type: "Pooling"
  bottom: "d3c"
  top: "d4a"
  pooling_param {
    pool: MAX
    kernel_size: 2
    stride: 2
  }
}
layer {
  name: "conv_d4a-b"
  type: "Convolution"
  bottom: "d4a"
  top: "d4b"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 1024
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}




layer {
  name: "relu_d4b"
  type: "ReLU"
  bottom: "d4b"
  top: "d4b"
}
layer {
  name: "conv_d4b-c"
  type: "Convolution"
  bottom: "d4b"
  top: "d4c"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 1024
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}




layer {
  name: "relu_d4c"
  type: "ReLU"
  bottom: "d4c"
  top: "d4c"
}

  
layer {
  name: "upconv_d4c_u3a"
  type: "Deconvolution"
  bottom: "d4c"
  top: "u3a"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 512
    pad: 0
    kernel_size: 2
    stride: 2
    weight_filler {
      type: "msra"
    }
  }
}




layer {
  name: "relu_u3a"
  type: "ReLU"
  bottom: "u3a"
  top: "u3a"
}
layer {
  name: "concat_d3cc_u3a-b"
  type: "Concat"
  bottom: "u3a"
  bottom: "d3c"
  top: "u3b"
}
layer {
  name: "conv_u3b-c"
  type: "Convolution"
  bottom: "u3b"
  top: "u3c"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 512
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u3c"
  type: "ReLU"
  bottom: "u3c"
  top: "u3c"
}
layer {
  name: "conv_u3c-d"
  type: "Convolution"
  bottom: "u3c"
  top: "u3d"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 512
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u3d"
  type: "ReLU"
  bottom: "u3d"
  top: "u3d"
}
layer {
  name: "upconv_u3d_u2a"
  type: "Deconvolution"
  bottom: "u3d"
  top: "u2a"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 256
    pad: 0
    kernel_size: 2
    stride: 2
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u2a"
  type: "ReLU"
  bottom: "u2a"
  top: "u2a"
}
layer {
  name: "concat_d2cc_u2a-b"
  type: "Concat"
  bottom: "u2a"
  bottom: "d2c"
  top: "u2b"
}
layer {
  name: "conv_u2b-c"
  type: "Convolution"
  bottom: "u2b"
  top: "u2c"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 256
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u2c"
  type: "ReLU"
  bottom: "u2c"
  top: "u2c"
}
layer {
  name: "conv_u2c-d"
  type: "Convolution"
  bottom: "u2c"
  top: "u2d"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 256
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u2d"
  type: "ReLU"
  bottom: "u2d"
  top: "u2d"
}
layer {
  name: "upconv_u2d_u1a"
  type: "Deconvolution"
  bottom: "u2d"
  top: "u1a"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 128
    pad: 0
    kernel_size: 2
    stride: 2
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u1a"
  type: "ReLU"
  bottom: "u1a"
  top: "u1a"
}
layer {
  name: "concat_d1cc_u1a-b"
  type: "Concat"
  bottom: "u1a"
  bottom: "d1c"
  top: "u1b"
}
layer {
  name: "conv_u1b-c"
  type: "Convolution"
  bottom: "u1b"
  top: "u1c"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u1c"
  type: "ReLU"
  bottom: "u1c"
  top: "u1c"
}
layer {
  name: "conv_u1c-d"
  type: "Convolution"
  bottom: "u1c"
  top: "u1d"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 128
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u1d"
  type: "ReLU"
  bottom: "u1d"
  top: "u1d"
}
layer {
  name: "upconv_u1d_u0a_NEW"
  type: "Deconvolution"
  bottom: "u1d"
  top: "u0a"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 64
    pad: 0
    kernel_size: 2
    stride: 2
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u0a"
  type: "ReLU"
  bottom: "u0a"
  top: "u0a"
}
layer {
  name: "concat_d0cc_u0a-b"
  type: "Concat"
  bottom: "u0a"
  bottom: "d0c"
  top: "u0b"
}
layer {
  name: "conv_u0b-c_New"
  type: "Convolution"
  bottom: "u0b"
  top: "u0c"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 64
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u0c"
  type: "ReLU"
  bottom: "u0c"
  top: "u0c"
}
layer {
  name: "conv_u0c-d_New"
  type: "Convolution"
  bottom: "u0c"
  top: "u0d"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 64
    pad: 1
    kernel_size: 3
    weight_filler {
      type: "msra"
    }
  }
}
layer {
  name: "relu_u0d"
  type: "ReLU"
  bottom: "u0d"
  top: "u0d"
}
layer {
  name: "conv_u0d-score_New"
  type: "Convolution"
  bottom: "u0d"
  top: "out"
  param {
    lr_mult: 1
    decay_mult: 1
  }
  param {
    lr_mult: 2
    decay_mult: 0
  }
  convolution_param {
    num_output: 8
    pad: 0
    kernel_size: 1
    weight_filler {
      type: "msra"
    }
   }
}
