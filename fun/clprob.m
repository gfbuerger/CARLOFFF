## usage: prob = clprob (par, x, u)
##
##
function prob = clprob (par, x, u)

   global PMODE = "prob"
   
   w = m5ppredict(par, x) ;

   switch PMODE
      case "det"
	 [~, J] = min(abs(w - u), [], 2) ;
	 d = cell2mat(arrayfun(@(i) nthargout(2, @min, sumsq(w(i,:) - u, 2)), 1 : size(w, 2), "UniformOutput", false)) ;
	 prob = u(J)' ;
      case "prob"
	 d = exp(-(mean(w, 2) - u).^2) ;
	 prob = d ./ sum(d, 2) ;
      otherwise
	 prob = mean(w, 2) ;
   endswitch

   prob = prob(:,2) ;

endfunction
