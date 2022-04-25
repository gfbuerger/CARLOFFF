
global isoctave LON LAT REG NH MON IMB

set(0, "defaultaxesfontsize", 26, "defaulttextfontsize", 30) ;

addpath ~/carlofff/fun
pmkdir("data")
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
NH = 24 ; # relevant hours
scale = 0.00390625 ; % MNIST
Q0 = 0.99 ;
IMB = "SIMPLE" ;

##{
isoctave = @() exist("OCTAVE_VERSION","builtin") ~= 0 ;
if isoctave()
   pkg load hdf5oct statistics
   source("caffe_loc.m") ; # LOC = "/path/to/caffe"
   addpath(sprintf("%s/matlab", LOC)) ;
   addpath(sprintf("%s/matlab/+caffe/private", LOC)) ;
   caffe.set_mode_gpu() ;
   caffe.set_device(0) ;
else
   addpath /opt/caffeML/matlab
endif
pmkdir(sprintf("data/%s.%02d", REG, NH)) ; pmkdir(sprintf("nc/%s.%02d", REG, NH)) ;

if isnewer(afile = sprintf("data/atm.%s.ob", GREG), glob("data/ind/*.nc"){:})
   load(afile) ;
else
   pkg load netcdf
   F = glob("data/ind/*.nc")' ;
   lon = ncread(F{1}, "longitude") ;
   lat = ncread(F{1}, "latitude") ;
   if (Llat = lat(1) > lat(end)) lat = flip(lat) ; endif
   nc = ncinfo(F{1}) ;
   id = nctime(F{1}) ;
   JLON = GLON(1) <= lon & lon <= GLON(2) ;
   JLAT = GLAT(1) <= lat & lat <= GLAT(2) ;

   for j = 1 : length(F)
      nc = ncinfo(F{j}) ;
      VAR(j) = v = {nc.Variables.Name}(4) ;
      LVAR{j} = nc.Variables(4).Attributes(6).Value ;
      x = squeeze(ncread(F{j}, v{:})) ;
      x = permute(x, [3 1 2]) ; # all data are N x W x H
      if Llat x = flip(x, 3) ; endif
      [id x] = selmon(id, x) ;
      eval(sprintf("%s.id = id ;", v{:})) ;
      eval(sprintf("%s.x = x(:,JLON,JLAT) ;", v{:})) ;
      eval(sprintf("%s.lon = lon(JLON) ;", v{:})) ;
      eval(sprintf("%s.lat = lat(JLAT) ;", v{:})) ;
      eval(sprintf("%s.name = VAR{j} ;", v{:})) ;
      ## aggregate
      eval(sprintf("%s = agg(%s, NH) ;", v{:}, v{:})) ;
   endfor
   save(afile, VAR{:}, "VAR", "LVAR") ;
endif

PDD = {"cape" "cp" "regnie" "RR" "CatRaRE"}{5} ;
if exist(pdfile = sprintf("data/%s.%s.ob", REG, PDD), "file") == 2
   load(pdfile) ;
else
   ## select predictand
   jV = find(strcmp(PDD, VAR)) ; if isempty(jV) jV = 1 ; endif
   str = sprintf("%s,", VAR{:}) ; str = str(1:end-1) ;
   eval(sprintf("pdd = selpdd(PDD, LON, LAT, ID, Q0, %s) ;", VAR{jV}))
   ## aggregate
   pdd = agg(pdd, NH) ;
   save(pdfile, "pdd") ;
endif

JVAR = [2 4 10] ;
FILL = true ;
ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
if isnewer(ptfile = sprintf("data/%s.%02d/%s.%s.ob", REG, NH, ind, pdd.name), afile, pdfile)

   load(ptfile) ;

else
   
   ## select predictors
   str = sprintf("%s,", VAR{JVAR}) ; str = str(1:end-1) ;
   eval(sprintf("ptr = selptr(scale, ind, ptfile, ID, FILL, %s) ;", str))
   ptr.name = "ptr" ;

   ## normalize with mean and std
   ptr.x = nrm_ptr(ptr.x) ;

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

w = squeeze(pdd.x(:,1,:,:)) ; # Eta
pdd.q = quantile(w(:), Q0) ;
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
SKL = {"HSS" "GSS"} ;
MDL = {"lasso" "tree" "nnet" "logr"} ;
PCA = {{} []}{1} ;
if iscell(PCA)
   ptr.ind = sprintf("R%s", ind) ;
else
   ptr.ind = sprintf("%s", ind) ;
endif
if isnewer(mfile = sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ptr.ind, pdd.name), ptfile, pdfile)
   load(mfile) ;
