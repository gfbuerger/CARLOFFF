
global isoctave LON LAT REG NH MON MODE IMB

set(0, "defaultaxesfontsize", 26, "defaulttextfontsize", 30) ;

addpath ~/oct/nc/borders ~/CARLOFFF/fun
[~, ~] = mkdir("data/CARLOFFF")
cd ~/CARLOFFF
mkdir(sprintf("data/%s.%02d", REG, NH)) ; mkdir(sprintf("nc/%s.%02d", REG, NH)) ;
[glat glon] = borders("germany") ;
GLON = [min(glon) max(glon)] ; GLAT = [min(glat) max(glat)] ;
##LON = GLON ; LAT = GLAT ; REG = "DE" ; # whole Germany
LON = [6 10] ; LAT = [51 54] ; REG = "NW" ; # Nordwest
##LON = [7 10] ; LAT = [47.5 49.5] ; REG = "SW" ; # Südwest
##LON = [9 14] ; LAT = [47.5 51] ; REG = "SE" ; # Südost
##LON = [9.7 9.9] ; LAT = [49.0 49.3] ; REG = "BB" ; # Braunsbach
ID = [2001 5 1 0 ; 2020 8 31 23] ;
MON = 5 : 8 ;
NH = 24 ; # relevant hours
scale = 0.00390625 ; % MNIST
Q0 = 0.99 ;
IMB = "notSMOTE" ;

##{
isoctave = @() exist("OCTAVE_VERSION","builtin") ~= 0 ;
if isoctave()
   pkg load hdf5oct netcdf statistics
##   addpath /opt/src/caffe/Build/octave ; # make
   addpath /opt/caffe/matlab ; # cmake
   addpath /opt/src/caffe/octave
   addpath /opt/src/caffe/octave/+caffe/private
   caffe.set_mode_gpu() ;
   caffe.set_device(0) ;
else
   addpath /opt/caffeML/matlab
end

if isnewer(afile = "data/atm.ob", glob("data/ind/*.nc"){:})
   load(afile) ;
else
   F = glob("data/ind/*.nc")' ;
   lon = ncread(F{1}, "longitude") ;
   lat = ncread(F{1}, "latitude") ;
   if (Llat = lat(1) > lat(end)) lat = flip(lat) ; endif
   nc = ncinfo(F{1}) ;
   id = nctime(F{1}) ;
   JLON = GLON(1) <= lon & lon <= GLON(2) ;
   JLAT = GLAT(1) <= lat & lat <= GLAT(2) ;
   JLON = JLON | true ; JLAT = JLAT | true ; # allow tolerance

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

JVAR = [2 3 4] ;
FILL = true ;
ind = sprintf("%d%d", ind2log(JVAR, numel(VAR))) ;
if isnewer(ptfile = sprintf("data/%s.%02d/%s.%s.ob", REG, NH, ind, pdd.name), afile, pdfile)

   load(ptfile) ;

else
   
   ## select predictors
   str = sprintf("%s,", VAR{JVAR}) ; str = str(1:end-1) ;
   eval(sprintf("ptr = selptr(scale, ind, ptfile, ID, FILL, %s) ;", str))
   ptr.name = "ptr" ;
   
   ptr.ptfile = ptfile ;
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
write_H(pdd.c) ;

%% write train (CAL) & test (VAL) data
ptr.YCAL = [2001 5 1 0 ; 2010 8 31 23] ;
ptr.YVAL = [2011 5 1 0 ; 2020 8 31 23] ;

if 0
   ## test with reduced major class
   [rptr rpdd] = redclass(ptr, pdd, 0.8) ;
endif

## logistic regression
MODE = "penalized" ;
if isnewer(mfile = sprintf("data/%s.%02d/lreg.%s.%s.ob", REG, NH, ptr.ind, pdd.name), ptfile)
   load(mfile) ;
else
   varargin = {} ;
##   varargin = {"lambdamax", 1e3, "lambdaminratio", 1e-3} ;
   lreg = run_lreg(ptr, pdd, [], "CVE", {"HSS" "GSS"}, varargin{:}) ;
   save(mfile, "lreg") ;
