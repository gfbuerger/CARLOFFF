function saveLabels(labels, filename)
%saveLabels saves a [number of labels] matrix containing
%the raw labels

delete(filename) ;
fp = fopen(filename, 'wb');
assert(fp ~= -1, ['Could not open ', filename, '']);

numLabels = size(labels, 1) ;

magic = 2049;
fwrite(fp, magic, 'int32', 0, 'ieee-be');
fwrite(fp, numLabels, 'int32', 0, 'ieee-be');
fwrite(fp, labels, 'unsigned char');

fclose(fp);

end
