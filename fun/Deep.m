## usage: [res weights] = Deep (ptr, pdd, solverstate=[], SKL= {"GSS" "HSS"}, rnd = false)
##
## calibrate and apply caffe model
function [res weights] = Deep (ptr, pdd, solverstate=[], SKL= {"GSS" "HSS"}, rnd = false)

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
      cwd = pwd ;
      printf("%s --> %s\n", fullfile(cwd, Dd), Sa) ;
      cd(sprintf("models/%s", proto)) ;
      symlink(sprintf("../../data/%s/%s", area, res), area) ;
      cd(cwd) ;
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

   h5f = @(pddn, phs) sprintf("%s/%s.%s.%s.txt", Dd, ptr.ind, pddn, phs) ;

   for phs = {"CAL" "VAL"}
      phs = phs{:} ;
      eval(sprintf("ptr.%s = sdate(ptr.id, ptr.Y%s) ;", phs, phs)) ;
      eval(sprintf("pdd.%s = sdate(pdd.id, ptr.Y%s) ;", phs, phs)) ;
      if ~isnewer(of = h5f(pdd.lname, phs), ptr.ptfile) || ~isempty(IMB)
	 labels = pdd.c(pdd.(phs),:) - 1 ;
	 images = ptr.img(ptr.(phs), :, :, :) ;

	 if strcmp(phs, "CAL")
	    ## oversampling
	    [images labels] = oversmpl(images, labels, IMB) ;
	 endif
	 
	 if 0
	    ifile = sprintf('%s/%s-images-idx3-ubyte', Dd, phs) ;
	    lfile = sprintf('%s/%s-labels-idx1-ubyte', Dd, phs) ;
	    save_bin(images, ifile, labels, lfile) ;
	 endif
	 save_hdf5(of, ptr.scale * images, labels, rnd) ;
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

   tic ;
   if exist("state", "var") == 0
      Solver.solve() ;
   else
      Solver.restore(state) ;
      iter = Solver.iter ;
      printf("Solver at iteration: %d\n", iter) ;
      if ~isnewer(state, solver, deploy, h5f(pdd.lname, "CAL"))
	 if BATCH
	    n = iter ;
	 else
	    n = input("retrain model?\n[],0: do nothing\nn>0: n more iterations\n") ;
	 endif
	 if ~isempty(n) && n > 0
	    printf("<-- %s\n", state) ;
	    Solver.step(n) ;
	 endif
      endif
   endif
   printf("training time:\t%10.5g\n", toc) ;
   pause(10) ;
   caffe.reset_all() ;
   state = strtrim(ls("-1t", pat)(1,:)) ;
   
   ## apply model
   weights = strrep(state, "solverstate", "caffemodel") ;
   if exist(deploy, "file") == 2
      printf("<-- %s\n", deploy) ;
   else
      error("file not found: %s", deploy)
   endif
   net = caffe.Net(deploy, weights, 'test') ;

   ## number of parameters
   count = compute_caffe_parameters(net) ;

   for phs = {"CAL" "VAL"}

      phs = phs{:} ;

      if 0

	 [images labels] = load_hdf5(h5f(pdd.lname, phs)) ;
	 labels_h5 = labels ;
	 N = size(labels) ;
	 prb.(phs) = nan(N) ;
	 for i = 1 : n
	    data = squeeze(images(i,1,:,:))' ;
	    phat = net.forward({single(data)}) ;
	    prb.(phs)(i,:) = phat{1} ;
	 end

      else

	 prb.(phs) = apply_net(ptr.scale*ptr.img, net, ptr.(phs)) ;

      endif

      lc = c2l(pdd.c(pdd.(phs),:)) ;
      ce.(phs) = crossentropy(lc, prb.(phs)) ;

      wskl = skl_est(prb.(phs), lc, SKL) ;
      th.(phs) = wskl.th ; skl.(phs) = wskl.skl ;

   endfor

   t = [datenum(pdd.id(pdd.CAL,:)) ; datenum(pdd.id(pdd.VAL,:))] ;
   [~, Is] = sort(t) ;
   prob.id = datevec(t(Is)) ;
   prob.x = [prb.CAL ; prb.VAL](Is,:) ;

   res = struct("crossentropy", ce, "th", th, "skl", skl, "prob", prob, "count", count) ;
   
endfunction
