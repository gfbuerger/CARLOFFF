## usage: [res prob] = run_caffe (ptr, pdd, proto = "test1", solverstate=[], SKL= {"GSS" "HSS"})
##
## calibrate and apply caffe model
function [res prob] = run_caffe (ptr, pdd, proto = "test1", solverstate=[], SKL= {"GSS" "HSS"})

   global REG NH IMB
   
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
      if ~isnewer(of = h5f(pdd.name, PHS), ptr.ptfile) || ~isempty(IMB)
	 labels = pdd.c(pdd.(PHS)) ;
	 images = ptr.x(ptr.(PHS), :, :, :) ;

	 if strcmp(PHS, "CAL")
	    ## oversampling
	    switch IMB
	       case "SMOTE"
		  [images labels] = smote(images, labels) ;
	       case ""
	       otherwise
		  [images labels] = oversmpl(images, labels) ;
	    endswitch
	    printf("calibration type: %s\n", IMB) ;
	 endif
	 
	 if 0
	    ifile = sprintf('data/%s.%02d/%s-images-idx3-ubyte', REG, NH, PHS) ;
	    lfile = sprintf('data/%s.%02d/%s-labels-idx1-ubyte', REG, NH, PHS) ;
	    save_bin(images, ifile, labels, lfile) ;
	 endif
	 save_hdf5(of, ptr.scale * images, labels) ;
      endif
   endfor

   [fss fsn fsd] = proto_upd(:, ptr, pdd, proto) ;
   if strcmp(solverstate, "netonly")
      res = {fss fsn fsd} ;
      return ;
   endif
   
   ## train model
   solver = caffe.Solver(sprintf("models/%s/%s_solver.prototxt", proto, pdd.name)) ;
   pat = sprintf("models/%s/%s_iter_*.solverstate*", proto, pdd.name) ;
   if exist(solverstate, "file") == 2
      state = solverstate ;
   elseif ~ismember(solverstate, {"empty" "null" ""}) && ~isempty(glob(pat))
      state = strtrim(ls("-1t", pat)(1,:)) ;
   endif
   
   if exist("state", "var") == 0 || exist(state, "file") ~= 2
      solver.solve() ;
   elseif ~isnewer(state, fss, fsn, fsd, h5f(pdd.name, "CAL"))
      solver.restore(state) ;
      iter = solver.iter ;
      printf("solver at iteration: %d\n", iter) ;
      n = input("retrain model?\n[]: do nothing\n0: full\nn>0: n more iterations\n") ;
      if ~isempty(n)
	 switch n > 0
	    case 0
	       printf("from scratch\n") ;
	       solver.solve() ;
	    otherwise
	       printf("<-- %s\n", state) ;
	       solver.step(n) ;
	 endswitch
      endif
   endif
   state = strtrim(ls("-1t", pat)(1,:)) ;

   ## apply model
   weights = strrep(state, "solverstate", "caffemodel") ;
   model = sprintf("models/%s/%s_deploy.prototxt", proto, pdd.name) ;
   if exist(model, "file") == 2
      printf("<-- %s\n", model) ;
   else
      error("file not found: %s", model)
   endif

   net = caffe.Net(model, weights, 'test') ;
   for PHS = {"CAL" "VAL"}
      PHS = PHS{:} ;

      if 0

	 [images labels] = load_hdf5(h5f(pdd.name, PHS)) ;
	 labels_h5 = labels ;
	 n = size(labels, 1) ;
	 prb.(PHS) = nan(n, 2) ;
	 for i = 1 : n
	    data = squeeze(images(i,1,:,:))' ;
	    data_h5(:,:,i) = data ;
	    phat = net.forward({data}) ;
	    prb.(PHS)(i,:) = phat{1} ;
	 end

      else

	 labels = pdd.c(pdd.(PHS)) ;
	 prb.(PHS) = apply_net(ptr.scale*ptr.x, net, ptr.(PHS)) ;

      endif
      
      ce.(PHS) = crossentropy(labels, prb.(PHS)) ;

      [th.(PHS) skl.(PHS)] = skl_est(prb.(PHS)(:,end), labels, SKL) ;
      
   endfor

   res = struct("crossentropy", ce, "th", th, "skl", skl) ;

   t = [datenum(pdd.id(pdd.CAL,:)) ; datenum(pdd.id(pdd.VAL,:))] ;
   [~, Is] = sort(t) ;
   prob = [prb.CAL ; prb.VAL](Is) ;
   
endfunction
