## usage: y = infogain (x)
##
## calculate info gain matrix
function y = infogain (x)

   nb = length(unique(x)) ;
   [nn xx] = hist(x, nb) ;
   p = nn / rows(x) ;
   [~, i] = min(p) ;
   y = eye(nb) ;   
   y(1, 2) = y(2, 1) = p(1:nb ~= i) ;

##   I = 1 : nb ;
   
##   for i = 1 : nb
##      for j = 1 : nb - 1
##	 y(i, j) = sum(p(I ~= i & I ~= j)) ;
##      endfor
##   endfor
##   y = nan(nb, nb) ;
##   y = (1 - nn) / nb ;
##   y(find(eye(nb))) = nn ;
endfunction
