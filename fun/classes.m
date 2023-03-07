## usage: res = classes (pdd, jVAR, Q0, cfun = @any)
##
## classify Q0-events in pdd.x(:,jVAR,:,:) according to region
## use cfun = @sum for class counts
function res = classes (pdd, jVAR, Q0, cfun = @any)

   global REG

   res = pdd ;
   n = size(res.x, 1) ;
   
   w = squeeze(res.x(:,jVAR,:,:)) ;
   res.q = quantile(w(:), Q0) ;

   printf("class rates: %.1f %%  %.1f %%\n\n", 100 * [sum(w(:) > 0) sum(w(:) == 0)] / numel(w)) ;

   for jREG = 1 : length(REG.geo(:))
      reg = REG.geo{jREG} ;
      Ilon = reg(1,1) <= res.lon & res.lon <= reg(1,2) ;
      Ilat = reg(2,1) <= res.lat & res.lat <= reg(2,2) ;
      lc(:,jREG+1) = cfun(cfun(w(:,Ilon,Ilat) > res.q, 2), 3) ;
   endfor
   lc(:,1) = all(lc(:,2:end) == 0, 2) ;
   
   res.c = l2c(lc) ;
   
   printf("class rates 00: %.1f %%\n", 100 * sum(lc(:,1)) / n)
   arrayfun(@(jREG) printf("class rates %s: %.1f %%\n",
			   REG.name{jREG}, 100 * sum(lc(:,jREG+1) > 0) / n), 1 : length(REG.geo(:))) ; 
   
endfunction
