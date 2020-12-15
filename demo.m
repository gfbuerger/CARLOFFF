
global isoctave
isoctave = @() exist('OCTAVE_VERSION','builtin') ~= 0 ;
if isoctave()
    w = OCTAVE_VERSION() ;
    if w(1) == '5', pkg load netcdf hdf5oct ; end
    addpath /opt/caffe/matlab
    addpath /opt/caffe/matlab/+caffe/private
else
    addpath /opt/caffeML/matlab
end

addpath ~/xds/fun ~/CARLOFFF/fun
droot = '/opt/tmp/caffe' ;
[~, ~] = mkdir(droot, 'data/CARLOFFF')
cd ~/CARLOFFF
scale = 0.00390625 ; % MNIST

##Caffe's Matlab interface can be used after successful compilation and configuration. The specific usage tutorial is as follows:

##Examples below shows detailed usages：

model = 'deploy.prototxt';
weights = 'data/snapshots/lenet_solver_iter_1000.caffemodel' ;

##Set mode and device

##Mode and device should always be set BEFORE you create a net or a solver.

##Use CPU:

caffe.set_mode_cpu();

####Use GPU and specify its gpu_id:

##caffe.set_mode_gpu();
caffe.set_device(0);

##Create a network and access its layers and blobs

##Create a network:

net = caffe.Net(model, weights, 'test'); % create net and load weights

##Or

net = caffe.Net(model, 'test'); % create net but not load weights
net.copy_from(weights); % load weights

##which creates net object as

##      Net with properties:

##               layer_vec: [1x23 caffe.Layer]
##                blob_vec: [1x15 caffe.Blob]
##                  inputs: {'data'}
##                 outputs: {'prob'}
##        name2layer_index: [23x1 containers.Map]
##         name2blob_index: [15x1 containers.Map]
##             layer_names: {23x1 cell}
##              blob_names: {15x1 cell}

##The two containers.Map objects are useful to find the index of a layer or a blob by its name.

##You have access to every blob in this network. To fill blob ‘data’ with all ones:

net.blobs('data').set_data(ones(net.blobs('data').shape));

##To multiply all values in blob ‘data’ by 10:

net.blobs('data').set_data(net.blobs('data').get_data() * 10);

##Be aware that since Matlab is 1-indexed and column-major, the usual 4 blob dimensions in Matlab are [width, height, channels, num], and width is the fastest dimension. Also be aware that images are in BGR channels. Also, Caffe uses single-precision float data. If your data is not single, set_data will automatically convert it to single.

##You also have access to every layer, so you can do network surgery. For example, to multiply conv1 parameters by 10:

net.params('conv1', 1).set_data(net.params('conv1', 1).get_data() * 10); % set weights
net.params('conv1', 2).set_data(net.params('conv1', 2).get_data() * 10); % set bias

##Alternatively, you can use

net.layers('conv1').params(1).set_data(net.layers('conv1').params(1).get_data() * 10);
net.layers('conv1').params(2).set_data(net.layers('conv1').params(2).get_data() * 10);

##To save the network you just modified:

net.save('my_net.caffemodel');

##To get a layer’s type (string):

layer_type = net.layers('conv1').type;

##Forward and backward

##Forward pass can be done using net.forward or net.forward_prefilled. Function net.forward takes in a cell array of N-D arrays containing data of input blob(s) and outputs a cell array containing data from output blob(s). Function net.forward_prefilled uses existing data in input blob(s) during forward pass, takes no input and produces no output. After creating some data for input blobs like data = rand(net.blobs('data').shape); you can run

res = net.forward({data});
prob = res{1};

##Or

net.blobs('data').set_data(data);
net.forward_prefilled();
prob = net.blobs('prob').get_data();

##Backward is similar using net.backward or net.backward_prefilled and replacing get_data and set_data with get_diff and set_diff. After creating some gradients for output blobs like prob_diff = rand(net.blobs('prob').shape); you can run

res = net.backward({prob_diff});
data_diff = res{1};

##Or

net.blobs('prob').set_diff(prob_diff);
net.backward_prefilled();
data_diff = net.blobs('data').get_diff();

##However, the backward computation above doesn’t get correct results, because Caffe decides that the network does not need backward computation. To get correct backward results, you need to set 'force_backward: true' in your network prototxt.

##After performing forward or backward pass, you can also get the data or diff in internal blobs. For example, to extract pool5 features after forward pass:

pool5_feat = net.blobs('pool5').get_data();

##Reshape

##Assume you want to run 1 image at a time instead of 10:

net.blobs('data').reshape([227 227 3 1]); % reshape blob 'data'
net.reshape();

##Then the whole network is reshaped, and now net.blobs('prob').shape should be [1000 1];
##Training

##Assume you have created training and validation lmdbs following our ImageNET Tutorial, to create a solver and train on ILSVRC 2012 classification dataset:

solver = caffe.Solver('./models/bvlc_reference_caffenet/solver.prototxt');

##which creates solver object as

##      Solver with properties:

##              net: [1x1 caffe.Net]
##        test_nets: [1x1 caffe.Net]

##To train:

solver.solve();

##Or train for only 1000 iterations (so that you can do something to its net before training more iterations)

solver.step(1000);

##To get iteration number:

##iter = solver.iter();

##To get its network:

train_net = solver.net;
test_net = solver.test_nets(1);

##To resume from a snapshot “your_snapshot.solverstate”:

solver.restore('your_snapshot.solverstate');

##Input and output

##caffe.io class provides basic input functions load_image and read_mean. For example, to read ILSVRC 2012 mean file (assume you have downloaded imagenet example auxiliary files by running ./data/ilsvrc12/get_ilsvrc_aux.sh):

##mean_data = caffe.io.read_mean('./data/ilsvrc12/imagenet_mean.binaryproto');

##To read Caffe’s example image and resize to [width, height] and suppose we want width = 256; height = 256;

im_data = caffe.io.load_image('./examples/images/cat.jpg');
im_data = imresize(im_data, [width, height]); % resize using Matlab's imresize

##Keep in mind that width is the fastest dimension and channels are BGR, which is different from the usual way that Matlab stores an image. If you don’t want to use caffe.io.load_image and prefer to load an image by yourself, you can do

im_data = imread('./examples/images/cat.jpg'); % read image
im_data = im_data(:, :, [3, 2, 1]); % convert from RGB to BGR
im_data = permute(im_data, [2, 1, 3]); % permute width and height
im_data = single(im_data); % convert to single precision