endif
strucdisp(lreg.skl) ;
plot_fit(lreg.fit) ;
set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
set(findall("type", "axes"), "fontsize", 24) ;
set(findall("type", "text"), "fontsize", 22) ;

## nnet
NET = {"simple1" "simple2" "logreg" "cifar10" "mnist"}{1} ;
if isnewer(mfile = sprintf("data/%s.%02d/nnet.%s.%s.%s.ob", REG, NH, NET, ptr.ind, pdd.name), ptfile)
   load(mfile) ;
else
   init_rnd(1) ;
   solverstate = "" ;
##   solverstate = "HHH" ;
##   solverstate = "models/simple1/cape_iter_3000.solverstate" ;
##   solverstate = "models/simple1/CatRaRE_iter_10000.solverstate" ;
   [nnet ptr.prob] = run_caffe(ptr, pdd, NET, solverstate, {"HSS" "GSS"}) ;
   strucdisp(nnet.skl) ;
   cmd = sprintf("python /opt/src/caffe/python/draw_net.py models/%s/%s.prototxt nc/%s.svg", NET, PDD, NET) ;
   system(cmd) ;
   save(mfile, "nnet") ;
   save(ptr.ptfile, "ptr") ;
endif
strucdisp(nnet.skl) ;

## cases
## June 2013
clf ;
D1 = [2013, 5, 15 ; 2013, 6, 15] ; d1 = [2013 5 30] ;
plot_case(lreg.prob, pdd, D1, d1) ;
set(findall("-property", "fontname"), "fontname", "Linux Biolinum", "fontsize", 24) ;
print(sprintf("nc/%s.%02d/2013-06.png", REG, NH)) ;

