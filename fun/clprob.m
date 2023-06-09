## usage: res = clprob (par, x, u)
##
## convert m5ppredict to prediction
function res = clprob (par, x, u)

   if isstruct(par)
      w = cell2mat(parfun(@(p) sim(p, x')', par, "UniformOutput", false)) ;
      J = cell2mat(arrayfun(@(j) nthargout(2, @min, abs(w(:,j) - u), [], 2), 1 : size(w, 2), "UniformOutput", false)) ;
      res = cell2mat(arrayfun(@(j) mean(u(:)(J) == u(j), 2), 1 : length(u), "UniformOutput", false)) ;
   else
      w = m5ppredict_new(par, x) ;
      J = cell2mat(arrayfun(@(j) nthargout(2, @min, abs(w(:,j) - u), [], 2), 1 : size(w, 2), "UniformOutput", false)) ;
      res = cell2mat(arrayfun(@(j) mean(u(:)(J) == u(j), 2), 1 : length(u), "UniformOutput", false)) ;
   endif

   res = res(:,end) ;

endfunction
