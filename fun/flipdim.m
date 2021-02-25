## usage: y = flipdim (x)
##
## flip x dimensions
function y = flipdim (x)

   y = permute(x, ndims(x):-1:1) ;

endfunction
