
profile on

global isoctave PFX REG NH MON IMB CNVDUR BLD VERBOSE PARALLEL MAXX

set(0, "defaultaxesfontsize", 26, "defaulttextfontsize", 30) ;

addpath ~/carlofff/fun

[~, ~] = mkdir("data") ;
cd ~/carlofff
[glat glon] = borders("germany") ;
REG.name = {"NW" "NE" "SW" "SE"} ;
REG.name = {"DE"} ;
PFX = "1R" ; BLD = ~true ; MAXX = 100 ;
GLON = [5.75 15.25] ; GLAT = [47.25 55.25] ;
for jLON = 1 : length(GLON) - 1
   for jLAT = 1 : length(GLAT) - 1
      REG.geo{jLON,jLAT} = [GLON([jLON jLON + 1]) ; GLAT([jLAT jLAT + 1])] ;
   endfor
endfor
ID = [2001 5 1 0 ; 2020 8 31 23] ;
MON = 5 : 8 ;
IND = "01010000010" ; # read these atm. indices
if isempty(CNVDUR = getenv("CNVDUR"))
   CNVDUR = 9 ;
else
   CNVDUR = str2num(CNVDUR) ;
endif
if isempty(JVAR = getenv("JVAR"))
   JVAR = [2 4 10] ;
else
   JVAR = str2num(char(strsplit(JVAR))) ;
endif
if isempty(GLOG_log_dir = getenv("GLOG_log_dir"))
   mkdir(GLOG_log_dir = sprintf("/tmp/GLOG.%d", getpid)) ;
   setenv("GLOG_log_dir", GLOG_log_dir) ;
endif
SOLV = getenv("SOLV") ;
NH = 24 ; # relevant hours
scale = 0.00390625 ; % MNIST
Q0 = {0.99 0.995 0.9986}{1} ; # 2nd optimal PC for MoC(HiOS, Eta)
IMB = {"SMOTE" "NONE" 0}{3} ;
SKL = {"HSS" "ETS" "BSS"} ; jSKL = 2 ; # ETS

##{
isoctave = @() exist("OCTAVE_VERSION","builtin") ~= 0 ;
if isoctave()
   pkg load hdf5oct statistics
   source("caffe_loc.m") ; # LOC = "/path/to/caffe"
   addpath(sprintf("%s/matlab", LOC)) ;
   addpath(sprintf("%s/matlab/+caffe/private", LOC)) ;
   [st out] = system("caffe device_query -gpu 0 2>&1") ;
   if st == 0
      printf("+++\t\tCaffe using GPU\t\t+++\n") ;
      caffe.set_mode_gpu() ;
      caffe.set_device(0) ;
   else
      printf("+++\t\tCaffe using CPU\t\t+++\n") ;
      caffe.set_mode_cpu() ;
   endif
else
   addpath /opt/caffeML/matlab
endif
[~, ~] = mkdir(sprintf("data/%s.%02d", PFX, NH)) ; [~, ~] = mkdir(sprintf("nc/%s.%02d", PFX, NH)) ;

if isnewer(afile = sprintf("data/ind/ind.%s.ob", PFX), glob("data/ind/*.nc"){:})
   printf("<-- %s\n", afile) ;
   load(afile) ;
else
   V = read_ana(REG.geo, NH) ;
   VAR = fieldnames(V)' ;
   for k = VAR
      eval(sprintf("%s = V.%s ;", k{:}, k{:})) ;
   endfor
   printf("--> %s\n", afile) ;
   save(afile, VAR{:}, "VAR") ;
endif

jPDD = 2 ;
PDD = {"WEI" "xWEI" "cape" "cp" "regnie" "RR" "CatRaRE"}{jPDD} ;
jVAR = {1 2 0 0 0 0 3}{jPDD} ;
if exist(pdfile = sprintf("data/%s.%s_%02d.ob", PFX, PDD, CNVDUR), "file") == 2
   printf("<-- %s\n", pdfile) ;
   load(pdfile) ;
