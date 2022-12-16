
profile on

global isoctave LON LAT GREG REG NH MON IMB CNVDUR

set(0, "defaultaxesfontsize", 26, "defaulttextfontsize", 30) ;

addpath ~/carlofff/fun
[~, ~] = mkdir("data") ;
cd ~/carlofff
[glat glon] = borders("germany") ;
##GLON = [min(glon) max(glon)] ; GLAT = [min(glat) max(glat)] ;
GLON = [5.75 15.25] ; GLAT = [47.25 55.25] ; GREG = "DE" ;
LON = GLON ; LAT = GLAT ; REG = "DE" ; # whole Germany
##LON = [6 10] ; LAT = [51 54] ; REG = "NW" ; # Nordwest
##LON = [10 14] ; LAT = [51 54] ; REG = "NE" ; # Nordost
##LON = [6 10] ; LAT = [47.5 51] ; REG = "SW" ; # Südwest
##LON = [10 14] ; LAT = [47.5 51] ; REG = "SE" ; # Südost
##LON = [9.7 9.9] ; LAT = [49.0 49.3] ; REG = "BB" ; # Braunsbach
##GLON = LON ; GLAT = LAT ; GREG = REG ;
ID = [2001 5 1 0 ; 2020 8 31 23] ;
MON = 5 : 8 ;
IND = "01010000010" ; # read these atm. indices
##[CNVDUR JVAR] = read_env("CNVDUR", "JVAR") ;
if isempty(CNVDUR = getenv("CNVDUR"))
   CNVDUR = 9 ;
else
   CNVDUR = str2num(CNVDUR) ;
endif
if isempty(JVAR = getenv("JVAR"))
   JVAR = [2:4 10] ;
else
   JVAR = str2num(char(strsplit(JVAR))) ;
endif
if isempty(GLOG_log_dir = getenv("GLOG_log_dir"))
   mkdir(GLOG_log_dir = sprintf("/tmp/GLOG.%d", getpid)) ;
endif
SOLV = getenv("SOLV") ;
NH = 24 ; # relevant hours
scale = 0.00390625 ; % MNIST
Q0 = {0.99 0.995 0.9986}{1} ; # 2nd optimal PC for MoC(HiOS, Eta)
IMB = "SIMPLE" ;
SKL = {"HSS" "ETS"} ;

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
[~, ~] = mkdir(sprintf("data/%s.%02d", REG, NH)) ; [~, ~] = mkdir(sprintf("nc/%s.%02d", REG, NH)) ;

if isnewer(afile = sprintf("data/ind/ind.%s.ob", GREG), glob("data/ind/*.nc"){:})
   printf("<-- %s\n", afile) ;
   load(afile) ;
else
   V = read_ana(GLON, GLAT, NH) ;
   VAR = fieldnames(V)' ;
   for k = VAR
      eval(sprintf("%s = V.%s ;", k{:}, k{:})) ;
   endfor
   printf("--> %s\n", afile) ;
   save(afile, VAR{:}, "VAR") ;
endif

PDD = {"xWEI" "cape" "cp" "regnie" "RR" "CatRaRE"}{6} ;
if exist(pdfile = sprintf("data/%s.%s_%02d.ob", REG, PDD, CNVDUR), "file") == 2
   printf("<-- %s\n", pdfile) ;
   load(pdfile) ;
else
   ## select predictand
   jV = find(strcmp(PDD, VAR)) ; if isempty(jV) jV = 1 ; endif
   str = sprintf("%s,", VAR{:}) ; str = str(1:end-1) ;
   eval(sprintf("pdd = selpdd(PDD, LON, LAT, ID, Q0, %s) ;", VAR{jV}))
   pdd.lname = sprintf("%s_%02d", pdd.name, CNVDUR) ; 
   ## aggregate
   pdd = agg(pdd, NH, @nanmax) ;
   printf("--> %s\n", pdfile) ;
   save(pdfile, "pdd") ;
endif

FILL = true ;
ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
if isnewer(ptfile = sprintf("data/%s.%02d/%s.%s.ob", REG, NH, ind, pdd.lname), afile, pdfile)

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

