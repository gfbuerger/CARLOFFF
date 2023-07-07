## usage: res = clprob (f, par, x, u)
##
## convert to categorical prediction
function res = clprob (f, par, x, u)

   switch f
      case {@m5ppredict_new, @rfPredict}
	 w = feval(f, par, x) ;
      otherwise
	 w = cell2mat(parfun(@(p) feval(f, p, x')', par, "UniformOutput", false)) ;
   endswitch

   J = cell2mat(arrayfun(@(j) nthargout(2, @min, abs(w(:,j) - u), [], 2), 1 : size(w, 2), "UniformOutput", false)) ;
   res = cell2mat(arrayfun(@(j) mean(u(:)(J) == u(j), 2), 1 : length(u), "UniformOutput", false)) ;

   res = res(:,end) ;

endfunction