else
   ## select predictand
   jV = find(strcmp(PDD, VAR)) ; if isempty(jV) jV = 1 ; endif
   str = sprintf("%s,", VAR{:}) ; str = str(1:end-1) ;
   eval(sprintf("pdd = selpdd(PDD, ID, Q0, %s) ;", VAR{jV}))
   ## aggregate
   pdd = agg(pdd, NH, @nanmax) ;
   ## select classes
   pdd.c = classes(pdd, jVAR, Q0) ;
   pdd.lname = sprintf("%s_%02d_%.2f", pdd.name, CNVDUR, 100 * Q0) ; 
   if 0 write_H(pdd.c) ; endif

   printf("--> %s\n", pdfile) ;
   save(pdfile, "pdd") ;
endif

FILL = true ;
ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
if isnewer(ptfile = sprintf("data/%s.%02d/%s.%s.ob", PFX, NH, ind, pdd.lname), afile, pdfile)

   printf("<-- %s\n", ptfile) ;
   load(ptfile) ;

else

   ## select predictors
   str = sprintf("%s,", VAR{JVAR}) ; str = str(1:end-1) ;
   eval(sprintf("ptr = selptr(scale, ind, ptfile, ID, FILL, %s) ;", str))
   ptr.name = "ptr" ;

   ## normalize with mean and std
   ptr.x = nrm_ptr(ptr.x) ;

   printf("--> %s\n", ptfile) ;
   save(ptfile, "ptr") ;
   
endif

if 0
   ## select hours
   H = 12 : 20 ; # from barplot
   I = ismember(ptr.id(:,4), H) ; 
   ptr.id = ptr.id(I,:) ;
   ptr.x = ptr.x(I,:,:,:) ;
   pdd.id = pdd.id(I,:) ;
   pdd.x = squeeze(pdd.x(I,jVAR,:,:)) ;
endif

if 0
   N = size(ptr.x) ;
   ptr.id = repmat(ptr.id, prod(N(3:end)), 1) ;
   ptr.x = permute(ptr.x, [1 3:length(N) 2]) ;
   ptr.x = reshape(ptr.x, [], N(2)) ;
   pdd.id = repmat(pdd.id, prod(N(3:end)), 1) ;
   pdd.x = pdd.x(:) ;
   I = ~any(isnan([ptr.x pdd.x]), 2) ;
   ## first impression
   disp(ndcorr(ptr.x(:,1,:,:), pdd.x)) ;
endif

%% write train (CAL) & test (VAL) data
ptr.YCAL = [2001 5 1 0 ; 2010 8 31 23] ;
ptr.YVAL = [2011 5 1 0 ; 2020 8 31 23] ;
##ptr.YCAL = ptr.YVAL = [2001 5 1 0 ; 2020 8 31 23] ;

if 0
   ## test with reduced major class
   [rptr rpdd] = redclass(ptr, pdd, 0.8) ;
endif

