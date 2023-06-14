
reset(0) ;
set(0, "defaultfigureunits", "normalized", "defaultfigurepapertype", "A4") ;
set(0, "defaultfigurepaperunits", "normalized", "defaultfigurepaperpositionmode", "auto") ;
set(0, "defaultfigureposition", [0.7 0.7 0.3 0.3]) ;
set(0, "defaultaxesgridalpha", 0.3)
set(0, "defaultaxesfontname", "Libertinus Sans", "defaulttextfontname", "Libertinus Sans") ;

set(0, "defaultaxesfontsize", 18, "defaulttextfontsize", 18, "defaultlinelinewidth", 2) ;


addpath ~/oct/nc/maxdistcolor
JMDL = 1 : 4 ;
colS = maxdistcolor(length(JMDL), @(m) sRGB_to_OSAUCS (m, true, true)) ;
colD = maxdistcolor(length(NET), @(m) sRGB_to_OSAUCS (m, true, true)) ;
##col = col(randperm(ncol),:) ;

pfx = @(net) sprintf("models/%s/%s.%02d/%s.%s.%s", net, PFX, NH, net, ind, pdd.lname) ;

### plots
alpha = 0.05 ;
qEta = sum(any(any(pdd.x(:,jVAR,:,:) > 0, 3), 4)) / rows(pdd.x) ;
global COL

## training curves
COL = [0.2 0.7 0.2 ; 0.2 0.2 0.7] ;
jNET = 2 ;
clf ;
jNET++ ;
net = NET{jNET} ;
lfile = sprintf("%s.log", pfx(net)) ;
plot_log(gca, lfile, "loss", gap = 2, pse = 0, plog = 0) ;
title(net)
hgsave(sprintf("nc/paper/loss.%s.og", net)) ;
print(sprintf("nc/paper/loss.%s.svg", net)) ;

GAP = [1 1 1 1 1 1 1 1 1] ;
clf ; j = 0 ; clear H ;
for net = NET((1:9) ~= jNET)
   net = net{:} ;
   ax(++j) = subplot(2, 4, j) ;
   if exist(lfile = sprintf("%s.log", pfx(net)), "file") ~= 2
      warning("file not found: %s", lfile) ;
   endif
   jN = find(strcmp(NET, net)) ;
   H(j,:) = plot_log(ax(j), lfile, "loss", gap = GAP(jN), pse = 0, plog = 0) ;
   title(net)
endfor
delete(H(:,3)) ;
set(findobj("-property", "fontsize"), "fontsize", 12) ;
set(ax, "xtick", 2:2:8) ;
hgsave(sprintf("nc/paper/loss.og")) ;
print(sprintf("nc/paper/loss.svg")) ;


### cases
jNET = 3 ;
net = NET{jNET} ; sfx = sprintf("data/%s.%02d/%dx%d", REG, NH, RES{jNET}) ;
load(sprintf("data/ind/ind.%s.ob", GREG)) ;
load(sprintf("%s/Deep.%s.%s.%s.ob", sfx, net, IND, pdd.lname)) ;
clf ; jVAR = 3 ;
## June 2013
D = [2013, 5, 15 ; 2013, 6, 15] ; d = [2013 5 31] ;
## July 2014
D = [2014 7 15 ; 2014 8 15] ; d = [2014 7 28] ;
## May 2016
D = [2016, 5, 15 ; 2016, 6, 15] ; d = [2016 5 29] ;

ds = datestr(datenum(d), "yyyy-mm") ;
[h1 h2] = plot_case(cape, pdd, deep.prob, D, d, jVAR, cx = 5) ;
printf("--> nc/%s.%02d/%s.svg\n", REG, NH, ds) ;
print(h1, sprintf("nc/%s.%02d/%s.svg", REG, NH, ds)) ;
printf("--> nc/cape.%s.svg\n", ds) ;
hgsave(h2, sprintf("nc/cape.%s.og", ds)) ;
print(h2, sprintf("nc/cape.%s.svg", ds)) ;


