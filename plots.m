
reset(0) ;
set(0, "defaultfigureunits", "normalized", "defaultfigurepapertype", "A4") ;
set(0, "defaultfigurepaperunits", "normalized", "defaultfigurepaperpositionmode", "auto") ;
set(0, "defaultfigureposition", [0.7 0.7 0.3 0.3]) ;
set(0, "defaultaxesgridalpha", 0.3)
set(0, "defaultaxesfontname", "Linux Biolinum", "defaulttextfontname", "Linux Biolinum") ;

set(0, "defaultaxesfontsize", 18, "defaulttextfontsize", 18, "defaultlinelinewidth", 2) ;


addpath ~/oct/nc/maxdistcolor
JMDL = 1 : 3 ;
col = maxdistcolor(ncol = length(JMDL) + length(NET), @(m) sRGB_to_OSAUCS (m, true, true)) ;
##col = col(randperm(ncol),:) ;

### cases
load(sprintf("data/ana.%s.ob", GREG)) ;
clf ; jVAR = 3 ;
## June 2013
D = [2013, 5, 15 ; 2013, 6, 15] ; d = [2013 5 31] ;
## July 2014
D = [2014 7 15 ; 2014 8 15] ; d = [2014 7 28] ;
## May 2016
D = [2016, 5, 15 ; 2016, 6, 15] ; d = [2016 5 29] ;

plot_case(cape, pdd, deep, D, d, jVAR, cx = 5) ;

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
clf ;
ax1 = subplot(1, 2, 1) ; hold on ;
axis square ;
sn = min(Pskl(:,1,:)) ; sx = max(Pskl(:,1,:)) ;
plot([sn sx], [sn sx], "k--") ;
for jMDL = 1 : size(Pskl, 1)
   hg(jMDL) = scatter(Pskl(jMDL,1,2), Pskl(jMDL,1,1), sz, col(jMDL,:), "", "s", "linewidth", 1.5) ;
   hgE(jMDL) = scatter(Pskl(jMDL,1,4), Pskl(jMDL,1,3), sz, col(jMDL,:), "filled", "s") ;
endfor
xlabel([SKL{jSKL} " with cape"]) ; ylabel([SKL{jSKL} " without cape"]) ;
xl = [xlim()(1) xlim()(2)] ; grid on
xlim(xl) ; ylim(xl) ;

## Deep
ax2 = subplot(1, 2, 2) ; hold on ;
axis square ;
jPLT = 0 ;
for jNET = 1 : rows(Pskl)
   jPLT++ ;
   hgS(jPLT) = scatter(Pskl(jNET,1,4), Pskl(jNET,end,4), sz, col(jPLT,:), "filled", "s") ;
endfor

for jNET = 1 : length(NET)
   jPLT++ ;
   net = NET{jNET} ;

   JVAR = [2 4 10] ;
   ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.lname) ;
   printf("<-- %s\n", mfile) ;
   load(mfile) ;
   hg(jNET) = hggroup() ;
   scatter(skl(:,jSKL), skl(:,end), sz/5, col(jPLT,:), "d", "filled", "parent", hg(jNET)) ;
   hgD(jNET) = scatter(mean(skl(:,jSKL)), mean(skl(:,end)), sz, col(jPLT,:), "d", "filled", "parent", hg(jNET)) ;

   JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.lname) ;
   printf("<-- %s\n", mfile) ;
   w = load(mfile) ;
   scatter(ax1, mean(skl(:,jSKL)), mean(w.skl(:,jSKL)), sz, col(jPLT,:), "d", "filled") ;
   axes(ax2) ;
endfor
xlim(xl) ; grid on
xlabel(SKL{jSKL}) ; ylabel("crossentropy") ;
hlS = legend(ax1, hgE, upper(MDL(JMDL)), "box", "off", "location", "northwest") ;
hlD = legend(hgD, NET, "box", "off", "location", "southwest") ;
set(findall(hlS, "type", "axes"), "xcolor", "none", "ycolor", "none") ;
pos = get(ax1, "position") ; pos(1) -= 0.05 ; set(ax1, "position", pos)
pos = get(ax2, "position") ; pos(1) += 0.05 ; set(ax2, "position", pos)
set(hlD, "position", [0.45 0.15 0.10 0.5])
set(hlS, "position", [0.45 0.65 0.10 0.24])

print(sprintf("nc/paper/%s_scatter.svg", SKL{jSKL})) ;



### plots
alpha = 0.05 ;
qEta = sum(any(any(pdd.x(:,1,:,:) > 0, 3), 4)) / rows(pdd.x) ;
global COL

## training curves
COL = [0.2 0.7 0.2 ; 0.2 0.2 0.7] ;
clf ;
net = NET{jNET=3} ;
lfile = sprintf("models/%s/DE.24/%s.01010000010.CatRaRE.log", net, net) ;
plot_log(gca, lfile, "loss", gap = 2, pse = 0, plog = 0) ;
title(net)
hgsave(sprintf("nc/paper/loss.%s.og", net)) ;
print(sprintf("nc/paper/loss.%s.svg", net)) ;

