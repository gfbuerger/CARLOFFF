## usage: plot_prob (s, pdd, d, d0)
##
##
function plot_prob (s, pdd, d, d0)

   global REG
   
   I1 = sdate(s.id, d) ;
   I2 = sdate(pdd.id, d) ;

   clf ; hold on
   hb = bar(datenum(pdd.id(I2,:)), double(pdd.c(I2,end)), 1) ;
   set(hb, "facecolor", 0.7*[1 1 1], "edgecolor", 0.7*[1 1 1]) ;
   plot(datenum(s.id(I1,:)), s.x(I1,end), "k", "linewidth", 3) ;

   I = all(pdd.id(I2,1:3) == d0, 2) ;
   w = 0 * double(pdd.c(I2,end)) ; w(I) = 1 ;

   if pdd.c(I2,end)(I)
      fc = "r" ;
   else
      fc = "w" ;
   endif
   
   hb = bar(datenum(pdd.id(I2,:)), w, 1, "edgecolor", "r", "facecolor", fc) ;

   datetick("mmm/dd", "keeplimits") ;
   axis tight

   xlabel("") ;
   ylabel("probability") ;

   d1 = datenum(d(1,:)) ;
   d2 = datenum(d(2,:)) ;

   d1 = datestr(d1, "yyyy-mm-dd") ;
   d2 = datestr(d2, "yyyy-mm-dd") ;
   
##   title(sprintf("%s events and predictions %s to %s", REG, d1, d2)) ;
   
endfunction
