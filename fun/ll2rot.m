## usage: y = ll2rot (x, xlon, xlat, ylon, ylat, new = false)
##
## pick rotated indices
function y = ll2rot (x, xlon, xlat, ylon, ylat, new = false)

   persistent I

   ylon = ylon(:) ; ylat = ylat(:)' ;
   
   if isempty(I) || new

      dist = @(x, y) sumsq(x - y, 2) ;

      Imap = @(lon,lat) nthargout(2, @min, dist([xlon(:) xlat(:)], [lon lat])) ;
      I = arrayfun(@(lon) arrayfun(@(lat) Imap(lon,lat), ylat, "UniformOutput", false), ylon, "UniformOutput", false) ;

      I = cell2mat(cell2mat(I)) ;
      
   endif

   N = size(x) ;

   w = reshape(x, [], N(3)) ;
   y = arrayfun(@(i) w(i,:)', I, "UniformOutput", false) ;
   y = cell2mat(y) ;

   y = reshape(y, N(3), length(ylon), length(ylat)) ;
   
endfunction
