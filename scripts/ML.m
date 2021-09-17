addpath /opt/src/caffe/matlab

weights = 'models/cnn1/CatRaRE_iter_1000.caffemodel' ;
model = 'models/cnn1/CatRaRE_deploy.prototxt' ;

net = caffe.Net(model, weights, 'test') ;

load data/ML.mat

scl = 0.00391 ;

ii = 0 ;
for i = I
    ii = ii + 1 ;
   data = scl * Data(:,:,:,i) ;
   phat = net.forward({data}) ;
   prob(ii,:) = phat{1} ;
end

