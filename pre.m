
global isoctave
isoctave = @() exist('OCTAVE_VERSION','builtin') ~= 0 ;

if isoctave() && OCTAVE_VERSION()(1) == '5', pkg load netcdf hdf5oct ; end

addpath ~/xds/fun ~/CARLOFFF/fun
droot = '/opt/tmp/caffe' ;
mkdir(droot, 'data/CARLOFFF')
cd ~/CARLOFFF
scale = 0.00390625 ; % MNIST

afile = 'data/atm.mat' ;
if exist(afile, 'file') == 2
   load(afile) ;
else   
   ncf = 'data/wnd.nc' ;
   t = ncread(ncf, 'time') ;
   wnd.id = nctime(t, :, :) ;
   wnd.u = ncread(ncf, 'u') ;
   wnd.v = ncread(ncf, 'v') ;
   ncf = 'data/ind.nc' ;
   t = ncread(ncf, 'time') ;
   lon = ncread(ncf, 'longitude') ;
   lat = ncread(ncf, 'latitude') ;
   id = nctime(t, :, :) ;
   cape = ncread(ncf, 'cape') ; cape = squeeze(cape(:,:,1,:)) ;
   cp = ncread(ncf, 'cp') ; cp = squeeze(cp(:,:,1,:)) ;
   LON = [] ; LAT = [49 56] ;
   cape = cape(:,lookup(LAT, lat)==1,:) ;
   cp = cp(:,lookup(LAT, lat)==1,:) ;
   save('-mat', afile, 'cp', 'cape') ;
end

if 0
   for s = {'train' 'test'}
      s = s{:} ;
      labels = loadMNISTLabels(sprintf('%s/data/mnist/%s-labels-idx1-ubyte', droot, s))' ;
      images = loadMNISTImages(sprintf('%s/data/mnist/%s-images-idx3-ubyte', droot, s)) ;
      labels = labels' ;
      labels2 = (labels == 1) ;
      saveMNISTLabels(labels, sprintf('%s/data/mnist/%s-labels', droot, s)) ;
      saveMNISTLabels(labels2, sprintf('%s/data/mnist/%s-labels2', droot, s)) ;
      saveMNISTImages(images, sprintf('%s/data/mnist/%s-images', droot, s)) ;
%%      continue ;
%%      save('-hdf5', '/opt/src/caffe/data/mnist/train-mnist.h5', 'labels', 'images') ;
      of = sprintf('%s/data/mnist/%s-mnist.h5', droot, s) ;
      delete(of) ;
%      images = permute(images, [3 2 1]) ;
%      h5create(of,'/data', size(images), 'Datatype', 'int8') ;
      N = size(images) ;
      N = [N(1) 1 N(2:end)] ; % channel dim
      h5create(of,'/data', flip(N), 'Datatype', 'double') ;
      h5write(of,'/data', scale * images) ;
      N = size(labels) ;
      h5create(of,'/label', flip(N), 'Datatype', 'double') ;
      h5write(of,'/label', labels) ;
      N = size(labels2) ;
      h5create(of,'/label2', flip(N), 'Datatype', 'double') ;
      h5write(of,'/label2', labels2) ;
      ig = infogain(labels2) ;
      N = size(ig) ;
      h5create(of,'/infogain', flip(N), 'Datatype', 'double') ;
      h5write(of,'/infogain', ig) ;
      hf = sprintf('%s/examples/mnist/%s-mnist.txt', droot, s) ;
      fid = fopen(hf, 'wt') ;
      fprintf(fid, '%s', of) ;
      fclose(fid) ;
   end
endif

dfile = 'data/dwd.Nord.mat' ;
if exist(dfile, 'file') == 2
   load(dfile) ;
else
   f = 'nc/Staedte_DWDEreigniskatalog_ERGEBNISSE_und_BESCHREIBUNG.Nord.xlsx' ;
   s = read_dwd(f) ;

   s.q = quantile(s.x, 0.96:0.01:1) ;
   s.c = lookup(s.q, s.x) ;
   if isoctave()
    save('-mat'  , dfile, 's', 'id') ;
   else
    save(dfile, 's', 'id') ;
   end
end

[~, I, Is] = intersect(datenum(id(:,1:3)), datenum(s.id(:,1:3))) ;

%% train
scale = 1e-3 ;
D = [2001 4 26 ; 2012 9 30] ;
Id = sdate(id(I,:), D) ;
Ids = sdate(s.id(Is,:), D) ;
labels = s.c(Ids) ; images = cape(:,:,Id) ;
images = permute(images, 3:-1:1) ;
%%saveLabels(labels, sprintf('%s/data/CARLOFFF/train-Nord-labels-idx1-ubyte', droot)) ;
%%saveImages(images, sprintf('%s/data/CARLOFFF/train-Nord-images-idx3-ubyte', droot)) ;
%save('-hdf5', '/opt/src/caffe/data/CARLOFFF/train-Nord.h5', 'labels', 'images') ;
of = sprintf('%s/data/CARLOFFF/train-Nord.h5', droot) ;
delete(of) ;
N = size(images) ;
N = flip([N(1) 1 N(2:end)]) ; % channel dim
h5create(of,'/data', N, 'Datatype', 'double') ;
h5write(of,'/data', scale * images) ;
N = flip(size(labels)) ;
h5create(of,'/label', N, 'Datatype', 'double') ;
h5write(of,'/label', labels) ;

%% test
D = [2013 4 26 ; 2019 8 31] ;
Id = sdate(id(I,:), D) ;
Ids = sdate(s.id(Is,:), D) ;
labels = s.c(Ids) ; images = cape(:,:,Id) ;
images = permute(images, 3:-1:1) ;
%%saveLabels(labels, sprintf('%s/data/CARLOFFF/test-Nord-labels-idx1-ubyte', droot)) ;
%%saveImages(images, sprintf('%s/data/CARLOFFF/test-Nord-images-idx3-ubyte', droot)) ;
%save('-hdf5', '/opt/src/caffe/data/CARLOFFF/test-Nord.h5', 'labels', 'images') ;
of = sprintf('%s/data/CARLOFFF/test-Nord.h5', droot) ;
delete(of) ;
N = size(images) ;
N = flip([N(1) 1 N(2:end)]) ; % channel dim
h5create(of,'/data', N, 'Datatype', 'double') ;
h5write(of,'/data', images) ;
N = flip(size(labels)) ;
h5create(of,'/label', N, 'Datatype', 'double') ;
h5write(of,'/label', labels) ;


addpath /opt/caffe/matlab /opt/caffe/matlab/+caffe/private
cd(droot) ;
model = 'examples/CARLOFFF/deploy.prototxt' ;
weights = 'examples/CARLOFFF/lenet/lenet_solver_iter_10000.caffemodel' ;

caffe.set_mode_cpu();
caffe.set_device(0);

net = caffe.Net(model, weights, 'test');

for i = 1 : size(cape, 3)
   image = cape(:,:,i) ;
   res = net.forward({image});
   prob(:,i) = res{1};
endfor
