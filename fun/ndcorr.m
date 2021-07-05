## usage: r = ndcorr (x, y)
##
## canonical correlation between x and y
function r = ndcorr (x, y)

   x = squeeze(x) ;
   y = squeeze(y) ;
   
   N = size(x) ;
   x = reshape(x, N(1), prod(N(2:end))) ;
   N = size(y) ;
   y = reshape(y, N(1), prod(N(2:end))) ;

   I = all(~isnan([x y]), 2) ;
   
   [~, ~, r] = canoncorr(x(I,:), y(I,:)) ;

   r = r(1) ;
   
endfunction
