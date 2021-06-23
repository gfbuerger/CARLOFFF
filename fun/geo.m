## usage: in = geo (reg)
##
##
function in = geo (reg)

   addpath ~/oct/nc/borders
   [lat lon] = borders(reg) ;

   G = dlmread("~/owncloud/SHIVA/Mahanadi.txt", ",")(:,1:2) ;
   q = 1.0 ;
   G0 = mean(G) ; Ge = G0 + q*(G - G0) ;

endfunction
