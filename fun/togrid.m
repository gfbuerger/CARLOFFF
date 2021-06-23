## usage: v = togrid (u)
##
## transform parametric to grid
function v = togrid (u, lon, lat)

   v = u ;

   t = datenum(v.id) ;

   [tv I J] = unique(t) ;

   J = parfun(@(ttv) find(t == ttv)', tv, "UniformOutput", false) ;
   D = cellfun(@(JJ) gp(v.x, v.lon, v.lat, JJ, lon, lat), J, "UniformOutput", false) ;
   D = cell2mat(D) ;
   v.x = reshape(D, columns(v.x), [], length(lon), length(lat)) ;
   v.x = permute(v.x, [2 1 3 4]) ;
   
   v.id = datevec(tv)(:,1:4) ;

   v.lon = lon ;
   v.lat = lat ;
   
endfunction


## usage: y = gp (x, xlon, ylat, JJ, lon, lat)
##
## fill grid points
function y = gp (x, xlon, ylat, JJ, lon, lat)
   
   I = lookup(lon, xlon(JJ)) ;
   J = lookup(lat, ylat(JJ)) ;

   y = -inf(columns(x), length(lon), length(lat)) ;

   for l = 1 : length(JJ)
      y(:,I(l),J(l)) = x(JJ(l),:) ;
   endfor
   
##   idx.type = "()" ;
##   idx.subs = repmat({":"}, 1, 3) ;
##   idx.subs{2} = I ;
##   idx.subs{3} = J ;

##   y = subsasgn(y, idx, x(JJ,:)) ;
##   y(:,I,J) = x(JJ,:) ;
   
endfunction
