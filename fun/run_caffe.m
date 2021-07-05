## usage: res = run_caffe (ptr, pdd, proto = "test1", netonly=false, SKL= {"GSS" "HSS"})
##
## calibrate and apply caffe model
function res = run_caffe (ptr, pdd, proto = "test1", netonly=false, SKL= {"GSS" "HSS"})

   global REG NH
   
   if exist(sprintf("%s/%s.%02d/CAL_lmdb", proto, REG, NH), "dir") ~= 7 & 0
      str = fileread("tools/gen_lmdb.sh") ;
      str = strrep(str, "REG_tpl", REG) ;
      tt = tempname ;
      fid  = fopen(tt, 'wt') ;
      fprintf(fid, '%s', str) ;
      fclose(fid) ;
      system(sprintf("sh %s", tt)) ;
      unlink(tt) ;
   endif

   h5f = @(pddn, PHS) sprintf("data/%s.%02d/%s.%s.txt", REG, NH, pddn, PHS) ;

   for PHS = {"CAL" "VAL"}
      PHS = PHS{:} ;
      eval(sprintf("ptr.%s = sdate(ptr.id, ptr.Y%s) ;", PHS, PHS)) ;
      eval(sprintf("pdd.%s = sdate(pdd.id, ptr.Y%s) ;", PHS, PHS)) ;
      if isnewer(ptr.pfile, of = h5f(pdd.name, PHS))
	 labels = pdd.c(pdd.(PHS)) ;
	 images = ptr.x(ptr.(PHS), :, :, :) ;
	 if 0
	    ifile = sprintf('data/%s.%02d/%s-images-idx3-ubyte', REG, NH, PHS) ;
	    lfile = sprintf('data/%s.%02d/%s-labels-idx1-ubyte', REG, NH, PHS) ;
	    save_bin(images, ifile, labels, lfile) ;
	 endif
	 save_hdf5(of, ptr.scale * images, labels) ;
      endif
   endfor

   [fss fsn fsd] = proto_upd(:, ptr, pdd, proto) ;
   if netonly
      res = {fss fsn fsd} ;
      return ;
   endif
   
   ## train model
   solver = caffe.Solver(sprintf("models/%s/%s_solver.prototxt", proto, pdd.name)) ;
   pat = sprintf("models/%s/%s_iter_*.solverstate*", proto, pdd.name) ;
   if isempty(glob(pat))
      solver.solve() ;
   elseif ~isnewer(glob(pat){1}, fss, fsn, fsd, h5f(pdd.name, "CAL"))
      if yes_or_no("re-train model?")
	 solver.solve() ;
      else
	 state = strtrim(ls("-1t", pat)(1,:)) ;
	 printf("<-- %s\n", state) ;
	 solver.restore(state) ;
##	 iter = solver.iter ;
##	 solver.step(round(0.5 * iter)) ;
      endif
   endif
   state = strtrim(ls("-1t", pat)(1,:)) ;

   ## apply model
   weights = strrep(state, "solverstate", "caffemodel") ;
   model = sprintf("models/%s/%s_deploy.prototxt", proto, pdd.name) ;
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

	 labels = pdd.c(pdd.(PHS)) ;
	 Data = flipdim(ptr.x) ;
	 N = size(Data) ;
	 if length(N) < 3
	    N = [1 1 N] ;
	    Data = reshape(Data, N) ;
	 endif
	 prob.(PHS) = nan(sum(ptr.(PHS)), 2) ; ii = 0 ;
	 for i = find(ptr.(PHS))'
	    data = ptr.scale * Data(:,:,:,i) ;
	    phat = net.forward({data}) ;
	    prob.(PHS)(++ii,:) = phat{1} ;
	 end

      endif
      
      ce.(PHS) = crossentropy(labels, prob.(PHS)) ;

      [th.(PHS) skl.(PHS)] = skl_est(prob.(PHS)(:,end), labels, SKL) ;
      
   endfor

   res = struct("prob", prob, "crossentropy", ce, "th", th, "skl", skl) ;

endfunction