else
   clear skl ;
   for jMDL = 1 : length(MDL)
      mdl = MDL{jMDL} ;
      if isnewer(sfile = sprintf("data/%s.%02d/Shallow.%s.%s.%s.ot", REG, NH, mdl, ptr.ind, pdd.name), ptfile)
	 printf("<-- %s\n", sfile) ;
	 load(sfile) ;
      else
	 varargin = {} ;
##	 varargin = {"lambdamax", 1e2, "lambdaminratio", 1e-2} ;
	 shallow = Shallow(ptr, pdd, PCA, "CVE", mdl, SKL, varargin{:}) ;
	 printf("--> %s\n", sfile) ;
	 save("-text", sfile, "shallow") ;
      endif
      skl(jMDL,:) = [cellfun(@(s) shallow.skl.VAL.(s), SKL) shallow.crossentropy.VAL] ;
##      strucdisp(shallow.skl) ;
##      plot_fit(shallow.fit) ;
##      set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
##      set(findall("type", "axes"), "fontsize", 24) ;
##      set(findall("type", "text"), "fontsize", 22) ;
   endfor
   skl = real(skl) ;
   save("-text", mfile, "skl") ;
endif

## Deep
## divergent: SqueezeNet
## shape mismatch: Inception-v4
NET = {"Simple" "ResNet" "LeNet-5" "CIFAR-10" "AlexNet" "GoogLeNet" "ALL-CNN" "DenseNet" "Logreg"} ;
RES = {[32 32] [32 32] [28 28] [32 32] [227 227] [224 224] [32 32] [32 32] [32 32]} ;
jSKL = 2 ; 	    # ETS
for jNET = 1 : length(NET)

   net = NET{jNET} ; sfx = sprintf("data/%s.%02d/%dx%d", REG, NH, RES{jNET}) ;

   if isnewer(mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.name), ptfile)

      load(mfile) ;
      load(sprintf("%s/Deep.%s.%s.%s.ob", sfx, net, ind, pdd.name))

   else

      init_rnd() ;
      ptr.img = arr2img(ptr.x, RES{jNET}) ;
      ##solverstate = sprintf("%s/%s.%s.netonly", sfx, net, PDD) ;
      solverstate = sprintf("%s/%s.%s_iter_0.solverstate", sfx, net, PDD) ;
      ##solverstate = sprintf("%s/%s.cape_iter_*.solverstate", sfx, net) ;
##      solverstate = sprintf("%s/%s.%s_iter_*.solverstate", sfx, net, PDD) ;
      clear skl deep ; i = 1 ;
      while i <= 20    ## UGLY
	 if exist(sfile = sprintf("%s/skl.%s.%s.%s.ot", sfx, net, ptr.ind, pdd.name))
	    load(sfile) ;
	    if rows(skl) > i && skl(i,1) > 0.1
	       i++ ;
	       continue ;
	    endif
	 endif
	 [deep(i) weights] = Deep(ptr, pdd, solverstate, SKL) ;
	 if deep(i).skl.VAL.(SKL{end}) <= 0.1 # no convergence, repeat
	    warning("no convergence, repeating %d for %s", i, net) ;
	    continue ;
	 endif
	 system(sprintf("cp -L /tmp/caffe.INFO %s", sprintf("%s/%s.%s.%s.%02d.log", sfx, net, ptr.ind, pdd.name, i))) ;
	 rename(weights, sprintf("%s/%s.%s.%s.%02d.caffemodel", sfx, net, ptr.ind, pdd.name, i)) ;
	 skl(i,:) = [cellfun(@(s) deep(i).skl.VAL.(s), SKL) deep(i).crossentropy.VAL] ;
	 save("-text", sfile, "skl") ; i++ ;
##	 system(sprintf("nvidia-smi -f nvidia.%d.log", i)) ;
      endwhile

      rename(sfile, mfile) ;
      save(strrep(strrep(sfile, "skl.", "Deep."), ".ot", ".ob"), "deep") ;
##      plot_log("/tmp/caffe.INFO", :, iter = 0, pse = 30, plog = 0) ;
##      cmd = sprintf("python /opt/src/caffe/python/draw_net.py models/%s/%s.prototxt nc/%s.svg", net, PDD, net) ;
##      system(cmd) ;

   endif

   ## find best model and apply
   [~, i] = max(skl(:,jSKL)) ;
   deep = deep(i) ;
   deep.name = net ;
   cd(sfx) ;
   wfile = sprintf("%s.%s.%s.%02d.caffemodel", net, ind, pdd.name, i) ;
   unlink(lfile = sprintf("%s.%s.%s.caffemodel", net, ind, pdd.name)) ;
   symlink(wfile, lfile) ;
   cd ~/carlofff

   if 0
      model = sprintf("models/%s/%s.%02d/%s.%s.%s_deploy.prototxt", net, REG, NH, net, ind, pdd.name) ;
      weights = sprintf("%s/%s.%s.%s.caffemodel", sfx, net, ind, pdd.name) ;
      printf("<-- %s\n", weights) ;
      deploy = caffe.Net(model, weights, 'test') ;
      ptr.img = arr2img(ptr.x, RES{jNET}) ;
      deep.prob = apply_net(scale*ptr.img, deploy) ;
   endif

