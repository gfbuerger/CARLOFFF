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
      lc(:,jREG+1) = cfun(cfun(w(:,Ilon,Ilat) > q, 2), 3) ;
   endfor
   lc(:,1) = all(lc(:,2:end) == 0, 2) ;

   c = l2c(lc) ;
   
   printf("class rates 00: %.1f %%\n", 100 * sum(lc(:,1)) / n)
   arrayfun(@(jREG) printf("class rates %s: %.1f %%\n",
			   REG.name{jREG}, 100 * sum(lc(:,jREG+1) > 0) / n), 1 : length(REG.geo(:))) ; 
   
endfunction
