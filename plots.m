
reset(0) ;
set(0, "defaultfigureunits", "normalized", "defaultfigurepapertype", "A4") ;
set(0, "defaultfigurepaperunits", "normalized", "defaultfigurepaperpositionmode", "auto") ;
set(0, "defaultfigureposition", [0.7 0.7 0.3 0.3]) ;
set(0, "defaultaxesgridalpha", 0.3)

set(0, "defaultaxesfontname", "Liberation Sans", "defaultaxesfontsize", 14) ;
set(0, "defaulttextfontname", "Linux Biolinum", "defaulttextfontsize", 14, "defaultlinelinewidth", 2) ;


addpath ~/oct/nc/maxdistcolor
col = maxdistcolor(ncol = length(MDL) + length(NET), @(m) sRGB_to_OSAUCS (m, true, true)) ;
##col = col(randperm(ncol),:) ;

### cases
## June 2013
clf ; jVAR = 1 ;
D1 = [2013, 5, 15 ; 2013, 6, 15] ; d1 = [2013 5 30] ;
plot_case(ptr, pdd, :, pdd, D1, d1) ;

## July 2014
D1 = [2014 7 15 ; 2014 8 15] ; d1 = [2014 7 28] ;
plot_case(ptr, pdd, :, D1, d1, jVAR, cx = 5) ;

## May 2016
D1 = [2016, 5, 15 ; 2016, 6, 15] ; d1 = [2016 5 29] ;
plot_case(ptr, pdd, :, D1, d1, jVAR) ;


### performance
## Shallow
clear SKL ;
## without EOFs
JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.R%s.%s.ot", REG, NH, ind, pdd.name))
SKL(:,:,1) = S ;
JVAR = [2 4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.R%s.%s.ot", REG, NH, ind, pdd.name))
SKL(:,:,2) = S ;
## with EOFs
JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ind, pdd.name))
SKL(:,:,3) = S ;
JVAR = [2 4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ind, pdd.name))
SKL(:,:,4) = S ;

figure(1, "position", [0.7 0.7 0.45 0.3]) ; sz = 70 ;
clf ;
ax1 = subplot(1, 2, 1) ; hold on ;
axis square ;
sn = min(SKL(:,1,:)) ; sx = max(SKL(:,1,:)) ;
plot([sn sx], [sn sx], "k--") ;
for jMDL = 1 : size(SKL, 1)
   hg(jMDL) = scatter(SKL(jMDL,1,2), SKL(jMDL,1,1), sz, col(jMDL,:), "", "s", "linewidth", 1.5) ;
   hgE(jMDL) = scatter(SKL(jMDL,1,4), SKL(jMDL,1,3), sz, col(jMDL,:), "filled", "s") ;
endfor
xlabel("ETS with cape") ; ylabel("ETS without cape") ;
hlE = legend(hgE, upper(MDL), "box", "off", "location", "northwest") ;
xl = [xlim()(1) xlim()(2)] ; grid on
xlim(xl) ; ylim(xl) ;

## Deep
ax2 = subplot(1, 2, 2) ; hold on ;
axis square ;
jPLT = 0 ;
for jNET = 1 : rows(S)
   jPLT++ ;
   hgS(jPLT) = scatter(SKL(jNET,1,4), SKL(jNET,2,4), sz, col(jPLT,:), "filled", "s") ;
endfor

JVAR = [2 4] ;
for jNET = 1 : length(NET)
   jPLT++ ;
   net = NET{jNET} ;

   ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.name) ;
   printf("<-- %s\n", mfile) ;
   load(mfile) ;
   hg = hggroup() ;
   scatter(skl(:,1), skl(:,2), 5, col(jPLT,:), "o", "filled", "parent", hg) ;
   hgD(jNET) = scatter(mean(skl(:,1)), mean(skl(:,2)), sz, col(jPLT,:), "d", "filled", "parent", hg) ;
   JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.name) ;
   printf("<-- %s\n", mfile) ;
   w = load(mfile) ;
   scatter(ax1, mean(skl(:,1)), mean(w.skl(:,1)), sz, col(jPLT,:), "d", "filled") ;
   axes(ax2) ;
