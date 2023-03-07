## usage: l = c2l (c)
##
##
function l = c2l (c)

   cu = unique(c) ;
   l = (c == cu') ;

endfunction
