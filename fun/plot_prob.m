## usage: plot_prob (s, skl, pdd, d, d0)
##
##
function plot_prob (s, skl, pdd, d, d0)

   global PFX
   
   I1 = sdate(s.prob.id, d) ;
   I2 = sdate(pdd.id, d) ;

   clf ; hold on
   hb = bar(datenum(pdd.id(I2,:)), double(pdd.c(I2,end)), 1) ;
   set(hb, "facecolor", 0.7*[1 1 1], "edgecolor", 0.7*[1 1 1]) ;
   plot(datenum(s.prob.id(I1,:)), s.prob.x(I1,end), "k", "linewidth", 3) ;
   plot(datenum(s.prob.id(I1,:)([1 end],:)), [s.th.(skl) s.th.(skl)], "k--", "linewidth", 1) ;

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

   ds = datestr(datenum(d(1,:)), "yyyy") ;

   xlabel(sprintf("%s", ds)) ;
   ylabel("probability") ;

<<<<<<< HEAD
   title(sprintf("typical %s events and %s predictions", PFX, s.name)) ;
=======
   title(sprintf("typical %s events and %s predictions", REG, s.prob.name)) ;
>>>>>>> carlofff1
   
endfunction
