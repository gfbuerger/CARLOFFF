## usage: res = crossentropy (o, p)
##
##
function res = crossentropy (o, p)

   eps = 1e-3 ;

   c = unique(o)' ;
   o = o == c ;

   p = p + eps ;

   if columns(o) == 1
      o = [o 1-o] ;
   endif
   
   I = all(isfinite(log(p)), 2) ;
   
   ce = @(o, p) -(o * log(p)') ;
   
   res = mean(arrayfun(@(i) ce(o(i,:), p(i,:)), find(I))') ;

endfunction
