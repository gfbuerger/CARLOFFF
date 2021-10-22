test_iter: 2000 #not subject to iter_size
test_interval: 1000
base_lr: 0.04
display: 40
max_iter: 170000
iter_size: 16 #global batch size = batch_size * iter_size
lr_policy: "poly"
power: 1.0 #linearly decrease LR
momentum: 0.9
weight_decay: 0.0002
snapshot: 1000
solver_mode: GPU
random_seed: 42
test_initialization: false
average_loss: 40
