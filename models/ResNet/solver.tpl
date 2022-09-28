# reduce learning rate after 120 epochs (60000 iters) by factor 0f 10
# then another factor of 10 after 10 more epochs (5000 iters)
# The train/test net protocol buffer definition
# test_iter specifies how many forward passes the test should carry out.
# In the case of CIFAR10, we have test batch size 100 and 100 test iterations,
# covering the full 10,000 testing images.
# random_seed: 1
average_loss: 20
debug_info: false
test_iter: 100
# Carry out testing every 1000 training iterations.
test_interval: 5
# The base learning rate, momentum and the weight decay of the network.
# base_lr: 0.001
# momentum: 0.9
# weight_decay: 0.004

base_lr: 0.001
momentum: 0.99
momentum2: 0.999
weight_decay: 0.001
# The learning rate policy
#lr_policy: "step"
#stepsize: 1000
#lr_policy: "exp"
#gamma: 0.999
lr_policy: "poly"
power: 3


# # The learning rate policy
# lr_policy: "fixed"
# Display every 200 iterations
display: 1
# The maximum number of iterations
max_iter: 100
# snapshot intermediate results
snapshot: 10000
#snapshot_format: HDF5
# solver mode: CPU or GPU
solver_mode: GPU
type: "Adam"
