## usage: save_bin (images, ifile, labels, lfile)
##
## save images and labels in binary format
function save_bin (images, ifile, labels, lfile)

   ## images
   filename = ifile ;
   unlink(filename) ;
   fp = fopen(filename, 'wb');
   assert(fp ~= -1, ['Could not open ', filename, '']);

   images = flipdim(images) ;
   [numCols, numRows, numImages] = size(images) ;

   magic = 2051;
   fwrite(fp, magic, 'int32', 0, 'ieee-be');
   fwrite(fp, numImages, 'int32', 0, 'ieee-be');
   fwrite(fp, numRows, 'int32', 0, 'ieee-be');
   fwrite(fp, numCols, 'int32', 0, 'ieee-be');
   fwrite(fp, images, 'unsigned char');
   fclose(fp);

   ## labels
   filename = lfile ;
   unlink(filename) ;
   fp = fopen(filename, 'wb');
   assert(fp ~= -1, ['Could not open ', filename, '']);

   numLabels = size(labels, 1) ;

   magic = 2049;
   fwrite(fp, magic, 'int32', 0, 'ieee-be');
   fwrite(fp, numLabels, 'int32', 0, 'ieee-be');
   fwrite(fp, labels, 'unsigned char');

   fclose(fp);

endfunction
