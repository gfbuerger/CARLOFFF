
global isoctave LON LAT REG NH MON PENALIZED

set(0, "defaultaxesfontsize", 26, "defaulttextfontsize", 30) ;

addpath ~/oct/nc/borders
[glat glon] = borders("germany") ;
GLON = [min(glon) max(glon)] ; GLAT = [min(glat) max(glat)] ;
LON = GLON ; LAT = GLAT ; REG = "DE" ; # whole Germany
##LON = [6 10] ; LAT = [51 54] ; REG = "NW" ; # Nordwest
##LON = [7 10] ; LAT = [47.5 49.5] ; REG = "SW" ; # Südwest
##LON = [9 14] ; LAT = [47.5 51] ; REG = "SE" ; # Südost
##LON = [9.7 9.9] ; LAT = [49.0 49.3] ; REG = "BB" ; # Braunsbach
MON = 5 : 8 ;
NH = 24 ; # relevant hours

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

addpath ~/CARLOFFF/fun
[~, ~] = mkdir("data/CARLOFFF")
cd ~/CARLOFFF
mkdir(sprintf("data/%s.%02d", REG, NH)) ; mkdir(sprintf("nc/%s.%02d", REG, NH)) ;
scale = 0.00390625 ; % MNIST
Q0 = 0.95 ;

if isnewer(afile = "data/atm.ob", glob("data/ind/*.nc"){:})
   load(afile) ;
else
   F = glob("data/ind/*.nc")' ;
   lon = ncread(F{1}, "longitude") ;
   lat = ncread(F{1}, "latitude") ;
   if (Llat = lat(1) > lat(end)) lat = flip(lat) ; endif
   t = ncread(F{1}, "time") ;
   id = nctime(t, :, :) ;
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
      eval(sprintf("%s.id = id ;", v{:})) ;
      eval(sprintf("%s.x = x(:,JLON,JLAT) ;", v{:})) ;
      eval(sprintf("%s.lon = lon(JLON) ;", v{:})) ;
      eval(sprintf("%s.lat = lat(JLAT) ;", v{:})) ;
      eval(sprintf("%s.name = VAR{j} ;", v{:})) ;
   endfor
   save(afile, VAR{:}, "VAR", "LVAR") ;
endif

PDD = {"cape" "cp" "regnie" "RR" "CatRaRE"}{1} ;
switch PDD
   case {"cape" "cp"}
      if isnewer(dfile = sprintf("data/%s.%s.ob", REG, PDD), "data/atm.ob")
	 load(dfile) ;
      else
	 eval(sprintf("pdd = sel_ptr(%s, LON, LAT, Q0) ;", PDD)) ;
	 save(dfile, "pdd") ;
      endif
   case "regnie"
      if isnewer(dfile = sprintf("data/%s.%s.ob", REG, PDD), "fun/regnie.m")
	 load(dfile) ;
      else
	 R0 = 10 ; # from climate explorer
	 rfile = "https://opendata.dwd.de/climate_environment/CDC/grids_germany/daily/regnie" ;
	 pdd = regnie(rfile, 2001, 2020, R0) ;
	 save(dfile, "pdd") ;
      endif
      x0 = quantile(pdd.x, Q0) ;
      pdd.x(pdd.x <= x0,:) = NaN ;
   case "RR"
      if exist(dfile = sprintf("data/%s.dwd.%s.ob", REG, PDD), "file") == 2
	 load(dfile) ;
      else
	 pdd = read_dwd("nc/StaedteDWD/klamex_with_coords.csv") ;
	 save(dfile, "pdd") ;
      endif
##      pdd.x = pdd.x(:,3) ; # use RRmean
##      pdd.x = pdd.x(:,5) ; # use Eta
##      pdd.x = pdd.x(:,6) ; # use RRmax
   case "CatRaRE"
      if exist(dfile = sprintf("data/%s.dwd.%s.ob", REG, PDD), "file") == 2
	 load(dfile) ;
      else
	 pdd = read_klamex("nc/StaedteDWD/CatRaRE_2001_2020_W3_Eta_v2021_01.csv") ;
	 save(dfile, "pdd") ;
      endif
