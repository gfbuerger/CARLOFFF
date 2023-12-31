average_loss: 20
test_iter: 60
# Carry out testing every 1000 training iterations.
test_interval: 20
# The base learning rate, momentum and the weight decay of the network.
base_lr: 0.001
momentum: 0.99
momentum2: 0.999
weight_decay: 0.001
# The learning rate policy
lr_policy: "poly"
power: 3
# Display every 200 iterations
display: 5
# The maximum number of iterations
max_iter: 200
# solver mode: CPU or GPU
solver_mode: GPU
type: "Adam"
