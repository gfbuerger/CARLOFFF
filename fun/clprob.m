## usage: res = clprob (f, par, x, u)
##
## convert to categorical prediction
function res = clprob (f, par, x, u)

<<<<<<< HEAD
   if isstruct(par)
      w = cell2mat(parfun(@(p) sim(p, x')', par, "UniformOutput", false)) ;
      J = cell2mat(arrayfun(@(j) nthargout(2, @min, abs(w(:,j) - u), [], 2), 1 : size(w, 2), "UniformOutput", false)) ;
      res = cell2mat(arrayfun(@(j) mean(u(:)(J) == u(j), 2), 1 : length(u), "UniformOutput", false)) ;
   else
      w = m5ppredict_new(par, x) ;
      J = cell2mat(arrayfun(@(j) nthargout(2, @min, abs(w(:,j) - u), [], 2), 1 : size(w, 2), "UniformOutput", false)) ;
      res = cell2mat(arrayfun(@(j) mean(u(:)(J) == u(j), 2), 1 : length(u), "UniformOutput", false)) ;
   endif
=======
   u = u(:)' ;

   switch f
      case {@rfPredict @m5ppredict_new}
	 w = feval(f, par, x) ;
      otherwise
	 w = cell2mat(parfun(@(p) feval(f, p, x')', par, "UniformOutput", false)) ;
   endswitch

   J = cell2mat(arrayfun(@(j) nthargout(2, @min, abs(w(:,j) - u), [], 2), 1 : size(w, 2), "UniformOutput", false)) ;
   res = cell2mat(arrayfun(@(j) mean(u(:)(J) == u(j), 2), 1 : length(u), "UniformOutput", false)) ;
>>>>>>> carlofff1

endfunction
