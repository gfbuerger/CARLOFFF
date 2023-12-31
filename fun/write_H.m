## usage: write_H (c)
##
## write InfoGain matrix H
function write_H (c)

   cu = unique(c)' ;
   N = size(cu) ;
   
   f = sum(c(:) == cu) / numel(c) ;
   [~, j] = min(f) ;

   source("caffe_loc.m") ; # LOC = "/path/to/caffe"
   
   s = fileread("python/infoGainloss.tpl") ;
   s = strrep(s, "LOC_tpl", [LOC "/python"]) ;
   s = strrep(s, "WGT_tpl", num2str(1/f(j))) ;
   fid = fopen("python/infoGainloss.py", "wt") ;
   fdisp(fid, s) ;
   fclose(fid) ;

   system("python python/infoGainloss.py") ;
   
##   H = ones(N(2)+1, N(2)+1) ;
##   H(1,2,1) = 1 ./ f(2) ;
##   H(2,1,1) = 1 ./ f(1) ;

##   caffe.io.write_mean(single(H), ofile) ;
   
##   unlink(ofile) ;
##   h5create(ofile,'/H', [2 2 1 1], 'Datatype', 'double') ;
##   h5write(ofile,'/H', H) ;

endfunction