if 0 		    # Eta for case
   clf ;
   I = pdd.id(:,1) == 2016 & ismember(pdd.id(:,2), MON) ;
   printf("average rate Eta > 0: %7.0f%%\n", 100*qEta) ;
   scatter(datenum(pdd.id(I,:)), nanmean(nanmean(pdd.x(I,1,:,:), 3), 4), 60, "k", "filled") ; axis tight
   set(gca, "ytick", [0 0.01 0.02])
   xlabel("") ; ylabel("Eta") ;
   datetick("mmm") ;
   hgsave(sprintf("nc/paper/Eta.og")) ;
   print(sprintf("nc/paper/Eta.svg")) ;
endif


### performance
## Shallow
clear Pskl ;
## without EOFs
JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.R%s.%s.ot", REG, NH, ind, pdd.lname))
Pskl(:,:,1) = skl(:,[jSKL end]) ;
JVAR = [2 4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.R%s.%s.ot", REG, NH, ind, pdd.lname))
Pskl(:,:,2) = skl(:,[jSKL end]) ;
## with EOFs
JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ind, pdd.lname))
Pskl(:,:,3) = skl(:,[jSKL end]) ;
JVAR = [2 4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ind, pdd.lname))
Pskl(:,:,4) = skl(:,[jSKL end]) ;

Pskl = Pskl(JMDL,:,:) ;

figure(1, "position", [0.7 0.7 0.45 0.3]) ; sz = 70 ;
clf ; clear ax
ax(1) = subplot(1, 2, 1) ; hold on ;
for jMDL = 1 : size(Pskl, 1)
   hg(jMDL) = scatter(Pskl(jMDL,1,2), Pskl(jMDL,1,1), sz, colS(jMDL,:), "", "s", "linewidth", 1.5) ;
   hgE(jMDL) = scatter(Pskl(jMDL,1,4), Pskl(jMDL,1,3), sz, colS(jMDL,:), "filled", "s") ;
endfor
xlabel([SKL{jSKL} " with cape"]) ; ylabel([SKL{jSKL} " without cape"]) ;

ax(2) = subplot(1, 2, 2) ; hold on ;
jPLT = 0 ;
for jMDL = 1 : length(MDL)
   jPLT++ ;
   hgS(jPLT) = scatter(Pskl(jPLT,1,4), Pskl(jPLT,end,4), sz, colS(jPLT,:), "filled", "s") ;
   printf("%s:\t%7.2f\n", MDL{jMDL}, Pskl(jPLT,1,4)) ;
endfor

## Deep
for jNET = 1 : length(NET)
   jPLT++ ;
   net = NET{jNET} ;

   JVAR = [2 4 10] ;
   ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.lname) ;
   load(mfile) ;
   printf("<-- %s: %7.2f %7.2f\n", mfile, [mean(skl(:,jSKL)) max(skl(:,jSKL))]) ;
   hg(jNET) = hggroup() ;
   scatter(skl(:,jSKL), skl(:,end), sz/4, colD(jNET,:), "d", "filled", "parent", hg(jNET)) ;
   hgD(jNET) = scatter(mean(skl(:,jSKL)), mean(skl(:,end)), sz, colD(jNET,:), "d", "filled", "parent", hg(jNET)) ;

   JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.lname) ;
   w = load(mfile) ;
   printf("<-- %s\n", mfile) ;
   scatter(ax(1), mean(skl(:,jSKL)), mean(w.skl(:,jSKL)), sz, colD(jNET,:), "d", "filled") ;
   axes(ax(2)) ;
endfor
axis(ax(1), "tight") ;
xl = [xlim(ax(1))(1) - 0.02 xlim(ax(1))(2) + 0.02] ;
yl = [ylim(ax(1))(1) - 0.02 ylim(ax(1))(2) + 0.02] ;
vn = min([xl yl](:)) ; vx = max([xl yl](:)) ;
plot(ax(1), [vn vx], [vn vx], "k--") ;
axis(ax(1), "tight") ;
xl = [0.415 0.525] ; yl = [0.33 0.51] ;
set(ax(2), "xlim", xl, "ylim", yl) ;
set(ax, "xgrid", "on", "ygrid", "on") ;
xlabel(ax(2), SKL{jSKL}) ; ylabel(ax(2), "crossentropy") ;
hlS = legend(ax(1), hgE, upper(MDL(JMDL)), "box", "off", "location", "northwest") ;
hlD = legend(ax(2), hgD, NET, "box", "off", "location", "southwest") ;
set(findall(hlS, "type", "axes"), "xcolor", "none", "ycolor", "none") ;
pos = get(ax(1), "position") ; pos(1) -= 0.05 ; set(ax(1), "position", pos)
pos = get(ax(2), "position") ; pos(1) += 0.05 ; set(ax(2), "position", pos)
set(findobj("-property", "fontsize"), "fontsize", 16) ;
set(hlS, "position", [0.43 0.69 0.10 0.24])
set(hlD, "position", [0.438 0.17 0.10 0.5])

