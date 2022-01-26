## usage: [h1, h2] = plot_case (ptr, pdd, prob, D, d, jVAR = 1, cx = 1)
##
## plot pattern and probs for D, d
function [h1, h2] = plot_case (ptr, pdd, prob, D, d, jVAR = 1, cx = 1)

   global REG NH

   ds = datestr(datenum(d), "yyyy-mm") ;
   
   h1 = figure(1) ;

   clf ;
   plot_prob(prob, pdd, D, d) ;
   set(findall("-property", "fontname"), "fontname", "Linux Biolinum", "fontsize", 24) ;
   printf("--> nc/%s.%02d/%s.png\n", REG, NH, ds) ;
   print(sprintf("nc/%s.%02d/%s.png", REG, NH, ds)) ;

   h2 = figure(2, "position", [0.7 0.4 0.3 0.6]) ;
   clf ; hold on

   I = sdate(ptr.id, d) ;
   xm = squeeze(ptr.x(I,jVAR,:,:)) ;
   imagesc(ptr.lon, ptr.lat, xm') ;
   set(gca, "ydir", "normal") ;
   xlabel("longitude") ; ylabel("latitude") ;
   colormap(brewermap(9, "Blues"))
   hc = colorbar ;
   pos = get(get(hc, "label"), "extent")(2) ;
   set(get(hc, "label"), "string", "cape  [J/kg]", "position", [0.5 2.15*pos], "rotation", 0) ;

   hb = borders("germany", "color", "black") ;

   I = sdate(pdd.ts.id, d) ;
   x = pdd.ts.x(I,jVAR) ;
   h = scatter(pdd.ts.lon(I), pdd.ts.lat(I), cx*x, "r", "o", "filled") ;
   [xn in] = min(x) ; [xx ix] = max(x) ;
   hn = scatter(pdd.ts.lon(I)(in), pdd.ts.lat(I)(in), cx*x(in), "r", "o", "filled") ;
   hx = scatter(pdd.ts.lon(I)(ix), pdd.ts.lat(I)(ix), cx*x(ix), "r", "o", "filled") ;
   sn = sprintf("{\\it{E_{T,A}}} = %.0f", xn) ; sx = sprintf("{\\it{E_{T,A}}} = %.0f", xx) ;
   legend([hx hn], {sx sn}, "box", "off", "location", "northeast") ;

   set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
   set(findall("type", "axes"), "fontsize", 24) ;
   set(findall("type", "text"), "fontsize", 24) ;

   printf("--> nc/%s.%s.png\n", ptr.vars{jVAR}, ds) ;
   hgsave(sprintf("nc/%s.%s.og", ptr.vars{jVAR}, ds)) ;
   print(sprintf("nc/%s.%s.png", ptr.vars{jVAR}, ds)) ;

endfunction
