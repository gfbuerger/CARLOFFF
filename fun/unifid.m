## usage: v = unifid (u, id0, id1, MON)
##
## find matching events
function v = unifid (u, id0, id1, MON)

   v = selper(u, id0, id1) ;
   
   if nargin < 4
      MON = 1 : 12 ;
   endif
   
   t0 = datenum(id0) ;
   t1 = datenum(id1) ;

   tv = datenum(v.id) ;

   dt = round(1 / min(diff(tv))) ;
   t = (t0 : 1/dt : t1)' ;

   id = datevec(t) ;
   I = ismember(id(:,2), MON) ;
   id = id(I,:) ;
   t = t(I) ;

   I = lookup(t, tv) ;
##   i0 = find(I == I(1))(end) ;
##   i1 = find(I == I(end))(1) ;
##   I = I(i0:i1) ;
   
   idx.type = "()" ; idx.subs = repmat({":"}, 1, ndims(v.x)) ;
   idx.subs{1} = I ;

   v.id = id(:,1:4) ;

   N = size(v.x) ;
   x = -inf([rows(v.id), N(2:end)]) ;

   v.x = subsasgn(x, idx, v.x) ;

endfunction
