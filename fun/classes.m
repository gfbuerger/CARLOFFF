## usage: res = classes (pdd, jVAR, Q0)
##
## classify Q0-events in pdd.x(:,jVAR,:,:) according to region
function res = classes (pdd, jVAR, Q0)

   global REG

   res = pdd ;
   
   w = squeeze(res.x(:,jVAR,:,:)) ;
   res.q = quantile(w(:), Q0) ;
   res.lname = sprintf("%s_%.2f", res.lname, 100 * Q0) ;

   printf("class rates: %.1f %%  %.1f %%\n\n", 100 * [sum(w(:) > 0) sum(w(:) == 0)] / numel(w)) ;

   for jREG = 1 : length(REG.geo(:))
      reg = REG.geo{jREG} ;
      Ilon = reg(1,1) <= res.lon & res.lon <= reg(1,2) ;
      Ilat = reg(2,1) <= res.lat & res.lat <= reg(2,2) ;
      c(:,jREG+1) = any(any(w(:,Ilon,Ilat) > res.q, 2), 3) ;
   endfor

   c(:,1) = all(c(:,2:end) == 0, 2) ;
   res.c = c ;

   n = rows(c) ;
   printf("class rates 00: %.1f %%\n", 100 * sum(c(:,1)) / n)
   arrayfun(@(jREG) printf("class rates %s: %.1f %%\n",
			   REG.name{jREG}, 100 * sum(c(:,jREG+1) > 0) / n), 1 : length(REG.geo(:))) ; 
   
endfunction
