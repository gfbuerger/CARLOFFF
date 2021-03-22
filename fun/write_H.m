## usage: write_H (c, q = 0, ofile)
##
## write InfoGain matrix H
function write_H (c, q = 0, ofile)

   cu = unique(c)' ;
   N = size(cu) ;
   
   f = sum(c == cu) / rows(c) ;
   [~, j] = min(f) ;

##   H = ones(N(2)+1, N(2)+1) ;
##   H(1,2,1) = 1 ./ f(1) ;
##   H(2,1,1) = 1 ./ f(2) ;

##   caffe.io.write_mean(single(H), ofile) ;
   
   H = q * ones(N(2), N(2), 1, 1) ;
##   H = ones(N(2), N(2), 1, 1) ;
##   H(1,2,1,1) = 1 - q + q * (1 ./ f(j)) ;

   unlink(ofile) ;
   h5create(ofile,'/H', [2 2 1 1], 'Datatype', 'double') ;
   h5write(ofile,'/H', H) ;

endfunction
