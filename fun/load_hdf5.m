## usage: [images labels] = load_hdf5 (ifile)
##
## load images and labels from ifile (h5)
function [images labels] = load_hdf5 (ifile)

   pkg load hdf5oct

   fid = fopen(ifile, "rt") ;
   file = fgetl(fid) ;
   fclose(fid) ;

   labels = h5read(file, "/label") ;
   images = h5read(file, "/data") ;

##   x = load(file) ;
##   images = x.data ;
##   labels = x.label ;

   labels = flipdim(labels) ;
   images = flipdim(images) ;
   
endfunction
