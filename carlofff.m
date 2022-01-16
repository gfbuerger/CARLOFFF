
global isoctave LON LAT REG NH MON IMB

set(0, "defaultaxesfontsize", 26, "defaulttextfontsize", 30) ;

addpath ~/carlofff/fun
[~, ~] = pmkdir("data")
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
end
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
ind = sprintf("%d%d", ind2log(JVAR, numel(VAR))) ;
if isnewer(ptfile = sprintf("data/%s.%02d/%s.%s.ob", REG, NH, ind, pdd.name), afile, pdfile)

   load(ptfile) ;

else
   
   ## select predictors
   str = sprintf("%s,", VAR{JVAR}) ; str = str(1:end-1) ;
   eval(sprintf("ptr = selptr(scale, ind, ptfile, ID, FILL, %s) ;", str))
   ptr.name = "ptr" ;
   
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

w = pdd.x(:,1,:,:) ; # Eta
pdd.q = quantile(w(:), Q0) ;
pdd.c = any(any(w > pdd.q, 3), 4) ;
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
MDL = {"lasso" "tree" "nnet" "nlinfit"} ;
if isnewer(sfile = sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ptr.ind, pdd.name), ptfile, pdfile)
   load(sfile) ;
else
   for jMDL = 1 : length(MDL)
      mdl = {"lasso" "tree" "nnet" "nlinfit"}{jMDL} ;
      if isnewer(sfile = sprintf("data/%s.%02d/Shallow.%s.%s.%s.ot", REG, NH, mdl, ptr.ind, pdd.name), ptfile)
	 load(sfile) ;
      else
	 varargin = {} ;
##	 varargin = {"lambdamax", 1e2, "lambdaminratio", 1e-2} ;
	 shallow = Shallow(ptr, pdd, [], "CVE", mdl, {"HSS" "GSS"}, varargin{:}) ;
	 S(jMDL,:) = [shallow.skl.VAL.GSS shallow.crossentropy.VAL] ;
	 save("-text", sfile, "S", "shallow") ;
      endif
##      strucdisp(shallow.skl) ;
##      plot_fit(shallow.fit) ;
##      set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
##      set(findall("type", "axes"), "fontsize", 24) ;
##      set(findall("type", "text"), "fontsize", 22) ;
   endfor
   S = real(S) ;
   save("-text", sfile, "S") ;
endif

## Deep
## divergent: SqueezeNet
## shape mismatch: Inception-v4
NET = {"Simple1" "ResNet" "LeNet-5" "CIFAR-10" "AlexNet" "GoogLeNet" "ALL-CNN" "DenseNet" "Logreg"} ;
global RES = [] ;
##for jNET = 1 : length(NET)
for jNET = 9

   net = NET{jNET} ;
   RES = {[32 32] [32 32] [28 28] [32 32] [227 227] [224 224] [32 32] [32 32] [32 32]}{jNET} ;

   if isnewer(mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.new.ot", REG, NH, net, ptr.ind, pdd.name), ptfile)
      load(mfile) ;
      S(jNET) = mean(skl(:,1)) ;
   else
      init_rnd() ;
      ptr.img = arr2img(ptr.x, RES) ;
      ##solverstate = sprintf("data/%s.%02d/%dx%d/%s.%s.netonly", REG, NH, RES, net, PDD) ;
      solverstate = sprintf("data/%s.%02d/%dx%d/%s.%s_iter_0.solverstate", REG, NH, RES, net, PDD) ;
      ##solverstate = sprintf("data/%s.%02d/%dx%d/%s.cape_iter_*.solverstate", REG, NH, RES, net) ;
##      solverstate = sprintf("data/%s.%02d/%dx%d/%s.%s_iter_*.solverstate", REG, NH, RES, net, PDD) ;
      clear skl ;
      for i = 1:20
	 if exist(sfile = sprintf("data/%s.%02d/skl.%s.%s.%s.tmp.ot", REG, NH, net, ptr.ind, pdd.name))
	    load(sfile) ;
	    if rows(skl) >= i continue ; endif
	 endif
	 [deep ptr.prob] = Deep(ptr, pdd, solverstate, {"HSS" "GSS"}) ;
	 skl(i,:) = [deep.skl.VAL.GSS deep.crossentropy.VAL] ;
	 save("-text", sfile, "skl") ;
	 system(sprintf("nvidia-smi -f nvidia.%d.log", i)) ;
      endfor
      ##plot_log(sprintf("data/%s.%02d/%dx%d/%s.%s.log", REG, NH, RES, net, PDD), :, iter = 0, pse = 5, plog = 0) ;
      ##cmd = sprintf("python /opt/src/caffe/python/draw_net.py models/%s/%s.prototxt nc/%s.svg", net, PDD, net) ;
      ##system(cmd) ;
      save("-text", mfile, "skl") ;
      delete(sprintf("data/%s.%02d/skl.%s.%s.%s.tmp.ot", REG, NH, net, ptr.ind, pdd.name)) ;
      ##save(ptr.ptfile, "ptr") ;
   endif

endfor

source plots.m ;

### historical and future simulations
load(ptfile = sprintf("data/%s.%02d/%s.%s.ob", REG, NH, ind, pdd.name)) ;
lon = ptr.lon ; lat = ptr.lat ; scale = ptr.scale ;
ID = [1961 1 1 ; 1990 12 31] ;
SVAR = {"cape" "prc"} ;
SIM = {"ptr" "historical" "rcp85"}([2 3]) ;
NSIM = {"ANA" "HIST" "RCP85"}([2 3]) ;

model = "models/simple1/CatRaRE_deploy.prototxt" ;
weights = "models/simple1/CatRaRE_iter_10000.caffemodel" ;
net = caffe.Net(model, weights, 'test') ;

for jsim = 1 : length(SIM)

   sim = SIM{jsim} ;

   for svar = SVAR
      svar = svar{:} ;

      if exist(ptfile = sprintf("esgf/%s.%s.ob", svar, sim), "file") == 2

	 load(ptfile) ;

      else

	 eval(sprintf("%s = read_sim(\"esgf\", svar, sim, lon, lat) ;", svar)) ;
	 
	 ## aggregate
	 eval(sprintf("%s = agg(%s, NH) ;", svar, svar)) ;
	 save(ptfile, svar) ;

      endif

   endfor

   if exist(ptfile = sprintf("esgf/%s.ob", sim), "file") == 2

      load(ptfile) ;

   else
      
      ## select predictors
      str = sprintf("%s,", SVAR{:}) ; str = str(1:end-1) ;
      if strcmp(sim, "historical")
	 eval(sprintf("[%s %s] = selptr(scale, ind, ptfile, ID, FILL, %s) ;", sim, str, str))   
	 for svar = SVAR
	    eval(sprintf("ref.%s.xm = %s.xm ; ref.%s.xs = %s.xs ;", svar{:}, svar{:}, svar{:}, svar{:})) ;
	 endfor
      else
	 for svar = SVAR
	    eval(sprintf("%s.xm = ref.%s.xm ; %s.xs = ref.%s.xs ;", svar{:}, svar{:}, svar{:}, svar{:})) ;
	 endfor
	 eval(sprintf("%s = selptr(scale, ind, ptfile, ID=[], FILL, %s) ;", sim, str))   
      endif
      eval(sprintf("%s.name = sim ;", NSIM{jsim})) ;
      eval(sprintf("%s.nnet.prob = apply_net(scale*%s.x, net) ;", sim, sim)) ;
      eval(sprintf("%s.shallow.prob = Shallow(%s, shallow, [], []) ;", sim, sim)) ;

      save(ptfile, sim) ;
   endif

endfor
