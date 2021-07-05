## usage: h = plot_hrs (s, jVAR)
##
##
function h = plot_hrs (s, jVAR)

   H = unique(s.id(:,4)) ;

   fun = @(x) sum(x > 0) ;

   i = 0 ;
   for h = H'
      i++ ;
      I = s.id(:,4) == h ;
      xh(i) = feval(fun, s.x(I,jVAR,:,:)(:)) ;
   endfor

   hold on ;
   bar(H, xh) ;
   axis tight
   xlabel("hour") ; ylabel("# of events") ;
##   plot([H(1) H(end)], [500 500], "--k") ;
   title("#events in the hour") ;

   set(findall("-property", "fontname"), "fontname", "Linux Biolinum", "fontsize", 30) ;

   hgsave(sprintf("nc/%s.ERA5_hrs.%s.og", s.reg, s.vars{jVAR}))
   print(sprintf("nc/%s.ERA5_hrs.%s.png", s.reg, s.vars{jVAR}))

endfunction
