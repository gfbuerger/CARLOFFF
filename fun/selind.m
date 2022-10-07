## usage: res = selind (s, ind, IND)
##
## select indices ind from IND
function res = selind (s, ind, IND)

   res = s ;

   if isequal(ind, IND) return ; endif

   indn = find(arrayfun(@(c) c == "1", ind)) ;
   INDn = find(arrayfun(@(c) c == "1", IND)) ;
   
   J = arrayfun(@(i) find(i == INDn), indn) ;

   res.x = s.x(:,J,:,:) ;
   res.vars = s.vars(J) ;
   res.ind = ind ;
   
endfunction
