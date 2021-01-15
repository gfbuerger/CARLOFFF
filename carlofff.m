
global isoctave
isoctave = @() exist('OCTAVE_VERSION','builtin') ~= 0 ;
if isoctave()
   pkg load hdf5oct netcdf
   addpath /opt/caffe/matlab
   addpath /opt/caffe/matlab/+caffe/private
else
   addpath /opt/caffeML/matlab
end

addpath ~/CARLOFFF/fun
droot = '/opt/tmp/caffe' ;
[~, ~] = mkdir(droot, 'data/CARLOFFF')
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
   cape.id = id ;
   cp.id = id ;
   cape.x = ncread(ncf, 'cape') ; cape.x = squeeze(cape.x(:,:,1,:)) ;
   cp.x = ncread(ncf, 'cp') ; cp.x = squeeze(cp.x(:,:,1,:)) ;
   LON = [] ; LAT = [49 56] ;
   cape.x = cape.x(:,lookup(LAT, lat)==1,:) ;
   cp.x = cp.x(:,lookup(LAT, lat)==1,:) ;
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
   RR = read_dwd(f) ;

##   RR.q = quantile(RR.x, 0.96:0.01:1) ;
   RR.q = quantile(RR.x, 0.975) ;
   RR.c = lookup(RR.q, RR.x) ;
   write_H(RR.c, 'data/Nord_H.h5') ;
   if isoctave()
    save('-mat', dfile, 'RR') ;
   else
    save(dfile, 'RR') ;
   end
end

[~, cape.I, RR.I] = intersect(datenum(cape.id(:,1:3)), datenum(RR.id(:,1:3))) ;
cape.I = ind2log(cape.I, size(cape.id, 1))' ;
RR.I = ind2log(RR.I, size(RR.id, 1))' ;

%% write train (CAL) & test (VAL) data
cape.scale = 1e-3 ;
CAL = [2001 4 26 ; 2012 9 30] ;
VAL = [2013 4 26 ; 2019 8 31] ;

## caffe
prob = run_caffe(cape, RR, CAL, VAL) ;

## logistic regression
prob = run_lreg(cape, RR, CAL, VAL, C, L) ;
