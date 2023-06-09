## usage: save_hdf5 (of, images, labels, lrnd = false)
##
## save to hdf5
function save_hdf5 (of, images, labels, lrnd = false)

   pkg load hdf5oct

   file = strrep(of, ".txt", ".h5") ;
   
   fid = fopen(of, "wt") ;
   fdisp(fid, file) ;
   fclose(fid) ;

   [st msg] = unlink(file) ;

   if lrnd
      warning("using scrambled data") ;
      labels = labels(randperm(size(labels, 1)),:) ;
   endif
   
   labels = flipdim(labels) ;
   images = flipdim(images) ;

   N = size(images) ;
   if length(N) < 3
      N = [1 1 N] ;
   endif
   
   h5create(file, '/data', N, 'Datatype', 'double') ;
   h5write(file, '/data', images) ;

   N = size(labels) ;
   h5create(file,'/label', N, 'Datatype', 'double') ;
   h5write(file,'/label', labels) ;

   printf("--> %s\n", file) ;
   
endfunction
