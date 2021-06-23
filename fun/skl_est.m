## usage: [th skl] = skl_est (p, o, SKL)
##
## estimate skill
function [th skl] = skl_est (p, o, SKL)

   np = 10 ;
   pr = linspace(min(p), max(p), np) ;
   dp = range(pr) / np ;
   
   for s = SKL
      s = s{:} ;
      fval = arrayfun(@(th) -MoC(s, o, p > th), pr) ;
      [~, j] = min(fval) ;

      [thx fval] = fminbnd(@(th) -MoC(s, o, p > th), pr(j) - dp, pr(j) + dp) ;

      th.(s) = thx ;
      skl.(s) = -fval ;
   endfor

endfunction
