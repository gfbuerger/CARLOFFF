## usage: p = softmax (x, dim = 2)
##
## calculate the softmax function
function p = softmax (x, dim = 2)

   if ndims(x) ~= 2
      error("softmax> need 2-dim input")
   endif

   xm = max(x, [], dim) ;
   x = exp(x - xm) ;

   p = x ./ sum(x, dim) ;
   
endfunction
