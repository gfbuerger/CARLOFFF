## usage: c = l2c (l)
##
## transform 1-hot to classes
function c = l2c (l)

   c = arrayfun(@(i) find(l(i,:)), 1 : size(l, 1))' ;
##   c = arrayfun(@(i) nthargout(2, @max, yy(i,:), [], 2), 1 : size(yy, 1))' ;

endfunction
