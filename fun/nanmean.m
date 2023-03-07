## usage: y = nanmean (x, varargin)
##
## nanmean from nansum
function y = nanmean (x, varargin)

   y = nansum(x, varargin{:}) ;
   n = nansum(~isnan(x), varargin{:}) ;

   y = y ./ n ;
   
endfunction
