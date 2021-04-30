
global isoctave LON LAT REG MON PENALIZED

addpath ~/oct/nc/borders
[glat glon] = borders("germany") ;
GLON = [min(glon) max(glon)] ; GLAT = [max(glat) min(glat)] ;
LON = GLON ; LAT = GLAT ; # whole Germany
MON = 5 : 8 ;
IH = 1 : 6 : 24 ; # relevant hours
REG = "DE" ;
##   LON = [6 10] ; LAT = [51 54] ; Nordwest
##REG = "NW" ;
##LON = [7 9] ; LAT = [47.5 49] ; # Südwest
##LON = [8 8.5] ; LAT = [48.5 48.8] ; # point

##LON = [9.7 9.9] ; LAT = [49.0 49.3] ; # Braunsbach
##REG = "BB" ;

isoctave = @() exist("OCTAVE_VERSION","builtin") ~= 0 ;
if isoctave()
   pkg load hdf5oct netcdf statistics
   addpath /opt/caffe/matlab
   addpath /opt/src/caffe/matlab
   addpath /opt/src/caffe/matlab/+caffe/private
   caffe.set_mode_gpu() ;
   caffe.set_device(0) ;
else
   addpath /opt/caffeML/matlab
end

addpath ~/CARLOFFF/fun
[~, ~] = mkdir("data/CARLOFFF")
cd ~/CARLOFFF
scale = 0.00390625 ; % MNIST
Q0 = 0.8 ;

if isnewer(afile = "data/atm.ob", ind.nc = "data/ind.nc", cp.nc = "data/cp.nc")
   load(afile) ;
else
##   t = ncread(wnc, "time") ;
##   wnd.id = nctime(t, :, :) ;
##   wnd.u = permute(ncread(wnc, "u"), [4 1 2 3]) ;
##   wnd.v = permute(ncread(wnc, "v"), [4 1 2 3]) ;
   lon = ncread(ind.nc, "longitude") ;
   lat = ncread(ind.nc, "latitude") ;
   t = ncread(ind.nc, "time") ;
   id = nctime(t, :, :) ;
   Ilon = lookup(lon, GLON) ;
   Ilat = lookup(lat, GLAT) ;
   lon = lon(Ilon(1):Ilon(2)) ; lat = lat(Ilat(1):Ilat(2)) ;
   nc = ncinfo(ind.nc) ;
   VAR = {nc.Variables.Name}(4:end)(1:end~=4) ; # cin has too many NaNs
   for v = VAR
      x = squeeze(ncread(ind.nc, v{:}, [Ilon(1) Ilat(1) 1], [numel(lon) numel(lat) Inf])) ;
      x = permute(x, [3 1 2]) ; # all data are N x W x H
      eval(sprintf("%s.id = id ;", v{:})) ;
      eval(sprintf("%s.x = x ;", v{:})) ;
      eval(sprintf("%s.lon = lon ;", v{:})) ;
      eval(sprintf("%s.lat = lat ;", v{:})) ;
   endfor

   t = ncread(cp.nc, "time") ;
   id = nctime(t, :, :) ;
   x = squeeze(ncread(cp.nc, "cp", [Ilon(1) Ilat(1) 1], [numel(lon) numel(lat) Inf])) ;
   x = permute(x, [3 1 2]) ; # all data are N x W x H
   N = size(x) ;
   cp.id = id(ismember(id(:,4), [0 6 12 18]),:) ;
   cp.x = squeeze(nanmean(reshape(x, 6, [], N(2), N(3)), 1)) ;
   cp.lon = lon ; cp.lat = lat ;
   
   save(afile, VAR{:}, "VAR") ;
end

