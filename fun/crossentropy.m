## usage: res = crossentropy (o, p)
##
##
function res = crossentropy (o, p)

   p = p + 1e-3 ;   # numeric stability

   I = all(isfinite(log(p)), 2) ;
   
   ce = @(o, p) -(o * log(p)') ;
   
   res = mean(arrayfun(@(i) ce(o(i,:), p(i,:)), find(I))') ;

endfunction