hgsave(sprintf("nc/paper/SI/%s_scatter.og", SKL{jSKL})) ;
print(sprintf("nc/paper/SI/%s_scatter.svg", SKL{jSKL})) ;

## reliability curves
set(gcf, "position", get(groot, "defaultfigureposition")) ;
clf ; j = 0 ; clear ax h r
for kMDL = 1 : length(MDL)
   mdl = MDL{kMDL} ; sfx = sprintf("data/%s.%02d/%dx%d", REG, NH, RES{kMDL}) ;
   if exist(pfile = sprintf("data/%s.%02d/Shallow.%s.%s.%s.ob", REG, NH, mdl, IND, pdd.lname), "file") == 2
      load(pfile) ;
   else
      warning("file not found: %s", pfile) ;
   endif
   [r(:,kMDL) b] = rlb(shallow.prob.x(:,2), pdd.c, 10) ;
##   ax(++j) = subaxis(2, 2, j, "SpacingH", 0.07, "SpacingV", 0.17) ;
   ax(++j) = subplot(2, 2, j) ;
   plot(b, r(:,kMDL), "color", colS(kMDL,:), [0 1], [0 1], "k--") ;
   title(upper(mdl))
   pos = get(gca, "position") ;
   ix(j) = axes("position",[pos(1)+0.21 pos(2)+0.05 pos(3)/3 pos(4)/3]) ;
   [nn xx] = hist(shallow.prob.x(:,2), 10, "facecolor", "k", "edgecolor", "k") ;
   bar(xx, nn/size(shallow.prob.x,1), "barwidth", 0.2, "facecolor", "k", "edgecolor", "k") ;
   ylim([0 0.35]) ;
   set(get(get(gca, "children"), "baseline"), "visible", "off") ;
   set(gca, "XTick", [], "YTick", [], "box", "off", "ycolor", "none")
endfor
set(ax, "XTick", [0.2 0.5 0.8], "YTick", [0.2 0.5 0.8]) ;
xlabel(ax(3), "forecast prob.") ; ylabel(ax(3), "observed freq.")
set(findobj("-property", "fontsize"), "fontsize", 16) ;
hgsave(sprintf("nc/paper/Shallow.rlb.og")) ;
print(sprintf("nc/paper/Shallow.rlb.svg")) ;

clf ; j = 0 ; clear ax h r
for kNET = 1 : length(NET)
   net = NET{kNET} ; sfx = sprintf("data/%s.%02d/%dx%d", REG, NH, RES{kNET}) ;
   if exist(pfile = sprintf("%s/Deep.%s.%s.%s.ob", sfx, net, ind, pdd.lname), "file") == 2
      load(pfile) ;
   else
      warning("file not found: %s", pfile) ;
   endif
   [r(:,kNET) b] = rlb(deep.prob.x(:,2), pdd.c, 10) ;
   ax(++j) = subplot(3, 3, j) ;
   plot(b, r(:,kNET), "color", colD(kNET,:), [0 1], [0 1], "k--") ;
   title(net)
   pos = get(gca, "position") ;
   ix(j) = axes("position",[pos(1)+0.12 pos(2)+0.03 pos(3)/3 pos(4)/3]) ;
   [nn xx] = hist(deep.prob.x(:,2), 10, "facecolor", "k", "edgecolor", "k") ;
   bar(xx, nn/size(deep.prob.x,1), "barwidth", 0.2, "facecolor", "k", "edgecolor", "k") ;
   ylim([0 0.35]) ;
   set(get(get(gca, "children"), "baseline"), "visible", "off") ;
   set(gca, "XTick", [], "YTick", [], "box", "off", "ycolor", "none")
