## usage: res = selind (s, ind, IND)
##
## select indices ind from IND
function res = selind (s, ind, IND)

   indn = find(arrayfun(@(c) c == "1", ind)) ;
   INDn = find(arrayfun(@(c) c == "1", IND)) ;
   
   J = arrayfun(@(i) find(i == INDn), indn)

   s.x = s.x(:,J,:,:) ;
   s.img = s.img(:,J,:,:) ;
   s.vars = s.vars(J) ;
   s.ind = ind ;
   
endfunction
