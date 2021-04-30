## usage: s = match (u, v)
##
## find matching events
function s = match (u, v)

   s = u ;
   
   idx.type = "()" ;
   idx.subs = repmat({":"}, 1, ndims(u.x)) ;

   tu = datenum(u.id) ;
   tv = datenum(v.id) ;

   idx.subs{1} = I = lookup(tu, tv) ;

   id = u.id(I,:) ;
   x = subsref(u.x, idx) ;

   Ilon = lookup(u.lon, v.lon) ;
   Ilat = lookup(u.lat, v.lat) ;

   x = cell2mat(arrayfun(@(i) x(i, :, Ilon(i), Ilat(i)), 1 : rows(x), "UniformOutput", false)') ;

   s.id = id ;
   s.x = x ;

   s.lon = u.lon(Ilon) ;
   s.lat = u.lat(Ilat) ;

endfunction