endfor
set(ax, "XTick", [0.2 0.5 0.8], "YTick", [0.2 0.5 0.8]) ;
xlabel(ax(7), "forecast prob.") ; ylabel(ax(7), "observed freq.")
set(findobj("-property", "fontsize"), "fontsize", 14) ;
hgsave(sprintf("nc/paper/Deep.rlb.og")) ;
print(sprintf("nc/paper/Deep.rlb.svg")) ;



## plot scatter of obs vs sim annual probs!!
C1 = cellfun(@(mdl) sprintf("Shallow.%s", mdl), MDL, "UniformOutput", false) ;
C1n = toupper(MDL) ;
C2= cellfun(@(net) sprintf("Deep.%s", net), NET, "UniformOutput", false) ;
C2n = NET ;
JM = [2 11] ;
C = union(C1, C2, "stable")(JM) ;
Cn = union(C1n, C2n, "stable")(JM) ;

## ERA5
COL = [1 1 1 ; 0.2 0.7 0.2 ; 0.2 0.2 0.7 ; 0.7 0.2 0.2] ;
figure(1, "position", [0.7 0.7 0.4 0.34]) ; sz = 40 ;
[o.id o.x] = annstat(pdd.id, real(pdd.c), @nanmean) ;
Y = [1979 2005] ;
oC = sdate(o.id, [2001 1 1 ; 2010 1 1]) ;
oV = sdate(o.id, [2011 1 1 ; 2020 1 1]) ;

jMDL = 0 ; clf ; hold on
for mdl = C
   jMDL++ ;
   mdl = mdl{:} ;
   eval(sprintf("[s.id s.x] = annstat(ana.prob.id, ana.prob.%s, @nanmean) ;", strrep(mdl, "-", "_"))) ;
   s.x = s.x(:,2) ;
   sC = sdate(s.id, [2001 1 1 ; 2010 1 1]) ;
   sV = sdate(s.id, [2011 1 1 ; 2020 1 1]) ;
   xn = min([o.x ; s.x]) ; xx = max([o.x ; s.x]) ;
   ax1 = subplot(2, 3, 3*(jMDL-1) + (1:2)) ; hold on
   plot(s.id([1 end],1), [qEta qEta], "color", 0.7*COL(1,:), "linewidth", 2, "linestyle", "--") ;
   scatter(o.id(:,1), o.x(:,1), 0.7*sz, 0*COL(1,:), "x") ;
   scatter(s.id(~(sC|sV),1), s.x(~(sC|sV),1), sz, COL(3,:), "filled") ;
   scatter(s.id(sC,1), s.x(sC,1), sz, COL(2,:), "filled") ;
   scatter(s.id(sV,1), s.x(sV,1), sz, COL(3,:), "filled") ;
   su = selper(s, Y(1), Y(2)) ;
   [B, BINT, R, RINT, STATS] = regress(su.x, [ones(rows(su.x),1) su.id(:,1)]) ;
   yf = [ones(rows(su.x),1) su.id(:,1)] * B ;
   h = plot(su.id(:,1), yf, "color", 0*COL(1,:), "linewidth", 2) ;
   xlim(s.id([1 end],1)) ;
   ylim([0.8*ylim()(1) 1.1*ylim()(2)]) ;
   xlabel("year") ; ylabel(sprintf("P")) ;
   if STATS(3) < alpha
      xt = mean(get(h, "xdata")) - 5 ;
      text(xt, 0.9*ylim()(2), sprintf("{\\ittr=%.2f}", 100*B(2)), "color", 0*COL(1,:)) ;
   endif
   set(gca, "fontsize", 14)
   ax2 = subplot(2, 3, 3*(jMDL-1) + 3) ; hold on
   plot([xn xx], [xn xx], "color", 0*COL(1,:), "linewidth", 2, "linestyle", "--") ;
   scatter(o.x(oC,1), s.x(sC,1), sz, COL(2,:), "filled") ;
   scatter(o.x(oV,1), s.x(sV,1), sz, COL(3,:), "filled") ;
   xlim([xn xx]) ; ylim([xn xx]) ;
   axis square ;
   xlabel("OBS") ; ylabel(sprintf("%s", Cn{jMDL})) ;
