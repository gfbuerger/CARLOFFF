## usage: res = run_mnist (ptr, pdd, proto = "mnist", SKL= {"GSS" "HSS"})
##
## calibrate and apply caffe model
function res = run_mnist (ptr, pdd, proto = "mnist", SKL= {"GSS" "HSS"})

   scale = 0.00390625 ;

   for s = {'train' 'test'}
      s = s{:} ;
      if exist(of = sprintf('data/mnist/mnist_%s.h5', s), "file") == 2 continue ; endif
      images = loadMNISTImages(sprintf('data/mnist/%s-images-idx3-ubyte', s)) ;
      labels = loadMNISTLabels(sprintf('data/mnist/%s-labels-idx1-ubyte', s)) ;
      save_hdf5(of, scale * images, labels) ;
      hf = strrep(of, ".h5", ".txt") ;
      fid = fopen(hf, 'wt') ;
      fputs(fid, of) ;
      fclose(fid) ;
   end

   caffe.set_mode_gpu() ;
   caffe.set_device(0) ;

   ## train model
   solver = caffe.Solver(sprintf("solver/%s_solver.prototxt", proto)) ;
   state = ls("-1t", sprintf("data/snapshots/%s_solver_iter_*.solverstate", proto))(1,:) ;
   if exist(state, "file") == 2
      solver.restore(state) ;
   else
      ##   caffe.io.write_mean(mean_data, 'data/infogainh.binaryproto')
      solver.solve() ;
   end

   ## apply model
   model = sprintf("nets/%s_deploy.prototxt", proto) ;
   if exist(model, "file") ~= 2
      error("file not found: %s", model)
   endif
   weights = strrep(state, "solverstate", "caffemodel") ;
   net = caffe.Net(model, weights, 'test') ;

   if 0
      images = loadMNISTImages("data/mnist/t10k-images-idx3-ubyte") ;
      labels = loadMNISTLabels("data/mnist/t10k-labels-idx1-ubyte") ;
   else
      [images labels] = load_hdf5("data/mnist/mnist_test.txt") ;
   endif
   N = size(images) ;

   prob = nan(N(1), 10) ;
   for i = 1 : N(1)
      data = squeeze(images(i,1,:,:))' ;
##      data = scale * squeeze(images(i,:,:))' ;
      res = net.forward({data}) ;
      prob(i,:) = res{1};
   endfor

   ce = crossentropy(labels, prob) ;

   for s = SKL

      s = s{:} ;
      [thx fval] = fminsearch(@(th) -MoC(s, labels, prob.(PHS)(end) > th), 0.1) ;

      th.(PHS).(s) = thx ;
      skl.(PHS).(s) = -fval ;

   endfor

   res = struct("prob", prob, "crossentropy", ce, "th", th, "skl", skl) ;

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
