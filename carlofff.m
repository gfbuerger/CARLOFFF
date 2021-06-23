
global isoctave LON LAT REG MON PENALIZED

addpath ~/oct/nc/borders
[glat glon] = borders("germany") ;
GLON = [min(glon) max(glon)] ; GLAT = [max(glat) min(glat)] ;
LON = GLON ; LAT = GLAT ; REG = "DE" ; # whole Germany
##LON = [6 10] ; LAT = [51 54] ; REG = "NW" ; # Nordwest
##GLON = LON = [7 9] ; LAT = [47.5 49] ; GLAT = flip(LAT) ; REG = "SW" ; # Südwest
##LON = [9.7 9.9] ; LAT = [49.0 49.3] ; REG = "BB" ; # Braunsbach
MON = 5 : 8 ;
NH = 6 ; # relevant hours

isoctave = @() exist("OCTAVE_VERSION","builtin") ~= 0 ;
if isoctave()
   pkg load hdf5oct netcdf statistics
   addpath /opt/src/caffe/Build/octave
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
scale = 0.00390625 ; % MNIST
Q0 = 0.8 ;

if isnewer(afile = sprintf("data/atm.%s.ob", REG), glob("data/ind/*.nc"){:})
   load(afile) ;
else
   F = glob("data/ind/*.nc")' ;
   lon = ncread(F{1}, "longitude") ;
   lat = ncread(F{1}, "latitude") ;
   t = ncread(F{1}, "time") ;
   id = nctime(t, :, :) ;
   Ilon = lookup(lon, GLON) ;
   Ilat = lookup(lat, GLAT) ;
   lon = lon(Ilon(1):Ilon(2)) ; lat = lat(Ilat(1):Ilat(2)) ;
   for j = 1 : length(F)
      nc = ncinfo(F{j}) ;
      VAR(j) = v = {nc.Variables.Name}(4) ;
      LVAR{j} = nc.Variables(4).Attributes(6).Value ;
      x = squeeze(ncread(F{j}, v{:}, [Ilon(1) Ilat(1) 1], [numel(lon) numel(lat) Inf])) ;
      x = permute(x, [3 1 2]) ; # all data are N x W x H
      eval(sprintf("%s.id = id ;", v{:})) ;
      eval(sprintf("%s.x = x ;", v{:})) ;
      eval(sprintf("%s.lon = lon ;", v{:})) ;
      eval(sprintf("%s.lat = lat ;", v{:})) ;
   endfor
   save(afile, VAR{:}, "VAR", "LVAR") ;
end

PDD = {"cape" "cp" "regnie" "RR" "CatRaRE"}{5} ;
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
	 R0 = 10 ; # from climate explorer
	 rfile = "https://opendata.dwd.de/climate_environment/CDC/grids_germany/daily/regnie" ;
	 pdd = regnie(rfile, 2001, 2020, R0) ;
	 save(dfile, "pdd") ;
      endif
      x0 = quantile(pdd.x, Q0) ;
      pdd.x(pdd.x <= x0,:) = NaN ;
   case "RR"
      if exist(dfile = sprintf("data/dwd.%s.%s.ob", PDD, REG), "file") == 2
	 load(dfile) ;
      else
	 pdd = read_dwd("nc/StaedteDWD/klamex_with_coords.csv") ;
	 save(dfile, "pdd") ;
      endif
##      pdd.x = pdd.x(:,3) ; # use RRmean
##      pdd.x = pdd.x(:,5) ; # use Eta
##      pdd.x = pdd.x(:,6) ; # use RRmax
   case "CatRaRE"
      if exist(dfile = sprintf("data/dwd.%s.%s.ob", PDD, REG), "file") == 2
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

if isnewer(pfile = sprintf("data/%s.%s.%s.ob", REG, ptr.ind, pdd.name), afile, dfile)

   load(pfile) ;

