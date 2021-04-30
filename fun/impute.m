## usage: y = impute (x)
##
## impute values using PCA and means
function y = impute (x)

   N = size(x) ;
   x = reshape(x, N(1), prod(N(2:end))) ;
   
   [E PC ev lmb D] = pca(x, trunc="full") ;

   y = nanmult(PC, E') ;

   I = all(isnan(y), 2) ;
   y(I,:) = repmat(nanmean(x), sum(I), 1) ;

   y = reshape(y, N) ;
   
endfunction
