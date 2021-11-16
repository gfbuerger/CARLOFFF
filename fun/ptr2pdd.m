## usage: pdd = ptr2pdd (s, LON, LAT, Q0)
##
## select areal ptr from s
function pdd = ptr2pdd (s, LON=[6 11], LAT=[52 53], Q0=0.8)

   Ilon = LON(1) <= s.lon & s.lon <= LON(2) ;
   Ilat = LAT(1) <= s.lat & s.lat <= LAT(2) ;

   xq = quantile(s.x(:,Ilon,Ilat)(:), Q0) ;
   I = any(any(s.x(:,Ilon,Ilat) > xq, 2), 3) ;
   
   pdd.id = s.id(I,:) ;
   pdd.x = s.x(I,Ilon,Ilat) ;

   N = size(pdd.x) ;

   [pdd.lat pdd.lon] = meshgrid(s.lat(Ilat), s.lon(Ilon)) ;

   pdd.id = repmat(pdd.id, [N(2:3) 1]) ;
   pdd.id = reshape(pdd.id, [], 4) ;

   pdd.lon = repmat(pdd.lon, [1 1 N(1)]) ;
   pdd.lat = repmat(pdd.lat, [1 1 N(1)]) ;

   pdd.lon = permute(pdd.lon, [3 1 2]) ;
   pdd.lat = permute(pdd.lat, [3 1 2]) ;

   pdd.x = pdd.x(:) ;
   pdd.lon = pdd.lon(:) ;
   pdd.lat = pdd.lat(:) ;
   
   pdd.vars = {s.name} ;
   
endfunction
