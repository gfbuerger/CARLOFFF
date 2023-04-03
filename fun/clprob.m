## usage: res = clprob (par, x, u)
##
## convert m5ppredict to prediction
function res = clprob (par, x, u)

   global PMODE = "prob"

   switch PMODE
      case "prob"
	 w = m5ppredict_new(par, x) ;
	 J = cell2mat(arrayfun(@(j) nthargout(2, @min, abs(w(:,j) - u), [], 2), 1 : size(w, 2), "UniformOutput", false)) ;
	 res = cell2mat(arrayfun(@(j) mean(u(J) == u(j), 2), 1 : length(u), "UniformOutput", false)) ;
      otherwise
	 w = m5ppredict(par, x)(:,end) ;
	 [~, J] = min(abs(w - u), [], 2) ;
	 res = u(J)' ;
   endswitch

   res = res(:,end) ;

endfunction
