## usage: [skl th] = skl_est (p, o, SKL, thi = [])
##
## estimate skill
function [skl th] = skl_est (p, o, SKL, thi = [])

   if size(o, 2) > 2
      skl = th = NaN ;
      return ;
   else
      p = p(:,end) ; o = o(:,end) ;
   endif

   np = 10 ;
   pr = linspace(min(p(:)), max(p(:)), np) ;
   dp = range(pr) / np ;
   
   for s = SKL
      s = s{:} ;

      switch s

	 case "BSS"

	    bs = sumsq(p - o) / size(o, 1) ;
	    om = mean(o) ;
	    bsr = sumsq(om - o) / size(o, 1) ;
	    skl.(s) = 1 - bs / bsr ;

	 case {"HSS" "ETS"}

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

      endswitch

   endfor

   res.th = th ;
   res.skl = skl ;
   
endfunction
