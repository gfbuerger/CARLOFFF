## usage: [y varargout] = nrm_ptr (x, I=[], varargin)
##
## normalize predictors
function [y varargout] = nrm_ptr (x, I=[], varargin)

   if isempty(I)
      I = true(size(x, 1), 1) ;
   endif
   
   if nargin < 3
      xm = arrayfun(@(j) nanmean(x(I,j,:)(:)), 1:size(x, 2)) ;
      xs = arrayfun(@(j) nanstd(x(I,j,:)(:)), 1:size(x, 2)) ;
   elseif nargin < 4
      xm = varargin{1} ;
      xs = arrayfun(@(j) nanstd(x(I,j,:)(:)), 1:size(x, 2)) ;
   else
      xm = varargin{1} ;
      xs = varargin{2} ;
   endif

   for j = 1 : size(x, 2)
      x(:,j,:) = (x(:,j,:) - xm(j)) ./ xs(j) ;
   endfor

   y = x ;
   
   if nargout > 2
      varargout{1} = xm ;
      varargout{2} = xs ;
   elseif nargout > 1
      varargout{1} = xm ;
   endif

endfunction
