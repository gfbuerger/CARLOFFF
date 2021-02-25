# The train/test net protocol buffer definition
net: "nets/PROTO_tpl.PDD_tpl.prototxt"
# test_iter specifies how many forward passes the test should carry out.
# In the case of MNIST, we have test batch size 100 and 100 test iterations,
# debug_info: true
# covering the full 10,000 testing images.
test_iter: 100
# Carry out testing every 500 training iterations.
test_interval: 500
# The base learning rate, momentum and the weight decay of the network.
base_lr: 0.001
gamma: 0.5
# The learning rate policy
lr_policy: "fixed"
momentum: 0.9
momentum2: 0.999
#weight_decay: 0.0005
power: 0.75
# Display every 100 iterations
display: 100
# The maximum number of iterations
max_iter: 10000
# snapshot intermediate results
snapshot: 5000
snapshot_prefix: "data/snapshots/PROTO_tpl.PDD_tpl"
type: "Adam"
# solver mode: CPU or GPU
solver_mode: GPU
