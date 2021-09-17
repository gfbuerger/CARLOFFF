function [idy y] = annstat (idx, x, fun, varargin)

   ## usage:  [idy y] = annstat(idx, x, fun)
   ##

   pkg load statistics
   global PAR DRATE MON = 1:12 VERBOSE = false
   if isempty(DRATE) DRATE = 0.7 ; endif

   if ~isequal(MON, 1:12) && VERBOSE
      disp(MON) ;
   endif

   N = size(x) ;
   
   if L = (ndims(x) > 2)
      x = reshape(x, N(1), prod(N(2:end))) ;
   endif

   if DRATE <= 1
      if length(unique(idx(:,3))) > 15 # daily
	 nlen = DRATE * 30 * length(MON) ;
      else
	 nlen = DRATE * length(MON) ;
      endif
   else
      nlen = DRATE ;
   endif

   if (nargin < 3), fun = @nanmean ; endif 

   Im = isempty(MON)(ones(N(1),1)) ;
   for m = MON
      Im = Im | idx(:,2) == m ;
   endfor
      
   Y = idx(1,1):idx(end,1) ;
   y = repmat(NaN,columns(Y), columns(x)) ;
   i = 0 ;
   for iy=Y

      i++ ;
      idy(i,:) = [iy, 1, 1] ;
      if (length(find(I = idx(:,1) == iy)) < nlen)
	 continue
      endif
      w = x(I,:) ;
      I = sum(!isnan(w)) ./ rows(w) > DRATE ; I = repmat(I, rows(w), 1) ;
      w(!I) = nan ;
      J = any(!isnan(w)) ;
      y(i,:) = nan([1 size(w)(2:end)]) ;
      w = feval(fun, w(:,J), varargin{:}) ;
      y(i,J) = w ;

   endfor

   if L, y = reshape(y, [rows(y), N(2:end)]) ; endif

endfunction
