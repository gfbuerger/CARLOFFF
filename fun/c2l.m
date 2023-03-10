## usage: [l uc] = c2l (c)
##
##
function [l uc] = c2l (c)

   uc = unique(c)' ;
   l = (c == uc) ;

endfunction
