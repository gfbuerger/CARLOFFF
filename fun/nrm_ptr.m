## usage: [y varargout] = nrm_ptr (x, varargin)
##
## normalize predictors
function [y varargout] = nrm_ptr (x, varargin)

   if nargin < 2
      xm = arrayfun(@(j) nanmean(x(:,j,:)(:)), 1:size(x, 2)) ;
      xs = arrayfun(@(j) nanstd(x(:,j,:)(:)), 1:size(x, 2)) ;
   elseif nargin < 3
      xm = varargin{1} ;
      xs = arrayfun(@(j) nanstd(x(:,j,:)(:)), 1:size(x, 2)) ;
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
