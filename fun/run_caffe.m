## usage: res = run_caffe (ptr, pdd, proto = "test1", SKL= {"GSS" "HSS"})
##
## calibrate and apply caffe model
function res = run_caffe (ptr, pdd, proto = "test1", SKL= {"GSS" "HSS"})

   global REG
   
   if exist(sprintf("data/%s_CAL_lmdb", REG), "dir") ~= 7
      str = fileread("tools/gen_lmdb.sh") ;
      str = strrep(str, "REG_tpl", REG) ;
      tt = tempname ;
      fid  = fopen(tt, 'wt') ;
      fprintf(fid, '%s', str) ;
      fclose(fid) ;
      system(sprintf("sh %s", tt)) ;
      unlink(tt) ;
   endif

   h5f = @(pddn, PHS) sprintf("data/%s_%s.%s.txt", REG, pddn, PHS) ;

   for PHS = {"CAL" "VAL"}
      PHS = PHS{:} ;
      eval(sprintf("ptr.%s = sdate(ptr.id, ptr.Y%s) ;", PHS, PHS)) ;
      eval(sprintf("pdd.%s = sdate(pdd.id, ptr.Y%s) ;", PHS, PHS)) ;
      if exist(of = h5f(pdd.name, PHS), "file") ~= 2 | 1
	 labels = pdd.c(pdd.I & pdd.(PHS)) ;
	 images = ptr.x(ptr.I & ptr.(PHS), :, :, :) ;
	 ifile = sprintf('data/%s_%s-images-idx3-ubyte', REG, PHS) ;
	 lfile = sprintf('data/%s_%s-labels-idx1-ubyte', REG, PHS) ;
	 save_bin(images, ifile, labels, lfile) ;
	 save_hdf5(of, ptr.scale * images, labels) ;
      endif
   endfor

   [fss fsn fsd] = proto_upd(:, ptr, pdd, proto) ;
   
   ## train model
   solver = caffe.Solver(sprintf("solver/%s.%s_solver.prototxt", proto, pdd.name)) ;
   pat = sprintf("data/snapshots/%s.%s_iter_*.solverstate", proto, pdd.name) ;
   if isempty(glob(pat)) || ~isnewer(glob(pat){1}, fss, fsn, fsd, h5f(pdd.name, "CAL"))
      if yes_or_no("re-train model?")
	 solver.solve() ;
	 state = ls("-1t", pat)(1,:) ;
      else
	 state = ls("-1t", pat)(1,:) ;
	 solver.restore(state) ;
      endif
   else
      state = ls("-1t", pat)(1,:) ;
      solver.restore(state) ;
##      iter = solver.iter ;
##      solver.step(round(0.5 * iter)) ;
   endif

   ## apply model
   weights = strrep(state, "solverstate", "caffemodel") ;
   n = size(ptr.x) ;   
   model = sprintf("nets/%s.%s_deploy.prototxt", proto, pdd.name) ;
   if exist(model, "file") ~= 2
      error("file not found: %s", model)
   endif

   net = caffe.Net(model, weights, 'test') ;
   for PHS = {"CAL" "VAL"}
      PHS = PHS{:} ;

      if 0

	 [images labels] = load_hdf5(h5f(pdd.name, PHS)) ;
	 labels_h5 = labels ;
	 n = size(labels, 1) ;
	 prob.(PHS) = nan(n, 2) ;
	 for i = 1 : n
	    data = squeeze(images(i,1,:,:))' ;
	    data_h5(:,:,i) = data ;
	    phat = net.forward({data}) ;
	    prob.(PHS)(i,:) = phat{1} ;
	 end

      else

	 labels = pdd.c(pdd.I & pdd.(PHS)) ;
	 I = ptr.I & ptr.(PHS) ;
	 prob.(PHS) = nan(sum(I), 2) ; ii = 0 ;
	 for i = find(I)'
	    data = ptr.scale * flipdim(squeeze(ptr.x(i,:,:,:))) ;
	    phat = net.forward({data}) ;
	    prob.(PHS)(++ii,:) = phat{1} ;
	 end

      endif
      
      ce.(PHS) = crossentropy(labels, prob.(PHS)) ;

      for s = SKL
	 s = s{:} ;
	 [thx fval] = fminsearch(@(th) -MoC(s, labels, prob.(PHS)(:,end) > th), 0.1) ;
	 th.(s).(PHS) = thx ;
	 skl.(s).(PHS) = -fval ;
      endfor

   endfor

   res = struct("prob", prob, "crossentropy", ce, "th", th, "skl", skl) ;

endfunction