##      pdd.x = pdd.x(:,3) ; # use RRmean
##      pdd.x = pdd.x(:,5) ; # use Eta
##      pdd.x = pdd.x(:,6) ; # use RRmax
endswitch
pdd.name = PDD ;

JVAR = [2 3 4 5 10 11] ;
jVAR = JVAR(1) ; # cape
ind = sprintf("%d%d", ind2log(JVAR, numel(VAR))) ;
if isnewer(pfile = sprintf("data/%s.%02d/%s.%s.ob", REG, NH, ind, pdd.name), afile, dfile)

   load(pfile) ;

else
   
   ## select predictors
   if isempty(JVAR) JVAR = [1 : length(VAR)] ; endif
   jVAR = JVAR(1) ; eval(sprintf("N = size(%s.x) ;", VAR{jVAR})) ;
   eval(sprintf("ptr = %s ;", VAR{jVAR})) ; ptr = rmfield(ptr, "x") ;
   j = 0 ;
   for jVAR = JVAR(1:end)
      eval(sprintf("x = %s.x ;", VAR{jVAR})) ;
      clear(VAR{jVAR}) ;
      if any(isnan(x(:))) continue ; endif
      j++ ;
      if ~any(x(:) < 0)
	 xm = 0 ;
      else
	 xm = nanmean(x(:)) ;
      endif
      xs = nanstd(x(:)) ;
      ptr.x(:,j,:,:) = (x - xm) ./ xs ;
      ptr.vars{j} = VAR{jVAR} ;
   endfor
   ptr.scale = scale ;
   ptr.ind = ind ;
   ptr.pfile = pfile ;
   ##n = length(ptr.var) ;
   ##for i = 1:n
   ##   disp(arrayfun(@(j) ndcorr(ptr.x(:,i,:,:), ptr.x(:,j,:,:)), find(1:n ~= i))) ;
   ##endfor

   id0 = [2001 5 1 0] ; id1 = [2019 8 31 23] ;
   ptr = unifid(ptr, id0, id1, MON) ;
   pdd = togrid(pdd, ptr.lon, ptr.lat) ;
   pdd = unifid(pdd, id0, id1, MON) ;

   ## plot pdd statistics
   if 0
      for jVAR = JVAR
	 plot_pdd(pdd, jVAR) ;
      endfor
   endif

   pdd.x(isinf(pdd.x)) = 0 ;

   if 0
      plot_hrs(pdd) ;
   endif
   
   ## aggregate
   ptr = agg(ptr, NH) ;
   pdd = agg(pdd, NH) ;

   save(pfile, "ptr", "pdd") ;
   
endif

if 0
   ## select predictand and hours
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

w = pdd.x(:,1,:,:) ;
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

 ##logistic regression
PENALIZED = true ;
if isnewer(mfile = sprintf("data/%s.%02d/lreg.%s.%s.ob", REG, NH, ptr.ind, pdd.name), pfile)
   load(mfile) ;
else
   varargin = {} ;
##   varargin = {"lambdamax", 1e3, "lambdaminratio", 1e-3} ;
   [lreg ptr1] = run_lreg(ptr, pdd, [], "CVE", {"HSS" "GSS" "PHI" "CSI"}, varargin{:}) ;
   save(mfile, "lreg", "ptr1") ;
endif
strucdisp(lreg.skl) ;
plot_fit(lreg.fit) ;
set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
set(findall("type", "axes"), "fontsize", 24) ;
set(findall("type", "text"), "fontsize", 22) ;

## caffe
if isnewer(mfile = sprintf("data/%s.%02d/caffe.%s.%s.ob", REG, NH, ptr.ind, pdd.name), pfile)
   load(mfile) ;
else
   netonly = ~true ;
   caffe = run_caffe(ptr, pdd, "cifar10", netonly, {"HSS" "GSS" "PHI" "CSI"}) ;
   save(mfile, "caffe") ;
endif
strucdisp(caffe.skl) ;

caffe = run_caffe(ptr, pdd, "logreg") ;
strucdisp(caffe) ;

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
