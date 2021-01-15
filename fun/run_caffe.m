## usage: prob = run_caffe (cape, RR, CAL, VAL)
##
## calibrate and apply caffe model
function prob = run_caffe (cape, RR, CAL, VAL)

   for PHS = {"CAL" "VAL"}
      PHS = PHS{:} ;
      eval(sprintf("cape.%s = sdate(cape.id, %s) ;", PHS, PHS)) ;
      eval(sprintf("RR.%s = sdate(RR.id, %s) ;", PHS, PHS)) ;
      of = ['data/Nord_' PHS '.h5'] ;
      labels = RR.c(RR.I & RR.(PHS)) ;
      images = cape.x(:, :, cape.I & cape.(PHS)) ;
      saveLabels(labels, sprintf('data/Nord_%s-labels-idx1-ubyte', PHS)) ;
      saveImages(images, sprintf('data/Nord_%s-images-idx3-ubyte', PHS)) ;
      images = permute(images, 3:-1:1) ;
      delete(of) ;
      N = size(images) ;
      N = flip([N(1) 1 N(2:end)]) ; % channel dim
      h5create(of,'/data', N, 'Datatype', 'double') ;
      h5write(of,'/data', cape.scale * images) ;
      N = flip(size(labels)) ;
      h5create(of,'/label', N, 'Datatype', 'double') ;
      h5write(of,'/label', labels) ;      
   end

   if exist("data/Nord_CAL_lmdb", "dir") ~= 7
      system("./gen_lmdb.sh") ;
   end

   caffe.set_mode_gpu() ;
   caffe.set_device(0) ;

   ## train model
   weights = 'data/snapshots/lenet_h5_solver_iter_1000.caffemodel' ;
   if exist(weights, "file") ~= 2 || 1
      solver = caffe.Solver('solver/lenet_h5_solver.prototxt') ;
      ##   solver.restore("data/snapshots/lenet_solver_iter_1000.solverstate");
      ##   caffe.io.write_mean(mean_data, 'data/infogainH.binaryproto')
      solver.solve() ;
   end

   ## apply model
   N = size(cape.x) ;
   prob = nan(N(3), 2) ;
   model = 'nets/deploy.prototxt' ;
   net = caffe.Net(model, weights, 'test') ;
   for i = find(cape.I & cape.VAL)'
      image = cape.scale * cape.x(:,:,i) ;
      res = net.forward({image});
      prob(i,:) = res{1};
   end

##   model = 'nets/lenet_h5.prototxt' ;
##   net = caffe.Net(model, weights, 'train') ;
##   w = net.blobs('data').get_data ;
##   w = net.blobs('label').get_data ;
##   net.blobs('infoGainLoss').set_data(w) ;

##   solver.step(1) ;

##   blob = blob_set_data( eye(2) )
##   caffe.io.write_mean(mean_data, 'data/infogainH.binaryproto')


##   mean_data = single(round(255*rand(2, 2, 1))) ;
##   w = caffe.io.read_mean('data/infogainH.binaryproto') ;

endfunction
