% load the dataset, this is built in to matlab
load fisheriris

% the data is ordered, we want to randomly select 100 points for train, 50
% for test. This part just generates a random list of array indices.
indices = randperm(150);
train_indices = indices(1:100);
test_indices = indices(101:end);

% meas contains the features, we use our random indices to select a subset
% for training and testing
train_data = meas(train_indices,:);
test_data = meas(test_indices,:);
% species is a cell array of strings, we need to convert to integers. 
% casting to int16 creates numbers 1-3, we subtract 1 so we get 0-2.
% caffe likes labels that start at 0.
labels = int16(nominal(species))-1;
train_labels = labels(train_indices);
test_labels = labels(test_indices);

% now our train and test sets have been made we need to write them to HDF5
% files. If the files exist, delete them.
delete('iris_train.hdf5')
delete('iris_test.hdf5')
% First write the train data
h5create('iris_train.hdf5','/data',[4,100],'Datatype','double');
h5write('iris_train.hdf5','/data',train_data');
h5create('iris_train.hdf5','/label',[1,100],'Datatype','double');
h5write('iris_train.hdf5','/label',train_labels');
% now write the test data
h5create('iris_test.hdf5','/data',[4,50],'Datatype','double');
h5write('iris_test.hdf5','/data',test_data');
h5create('iris_test.hdf5','/label',[1,50],'Datatype','double');
h5write('iris_test.hdf5','/label',test_labels');

% our datasets have now been created, now we can run caffe
