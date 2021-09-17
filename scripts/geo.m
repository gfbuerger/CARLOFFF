pkg load netcdf

addpath ~/oct/nc/borders
[glat glon] = borders("germany") ;
GLON = [min(glon) max(glon)] ; GLAT = [min(glat) max(glat)] ;

ncf = "cape_EUR-11_CNRM-CERFACS-CNRM-CM5_rcp85_r1i1p1_CLMcom-ETH-COSMO-crCLIM-v1-1_v1_3hr_200601010000-200612312100.nc" ;

lon = ncread(ncf, "lon") ;
lat = ncread(ncf, "lat") ;
x = ncread(ncf, "cape") ;
JLON = GLON(1) <= lon & lon <= GLON(2) ;
JLAT = GLAT(1) <= lat & lat <= GLAT(2) ;
J = JLON & JLAT ;
n = sum(J(:)) ;
J = repmat(J, [1 1 size(x, 3)]) ;

x = reshape(x(J), n, []) ;
