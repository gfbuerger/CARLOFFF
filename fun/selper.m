function t = selper (s, varargin)

   ## usage:  t = selper (s, varargin)
   ##
   ## select period of structure s

   if nargin > 2
      I = sdate(s.id, varargin{:}) ;
   else
      I = varargin{1} ;
   endif
   
   rI = rows(I) ;
   persistent L = false ;
   t = s ;

   if isstruct(s)
      for [v k]=s
	 if (rows(v) != rI), continue, endif 
	 t.(k) = selper(v, I) ;
	 L = true ;
      endfor
   elseif isnumeric(s)
      N = size(s) ;
      if (N(1) == rI)
	 s = reshape(s, N(1), prod(N(2:end))) ;
	 t = s(I,:) ;
	 t = reshape(t, [size(t,1), N(2:end)]) ;
	 L = true ;
      endif
   endif
   if (!L) error("selper: incompatible input.\n"), endif 

endfunction
