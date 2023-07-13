## usage: [h1, h2] = plot_case (ptr, pdd, s, D, d, jVAR = 1, skl, cx = 1)
##
## plot pattern and probs for D, d
function [h1, h2] = plot_case (ptr, pdd, s, D, d, jVAR = 1, skl, cx = 1)

   global PFX NH

   h1 = figure(1) ;
<<<<<<< HEAD
   clf ; pause(2) ;
   plot_prob(s, pdd, D, d) ;
=======
   clf ;
   plot_prob(s, skl, pdd, D, d) ;
>>>>>>> carlofff1
   set(findall("-property", "fontname"), "fontname", "Libertinus Sans", "fontsize", 24) ;

   h2 = figure(2, "position", [0.7 0.4 0.3 0.6]) ;
   clf ; hold on ; pause(2) ;

   I = sdate(ptr.id, d) ;
   xm = squeeze(ptr.x(I,:,:)) ;
   imagesc(ptr.lon, ptr.lat, xm') ;
   set(gca, "ydir", "normal") ;
   xlabel("longitude") ; ylabel("latitude") ;
   colormap(brewermap(9, "Blues"))
   hc = colorbar ;
   pos = get(get(hc, "label"), "extent")(2) ;
   set(get(hc, "label"), "string", "cape  [J/kg]", "position", [0.5 2.1*pos], "rotation", 0) ;

   hb = borders("germany", "color", "black") ;

   I = sdate(pdd.ts.id, d) ;
   if any(I)
      x = pdd.ts.x(I,jVAR) ;
      h = scatter(pdd.ts.lon(I), pdd.ts.lat(I), cx*x, "r", "o", "filled") ;
      [xn in] = min(x) ; [xx ix] = max(x) ;
      hn = scatter(pdd.ts.lon(I)(in), pdd.ts.lat(I)(in), cx*x(in), "r", "o", "filled") ;
      hx = scatter(pdd.ts.lon(I)(ix), pdd.ts.lat(I)(ix), cx*x(ix), "r", "o", "filled") ;
      sn = sprintf("{\\it{E_{T,A}}} = %.0f", xn) ; sx = sprintf("{\\it{E_{T,A}}} = %.0f", xx) ;
      legend([hx hn], {sx sn}, "box", "off", "location", "northeast") ;
   endif
   set(findall("-property", "fontname"), "fontname", "Libertinus Sans") ;
   set(findall("type", "axes"), "fontsize", 24) ;
   set(findall("type", "text"), "fontsize", 24) ;

endfunction