##   xlabel("{\\itP_{CatRaRE}}, OBS") ; ylabel(sprintf("{\\itP_{CatRaRE}}, %s", mdl)) ;
   r = corr(o.x(oV,1), s.x(sV,1)) ;
   printf("%s:\t%.2f\t%.2f\t%.2f\n", mdl, r, 100*B(2), STATS(3)<alpha) ;
   text(xn, xx, sprintf("{\\it\\rho = %.2f}", r), "color", COL(3,:)) ;
   set(gca, "fontsize", 14, "XTick", [0.4 0.6], "YTick", [0.4 0.6]) ;
   yl = [min(ylim(ax1)(1), ylim(ax2)(1)) max(ylim(ax1)(2), ylim(ax2)(2))] ;
   set([ax1 ax2], "ylim", yl)
endfor
hgsave(sprintf("nc/paper/ERA5.%s-%s.og", Cn{:})) ;
print(sprintf("nc/paper/ERA5.%s-%s.svg", Cn{:})) ;

figure(1, "position", [0.7 0.3 0.3 0.7]) ; sz = 20 ;
JMa = setxor(JM, 1 : length(MDL) + length(NET)) ;
Call = union(C1, C2, "stable")(JMa) ;
Calln = union(C1n, C2n, "stable")(JMa) ;
clf ; hold on ; clear ax
jPLT = jMDL = 0 ; nMDL = round(length(Call)/2) ; fs = 14 ;
for mdl = Call
   jPLT++ ; jMDL++ ;
   if jPLT/nMDL > 1
      set(findobj("-property", "fontsize"), "fontsize", fs) ;
      hgsave(sprintf("nc/paper/ERA5.1.og")) ;
      print(sprintf("nc/paper/ERA5.1.svg")) ;
      jPLT = rem(jPLT, nMDL) ;
      clf ; hold on ;
   endif
   mdl = mdl{:} ;
   ax(jPLT,1) = subplot(nMDL, 3, 3*(jPLT-1) + (1:2)) ; hold on
   eval(sprintf("[s.id s.x] = annstat(ana.prob.id, ana.prob.%s, @nanmean) ;", strrep(mdl, "-", "_"))) ;
   s.x = s.x(:,2) ;
   sC = sdate(s.id, [2001 1 1 ; 2010 1 1]) ;
   sV = sdate(s.id, [2011 1 1 ; 2020 1 1]) ;
   xn = min([o.x ; s.x]) ; xx = max([o.x ; s.x]) ;
   plot(s.id([1 end],1), [qEta qEta], "color", 0.7*COL(1,:), "linewidth", 2, "linestyle", "--") ;
   scatter(o.id(:,1), o.x(:,1), 0.7*sz, 0*COL(1,:), "x") ;
   scatter(s.id(~(sC|sV),1), s.x(~(sC|sV),1), sz, COL(3,:), "filled") ;
   scatter(s.id(sC,1), s.x(sC,1), sz, COL(2,:), "filled") ;
   scatter(s.id(sV,1), s.x(sV,1), sz, COL(3,:), "filled") ;
   su = selper(s, Y(1), Y(2)) ;
   [B, BINT, R, RINT, STATS] = regress(su.x, [ones(rows(su.x),1) su.id(:,1)]) ;
   yf = [ones(rows(su.x),1) su.id(:,1)] * B ;
   h = plot(su.id(:,1), yf, "color", 0*COL(1,:), "linewidth", 2) ;
   xlim(s.id([1 end],1)) ;
   ylim([0.8*ylim()(1) 1.1*ylim()(2)]) ;
   xlabel("year") ; ylabel(sprintf("P")) ;
   if STATS(3) < alpha
      xt = get(h, "xdata")(1) + 5 ;
      text(xt, 0.9*ylim()(2), sprintf("{\\ittr=%.2f}", 100*B(2)), "color", 0*COL(1,:)) ;
   endif
   set(gca, "fontsize", 14)
   ax(jPLT,2) = subplot(nMDL, 3, 3*(jPLT-1) + 3) ; hold on
   plot([xn xx], [xn xx], "color", 0*COL(1,:), "linewidth", 2, "linestyle", "--") ;
   scatter(o.x(oC,1), s.x(sC,1), sz, COL(2,:), "filled") ;
   scatter(o.x(oV,1), s.x(sV,1), sz, COL(3,:), "filled") ;
   xlim([xn xx]) ; ylim([xn xx]) ;
   set(gca, "XTick", [0.4 0.6], "YTick", [0.4 0.6]) ;
   axis square ;
   xlabel("OBS") ; ylabel(sprintf("%s", Calln{jMDL})) ;
