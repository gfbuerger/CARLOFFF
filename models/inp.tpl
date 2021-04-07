name: "PROTO_tpl.PDD_tpl_Deploy"
layer {
    name: "data"
    type: "Input"
    top: "data"
    input_param { shape: { dim: 1 dim: CHANNEL_tpl dim: WIDTH_tpl dim: HEIGHT_tpl } }
}
