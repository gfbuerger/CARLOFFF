## usage: [res prob] = Deep (ptr, pdd, solverstate=[], SKL= {"GSS" "HSS"})
##
## calibrate and apply caffe model
function [res prob] = Deep (ptr, pdd, solverstate=[], SKL= {"GSS" "HSS"})

   global IMB

   [Dd Dn De] = fileparts(solverstate) ;
   Dn = strsplit(Dn, ".") ;
   proto = Dn{1} ; area = strsplit(Dd, "/"){2} ; res = strsplit(Dd, "/"){3} ;
   if exist(Dd, "dir") ~= 7
      mkdir(Dd) ;
   endif
   Sa = sprintf("models/%s/%s", proto, area) ;
   if exist(Sa, "file") ~= 7 || ~S_ISLNK(lstat(Sa).mode)
      symlink(fullfile(pwd, Dd), Sa) ;
      printf("%s --> %s\n", fullfile(pwd, Dd), Sa) ;
   endif

   if exist(sprintf("%s/CAL_lmdb", Dd), "dir") ~= 7 & 0
      str = fileread("tools/gen_lmdb.sh") ;
      str = strrep(str, "REG_tpl", REG) ;
      tt = tempname ;
      fid  = fopen(tt, 'wt') ;
      fprintf(fid, '%s', str) ;
      fclose(fid) ;
      system(sprintf("sh %s", tt)) ;
      unlink(tt) ;
   endif

   h5f = @(pddn, PHS) sprintf("%s/%s.%s.txt", Dd, pddn, PHS) ;

   for PHS = {"CAL" "VAL"}
      PHS = PHS{:} ;
      eval(sprintf("ptr.%s = sdate(ptr.id, ptr.Y%s) ;", PHS, PHS)) ;
      eval(sprintf("pdd.%s = sdate(pdd.id, ptr.Y%s) ;", PHS, PHS)) ;
      if ~isnewer(of = h5f(pdd.name, PHS), ptr.ptfile) || ~isempty(IMB)
	 labels = pdd.c(pdd.(PHS)) ;
	 images = ptr.img(ptr.(PHS), :, :, :) ;

	 if strcmp(PHS, "CAL")
	    ## oversampling
	    switch IMB
	       case "SMOTE"
		  [images labels] = smote(images, labels) ;
	       case "SIMPLE"
		  [images labels] = oversmpl(images, labels) ;
	       otherwise
	    endswitch
	    printf("oversampling with: %s\n", IMB) ;
	 endif
	 
	 if 0
	    ifile = sprintf('%s/%s-images-idx3-ubyte', Dd, PHS) ;
	    lfile = sprintf('%s/%s-labels-idx1-ubyte', Dd, PHS) ;
	    save_bin(images, ifile, labels, lfile) ;
	 endif
	 save_hdf5(of, ptr.scale * images, labels) ;
      endif
   endfor

   [fss fsn fsd] = proto_upd(:, ptr, pdd, proto, Dd) ;
   if strcmp(De, ".netonly")
      res = {fss fsn fsd} ; prob = NaN ;
      return ;
   endif
   
   ## train model
   solver = caffe.Solver(sprintf("%s/%s.%s_solver.prototxt", Dd, proto, pdd.name)) ;
   pat = sprintf("%s/%s.%s_iter_*.solverstate", Dd, proto, pdd.name) ;
   if regexp(solverstate, "\\*") && ~isempty(lst = glob(solverstate))
      state = strtrim(ls("-1t", lst{end})(1,:)) ;
   elseif exist(solverstate, "file") == 2
      state = solverstate ;
   endif
   
   if exist("state", "var") == 0
      solver.solve() ;
   else
      solver.restore(state) ;
      iter = solver.iter ;
      printf("solver at iteration: %d\n", iter) ;
      if ~isnewer(state, fss, fsn, fsd, h5f(pdd.name, "CAL"))
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
   endif
   state = strtrim(ls("-1t", pat)(1,:)) ;

   ## apply model
   weights = strrep(state, "solverstate", "caffemodel") ;
   model = sprintf("%s/%s.%s_deploy.prototxt", Dd, proto, pdd.name) ;
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
	    phat = net.forward({single(data)}) ;
	    prb.(PHS)(i,:) = phat{1} ;
	 end

      else

	 labels = pdd.c(pdd.(PHS)) ;
	 prb.(PHS) = apply_net(ptr.scale*ptr.img, net, ptr.(PHS)) ;

      endif
      
      ce.(PHS) = crossentropy(labels, prb.(PHS)) ;

      [th.(PHS) skl.(PHS)] = skl_est(prb.(PHS)(:,end), labels, SKL) ;
      
   endfor

   res = struct("crossentropy", ce, "th", th, "skl", skl) ;

   t = [datenum(pdd.id(pdd.CAL,:)) ; datenum(pdd.id(pdd.VAL,:))] ;
   [~, Is] = sort(t) ;
   prob = [prb.CAL ; prb.VAL](Is) ;
   
endfunction