for jVAR = 1 : numel(ptr.vars)
   clf ;
   ds = datestr(datenum(d1), "yyyy-mm-dd") ;
   I = sdate(ptr.id, d1) ;
   xm = zscore(squeeze(ptr.x(:,jVAR,:,:))) ;
   xm = squeeze(xm(I,:,:)) ;
   imagesc(ptr.lon, ptr.lat, xm') ;
   set(gca, "ydir", "normal", "clim", [-3 3]) ;
   ##title(sprintf("normalized %s for %s", toupper(ptr.vars{jVAR}), ds)) ;
   hc = colorbar ;
   colormap(redblue)
   xlabel("longitude") ; ylabel("latitude") ;
   
   hold on
   hb = borders("germany", "color", "black") ;

   set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
   set(findall("type", "axes"), "fontsize", 14) ;
   set(findall("type", "text"), "fontsize", 22) ;
   hgsave(sprintf("nc/%s.2013-06.og", ptr.vars{jVAR})) ;
   print(sprintf("nc/%s.2013-06.png", ptr.vars{jVAR})) ;
endfor

## July 2014
D1 = [2014 7 15 ; 2014 8 15] ; d1 = [2014 7 28] ;
plot_case(ptr, pdd, lreg.prob, D1, d1, jVAR) ;

## May 2016
D1 = [2016, 5, 15 ; 2016, 6, 15] ; d1 = [2016 5 29] ;
plot_case(ptr, pdd, lreg.prob, D1, d1, jVAR) ;


plot_case(lreg.prob, pdd, D1, d1) ;
set(findall("-property", "fontname"), "fontname", "Linux Biolinum", "fontsize", 24) ;
print(sprintf("nc/%s.%02d/2016-05.png", REG, NH)) ;

clf ; jVAR = 1 ;
ds = datestr(datenum(d1), "yyyy-mm-dd") ;

I = sdate(ptr.id, d1) ;
xm = zscore(squeeze(ptr.x(:,jVAR,:,:))) ;
xm = squeeze(xm(I,:,:)) ;
imagesc(ptr.lon, ptr.lat, xm') ;
set(gca, "ydir", "normal", "clim", [-3 3]) ;
##title(sprintf("normalized %s for %s", toupper(ptr.vars{jVAR}), ds)) ;
hc = colorbar ;
colormap(redblue)
xlabel("longitude") ; ylabel("latitude") ;
##   set(get(hc, "Title"), "string", "[%]") ;
   
hold on
hb = borders("germany", "color", "black") ;

set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
set(findall("type", "axes"), "fontsize", 14) ;
set(findall("type", "text"), "fontsize", 22) ;
hgsave(sprintf("nc/%s.2016-05.og", ptr.vars{jVAR})) ;
print(sprintf("nc/%s.2016-05.png", ptr.vars{jVAR})) ;


clf ;
I = sdate(pdd.id, d1) ;
w = pdd.x(I,1,:,:) ;
xm = squeeze(any(w > pdd.q, 1)) ;
imagesc(pdd.lon-0.125, pdd.lat-0.125, xm') ;
xticks(pdd.lon) ; yticks(pdd.lat) ; 
set(gca, "ydir", "normal") ;
colormap(flip(gray(5)))
title(sprintf("%s > 0 for %s", toupper(pdd.vars{1}), ds)) ;
set(gca, "xtick", [], "ytick", [], "xticklabel", [], "yticklabel", [])
##xlabel("longitude") ; ylabel("latitude") ;
   
hold on
hb = borders("germany", "color", "black") ;

set(findall("-property", "fontname"), "fontname", "Linux Biolinum", "fontsize", 30) ;
hgsave(sprintf("nc/%s.%02d/%s.2016-05.og", REG, NH, pdd.vars{1})) ;
print(sprintf("nc/%s.%02d/%s.2016-05.png", REG, NH, pdd.vars{1})) ;
##}

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
      eval(sprintf("%s.lreg.prob = run_lreg(%s, lreg, [], []) ;", sim, sim)) ;

      save(ptfile, sim) ;
   endif

endfor

### plots
global COLORORDER
COLORORDER = [0.8 0.2 0.2 ; 0.2 0.8 0.2 ; 0.2 0.2 0.8]([3 2],:) ;
set(0, "defaultaxesfontname", "Linux Biolinum", "defaultaxesfontsize", 24) ;
set(0, "defaulttextfontname", "Linux Biolinum", "defaulttextfontsize", 22, "defaultlinelinewidth", 2) ;

# nnet training
clf ;
plot_log("models/simple1/CatRaRE.log", {"Train" "Test"}, "loss") ;
hgsave(sprintf("nc/plots/%s.loss.og", NET)) ;
print(sprintf("nc/plots/%s.loss.png", NET)) ;

# 
I = pdd.id(:,1) == 2016 & ismember(pdd.id(:,2), MON) ;
printf("average rate Eta > 0: %7.0f%%\n", 100*sum(any(any(pdd.x(:,1,:,:) > 0, 3), 4)) / rows(pdd.x)) ;
scatter(datenum(pdd.id(I,:)), nanmean(nanmean(pdd.x(I,1,:,:), 3), 4), 60, "k", "filled") ; axis tight
set(gca, "ytick", [0 0.01 0.02])
xlabel("") ; ylabel("Eta") ;
datetick("mmm") ;
hgsave(sprintf("nc/plots/Eta.og")) ;
print(sprintf("nc/plots/Eta.svg")) ;

for mdl = {"lreg" "nnet"}
   mdl = mdl{:} ;
   clf ; hold on ; clear h ; j = 0 ;
   for sim = SIM
      eval(sprintf("sim = %s ;", sim{:})) ; j++ ;
      eval(sprintf("[s.id s.x] = annstat(sim.id, sim.%s.prob, @nanmean) ;", mdl)) ;
      scatter(s.id(:,1), s.x(:,2), 20, 0.8*COL{j}, "filled") ; axis tight
      h(j) = plot(s.id(:,1), smooth(s.x(:,2), 1), "color", COL{j}, "linewidth", 5) ;
      xlabel("year") ; ylabel(sprintf("prob (WS {\\geq 3})", 0.3)) ;
   endfor
   set(gca, "ygrid", "on") ;
   legend(h, NSIM, "box", "off", "location", "northwest") ;
   hgsave(sprintf("nc/plots/%s.sim.og", mdl)) ;
   print(sprintf("nc/plots/%s.sim.png", mdl)) ;
endfor