jVAR = 3 ; # Eta
w = squeeze(pdd.x(:,jVAR,:,:)) ;
pdd.q = quantile(w(:), Q0) ;
pdd.lname = sprintf("%s_%.2f", pdd.lname, 100 * Q0) ;
pdd.c = any(any(w > pdd.q, 2), 3) ;
printf("class rates: %.1f %%  %.1f %%\n", 100 * [sum(w(:) > 0) sum(w(:) == 0)] / numel(w)) ;
printf("class rates: %.1f %%  %.1f %%\n", 100 * [sum(pdd.c) sum(~pdd.c)] / rows(pdd.c)) ;
if 0 write_H(pdd.c) ; endif

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
MDL = {"lasso" "tree" "nls"} ;
for PCA = {{} []}
   PCA = PCA{:} ;
   if iscell(PCA)
      ptr.ind = ["R" ind] ;
   else
      ptr.ind = ind ;
   endif
   if isnewer(mfile = sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ptr.ind, pdd.lname), ptfile, pdfile)
      load(mfile) ;
   else
      clear skl ;
      for jMDL = 1 : length(MDL)
	 mdl = MDL{jMDL} ;
	 if isnewer(sfile = sprintf("data/%s.%02d/Shallow.%s.%s.%s.ot", REG, NH, mdl, ptr.ind, pdd.lname), ptfile, pdfile)
	    printf("<-- %s\n", sfile) ;
	    load(sfile) ;
	    if 0
	       strucdisp(shallow.skl) ;
	       plot_fit(mdl, shallow.fit) ;
	       set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
	       set(findall("type", "axes"), "fontsize", 24) ;
	       set(findall("type", "text"), "fontsize", 22) ;
	    endif
	 else
	    varargin = {} ;
	    ##	 varargin = {"lambdamax", 1e2, "lambdaminratio", 1e-2} ;
	    shallow = Shallow(ptr, pdd, PCA, "CVE", mdl, SKL, varargin{:}) ;
	    printf("--> %s\n", sfile) ;
	    save("-text", sfile, "shallow") ;
	 endif
	 skl(jMDL,:) = [cellfun(@(s) shallow.skl.VAL.(s), SKL) shallow.crossentropy.VAL] ;
      endfor
      skl = real(skl) ;
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
jSKL = 2 ; 	    # ETS
for jNET = 1 : length(NET)

   net = NET{jNET} ; sfx = sprintf("data/%s.%02d/%dx%d", REG, NH, RES{jNET}) ;
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.lname) ;
   dfile = sprintf("%s/Deep.%s.%s.%s.ob", sfx, net, ind, pdd.lname) ;

   if isnewer(mfile, ptfile, pdfile, dfile)

      load(mfile) ;
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
	    if rows(skl) >= i
	       i++ ;
	       continue ;
	    endif
	 endif

	 kfail = 0 ; wskl = 0 ;
	 while ++kfail <= 5 && wskl <= 0.3
	    [deep weights] = Deep(ptr, pdd, solverstate, SKL) ;
	    wskl = deep.skl.VAL.(SKL{jSKL}) ;
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
	 skl(i,:) = [cellfun(@(s) deep.skl.VAL.(s), SKL) deep.crossentropy.VAL] ;
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
      model = sprintf("models/%s/%s.%02d/%s.%s.%s_deploy.prototxt", net, REG, NH, net, ind, pdd.lname) ;
      weights = sprintf("%s/%s.%s.%s.caffemodel", sfx, net, ind, pdd.lname) ;
      printf("<-- %s\n", weights) ;
      deploy = caffe.Net(model, weights, 'test') ;
      ptr.img = arr2img(ptr.x, RES{jNET}) ;
      deep.prob = apply_net(scale*ptr.img, deploy) ;
   endif

endfor

profshow ;
profile off ;
T = profile("info") ;
save -text prof.ot T
exit

### historical and future simulations
load(ptfile = sprintf("data/%s.%02d/%s.%s.ob", REG, NH, ind, pdd.lname)) ;
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

   glb = glob(sprintf("data/%s.%02d/Shallow.*.%s.%s.ot", REG, NH, ptr.ind, pdd.lname)) ;
   glb = union(glb, glob(sprintf("models/*/%s.%02d/*.%s.%s_iter_*.caffemodel", REG, NH, ind, pdd.lname))) ;
   glb = union(glb, glob(sprintf("esgf/*.%s.ob", sim))) ;
   glb = union(glb, glob(sprintf("data/%s.ob", sim))) ;

   if isnewer(ptfile = sprintf("data/%s.%s.%s.ob", sim, ind, pdd.lname), glb{:})

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
	 sfile = sprintf("data/%s.%02d/Shallow.%s.%s.%s.ot", REG, NH, mdl, ptr.ind, pdd.lname) ;
	 printf("<-- %s\n", sfile) ;
	 load(sfile) ;
	 out = sprintf("%s.prob.Shallow.%s = Shallow(%s.prob, shallow, PCA, [], mdl) ;", sim, mdl, sim) ;
	 eval(out) ;
      endfor
      
      for jNET = 1 : length(NET(JNET))
	 net = NET(JNET){jNET} ; res = RES(JNET){jNET} ;
	 pfx = sprintf("models/%s/%s.%02d/%s.%s.%s", net, REG, NH, net, ind, pdd.lname) ;
	 model = sprintf("%s_deploy.prototxt", pfx) ;
	 if exist(model, "file") ~= 2
	    warning("model not found: %s\n", model) ;
	    continue ;
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

source plots.m ;
