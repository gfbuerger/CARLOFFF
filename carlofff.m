
global isoctave LON LAT REG PENALIZED

GLON = [6 11] ; GLAT = [56 47] ;
##   LON = [6 10] ; LAT = [51 54] ; Nordwest
REG = "SW" ;
LON = [7 9] ; LAT = [47.5 49] ; # Südwest
LON = [8 8.5] ; LAT = [48.5 48.8] ; # point

LON = [9.7 9.9] ; LAT = [49.0 49.3] ; # Braunsbach
REG = "BB" ;

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
VAR = {"cape" "cp"} ;

if exist(afile = "data/atm.ob", "file") == 2
   load(afile) ;
else
   ncf = "data/wnd.nc" ;
   t = ncread(ncf, "time") ;
   wnd.id = nctime(t, :, :) ;
   wnd.u = permute(ncread(ncf, "u"), [4 1 2 3]) ;
   wnd.v = permute(ncread(ncf, "v"), [4 1 2 3]) ;
   ncf = "data/ind.nc" ;
   t = ncread(ncf, "time") ;
   lon = ncread(ncf, "longitude") ;
   lat = ncread(ncf, "latitude") ;
   id = nctime(t, :, :) ;
   Ilon = lookup(lon, GLON) ;
   Ilat = lookup(lat, GLAT) ;
   lon = lon(Ilon(1):Ilon(2)) ; lat = lat(Ilat(1):Ilat(2)) ;
   for v = VAR
      x = squeeze(ncread(ncf, v{:}, [Ilon(1) Ilat(1) 1], [numel(lon) numel(lat) Inf])) ;
      x = permute(x, [3 1 2]) ; # all data are N x W x H
      eval(sprintf("%s.id = id ;", v{:})) ;
      eval(sprintf("%s.x = x ;", v{:})) ;
      eval(sprintf("%s.lon = lon ;", v{:})) ;
      eval(sprintf("%s.lat = lat ;", v{:})) ;
   endfor
   save(afile, VAR{:}, "GLON", "GLAT") ;
end

PDD = {"cape" "cp" "regnie" "RR"}{3} ;
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
      pdd.x = pdd.x(:,3) ; # use RRmean
      pdd.x = pdd.x(:,6) ; # use RRmax
endswitch
pdd.name = PDD ;
pdd.q = quantile(pdd.x, Q0) ;
pdd.c = lookup(pdd.q, pdd.x) ;
write_H(pdd.c, 1.0, sprintf("data/%s.%s.H.h5", REG, pdd.name)) ;

## select predictors
JVAR = [1 2] ;
jVAR = JVAR(1) ; eval(sprintf("N = size(%s.x) ;", VAR{jVAR})) ;
eval(sprintf("ptr = %s ;", VAR{jVAR})) ; ptr = rmfield(ptr, "x") ;
j = 0 ;
for jVAR = JVAR(1:end)
   j++ ;
   eval(sprintf("xm = nanmean(%s.x(:)) ;", VAR{jVAR})) ;
   eval(sprintf("xs = nanstd(%s.x(:)) ;", VAR{jVAR})) ;
   eval(sprintf("ptr.x(:,%d,:,:) = (%s.x - xm) ./ xs ;", j, VAR{jVAR})) ;
endfor

[~, ptr.I, pdd.I] = intersect(datenum(ptr.id(:,1:3)), datenum(pdd.id(:,1:3))) ;
ptr.I = ind2log(ptr.I, size(ptr.id, 1))' ;
pdd.I = ind2log(pdd.I, size(pdd.id, 1))' ;

ptr.scale = scale ;
ptr.ind = sprintf("%d%d", ind2log(JVAR, numel(VAR))) ;

%% write train (CAL) & test (VAL) data
ptr.YCAL = [2001 4 26 ; 2010 9 30] ;
ptr.YVAL = [2011 4 26 ; 2019 8 31] ;

##logistic regression
PENALIZED = true ;
[lreg ptr1] = run_lreg(ptr, pdd, 100, "AIC", :) ;
save(sprintf("data/lreg.%s.%s.ob", ptr.ind, pdd.name), "lreg", "ptr1") ;
strucdisp(lreg) ;

## caffe
##load(sprintf("data/lreg.%s.%s.ob", ptr.ind, pdd.name)) ;
caffe = run_caffe(ptr, pdd, "cnn1") ;
strucdisp(caffe) ;
save(sprintf("data/caffe.%s.%s.ob", ptr.ind, pdd.name), "caffe") ;

caffe = run_caffe(ptr, pdd, "logreg") ;
strucdisp(caffe) ;
