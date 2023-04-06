# random_seed: 1
average_loss: 20
debug_info: false
test_iter: 10
# Carry out testing every 1000 training iterations.
test_interval: 20
# The base learning rate, momentum and the weight decay of the network.
base_lr: 0.0017
momentum: 0.99
momentum2: 0.999
weight_decay: 0.001
# The learning rate policy
lr_policy: "poly"
power: 0.5
# Display every 200 iterations
display: 5
# The maximum number of iterations
max_iter: 1000
# solver mode: CPU or GPU
solver_mode: GPU
type: "Adam"