##   xlabel("{\\itP_{CatRaRE}}, OBS") ; ylabel(sprintf("{\\itP_{CatRaRE}}, %s", mdl)) ;
   r = corr(o.x(oV,1), s.x(sV,1)) ;
   printf("%s:\t%.2f\t%.2f\t%.2f\n", mdl, r, 100*B(2), STATS(3)<alpha) ;
   text(xn, xx, sprintf("{\\it\\rho = %.2f}", r), "color", COL(3,:)) ;
   set(gca, "fontsize", 14)
   yl = [min(ylim(ax(jPLT,1))(1), ylim(ax(jPLT,2))(1)) max(ylim(ax(jPLT,1))(2), ylim(ax(jPLT,2))(2))] ;
   set(ax(jPLT,:), "ylim", yl)
   drawnow
endfor
set(findobj("-property", "fontsize"), "fontsize", fs) ;
hgsave(sprintf("nc/paper/ERA5.2.og")) ;
print(sprintf("nc/paper/ERA5.2.svg")) ;


## GCM/RCM
figure(1, "position", [0.7 0.7 0.4 0.4]) ; sz = 30 ;
jMDL = 0 ; clf ; hold on
for mdl = C
   jMDL++ ;
   mdl = mdl{:} ;
   subplot(2, 1, jMDL) ; hold on
   clear h stats ; j = 0 ;
   h(++j) = plot([1951 2100], [qEta qEta], "color", 0.7*COL(1,:), "linewidth", 2, "linestyle", "--") ;
   for sim = SIM(j+1:end)
      j++ ;
      eval(sprintf("sim = %s ;", sim{:})) ;
      eval(sprintf("[s.id s.x] = annstat(sim.prob.id, sim.prob.%s, @nanmean) ;", strrep(mdl, "-", "_"))) ;
      scatter(s.id(:,1), s.x(:,2), sz, COL(j+1,:), "filled") ; axis tight
      if strcmp(sim.prob.name, "historical")
	 su = selper(s, Y(1), Y(2)) ;
      else
	 su = s ;
      endif
      [B, BINT, R, RINT, STATS] = regress(su.x(:,2), [ones(rows(su.x),1) su.id(:,1)]) ;
      ct(j) = 100*B(2) ;
      stats(j,:) = STATS ;
      yf = [ones(rows(su.x),1) su.id(:,1)] * B ;
      h(j) = plot(su.id(:,1), yf, "color", COL(j+1,:), "linewidth", 2) ;
      xlabel("year") ; ylabel(sprintf("P")) ;
   endfor
   printf("%s:\t%.2f\t%d\t%.2f\t%d\n", mdl, ct(2), stats(2,3)<alpha, ct(3), stats(3,3)<alpha) ;
   ylim([0.25 0.7]) ;
   for j = 2:rows(stats)
      if stats(j,3) < alpha
	 xt = mean(get(h(j), "xdata")) - 10 ;
	 text(xt, 1.2*ylim()(1), sprintf("{\\ittr=%.2f}", ct(j)), "color", COL(j+1,:)) ;
      endif
   endfor
   legend(h, {"CLIM" NSIM{2:end}}, "box", "off", "location", "southeast") ;
   j = eval(sprintf("find(strcmp({%s.prob.nc.Attributes.Name}, \"driving_model_id\")) ;", SIM{2})) ;
   GCM = eval(sprintf("%s.prob.nc.Attributes(j).Value ;", SIM{2})) ;
   j = eval(sprintf("find(strcmp({%s.prob.nc.Attributes.Name}, \"model_id\")) ;", SIM{2})) ;
   RCM = eval(sprintf("%s.prob.nc.Attributes(j).Value ;", SIM{2})) ;
   htit = title(sprintf("%s", Cn{jMDL}), "fontsize", 20) ;
   pos = get(htit, "position") ;
   ht = text(1960, pos(2) - 0.05, sprintf("GCM: %s\nRCM: %s", GCM, RCM), "fontsize", 14) ;
