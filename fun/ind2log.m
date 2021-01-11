function L = ind2log (I, n)

   ## usage: L = ind2log (I, n)
   ## 
   ## convert index to logical (of optional length n)

   if isempty(I)
      if nargin < 2
	 error("ind2log: empty input") ;
      else
	 L = false(1, n) ;
	 return ;
      endif
   else
      if nargin < 2
	 n = length(I) ;
      endif
   endif

   if !iscell(I), I = num2cell(I) ; endif

   C = parfun(@(x) 1:n == x, I, "UniformOutput", false, "VerboseLevel", 0) ;

   if length(C) > 1
      L = or(C{:}) ;
   else
      L = C{1} ;
   endif
   
endfunction
