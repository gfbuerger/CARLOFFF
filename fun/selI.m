## usage: y = selI (x, I)
##
## select subset of x using I (first dimension)
function y = selI (x, I)

   idx.type = "()" ;
   idx.subs = repmat({":"}, 1, ndims(x)) ;
   idx.subs{1} = I ;
   
   y = subsref(x, idx) ;
   
endfunction