endfor


### historical and future simulations
load(ptfile = sprintf("data/%s.%02d/%s.%s.ob", REG, NH, ind, pdd.name)) ;
lon = ptr.lon ; lat = ptr.lat ; scale = ptr.scale ;
ID = [1961 1 1 ; 1990 12 31] ;
SVAR = trl_atm("atmvar.lst", JVAR) ;
SIM = {"ptr" "historical" "rcp85"}([2 3]) ;
NSIM = {"ANA" "HIST" "RCP85"}([2 3]) ;

PCA = {{} []}{2} ;
if iscell(PCA) ptr.ind = sprintf("R%s", ind) ; endif

for jSIM = 1 : length(SIM)

   sim = SIM{jSIM} ;

   ## load atmospheric variables
   for svar = SVAR
      svar = svar{:} ;

      if exist(sfile = sprintf("esgf/%s.%s.ob", svar, sim), "file") == 2

	 load(sfile) ;

      else

	 eval(sprintf("%s = read_sim(\"esgf\", svar, sim, lon, lat) ;", svar)) ;
	 
	 ## aggregate
	 eval(sprintf("%s = agg(%s, NH) ;", svar, svar)) ;
	 save(sfile, svar) ;

      endif

   endfor

   glb = glob(sprintf("data/%s.%02d/Shallow.*.%s.%s.ot", REG, NH, ptr.ind, pdd.name)) ;
   glb = union(glb, glob(sprintf("models/*/%s.%02d/*.%s.%s.caffemodel", REG, NH, ptr.ind, pdd.name))) ;
   glb = union(glb, glob(sprintf("esgf/*.%s.ob", sim))) ;

   if isnewer(ptfile = sprintf("esgf/%s.ob", sim), glb{:}) && 0

      load(ptfile) ;

   else

      ## select predictors
      str = sprintf("%s,", SVAR{:}) ; str = str(1:end-1) ;
      eval(sprintf("%s = selptr(scale, ind, ptfile, ID=[], FILL, %s) ;", sim, str))   
      eval(sprintf("%s.name = sim ;", NSIM{jSIM})) ;

      ## normalize with mean and std	 
      if strcmp(sim, "historical")
	 eval(sprintf("[%s.x %s.xm %s.xs] = nrm_ptr(%s.x) ;", sim, sim, sim, sim)) ;
      else
	 eval(sprintf("%s.x = nrm_ptr(%s.x, historical.xm, historical.xs) ;", sim, sim)) ;
      endif

      for jMDL = 1 : length(MDL)
	 mdl = MDL{jMDL} ;
	 load(sprintf("data/%s.%02d/Shallow.%s.%s.%s.ot", REG, NH, mdl, ptr.ind, pdd.name)) ;
	 out = sprintf("%s.Shallow.%s.prob = Shallow(%s, shallow, PCA, [], mdl) ;", sim, mdl, sim) ;
	 printf("%s\n", out) ;
	 eval(out) ;
      endfor
      
      for jNET = 1 : length(NET(JNET))
	 net = NET(JNET){jNET} ; res = RES(JNET){jNET} ;
	 pfx = sprintf("models/%s/%s.%02d/%s.%s.%s", net, REG, NH, net, ptr.ind, pdd.name) ;
	 model = sprintf("%s_deploy.prototxt", pfx) ;
	 if exist(model, "file") ~= 2 continue ; endif
	 weights = sprintf("%s.caffemodel", pfx) ;
	 if exist(weights, "file") ~= 2 continue ; endif
	 deploy = caffe.Net(model, weights, 'test') ;
	 eval(sprintf("%s.img = arr2img(%s.x, res) ;", sim, sim)) ;
	 out = sprintf("%s.Deep.%s.prob = apply_net(scale*%s.img, deploy) ;", sim, strrep(net, "-", "_"), sim) ;
	 printf("%s\n", out) ;
	 eval(out) ;
      endfor

      save(ptfile, sim) ;

   endif

endfor

source plots.m ;
