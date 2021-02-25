## usage: save_hdf5 (of, images, labels)
##
## save to hdf5
function save_hdf5 (of, images, labels)

   pkg load hdf5oct

   file = strrep(of, ".txt", ".h5") ;
   
   fid = fopen(of, "wt") ;
   fputs(fid, file) ;
   fclose(fid) ;

   unlink(file) ;

   labels = flipdim(labels) ;
   images = flipdim(images) ;

   N = size(images) ;
   N = [N(1:2) 1 N(end)] ; % channel dim
   h5create(file, '/data', N, 'Datatype', 'double') ;
   h5write(file, '/data', images) ;

   N = size(labels) ;
   h5create(file,'/label', N, 'Datatype', 'double') ;
   h5write(file,'/label', labels) ;

endfunction
