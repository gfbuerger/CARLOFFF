## usage: y = to_uint (x)
##
## transform to uint
function y = to_uint (x)
   xn = min(x(:)) ;
   x = x - xn ;
   xx = max(x(:)) ;
   x = x ./ xx * 255 ;
   y = round(x) ;
endfunction
