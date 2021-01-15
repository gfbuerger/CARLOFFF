## usage: write_H (c, ofile)
##
## write InfoGain matrix H
function write_H (c, ofile)

   cu = unique(c)' ;
   f = sum(c == cu) / rows(c) ;

   H(1,1,1) = H(1,2,2) = 0 ;
   H(1,1,1:2) = flip(1 ./ f) ;

   N = flip(size(H)) ;

   delete(ofile) ;
   h5create(ofile,'/H', N, 'Datatype', 'double') ;
   h5write(ofile,'/H', H) ;

endfunction
