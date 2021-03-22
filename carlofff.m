
global isoctave LON LAT REG

GLON = [6 11] ; GLAT = [47 56] ;
##   LON = [6 10] ; LAT = [51 54] ; Nordwest
REG = "SW" ;
LON = [7 9] ; LAT = [47.5 49] ; # Südwest
LON = [8 8.5] ; LAT = [48.5 48.8] ; # point

isoctave = @() exist("OCTAVE_VERSION","builtin") ~= 0 ;
if isoctave()
   pkg load hdf5oct netcdf
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
   Ilon = find(lookup(LON, lon) > 0) ;
   Ilat = find(lookup(LAT, lat) > 0) ;
   lon = lon(Ilon) ; lat = lat(Ilat) ;
   for v = VAR
      x = squeeze(ncread(ncf, v{:}, [Ilon(1) Ilat(1) 1 1], [numel(Ilon) numel(Ilat) 1 Inf])) ;
      x = permute(x, [3 1 2]) ; # all data are N x W x H
      eval(sprintf("%s.id = id ;", v{:})) ;
      eval(sprintf("%s.x = x ;", v{:})) ;
      eval(sprintf("%s.lon = lon ;", v{:})) ;
      eval(sprintf("%s.lat = lat ;", v{:})) ;
   endfor
   save(afile, VAR{:}, "GLON", "GLAT") ;
end

PDD = {"cape" "cp" "regnie" "RR"}{2} ;
switch PDD
   case "RR"
      if exist(dfile = sprintf("data/dwd.%s.ob", REG), "file") == 2
	 load(dfile) ;
      else
	 pdd = read_dwd("nc/StaedteDWD/klamex_with_coords.csv") ;
	 save(dfile, "pdd") ;
      endif
   case {"cape" "cp"}
      if exist(dfile = sprintf("data/%s.%s.ob", REG, PDD), "file") == 2
	 load(dfile) ;
      else
	 eval(sprintf("pdd = sel_ptr(%s, LON, LAT) ;", PDD)) ;
	 save(dfile, "pdd") ;
      endif
   case "regnie"
      if isnewer(dfile = sprintf("data/%s/%s.%s.ob", PDD, REG, PDD), "fun/regnie.m")
	 load(dfile) ;
      else
	 pdd = regnie("https://opendata.dwd.de/climate_environment/CDC/grids_germany/daily/regnie") ;
	 save(dfile, "pdd") ;
	 exit ;
      endif
endswitch
pdd.name = PDD ;
pdd.q = quantile(pdd.x, Q0) ;
pdd.c = lookup(pdd.q, pdd.x) ;
write_H(pdd.c, 1.0, sprintf("data/%s.%s.H.h5", REG, pdd.name)) ;

## select predictors
JVAR = [2] ;
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

%% write train (CAL) & test (VAL) data
ptr.YCAL = [2001 4 26 ; 2010 9 30] ;
ptr.YVAL = [2011 4 26 ; 2019 8 31] ;

## logistic regression
##lreg = run_lreg(ptr, pdd, "levfit", :, "nlambda", 1000, "lambdamax", 1000) ;
lreg = run_lreg(ptr, pdd, 100, :) ;
strucdisp(lreg) ;

## caffe
caffe = run_caffe(ptr, pdd, "cnn1") ;
strucdisp(caffe) ;