endfor
xlim(xl) ; grid on
xlabel("ETS") ; ylabel("crossentropy") ;
hlD = legend(hgD, NET, "box", "off", "location", "southwest") ;
hlS = copyobj(hlE, gcf) ;
delete(hlE) ;
set(findall(hlS, "type", "axes"), "xcolor", "none", "ycolor", "none") ;
pos = get(ax1, "position") ; pos(1) -= 0.05 ; set(ax1, "position", pos)
pos = get(ax2, "position") ; pos(1) += 0.05 ; set(ax2, "position", pos)
set(hlD, "position", [0.45 0.15 0.10 0.5])
set(hlS, "position", [0.45 0.65 0.10 0.24])

print("nc/paper/skl_scatter.svg") ;



### plots
alpha = 0.05 ;
qEta = sum(any(any(pdd.x(:,1,:,:) > 0, 3), 4)) / rows(pdd.x) ;
global COL
COL = [0.8 0.2 0.2 ; 0.2 0.8 0.2 ; 0.2 0.2 0.8]([3 2],:) ;
set(0, "defaultaxesfontname", "Linux Biolinum", "defaultaxesfontsize", 24) ;
set(0, "defaulttextfontname", "Linux Biolinum", "defaulttextfontsize", 22, "defaultlinelinewidth", 2) ;

# nnet training
clf ;
h = plot_log("models/simple1/CatRaRE.log", {"Train" "Test"}, "loss") ;
set(h(1), "linewidth", 1) ; set(h(2), "linewidth", 4) ;
hgsave(sprintf("nc/plots/%s.loss.og", net)) ;
print(sprintf("nc/plots/%s.loss.png", net)) ;

# 
I = pdd.id(:,1) == 2016 & ismember(pdd.id(:,2), MON) ;
printf("average rate Eta > 0: %7.0f%%\n", 100*qEta) ;
scatter(datenum(pdd.id(I,:)), nanmean(nanmean(pdd.x(I,1,:,:), 3), 4), 60, "k", "filled") ; axis tight
set(gca, "ytick", [0 0.01 0.02])
xlabel("") ; ylabel("Eta") ;
datetick("mmm") ;
hgsave(sprintf("nc/plots/Eta.og")) ;
print(sprintf("nc/plots/Eta.svg")) ;

COL = [0 0 0 ; 0.8 0.2 0.2 ; 0.2 0.8 0.2 ; 0.2 0.2 0.8]([1 4 2],:) ;
for mdl = {"Shallow.tree" "Deep.Simple"}
   mdl = mdl{:} ;
   clf ; hold on ; clear h ; j = 0 ;
   h(++j) = plot([1951 2100], [qEta qEta], "color", COL(1,:), "linewidth", 4, "linestyle", "--") ;
   for sim = SIM
      j++ ;
      eval(sprintf("sim = %s ;", sim{:})) ;
      eval(sprintf("[s.id s.x] = annstat(sim.id, sim.%s.prob, @nanmean) ;", mdl)) ;
      scatter(s.id(:,1), s.x(:,2), 20, 0.8*COL(j,:), "filled") ; axis tight
      [B, BINT, R, RINT, STATS] = regress(s.x(:,2), [ones(rows(s.x),1) s.id(:,1)]) ;
      stats(j,:) = STATS ;
      yf = [ones(rows(s.x),1) s.id(:,1)] * B ;
      h(j) = plot(s.id(:,1), yf, "color", COL(j,:), "linewidth", 4) ;
##      h(j) = plot(s.id(:,1), smooth(s.x(:,2), 1), "color", COL(j,:), "linewidth", 5) ;
      xlabel("year") ; ylabel(sprintf("prob (CatRaRE)")) ;
   endfor
   ##   set(gca, "ygrid", "on") ;
   ylim([0.8*ylim()(1) 1.1*ylim()(2)]) ;
   xt = mean(get(h(j), "xdata")) ;
   for j = 2:3
      if stats(j,3) < alpha
	 text(xt, 0.7, "p<0.05", "color", COL(j,:)) ;
      endif
   endfor
   if strcmp(mdl, "Deep.Simple")
      loc = "northwest" ;
   else
      loc = "southeast" ;
   endif
   legend(h, {"CLIM" NSIM{:}}, "box", "off", "location", loc) ;
   hgsave(sprintf("nc/plots/%s.sim.og", mdl)) ;
   print(sprintf("nc/plots/%s.sim.svg", mdl)) ;
endfor

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

hgsave(sprintf("nc/plots/Shallow.sim.og")) ;
print(sprintf("nc/plots/Shallow.sim.svg")) ;
