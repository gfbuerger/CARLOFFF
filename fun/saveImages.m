function saveImages(images, filename)
%saveImages saves a [number of images] matrix containing
%the raw images

delete(filename) ;
fp = fopen(filename, 'wb');
assert(fp ~= -1, ['Could not open ', filename, '']);

[numCols, numRows, numImages] = size(images) ;

magic = 2051;
fwrite(fp, magic, 'int32', 0, 'ieee-be');
fwrite(fp, numImages, 'int32', 0, 'ieee-be');
fwrite(fp, numRows, 'int32', 0, 'ieee-be');
fwrite(fp, numCols, 'int32', 0, 'ieee-be');
fwrite(fp, images, 'unsigned char');

fclose(fp);

end
