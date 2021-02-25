## usage: y = nancenter (x, q = 0.5)
##
## respect NaNs for center; minimum of q numbers required
function y = nancenter (x, q = 0.5)

   pkg load statistics
   
   if nargin < 2, dim = 1 ; endif

   N = size(x) ;
   x = reshape(x, N(1), []) ;

   I = sum(~isnan(x), 2) / N(2) > q ;
   
   w = x(I,:) ;

   w = reshape(w, [rows(w) N(2:end)]) ;

   y = x - nanmean(w) ;
   
endfunction