else
   
   ## select predictors
   JVAR = [2 3 4 5 6 10 12] ;
   if isempty(JVAR) JVAR = [1 : length(VAR)] ; endif
   jVAR = JVAR(1) ; eval(sprintf("N = size(%s.x) ;", VAR{jVAR})) ;
   eval(sprintf("ptr = %s ;", VAR{jVAR})) ; ptr = rmfield(ptr, "x") ;
   j = 0 ;
   for jVAR = JVAR(1:end)
      eval(sprintf("x = %s.x ;", VAR{jVAR})) ;
      clear(VAR{jVAR}) ;
      if any(isnan(x(:))) continue ; endif
      j++ ;
      xm = nanmean(x(:)) ;
      xs = nanstd(x(:)) ;
      ptr.x(:,j,:,:) = (x - xm) ./ xs ;
      ptr.vars{j} = VAR{jVAR} ;
   endfor
   ptr.scale = scale ;
   ptr.ind = sprintf("%d%d", ind2log(JVAR, numel(VAR))) ;
   ##n = length(ptr.var) ;
   ##for i = 1:n
   ##   disp(arrayfun(@(j) nthargout(3, @canoncorr, ptr.x(:,i,:,:), ptr.x(:,j,:,:))(1), find(1:n ~= i))) ;
   ##endfor

   id0 = [2001 5 1 0] ; id1 = [2019 8 31 23] ;
   ptr = unifid(ptr, id0, id1, MON) ;
   pdd = togrid(pdd, ptr.lon, ptr.lat) ;
   pdd = unifid(pdd, id0, id1, MON) ;
   pdd.q = squeeze(sum(isfinite(pdd.x), 1)) / rows(pdd.x) ; 
   ## plot pdd statistics
   jVar = 1 ; # Eta
   if 0
      for jVar = 1 : length(pdd.vars)
	 plot_pdd(pdd, jVar) ;
      endfor
   endif

   pdd.x(isinf(pdd.x)) = 0 ;
   save(pfile, "ptr", "pdd") ;
   
endif

if 0
   ptr = agg(ptr, NH) ;
   pdd = agg(pdd, NH, @nanmean) ;
endif

## select predictand and hours
jVar = 1 ; # Eta
H = 12 : 20 ; # from barplot
I = ismember(ptr.id(:,4), H) ; 
ptr.id = ptr.id(I,:) ;
ptr.x = ptr.x(I,:,:,:) ;
pdd.id = pdd.id(I,:) ;
pdd.x = squeeze(pdd.x(I,jVar,:,:)) ;

if 0
   N = size(ptr.x) ;
   ptr.id = repmat(ptr.id, prod(N(3:end)), 1) ;
   ptr.x = permute(ptr.x, [1 3:length(N) 2]) ;
   ptr.x = reshape(ptr.x, [], N(2)) ;
   pdd.id = repmat(pdd.id, prod(N(3:end)), 1) ;
   pdd.x = pdd.x(:) ;
   I = ~any(isnan([ptr.x pdd.x]), 2) ;
   ## first impression
   disp(nthargout(3, @canoncorr, ptr.x(:,1,:,:), pdd.x)) ;
endif

##pdd.q = quantile(pdd.x, Q0) ;
pdd.q = min(pdd.x(pdd.x(:) > 0)) ;
pdd.c = any(lookup(pdd.q, reshape(pdd.x, rows(pdd.x), [])), 2) ;

%% write train (CAL) & test (VAL) data
ptr.YCAL = [2001 5 1 0 ; 2010 8 31 23] ;
ptr.YVAL = [2011 5 1 0 ; 2020 8 31 23] ;

if 0
   ## test with reduced major class
   [rptr rpdd] = redclass(ptr, pdd, 0.8) ;
   write_H(pdd.c) ;
endif

##logistic regression
PENALIZED = true ;
[lreg ptr1] = run_lreg(ptr, pdd, [], "AIC", {"HSS" "GSS" "PHI" "CSI"}) ;
save(sprintf("data/lreg.%s.%s.ob", ptr.ind, pdd.name), "lreg", "ptr1") ;
load(sprintf("data/lreg.%s.%s.ob", ptr.ind, pdd.name)) ;
strucdisp(lreg.skl) ;

## caffe
##load(sprintf("data/lreg.%s.%s.ob", ptr.ind, pdd.name)) ;
##ptr.x = zscore(ptr.x, [], 1) ;
netonly = ~true ;
caffe = run_caffe(ptr, pdd, "cnn1", netonly, {"HSS" "GSS" "PHI" "CSI"}) ;
strucdisp(caffe) ;
save(sprintf("data/caffe.%s.%s.ob", ptr.ind, pdd.name), "caffe") ;
load(sprintf("data/caffe.%s.%s.ob", ptr.ind, pdd.name)) ;

caffe = run_caffe(ptr, pdd, "logreg") ;
strucdisp(caffe) ;
