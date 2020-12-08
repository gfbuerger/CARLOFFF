function saveMNISTImages(images, filename)
%saveMNISTImages saves a [number of MNIST images] matrix containing
%the raw MNIST images

fp = fopen(filename, 'wb');
assert(fp ~= -1, ['Could not open ', filename, '']);

N = size(images) ;
##images = permute(images,[2 1 3]);

magic = 2051;
fwrite(fp, magic, 'int32', 0, 'ieee-be');
fwrite(fp, N(1), 'int32', 0, 'ieee-be');
fwrite(fp, N(2), 'int32', 0, 'ieee-be');
fwrite(fp, N(3), 'int32', 0, 'ieee-be');
fwrite(fp, images, 'unsigned char');

fclose(fp);

end
