## usage: res = crossentropy (o, p)
##
##
function res = crossentropy (o, p)

   c = unique(o)' ;

   o = o == c ;

   I = all(isfinite(log(p)), 2) ;
   
   ce = @(o, p) -(o * log(p)') ;
   
   res = arrayfun(@(i) ce(o(i,:), p(i,:)), find(I))' ;

   res = mean(res) ;

endfunction
