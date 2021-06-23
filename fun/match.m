## usage: s = match (u, v)
##
## find matching lons, lats
function s = match (u, v, id0, id1, MON)

   u = unifid(u, id0, id1, MON) ;
   v = unifid(v, id0, id1, MON) ;

   s = u ;
   
   Ilon = lookup(u.lon, v.lon) ;
   Ilat = lookup(u.lat, v.lat) ;

   x = cell2mat(arrayfun(@(i) u.x(i, :, Ilon(i), Ilat(i)), 1 : rows(u.x), "UniformOutput", false)') ;

   s.x = x ;

   s.lon = u.lon(Ilon) ;
   s.lat = u.lat(Ilat) ;

endfunction