clf ; j = 0 ; clear H ;
for net = NET((1:9) ~= jNET)
   ax(++j) = subplot(2, 4, j) ;
   net = net{:} ;
##   if exist(lfile = sprintf("data/%s.log", net), "file") ~= 2
   if exist(lfile = sprintf("models/%s/DE.24/%s.01010000010.CatRaRE.log", net, net), "file") ~= 2
      warning("file not found: %s", lfile) ;
   endif
   H(j,:) = plot_log(ax(j), lfile, "loss", gap = 2, pse = 0, plog = 0) ;
   title(net)
endfor
delete(H(:,3)) ;
##set(H(:,1), "linewidth", 1) ; set(H(:,2), "linewidth", 2) ;
##set(ax, "ylim", [0.2 0.71]) ;
hgsave(sprintf("nc/paper/loss.og")) ;
print(sprintf("nc/paper/loss.svg")) ;


## plot scatter of obs vs sim annual probs!!

C1 = cellfun(@(mdl) sprintf("Shallow.%s", mdl), MDL, "UniformOutput", false) ;
C1n = toupper(MDL) ;
C2= cellfun(@(net) sprintf("Deep.%s", net), NET, "UniformOutput", false) ;
C2n = NET ;
JM = {[2 7] [1 11] [12 10] [3 5] [6 8] [9 13]}{6} ;
C = union(C1, C2, "stable")(JM) ;
Cn = union(C1n, C2n, "stable")(JM) ;

## ERA5
COL = [1 1 1 ; 0.2 0.7 0.2 ; 0.2 0.2 0.7 ; 0.7 0.2 0.2] ;
figure(1, "position", [0.7 0.7 0.4 0.34]) ; sz = 60 ;
[o.id o.x] = annstat(pdd.id, real(pdd.c), @nanmean) ;
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
   subplot(2, 3, 3*(jMDL-1) + (1:2)) ; hold on
   plot(s.id([1 end],1), [qEta qEta], "color", 0.7*COL(1,:), "linewidth", 2, "linestyle", "--") ;
   scatter(o.id(:,1), o.x(:,1), 0.7*sz, 0*COL(1,:), "x") ;
   scatter(s.id(~(sC|sV),1), s.x(~(sC|sV),1), sz, COL(3,:), "filled") ;
   scatter(s.id(sC,1), s.x(sC,1), sz, COL(2,:), "filled") ;
   scatter(s.id(sV,1), s.x(sV,1), sz, COL(3,:), "filled") ;
   [B, BINT, R, RINT, STATS] = regress(s.x, [ones(rows(s.x),1) s.id(:,1)]) ;
   yf = [ones(rows(s.x),1) s.id(:,1)] * B ;
   h = plot(s.id(:,1), yf, "color", 0*COL(1,:), "linewidth", 2) ;
   xlim(s.id([1 end],1)) ;
   ylim([0.8*ylim()(1) 1.1*ylim()(2)]) ;
   xlabel("year") ; ylabel(sprintf("P_{CatRaRE}")) ;
   if STATS(3) < alpha
      xt = mean(get(h, "xdata")) - 5 ;
      text(xt, 0.9*ylim()(2), sprintf("p<%.2f", alpha), "color", 0*COL(1,:)) ;
   endif
   set(gca, "fontsize", 14)
   subplot(2, 3, 3*(jMDL-1) + 3) ; hold on
   plot([xn xx], [xn xx], "color", 0*COL(1,:), "linewidth", 2, "linestyle", "--") ;
   scatter(o.x(oC,1), s.x(sC,1), sz, COL(2,:), "filled") ;
   scatter(o.x(oV,1), s.x(sV,1), sz, COL(3,:), "filled") ;
   xlim([xn xx]) ; ylim([xn xx]) ;
   axis square ;
   xlabel("OBS") ; ylabel(sprintf("%s", Cn{jMDL})) ;
##   xlabel("{\\itP_{CatRaRE}}, OBS") ; ylabel(sprintf("{\\itP_{CatRaRE}}, %s", mdl)) ;
   r = corr(o.x(oV,1), s.x(sV,1)) ;
   text(xn, xx, sprintf("{\\it\\rho} = %.2f", r), "color", COL(3,:)) ;
   set(gca, "fontsize", 14)
endfor
hgsave(sprintf("nc/paper/ERA5.%s-%s.og", Cn{:})) ;
print(sprintf("nc/paper/ERA5.%s-%s.svg", Cn{:})) ;