## Shallow
MDL = {"lasso" "tree" "nnet" "nls"} ;
for PCA = {{} []}(2)
   PCA = PCA{:} ;
   if iscell(PCA)
      ptr.ind = ["R" ind] ;
   else
      ptr.ind = ind ;
   endif
   if isnewer(mfile = sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", PFX, NH, ptr.ind, pdd.lname), ptfile, pdfile)
      printf("<-- %s\n", mfile) ;
      load(mfile) ;
   else
      clear skl ;
      for jMDL = 1 : length(MDL)
	 mdl = MDL{jMDL} ;
	 if isnewer(sfile = sprintf("data/%s.%02d/Shallow.%s.%s.%s.ob", PFX, NH, mdl, ptr.ind, pdd.lname), ptfile, pdfile)
	    printf("<-- %s\n", sfile) ;
	    load(sfile) ;
	    if 0
	       strucdisp(shallow.skl) ;
	       plot_fit(mdl, shallow.fit) ;
	       set(findall("-property", "fontname"), "fontname", "Libertinus Sans") ;
	       set(findall("type", "axes"), "fontsize", 24) ;
	       set(findall("type", "text"), "fontsize", 22) ;
	    endif
	 else
	    varargin = {} ;
	    ##	 varargin = {"lambdamax", 1e2, "lambdaminratio", 1e-2} ;
	    shallow = Shallow(ptr, pdd, PCA, "CVE", mdl, SKL, varargin{:}) ;
	    printf("--> %s\n", sfile) ;
	    save(sfile, "shallow") ;
	 endif
	 skl(jMDL,:) = [cellfun(@(s) mean(diag(shallow.skl.VAL.(s))), SKL) shallow.crossentropy.VAL] ;
      endfor
      skl = real(skl) ;
      printf("--> %s\n", mfile) ;
      save("-text", mfile, "skl") ;
   endif
endfor

## Deep
## divergent: CIFAR-10, SqueezeNet
## shape mismatch: Inception-v4
JNET = 1 : 9 ;
NET = {"Simple" "ResNet" "LeNet-5" "CIFAR-10" "AlexNet" "GoogLeNet" "ALL-CNN" "DenseNet" "Logreg"}(JNET) ;
RES = {[32 32] [32 32] [28 28] [32 32] [227 227] [224 224] [32 32] [32 32] [32 32]}(JNET) ;
ptr.ind = ind ;
for jNET = 1 : length(NET)

   net = NET{jNET} ;
   [~, ~] = mkdir(sfx = sprintf("data/%s.%02d/%dx%d", PFX, NH, RES{jNET})) ;
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", PFX, NH, net, ind, pdd.lname) ;
   dfile = sprintf("%s/Deep.%s.%s.%s.ob", sfx, net, ind, pdd.lname) ;

   if isnewer(mfile, ptfile, pdfile, dfile)

      printf("<-- %s\n", mfile) ;
      load(mfile) ;
      printf("<-- %s\n", dfile) ;
      load(dfile) ;
      
   else

      init_rnd() ;
      ptr.img = arr2img(ptr.x, RES{jNET}) ;
      pfx = sprintf("%s/%s.%s.%s", sfx, net, ptr.ind, pdd.lname) ;
      switch SOLV
	 case ""
	    solverstate = sprintf("%s_iter_0.solverstate", pfx) ;
	 case "netonly"
	    solverstate = sprintf("%s.netonly", pfx) ;
	 case "cont"
	    siter = table_pick(sprintf("%s_solver.prototxt", pfx), "max_iter") ;
	    solverstate = sprintf("%s_iter_%s.solverstate", pfx, siter) ;
	 otherwise
	    if ~strcmp(strsplit(SOLV, "/"){2}, net)
	       warning("SOLV not matching %s, continuing\n", net) ;
	       continue ;
	    endif
	    solverstate = upd_solver(SOLV, ptr.ind, pdd.lname) ;
      endswitch
      clear skl deep ; i = 1 ;
      while i <= 20    ## UGLY
	 if exist(sfile = sprintf("%s/skl.%s.%s.%s.ot", sfx, net, ind, pdd.lname)) == 2
	    load(sfile) ;
	    skl = skl(~any(skl(:,[1 2]) < 0.3, 2),:) ; # retry low skill
	    if rows(skl) >= i
	       i++ ;
	       continue ;
	    endif
	 endif

	 kfail = 0 ; wskl = Inf ;
	 while ++kfail <= 50 && wskl > 3
	    [deep weights] = Deep(ptr, pdd, solverstate, SKL) ;
	    wskl = deep.crossentropy.VAL ;
	 endwhile
	 if kfail > 5 warning("no convergence\n") ; endif

	 deep.prob.name = net ;
	 save(sprintf("%s.%02d", dfile, i), "deep") ;
	 printf("%s/caffe.INFO --> %s/%s.%s.%s.log.%02d\n", GLOG_log_dir, sfx, net, ind, pdd.lname, i) ;
	 system(sprintf("cp -L %s/caffe.INFO %s/%s.%s.%s.log.%02d", GLOG_log_dir, sfx, net, ind, pdd.lname, i)) ;
	 system(sprintf("cp /dev/null %s/caffe.INFO", GLOG_log_dir)) ;
	 state = strrep(weights, ".caffemodel", ".solverstate") ;
	 rename(weights, sprintf("%s.%02d", weights, i)) ;
	 rename(state, sprintf("%s.%02d", state, i)) ;
	 skl(i,:) = [cellfun(@(s) mean(diag(deep.skl.VAL.(s))), SKL) deep.crossentropy.VAL] ;
	 save("-text", sfile, "skl") ;
	 i++ ;
##	 system(sprintf("nvidia-smi -f nvidia.%d.log", i)) ;
      endwhile

      printf("--> %s\n", mfile) ;
      copyfile(sfile, mfile) ; unlink(sfile) ;
##      plot_log("/tmp/caffe.INFO", :, iter = 0, pse = 30, plog = 0) ;
##      cmd = sprintf("python /opt/src/caffe/python/draw_net.py models/%s/%s.prototxt nc/%s.svg", net, pdd.lname, net) ;
##      system(cmd) ;

   endif

   ## find best model and apply
   [~, i] = max(skl(:,jSKL)) ;

   pfx = sprintf("%s/%s.%s.%s", sfx, net, ind, pdd.lname) ;
   difile = sprintf("%s.%02d", dfile, i) ;
   if exist(difile, "file") == 2 && ~isnewer(dfile, difile)
      rename(difile, dfile) ;
      delete(ls("-1t", sprintf("%s.*", dfile))) ;
      wfile = strtrim(ls("-1t", sprintf("%s_iter_*.caffemodel.%02d", pfx, i))(1,:)) ;
      rename(wfile, wfile(1:end-3)) ;
      delete(ls("-1t", sprintf("%s_iter_*.caffemodel.*", pfx))) ;
      wfile = strtrim(ls("-1t", sprintf("%s_iter_*.solverstate.%02d", pfx, i))(1,:)) ;
      rename(wfile, wfile(1:end-3)) ;
      delete(ls("-1t", sprintf("%s_iter_*.solverstate.*", pfx))) ;
      wfile = sprintf("%s.log.%02d", pfx, i) ;
      rename(wfile, wfile(1:end-3)) ;
      delete(ls("-1t", sprintf("%s.log.*", pfx))) ;
   endif
   
   if 0 && ~strcmp(graphics_toolkit, "gnuplot")
      figure(1, "visible", "off") ; clf ;
      lfile = sprintf("%s.log", pfx)
      plot_log(gca, lfile, :, :, pse = 1, plog = 0) ;
      print(strrep(lfile, ".log", ".svg")) ;
   endif
   
   if 0
      model = sprintf("models/%s/%s.%02d/%s.%s.%s_deploy.prototxt", net, PFX, NH, net, ind, pdd.lname) ;
      weights = sprintf("%s/%s.%s.%s.caffemodel", sfx, net, ind, pdd.lname) ;
      printf("<-- %s\n", weights) ;
      deploy = caffe.Net(model, weights, 'test') ;
      ptr.img = arr2img(ptr.x, RES{jNET}) ;
      deep.prob = apply_net(scale*ptr.img, deploy) ;
   endif

endfor
exit

profshow ;
profile off ;
T = profile("info") ;
save -text prof.ot T

### historical and future simulations
load(ptfile) ;
lon = ptr.lon ; lat = ptr.lat ; scale = ptr.scale ;
JSIM = 1:3 ;
SIM = {"ana" "historical" "rcp85"}(JSIM) ;
NSIM = {"ANA" "HIST" "RCP85"}(JSIM) ;
JNET = 1 : 9 ;

PCA = {{} []}{2} ;
if iscell(PCA) ptr.ind = sprintf("R%s", ind) ; endif

for jSIM = 1 : length(SIM)

   sim = SIM{jSIM} ;

   ## load atmospheric variables
   if exist(sfile = sprintf("data/%s.%s.ob", sim, IND), "file") == 2

      printf("<-- %s\n", sfile) ;
      load(sfile) ;

   else

      SVAR = trl_atm("atmvar.lst", [1 2 2](jSIM), JVAR) ;
      clear(SVAR{:}) ;
      for svar = SVAR
	 svar = svar{:} ;
	 if strcmp(sim, "ana")
	    s = read_ana(GLON, GLAT, NH, svar) ;
	 else
	    s = read_sim("esgf", svar, sim, lon, lat) ;
	 endif
	 ## aggregate
	 eval(sprintf("%s.%s = agg(s, NH) ;", sim, svar)) ;

      endfor

      ## select predictors
      str = cellfun(@(c) sprintf("%s.%s,", sim, c), SVAR, "Uniformoutput", false) ;
      str = strcat(str{:})(1:end-1) ;
      eval(sprintf("%s.prob = selptr(scale, IND, ptfile, :, FILL, %s) ;", sim, str)) ;
      eval(sprintf("%s.prob.name = \"%s\" ;", sim, sim)) ;

      save(sfile, sim) ;

   endif

endfor

for jSIM = 1 : length(SIM)

   sim = SIM{jSIM} ;

   glb = glob(sprintf("data/%s.%02d/Shallow.*.%s.%s.ot", PFX, NH, ptr.ind, pdd.lname)) ;
   glb = union(glb, glob(sprintf("models/*/%s.%02d/*.%s.%s_iter_*.caffemodel", PFX, NH, ind, pdd.lname))) ;
   glb = union(glb, glob(sprintf("esgf/*.%s.ob", sim))) ;
   glb = union(glb, glob(sprintf("data/%s.ob", sim))) ;

   if isnewer(ptfile = sprintf("data/%s.%s.%s.ob", sim, ptr.ind, pdd.lname), glb{:})

      printf("<-- %s\n", ptfile) ;
      load(ptfile) ;
##      eval(sprintf("%s.prob.Shallow.nls = %s.prob.Shallow.logr ;", sim, sim)) ;
##      eval(sprintf("%s.prob.Shallow = rmfield(%s.prob.Shallow, \"logr\") ;", sim, sim)) ;
##      save(ptfile, sim) ;

   else

      ## select variables
      eval(sprintf("%s.prob = selind(%s.prob, ind, IND) ;", sim, sim)) ;

      ## normalize with mean and std
      switch sim
	 case "ana"
	    eval(sprintf("%s.prob.x = nrm_ptr(%s.prob.x, sdate(%s.prob.id, ID)) ;", sim, sim, sim)) ;
	 otherwise
	    if exist(rfile = "data/refclim.ob", "file") == 2
	       load(rfile) ;
	    else
	       eval(sprintf("[refclim.xm refclim.xs] = ref_clim(%s.prob, %s.prob, ID) ;", SIM{2}, SIM{3})) ;
	       save(rfile, "refclim") ;
	    endif
	    eval(sprintf("%s.prob.x = nrm_ptr(%s.prob.x, :, refclim.xm, refclim.xs) ;", sim, sim)) ;
      endswitch

      for jMDL = 1 : length(MDL)
	 mdl = MDL{jMDL} ;
	 sfile = sprintf("data/%s.%02d/Shallow.%s.%s.%s.ob", PFX, NH, mdl, ptr.ind, pdd.lname) ;
	 printf("<-- %s\n", sfile) ;
	 load(sfile) ;
	 eval(sprintf("%s.prob.Shallow.%s = Shallow(%s.prob, shallow, PCA, [], mdl) ;", sim, mdl, sim)) ;
      endfor
      
      for jNET = 1 : length(NET(JNET))
	 net = NET(JNET){jNET} ; res = RES(JNET){jNET} ;
	 pfx = sprintf("models/%s/%s.%02d/%s.%s.%s", net, PFX, NH, net, ind, pdd.lname) ;
	 model = sprintf("%s_deploy.prototxt", pfx) ;
	 if exist(model, "file") ~= 2
	    error("model not found: %s", model) ;
	 endif
	 siter = table_pick(sprintf("%s_solver.prototxt", pfx), "max_iter") ;
	 weights = sprintf("%s_iter_%s.caffemodel", pfx, siter) ;
	 if exist(weights, "file") ~= 2
	    warning("weights not found: %s\n", weights) ;
	    continue ;
	 endif
	 deploy = caffe.Net(model, weights, 'test') ;
	 eval(sprintf("%s.prob.img = arr2img(%s.prob.x, res) ;", sim, sim)) ;
	 out = sprintf("%s.prob.Deep.%s = apply_net(scale*%s.prob.img, deploy) ;", sim, strrep(net, "-", "_"), sim) ;
	 printf("%s\n", out) ;
	 eval(out) ;
      endfor

      printf("--> %s\n", ptfile) ;
      save(ptfile, sim) ;

   endif

endfor

if ~isempty(graphics_toolkit) && ~strcmp(graphics_toolkit, "gnuplot")
   source plots.m ;
endif
