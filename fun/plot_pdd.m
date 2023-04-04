## usage: plot_pdd (s, jVAR = 1)
##
##
function plot_pdd (s, jVAR = 1)

   set(1, "defaultaxesfontsize", 14, "defaulttextfontsize", 22) ;

   figure(1) ;
   set(gcf, "position", [0.4 0.7 0.6 0.3]) ;

   clf ;
   N = size(s.x) ;
   
   J = squeeze(all(isinf(s.x(:,jVAR,:,:)), 1)) ;
   J = repmat(J, N(1:2)) ;
   J = reshape(J, N(3), N(1), N(4), N(2)) ;
   J = permute(J, [2 4 1 3]) ;

   s.x(~isfinite(s.x) & ~J) = NaN ;
   
   ax(1) = subplot(1,3,1) ;

   qfun = @(x) nansum(isfinite(x)) ;
   xm = squeeze(feval(qfun, s.x(:,jVAR,:,:))) ;

   imagesc(s.lon, s.lat, xm') ;
   set(gca, "ydir", "normal") ;
   hc = colorbar ;
   colormap(flip(gray))
   xlabel("longitude") ; ylabel("latitude") ;
   
   hold on
   hb = borders("germany", "color", "black") ;

   ax(2) = subplot(1,3,2) ;
   
   fun=@nanmean ;
   xm = squeeze(feval(fun, s.x(:,jVAR,:,:))) ;

   imagesc(s.lon, s.lat, xm') ;
   set(gca, "ydir", "normal") ;
   hc = colorbar ;
   colormap(flip(gray))
   xlabel("longitude") ; ylabel("latitude") ;
   
   hold on
   hb = borders("germany", "color", "black") ;

   ax(3) = subplot(1,3,3) ;

   fun = @(x) nanmax(x, [], 1) ;
   xm = squeeze(feval(fun, s.x(:,jVAR,:,:))) ;

   imagesc(s.lon, s.lat, xm') ;
   set(gca, "ydir", "normal") ;
   hc = colorbar ;
   colormap(flip(gray))
   xlabel("longitude") ; ylabel("latitude") ;
   
   hold on
   hb = borders("germany", "color", "black") ;

##   title(ax(1), sprintf("# of events / ERA5 grid")) ;
##   title(ax(2), sprintf("long-term {\\bf mean} %s", s.vars{jVAR})) ;
##   title(ax(3), sprintf("long-term {\\bf max} %s", s.vars{jVAR})) ;

   set(findall("-property", "fontname"), "fontname", "Libertinus Sans") ;
##   set(findall("type", "axes"), "fontsize", 14) ;
##   set(findall("type", "text"), "fontsize", 22) ;
   print(sprintf("nc/ERA5_stat.%s.png", s.vars{jVAR}))

endfunction
