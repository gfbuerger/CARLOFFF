function z = nanmult(varargin)

   ## usage: z = nanmult(varargin)
   ## 
   ## multiply matrices (ignoring NaNs) 

   if (nargin > 2)
      z = nanmult(nanmult(varargin{1:nargin-1}), varargin{nargin}) ;
      return ;
   endif

   x = varargin{1} ; y = varargin{2} ;
   clear varargin ;
   
   Nx = size(x) ; Ny = size(y) ;
   x = reshape(x, prod(Nx(1:end-1)), Nx(end)) ;
   y = reshape(y, Ny(1), prod(Ny(2:end))) ;

   if (isempty(x) || isempty(y))
      z = [] ;
      return ;
   endif 

   I = isnan(x) ;
   J = isnan(y) ;
   
   x(I) = 0 ;
   y(J) = 0 ;

   z = x*y ;

   clear x y ;

   IJ = (~I * ~J == 0) ;
   clear I J ;
   
   z(IJ) = NaN ;

   z = squeeze(reshape(z, [Nx(1:end-1) Ny(2:end)])) ;

endfunction
