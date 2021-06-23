## usage: plot_pdd (s, jVar = 1)
##
##
function plot_pdd (s, jVar = 1)

   figure(1) ;
   set(gcf, "position", [0.5 0.7 0.5 0.3]) ;
   clf ;

   N = size(s.x) ;
   
   J = squeeze(all(isinf(s.x(:,jVar,:,:)), 1)) ;
   J = repmat(J, N(1:2)) ;
   J = reshape(J, N(3), N(1), N(4), N(2)) ;
   J = permute(J, [2 4 1 3]) ;

   s.x(~isfinite(s.x) & ~J) = NaN ;
   
   subplot(1,3,1) ;

   qfun = @(x) nansum(isfinite(x)) ;
   xm = 100 * squeeze(feval(qfun, s.x(:,jVar,:,:))) ;

   imagesc(s.lon, s.lat, xm') ;
   set(gca, "ydir", "normal") ;
   title(sprintf("# of events / ERA5 grid")) ;
   hc = colorbar ;
   colormap(flip(gray))
   xlabel("longitude") ; ylabel("latitude") ;
##   set(get(hc, "Title"), "string", "[%]") ;
   
   hold on
   hb = borders("germany", "color", "black") ;

   subplot(1,3,2) ;
   
   fun=@nanmean ;
   xm = squeeze(feval(fun, s.x(:,jVar,:,:))) ;

   imagesc(s.lon, s.lat, xm') ;
   set(gca, "ydir", "normal") ;
   title(sprintf("long-term {\\bf mean} %s", s.vars{jVar})) ;
   hc = colorbar ;
   colormap(flip(gray))
   xlabel("longitude") ; ylabel("latitude") ;
##   set(get(hc, "Title"), "string", s.vars{jVar}) ;
   
   hold on
   hb = borders("germany", "color", "black") ;

   subplot(1,3,3) ;

   fun = @(x) nanmax(x, [], 1) ;
   xm = squeeze(feval(fun, s.x(:,jVar,:,:))) ;

   imagesc(s.lon, s.lat, xm') ;
   set(gca, "ydir", "normal") ;
   title(sprintf("long-term {\\bf max} %s", s.vars{jVar})) ;
   hc = colorbar ;
   colormap(flip(gray))
   xlabel("longitude") ; ylabel("latitude") ;
##   set(get(hc, "Title"), "string", s.vars{jVar}) ;
   
   hold on
   hb = borders("germany", "color", "black") ;

   print(sprintf("nc/ERA5_stat.%s.png", s.vars{jVar}))

   return ;

   figure(2) ;
   
   H = unique(s.id(:,4)) ;

   fun = @(x) sum(x > 0) ;

   i = 0 ;
   for h = H'
      i++ ;
      I = s.id(:,4) == h ;
      xh(i) = feval(fun, s.x(I,jVar,:,:)(:)) ;
   endfor

   hold on ;
   bar(H, xh) ;
   axis tight
   xlabel("hour") ; ylabel("# of events") ;
   plot([H(1) H(end)], [500 500], "--k") ;
   title("#events in the hour") ;

   print(sprintf("nc/ERA5_hrs.%s.svg", s.vars{jVar}))

endfunction
