## usage: [h1, h2] = plot_case (ptr, pdd, prob, D, d, jVAR = 1)
##
## plot pattern and probs for D, d
function [h1, h2] = plot_case (ptr, pdd, prob, D, d, jVAR = 1)

   global REG NH

   ds = datestr(datenum(d), "yyyy-mm") ;
   
   h1 = figure() ;

   clf ;
   plot_prob(prob, pdd, D, d) ;
   set(findall("-property", "fontname"), "fontname", "Linux Biolinum", "fontsize", 24) ;
   print(sprintf("nc/%s.%02d/%s.png", REG, NH, ds)) ;

   h2 = figure("position", [0.7 0.4 0.3 0.6]) ;
   clf ;

   I = sdate(ptr.id, d) ;
   xm = zscore(squeeze(ptr.x(:,jVAR,:,:))) ;
   xm = squeeze(xm(I,:,:)) ;
   imagesc(ptr.lon, ptr.lat, xm') ;
   set(gca, "ydir", "normal", "clim", [-3 3], "xtick", [], "ytick", [], "xticklabel", [], "yticklabel", [])
##   title(sprintf("normalized %s for %s", toupper(ptr.vars{jVAR}), ds)) ;
##   xlabel("longitude") ; ylabel("latitude") ;
   hc = colorbar ;
   colormap(redblue)
   
   hold on
   hb = borders("germany", "color", "black") ;

   set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
   set(findall("type", "axes"), "fontsize", 30) ;
   set(findall("type", "text"), "fontsize", 22) ;

   hgsave(sprintf("nc/%s.%s.og", ptr.vars{jVAR}, ds)) ;
   print(sprintf("nc/%s.%s.png", ptr.vars{jVAR}, ds)) ;

   clf ;
   I = sdate(pdd.id, d) ;
   w = pdd.x(I,1,:,:) ;
   xm = squeeze(any(w > pdd.q, 1)) ;
   imagesc(pdd.lon-0.125, pdd.lat-0.125, xm') ;
##   xticks(pdd.lon) ; yticks(pdd.lat) ; 
   colormap(flip(gray(5)))
##   title(sprintf("%s > 0 for %s", toupper(pdd.vars{1}), ds)) ;
   set(gca, "ydir", "normal", "clim", [0 1], "xtick", [], "ytick", [], "xticklabel", [], "yticklabel", [])
   ##xlabel("longitude") ; ylabel("latitude") ;
   
   hold on
   hb = borders("germany", "color", "black") ;

   set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
   set(findall("type", "axes"), "fontsize", 30) ;
   set(findall("type", "text"), "fontsize", 22) ;

   hgsave(sprintf("nc/%s.%02d/%s.%s.og", REG, NH, pdd.vars{1}, ds)) ;
   print(sprintf("nc/%s.%02d/%s.%s.png", REG, NH, pdd.vars{1}, ds)) ;

endfunction
