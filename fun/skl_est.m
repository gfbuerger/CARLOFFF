## usage: [th skl] = skl_est (p, o, SKL, thi = [])
##
## estimate skill
function [th skl] = skl_est (p, o, SKL, thi = [])

   np = 10 ;
   pr = linspace(min(p), max(p), np) ;
   dp = range(pr) / np ;
   
   for s = SKL
      s = s{:} ;

      if isempty(thi)

	 fval = arrayfun(@(th) -MoC(s, o, p > th), pr) ;
	 [~, j] = min(fval) ;

	 [thx fval] = fminbnd(@(th) -MoC(s, o, p > th), pr(j) - dp, pr(j) + dp) ;

	 th.(s) = thx ;
	 skl.(s) = -fval ;

      else

	 th.(s) = thi.(s) ;
	 skl.(s) = MoC(s, o, p > th.(s)) ;

      endif

   endfor

endfunction
