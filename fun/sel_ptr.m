## usage: pdd = sel_ptr (s, LON, LAT)
##
## select areal ptr from s
function pdd = sel_ptr (s, LON=[6 11], LAT=[52 53])

   Ilon = find(lookup(LON, s.lon) > 0) ;
   Ilat = find(lookup(LAT, s.lat) > 0) ;

   pdd.id = s.id ;
   pdd.x = squeeze(mean(mean(s.x(:,Ilon,Ilat), 2), 3)) ;

endfunction
