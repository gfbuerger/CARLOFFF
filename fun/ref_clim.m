## usage: [xm, xs] = ref_clim (hist, scn, ID)
##
## calculate reference climatology
function [xm, xs] = ref_clim (hist, scn, ID)

   hist = selper(hist, ID(1,:), ID(2,:)) ;
   scn = selper(scn, ID(1,:), ID(2,:)) ;

   x = cat(1, hist.x, scn.x) ;

   xm = arrayfun(@(j) nanmean(x(:,j,:,:)(:)), 1:size(x, 2)) ;
   xs = arrayfun(@(j) nanstd(x(:,j,:,:)(:)), 1:size(x, 2)) ;
   
endfunction
