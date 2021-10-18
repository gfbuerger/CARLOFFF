## usage: [ptr varargout] = selptr (scale, ind=[], ptfile, ID=[], FILL=false, varargin)
##
## select predictors
function [ptr varargout] = selptr (scale, ind=[], ptfile, ID=[], FILL=false, varargin)

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

      if ~isfield(v, "xm") || ~isfield(v, "xs")
	 if ~any(x(:) < 0)
	    v.xm = 0 ;
	 else
	    v.xm = nanmean(x(:)) ;
	 endif
	 v.xs = nanstd(x(:)) ;
      endif
      ptr.x(:,i,:,:) = (x - v.xm) ./ v.xs ;
      ptr.vars{i} = v.name ;
      varargout{i} = v ;
   endfor

   ptr.scale = scale ;
   ptr.ind = ind ;
   ptr.ptfile = ptfile ;

   if ~isempty(ID)
      ptr = selper(ptr, ID(1,:), ID(2,:)) ;
   endif
   
endfunction
