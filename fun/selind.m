## usage: res = selind (s, ind, IND)
##
## select indices ind from IND
function res = selind (s, ind, IND)

   res = s ;

   indn = find(arrayfun(@(c) c == "1", ind)) ;
   INDn = find(arrayfun(@(c) c == "1", IND)) ;
   
   J = arrayfun(@(i) find(i == INDn), indn) ;

   res.x = s.x(:,J,:,:) ;
   res.img = s.img(:,J,:,:) ;
   res.vars = s.vars(J) ;
   res.ind = ind ;
   
endfunction
