## usage: h = plot_fit (fit)
##
##
function h = plot_fit (fit)

   global REG NH
   
   h = figure("position", [0.8 0.5 0.2 0.5]) ;

   clf ;
   ax(1) = subplot(3, 1, 1) ;
   plot_penalized(fit) ;
   set(ax(1), "xlabel", "", "ylabel", "pred. coeff.", "ylim", [-0.2 0.3]) ;
   ax(2) = subplot(3, 1, 2) ;
   semilogx(fit.lambda, sum(fit.beta(2:end,:) ~= 0, 1)) ;
   set(ax(2), "xlabel", "", "ylabel", "# of pred.") ;
   ax(3) = subplot(3, 1, 3) ;
   semilogx(fit.CV.lambda', fit.CV.cve) ;
   xlabel({"imposed regularity"}) ; ylabel({"CV error"}) ;
   set(ax, "xdir", "normal") ;
   set(ax, "xlim", xlim(ax(1)), "Nextplot", "add") ;
   arrayfun(@(a) plot(a, [fit.lambda(fit.jLasso) fit.lambda(fit.jLasso)], ylim(a), "--k"), ax) ;

   set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
   set(findall("type", "axes"), "fontsize", 24) ;
   set(findall("type", "text"), "fontsize", 22) ;

   hgsave(sprintf("nc/%s.%02d/LASSO.og", REG, NH)) ;
   print(sprintf("nc/%s.%02d/LASSO.png", REG, NH)) ;
   
endfunction
