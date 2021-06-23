## usage: [ru, rv] = redclass (u, v, q)
##
## reduce major class of u, v with target ratio q
function [ru, rv] = redclass (u, v, q)

   persistent rstate

   if exist("rstate", "var") == 1
      rand("state", rstate) ;
   else
      rstate = rand("state") ;
   endif
   
   c = unique(v.c)' ;
   I = v.c == c ;

   [~,j] = max(sum(I)) ;
   I = I(:,j) ;
   
   n = rows(I) ;
   n1 = sum(I) ;
   k = n - n1 ;
   l = round(q/(1-q) * k) ;

   J = sort(randperm(n1)(1:l)) ;
   J = find(I)(J) ;
   J = ind2log(J, n) ;

   J = ~I | J ;
   
   ru = u ; rv = v ;

   ru.id = selI(ru.id, J) ;
   ru.x = selI(ru.x, J) ;

   rv.id = selI(rv.id, J) ;
   rv.x = selI(rv.x, J) ;
   rv.c = selI(rv.c, J) ;

endfunction
