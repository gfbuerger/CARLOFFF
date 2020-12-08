function saveMNISTLabels(labels, filename)
%saveMNISTLabels saves a [number of MNIST labels] matrix containing
%the raw MNIST labels

fp = fopen(filename, 'wb');
assert(fp ~= -1, ['Could not open ', filename, '']);

numLabels = size(labels, 2) ;

magic = 2049;
fwrite(fp, magic, 'int32', 0, 'ieee-be');
fwrite(fp, numLabels, 'int32', 0, 'ieee-be');
fwrite(fp, labels, 'unsigned char');

fclose(fp);

end