PDD = {"cape" "cp" "regnie" "RR"}{4} ;
switch PDD
   case {"cape" "cp"}
      if isnewer(dfile = sprintf("data/%s.%s.ob", REG, PDD), "data/atm.ob")
	 load(dfile) ;
      else
	 eval(sprintf("pdd = sel_ptr(%s, LON, LAT) ;", PDD)) ;
	 save(dfile, "pdd") ;
      endif
   case "regnie"
      if isnewer(dfile = sprintf("data/%s/%s.%s.ob", PDD, REG, PDD), "fun/regnie.m")
	 load(dfile) ;
      else
	 rfile = "https://opendata.dwd.de/climate_environment/CDC/grids_germany/daily/regnie" ;
	 pdd = regnie(rfile, 2001, 2020) ;
	 save(dfile, "pdd") ;
      endif
      Q0 = 0.9 ; x0 = quantile(pdd.x, Q0) ;
      pdd.x(pdd.x <= x0,:) = NaN ;
   case "RR"
      if exist(dfile = sprintf("data/dwd.%s.ob", REG), "file") == 2
	 load(dfile) ;
      else
	 pdd = read_dwd("nc/StaedteDWD/klamex_with_coords.csv") ;
	 save(dfile, "pdd") ;
      endif
##      pdd.x = pdd.x(:,3) ; # use RRmean
      pdd.x = pdd.x(:,5) ; # use Eta
##      pdd.x = pdd.x(:,6) ; # use RRmax
endswitch
pdd.name = PDD ;
pdd.q = quantile(pdd.x, Q0) ;
pdd.c = lookup(pdd.q, pdd.x) ;
write_H(pdd.c, 1.0, sprintf("data/%s.%s.H.h5", REG, pdd.name)) ;

## select predictors
JVAR = [1 : length(VAR)] ;
jVAR = JVAR(1) ; eval(sprintf("N = size(%s.x) ;", VAR{jVAR})) ;
eval(sprintf("ptr = %s ;", VAR{jVAR})) ; ptr = rmfield(ptr, "x") ;
j = 0 ;
for jVAR = JVAR(1:end)
   j++ ;
   eval(sprintf("xm = nanmean(%s.x(:)) ;", VAR{jVAR})) ;
   eval(sprintf("xs = nanstd(%s.x(:)) ;", VAR{jVAR})) ;
   eval(sprintf("ptr.x(:,%d,:,:) = (%s.x - xm) ./ xs ;", j, VAR{jVAR})) ;
   ptr.var{j} = VAR{jVAR} ;
endfor

if 1
   ptr = match(ptr, pdd) ;
else
   [~, ptr.I, pdd.I] = intersect(datenum(ptr.id(:,1:4)), datenum(pdd.id(:,1:4))) ;
   ptr.I = ind2log(ptr.I, size(ptr.id, 1))' ;
   pdd.I = ind2log(pdd.I, size(pdd.id, 1))' ;
   ptr.id = ptr.id(ptr.I,:) ; ptr.x = ptr.x(ptr.I,:,:,:) ;
   pdd.id = pdd.id(pdd.I,:) ; pdd.x = pdd.x(pdd.I,:) ;
endif
ptr.scale = scale ;
ptr.ind = sprintf("%d%d", ind2log(JVAR, numel(VAR))) ;

%% write train (CAL) & test (VAL) data
ptr.YCAL = [2001 5 1 ; 2010 8 31] ;
ptr.YVAL = [2011 5 1 ; 2020 8 31] ;

##logistic regression
PENALIZED = true ;
[lreg ptr1] = run_lreg(ptr, pdd, 100, "PCA/2", :) ;
save(sprintf("data/lreg.%s.%s.ob", ptr.ind, pdd.name), "lreg", "ptr1") ;
strucdisp(lreg) ;

## caffe
##load(sprintf("data/lreg.%s.%s.ob", ptr.ind, pdd.name)) ;
caffe = run_caffe(ptr, pdd, "cnn1") ;
strucdisp(caffe) ;
save(sprintf("data/caffe.%s.%s.ob", ptr.ind, pdd.name), "caffe") ;

caffe = run_caffe(ptr, pdd, "logreg") ;
strucdisp(caffe) ;
