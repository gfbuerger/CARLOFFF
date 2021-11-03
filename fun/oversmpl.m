## usage: [iout, lout] = oversmpl (i, l)
##
## oversample i, l
function [iout, lout] = oversmpl (i, l)

   N = size(i) ;
   
   lu = unique(l) ;
   I = l == lu' ;
   [~, j] = min(sum(I)) ;
   I = I(:,j) ;

   n = floor(sum(~I) / sum(I)) ;
   fI = repmat(find(I), n, 1) ;
   fnI = find(~I) ;

   fnI = fnI(randperm(length(fnI))) ;
   fI = fI(randperm(length(fI))) ;

   lout = [l(fnI) ; l(fI)] ;
   iout = [i(fnI,:,:,:) ; i(fI,:,:,:)] ;

   k = floor(length(lout) / 2) ;
   
   lout = reshape(lout(1:2*k), k, 2) ;
   iout = reshape(iout(1:2*k,:,:,:), [k 2 N(2:end)]) ;

   lout = permute(lout, [2 1]) ;
   iout = permute(iout, [2 1 3 4 5]) ;

   lout = reshape(lout, 2*k, 1) ;
   iout = reshape(iout, [2*k, N(2:end)]) ;
   
endfunction
