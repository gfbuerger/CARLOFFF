## usage: [th skl] = skl_est (p, o, SKL)
##
## estimate skill
function [th skl] = skl_est (p, o, SKL)

   addpath ~/oct/nc/MLToolbox/MeteoLab/Validation

   ot(:,1,:) = o ;
   pt(:,1,:) = p ;

   [rps,rpss] = validationRPS(ot, pt) ;
##   th = rps ; skl = rpss ; return ;

   o = (o == unique(o(:))') ;
   
   np = 10 ;
   pr = linspace(min(p(:)), max(p(:)), np) ;
   dp = range(pr) / np ;

   for k = 1 : size(p, 2)
      for l = 1 : k
	 for s = SKL
	    s = s{:} ;
	    fval = arrayfun(@(th) -MoC(s, o(:,k), p(:,l) > th), pr) ;
	    [~, j] = min(fval) ;

	    [thx fval] = fminbnd(@(th) -MoC(s, o(:,k), p(:,l) > th), pr(j) - dp, pr(j) + dp) ;

	    th.(s)(k,l) = th.(s)(l,k) = thx ;
	    skl.(s)(k,l) = skl.(s)(l,k) = -fval ;
	 endfor
      endfor
   endfor

endfunction