## GCM/RCM
figure(1, "position", [0.7 0.7 0.4 0.4]) ; sz = 20 ;
jMDL = 0 ; clf ; hold on
for mdl = C
   jMDL++ ;
   mdl = mdl{:} ;
   subplot(2, 1, jMDL) ; hold on
   clear h stats ; j = 0 ;
   h(++j) = plot([1951 2100], [qEta qEta], "color", 0.7*COL(1,:), "linewidth", 4, "linestyle", "--") ;
   for sim = SIM(j+1:end)
      j++ ;
      eval(sprintf("sim = %s ;", sim{:})) ;
      eval(sprintf("[s.id s.x] = annstat(sim.prob.id, sim.prob.%s, @nanmean) ;", strrep(mdl, "-", "_"))) ;
      scatter(s.id(:,1), s.x(:,2), sz, COL(j+1,:), "filled") ; axis tight
      [B, BINT, R, RINT, STATS] = regress(s.x(:,2), [ones(rows(s.x),1) s.id(:,1)]) ;
      stats(j,:) = STATS ;
      yf = [ones(rows(s.x),1) s.id(:,1)] * B ;
      h(j) = plot(s.id(:,1), yf, "color", COL(j+1,:), "linewidth", 3) ;
      xlabel("year") ; ylabel(sprintf("P_{CatRaRE}")) ;
   endfor
   ylim([0.7*ylim()(1) 1.2*ylim()(2)]) ;
   for j = 2:rows(stats)
      if stats(j,3) < alpha
	 xt = mean(get(h(j), "xdata")) - 10 ;
	 text(xt, 0.84*ylim()(2), "p<0.05", "color", COL(j+1,:)) ;
      endif
   endfor
   loc = "southeast" ;
   legend(h, {"CLIM" NSIM{2:end}}, "box", "off", "location", loc) ;
   j = eval(sprintf("find(strcmp({%s.prob.nc.Attributes.Name}, \"driving_model_id\")) ;", SIM{2})) ;
   GCM = eval(sprintf("%s.prob.nc.Attributes(j).Value ;", SIM{2})) ;
   j = eval(sprintf("find(strcmp({%s.prob.nc.Attributes.Name}, \"model_id\")) ;", SIM{2})) ;
   RCM = eval(sprintf("%s.prob.nc.Attributes(j).Value ;", SIM{2})) ;
   smdl = strsplit(mdl, "."){2} ;
   htit = title(sprintf("%s", Cn{jMDL}), "fontsize", 20) ;
   pos = get(htit, "position") ;
   ht = text(1960, pos(2) - 0.05, sprintf("GCM: %s\nRCM: %s", GCM, RCM), "fontsize", 14) ;
endfor
hgsave(sprintf("nc/paper/%s.%s.%s-%s.og", GCM, RCM, Cn{:})) ;
print(sprintf("nc/paper/%s.%s.%s-%s.svg", GCM, RCM, Cn{:})) ;

COL = [0 0 0 ; 0.8 0.2 0.2 ; 0.2 0.8 0.2 ; 0.2 0.2 0.8]([1 4 2],:) ;
set(0, "defaultaxesfontsize", 18) ;
set(0, "defaulttextfontsize", 18, "defaultlinelinewidth", 2) ;
MDL = {"Shallow.tree" "Deep.CIFAR_10"} ; 
clf ; jMDL = 0 ;
for iMDL = [2 1]
   jMDL++ ;
   ax(jMDL) = subplot(1, 2, jMDL) ; hold on ; clear h ;
   mdl = MDL{iMDL} ;
   h(1) = plot([1951 2100], [qEta qEta], "color", COL(1,:), "linewidth", 4, "linestyle", "--") ;
   for jSIM = 1 : length(SIM)
      eval(sprintf("sim = %s ;", SIM{jSIM})) ;
      eval(sprintf("[s.id s.x] = annstat(sim.id, sim.%s.prob, @nanmean) ;", mdl)) ;
      scatter(s.id(:,1), s.x(:,2), 6, 0.8*COL(jSIM+1,:), "filled") ; axis tight
      [B, BINT, R, RINT, STATS] = regress(s.x(:,2), [ones(rows(s.x),1) s.id(:,1)]) ;
      stats(jSIM,:) = STATS ;
      yf = [ones(rows(s.x),1) s.id(:,1)] * B ;
      h(1+jSIM) = plot(s.id(:,1), yf, "color", COL(1+jSIM,:), "linewidth", 4) ;
      ##      h(j) = plot(s.id(:,1), smooth(s.x(:,2), 1), "color", COL(j,:), "linewidth", 5) ;
      xlabel("year") ; ylabel(sprintf("prob (CatRaRE)")) ;
   endfor
   ##   set(gca, "ygrid", "on") ;
   for jSIM = 1 : 2
      if stats(jSIM,3) < alpha
	 xt = mean(get(h(1+jSIM), "xdata")) ;
	 text(xt, 0.72, {"\\it p<0.05"}, "color", COL(1+jSIM,:)) ;
      endif
   endfor
   title(toupper(strrep(mdl, "_", "\\_"))) ;
   legend(h, {"CLIM" NSIM{:}}, "box", "off", "location", "southeast") ;
endfor
set(ax, "ylim", [0.35 0.75]) ;

hgsave(sprintf("nc/paper/Shallow.sim.og")) ;
print(sprintf("nc/paper/Shallow.sim.svg")) ;
