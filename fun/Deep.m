## usage: [res weights] = Deep (ptr, pdd, solverstate=[], SKL= {"GSS" "HSS"})
##
## calibrate and apply caffe model
function [res weights] = Deep (ptr, pdd, solverstate=[], SKL= {"GSS" "HSS"})

   global IMB BATCH

   [Dd Dn De] = fileparts(solverstate) ;
   Dn = strsplit(Dn, ".") ;
   proto = Dn{1} ; area = strsplit(Dd, "/"){2} ;
   res = strsplit(Dd, "/"){3} ; weights = "" ;
   Sa = sprintf("models/%s/%s", proto, area) ;
   if (ie = exist(Sa)) == 0 || ~S_ISLNK(lstat(Sa).mode)
      switch ie
	 case 2
	    [st msg] = unlink(Sa) ;
	 case 7
	    [st msg] = rmdir(Sa, "s") ;
	 otherwise
      endswitch
      printf("%s --> %s\n", fullfile(pwd, Dd), Sa) ;
      symlink(fullfile(pwd, Dd), Sa) ;
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
      if ~isnewer(of = h5f(pdd.lname, PHS), ptr.ptfile) || ~isempty(IMB)
	 labels = pdd.c(pdd.(PHS)) ;
	 images = ptr.img(ptr.(PHS), :, :, :) ;

	 if strcmp(PHS, "CAL")
	    ## oversampling
	    [images labels] = oversmpl(images, labels, IMB) ;
	 endif
	 
	 if 0
	    ifile = sprintf('%s/%s-images-idx3-ubyte', Dd, PHS) ;
	    lfile = sprintf('%s/%s-labels-idx1-ubyte', Dd, PHS) ;
	    save_bin(images, ifile, labels, lfile) ;
	 endif
	 save_hdf5(of, ptr.scale * images, labels) ;
      endif
   endfor

   [solver deploy] = proto_upd(:, ptr, pdd, proto, Dd) ;
   if strcmp(De, ".netonly")
      res = struct("crossentropy", NaN, "th", NaN, "skl", NaN, "prob", NaN) ;
      weights = "" ;
      return ;
   endif

   ## train model
   Solver = caffe.Solver(solver) ;
   sfx = sprintf("%s/%s.%s.%s", Dd, proto, ptr.ind, pdd.lname) ;
   pat = sprintf("%s_iter_*.solverstate", sfx) ;
   if regexp(solverstate, "\\*") && ~isempty(lst = glob(solverstate))
      state = strtrim(ls("-1t", lst{:})(1,:)) ;
   elseif exist(solverstate, "file") == 2
      state = upd_solver(solverstate, ptr.ind, pdd.lname) ;
   endif

   if exist("state", "var") == 0
      Solver.solve() ;
   else
      Solver.restore(state) ;
      iter = Solver.iter ;
      printf("Solver at iteration: %d\n", iter) ;
      if ~isnewer(state, solver, deploy, h5f(pdd.lname, "CAL"))
	 if BATCH || true
	    n = iter ;
	 else
	    n = input("retrain model?\n[]: do nothing\n0: full\nn>0: n more iterations\n") ;
	 endif
	 if ~isempty(n)
	    switch n > 0
	       case 0
		  printf("from scratch\n") ;
		  Solver.solve() ;
	       otherwise
		  printf("<-- %s\n", state) ;
		  Solver.step(n) ;
	    endswitch
	 endif
      endif
   endif
   state = strtrim(ls("-1t", pat)(1,:)) ;
   
   ## apply model
   weights = strrep(state, "solverstate", "caffemodel") ;
   if exist(deploy, "file") == 2
      printf("<-- %s\n", deploy) ;
   else
      error("file not found: %s", deploy)
   endif
   net = caffe.Net(deploy, weights, 'test') ;

   for PHS = {"CAL" "VAL"}

      PHS = PHS{:} ;

      if 0

	 [images labels] = load_hdf5(h5f(pdd.lname, PHS)) ;
	 labels_h5 = labels ;
	 n = size(labels, 1) ;
	 prb.(PHS) = nan(n, 2) ;
	 for i = 1 : n
	    data = squeeze(images(i,1,:,:))' ;
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

   t = [datenum(pdd.id(pdd.CAL,:)) ; datenum(pdd.id(pdd.VAL,:))] ;
   [~, Is] = sort(t) ;
   prob.id = datevec(t(Is)) ;
   prob.x = [prb.CAL ; prb.VAL](Is,:) ;
   
   res = struct("crossentropy", ce, "th", th, "skl", skl, "prob", prob) ;
   
endfunction
