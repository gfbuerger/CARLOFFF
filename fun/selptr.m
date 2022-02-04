## usage: ptr = selptr (scale, ind=[], ptfile, ID=[], FILL=false, varargin)
##
## select predictors
function ptr = selptr (scale, ind=[], ptfile, ID=[], FILL=false, varargin)

   ptr = varargin{1} ;
   N = size(ptr.x) ;
   ptr = rmfield(ptr, "x") ;

   for i = 1 : nargin - 5
      v = varargin{i} ;
      clear varargin{i} ;
      x = v.x ;

      if FILL
	 xm = nanmean(x) ;
	 xm(isnan(xm)) = nanmean(xm(:)) ;
	 xm = repmat(xm, [N(1) 1 1]) ;
	 if 0
	    I = all(all(isnan(x), 2), 3) ;
	    x(I,:,:) = xm(I,:,:) ;
	 else
	    I = isnan(x) ;
	    x(I) = xm(I) ;
	 endif
      endif      

      ptr.x(:,i,:,:) = x ;
      ptr.vars{i} = v.name ;
   endfor

   ptr.scale = scale ;
   ptr.ind = ind ;
   ptr.ptfile = ptfile ;

   if ~isempty(ID)
      ptr = selper(ptr, ID(1,:), ID(2,:)) ;
   endif
   
endfunction