endfor
hgsave(sprintf("nc/paper/%s.%s.%s-%s.og", GCM, RCM, Cn{:})) ;
print(sprintf("nc/paper/%s.%s.%s-%s.svg", GCM, RCM, Cn{:})) ;

figure(1, "position", [0.7 0.3 0.3 0.7]) ; sz = 20 ;
clf ; hold on ;
jPLT = jMDL = 0 ; nMDL = round(length(Call)/2) ; sz = 10 ; fs = 12 ;
for mdl = Call
   jPLT++ ; jMDL++ ;
   if jPLT/nMDL > 1
      set(findobj("-property", "fontsize"), "fontsize", fs) ;
      hgsave(sprintf("nc/paper/GCM_RCM.1.og")) ;
      print(sprintf("nc/paper/GCM_RCM.1.svg")) ;
      jPLT = rem(jPLT, nMDL) ;
      clf ; hold on ;
   endif
   mdl = mdl{:} ;
   ax(jPLT,1) = subplot(nMDL, 1, jPLT) ; hold on
   clear h stats ; j = 0 ;
   h(++j) = plot([1951 2100], [qEta qEta], "color", 0.7*COL(1,:), "linewidth", 2, "linestyle", "--") ;
   for sim = SIM(j+1:end)
      j++ ;
      eval(sprintf("sim = %s ;", sim{:})) ;
      eval(sprintf("[s.id s.x] = annstat(sim.prob.id, sim.prob.%s, @nanmean) ;", strrep(mdl, "-", "_"))) ;
      scatter(s.id(:,1), s.x(:,2), sz, COL(j+1,:), "filled") ; axis tight
      if strcmp(sim.prob.name, "historical")
	 su = selper(s, Y(1), Y(2)) ;
      else
	 su = s ;
      endif
      [B, BINT, R, RINT, STATS] = regress(su.x(:,2), [ones(rows(su.x),1) su.id(:,1)]) ;
      ct(j) = 100 * B(2) ;
      stats(j,:) = STATS ;
      yf = [ones(rows(su.x),1) su.id(:,1)] * B ;
      h(j) = plot(su.id(:,1), yf, "color", COL(j+1,:), "linewidth", 2) ;
      xlabel("year") ; ylabel(sprintf("P")) ;
   endfor
   printf("%s:\t%.2f\t%d\t%.2f\t%d\n", mdl, ct(2), stats(2,3)<alpha, ct(3), stats(3,3)<alpha) ;
   ylim([0.25 0.7]) ;
   for j = 2:rows(stats)
      if stats(j,3) < alpha
	 xt = mean(get(h(j), "xdata")) - 10 ;
	 text(xt, 1.2*ylim()(1), sprintf("{\\ittr=%.2f}", ct(j)), "color", COL(j+1,:)) ;
      endif
   endfor
   htit = title(sprintf("%s", Calln{jMDL}), "fontsize", 20) ;
   if jPLT ~= 1 continue ; endif
##   j = eval(sprintf("find(strcmp({%s.prob.nc.Attributes.Name}, \"driving_model_id\")) ;", SIM{2})) ;
##   GCM = eval(sprintf("%s.prob.nc.Attributes(j).Value ;", SIM{2})) ;
##   j = eval(sprintf("find(strcmp({%s.prob.nc.Attributes.Name}, \"model_id\")) ;", SIM{2})) ;
##   RCM = eval(sprintf("%s.prob.nc.Attributes(j).Value ;", SIM{2})) ;
##   pos = get(htit, "position") ;
##   ht = text(1955, pos(2) - 0.05, sprintf("GCM: %s\nRCM: %s", GCM, RCM), "fontsize", 14) ;
   legend(h, {"CLIM" NSIM{2:end}}, "box", "off", "location", "southeast") ;
endfor
set(findobj("-property", "fontsize"), "fontsize", fs) ;
hgsave(sprintf("nc/paper/GCM_RCM.2.og")) ;
print(sprintf("nc/paper/GCM_RCM.2.svg")) ;
