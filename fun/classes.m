## usage: [c q] = classes (pdd, jVAR, Q0, cfun = @any)
##
## classify Q0-events in pdd.x(:,jVAR,:,:) according to region
## use cfun = @sum for class counts
function [c q] = classes (pdd, jVAR, Q0, cfun = @any)

   global REG

   n = size(pdd.x, 1) ;
   
   w = squeeze(pdd.x(:,jVAR,:,:)) ;
   q = quantile(w(:), Q0) ;

   printf("class rates: %.1f %%  %.1f %%\n\n", 100 * [sum(w(:) > 0) sum(w(:) == 0)] / numel(w)) ;

   for jREG = 1 : length(REG.geo(:))
      reg = REG.geo{jREG} ;
      Ilon = reg(1,1) <= pdd.lon & pdd.lon <= reg(1,2) ;
      Ilat = reg(2,1) <= pdd.lat & pdd.lat <= reg(2,2) ;
      c(:,jREG) = cfun(cfun(w(:,Ilon,Ilat) > q, 2), 3) ;
   endfor

   if length(REG.geo(:)) < 2
      c = [all(c(:,2:end) == 0, 2) c] ;
      c = l2c(c) ;
   endif

   arrayfun(@(jREG) printf("class rates %s: %.1f %%\n",
			   REG.name{jREG}, 100 * sum(c(:,jREG) > 0) / n), 1 : length(REG.geo(:))) ; 
   
endfunction
