# reduce learning rate after 120 epochs (60000 iters) by factor 0f 10
# then another factor of 10 after 10 more epochs (5000 iters)
# The train/test net protocol buffer definition
net: "models/PROTO_tpl/PDD_tpl.prototxt"
test_iter: 50
# Carry out testing every 200 training iterations.
test_interval: 200
# Optimizer, the base learning rate, momentum and the weight decay of the network.
type: "SGD"
momentum: 0.9
base_lr: 0.05
weight_decay: 0.001
# The learning rate policy
lr_policy: "multistep"
gamma: 0.1
# stepvalue: 200 epochs
stepvalue: 40000
# stepvalue: 250 epochs
stepvalue: 50000
# stepvalue: 300 epochs
stepvalue: 60000
# Display every 200 iterations
display: 200
# The maximum number of iterations
# max epochs: 350 ~ 70000 iterations with 256 examples per batch
max_iter: 70000
# snapshot intermediate results every 2000 iterations ~ 10 epochs
snapshot: 2000
snapshot_prefix: "models/PROTO_tpl/PDD_tpl"
# solver mode: CPU or GPU
solver_mode: GPU
# debug mode
debug_info: false
