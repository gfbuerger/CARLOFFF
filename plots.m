
reset(0) ;
set(0, "defaultfigureunits", "normalized", "defaultfigurepapertype", "A4") ;
set(0, "defaultfigurepaperunits", "normalized", "defaultfigurepaperpositionmode", "auto") ;
set(0, "defaultfigureposition", [0.7 0.7 0.3 0.3]) ;
set(0, "defaultaxesgridalpha", 0.3)

set(0, "defaultaxesfontname", "Liberation Sans", "defaultaxesfontsize", 14) ;
set(0, "defaulttextfontname", "Linux Biolinum", "defaulttextfontsize", 14, "defaultlinelinewidth", 2) ;


addpath ~/oct/nc/maxdistcolor
JMDL = 1 : 3 ;
col = maxdistcolor(ncol = length(JMDL) + length(NET), @(m) sRGB_to_OSAUCS (m, true, true)) ;
##col = col(randperm(ncol),:) ;

### cases
load(sprintf("data/atm.%s.ob", GREG)) ;
clf ; jVAR = 1 ;
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
load(sprintf("nc/%s.%02d/skl.Shallow.R%s.%s.ot", REG, NH, ind, pdd.name))
Pskl(:,:,1) = skl(:,[jSKL end]) ;
JVAR = [2 4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.R%s.%s.ot", REG, NH, ind, pdd.name))
Pskl(:,:,2) = skl(:,[jSKL end]) ;
## with EOFs
JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ind, pdd.name))
Pskl(:,:,3) = skl(:,[jSKL end]) ;
JVAR = [2 4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ind, pdd.name))
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
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.name) ;
   printf("<-- %s\n", mfile) ;
   load(mfile) ;
   hg(jNET) = hggroup() ;
   scatter(skl(:,jSKL), skl(:,end), sz/5, col(jPLT,:), "o", "filled", "parent", hg(jNET)) ;
   hgD(jNET) = scatter(mean(skl(:,jSKL)), mean(skl(:,end)), sz, col(jPLT,:), "d", "filled", "parent", hg(jNET)) ;

   JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ind, pdd.name) ;
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
COL = [0.8 0.2 0.2 ; 0.2 0.8 0.2 ; 0.2 0.2 0.8]([3 2],:) ;
set(0, "defaultaxesfontname", "Linux Biolinum", "defaultaxesfontsize", 24) ;
set(0, "defaulttextfontname", "Linux Biolinum", "defaulttextfontsize", 22, "defaultlinelinewidth", 2) ;

# nnet training
clf ;
h = plot_log("models/DenseNet/DE.24/DenseNet.01010000010.CatRaRE.log", "loss") ;
set(h(1), "linewidth", 1) ; set(h(2), "linewidth", 4) ;
hgsave(sprintf("nc/paper/%s.loss.og", net)) ;
print(sprintf("nc/paper/%s.loss.png", net)) ;


COL = [0 0 0 ; 0.8 0.2 0.2 ; 0.2 0.8 0.2 ; 0.2 0.2 0.8]([1 4 2],:) ;
C1 = cellfun(@(mdl) sprintf("Shallow.%s", mdl), MDL, "UniformOutput", false) ;
C2= cellfun(@(net) sprintf("Deep.%s", net), NET, "UniformOutput", false) ;
for mdl = union(C1, C2)
   mdl = mdl{:} ;
   clf ; hold on ; clear h ; j = 0 ;
   h(++j) = plot([1951 2100], [qEta qEta], "color", COL(1,:), "linewidth", 4, "linestyle", "--") ;
   for sim = SIM
      j++ ;
      eval(sprintf("sim = %s ;", sim{:})) ;
      eval(sprintf("[s.id s.x] = annstat(sim.id, sim.%s.prob, @nanmean) ;", strrep(mdl, "-", "_"))) ;
      scatter(s.id(:,1), s.x(:,2), 20, 0.8*COL(j,:), "filled") ; axis tight
      [B, BINT, R, RINT, STATS] = regress(s.x(:,2), [ones(rows(s.x),1) s.id(:,1)]) ;
      stats(j,:) = STATS ;
      yf = [ones(rows(s.x),1) s.id(:,1)] * B ;
      h(j) = plot(s.id(:,1), yf, "color", COL(j,:), "linewidth", 4) ;
##      h(j) = plot(s.id(:,1), smooth(s.x(:,2), 1), "color", COL(j,:), "linewidth", 5) ;
      xlabel("year") ; ylabel(sprintf("prob (CatRaRE)")) ;
   endfor
   ##   set(gca, "ygrid", "on") ;
   ylim([0.7*ylim()(1) 1.2*ylim()(2)]) ;
   for j = 2:3
      if stats(j,3) < alpha
	 xt = mean(get(h(j), "xdata")) - 10 ;
	 text(xt, 0.7, "p<0.05", "color", COL(j,:)) ;
      endif
   endfor
##   if strcmp(mdl, "Deep.Simple")
##      loc = "northwest" ;
##   else
      loc = "southeast" ;
##   endif
   legend(h, {"CLIM" NSIM{:}}, "box", "off", "location", loc) ;
   j = eval(sprintf("find(strcmp({%s.nc.Attributes.Name}, \"driving_model_id\")) ;", SIM{1})) ;
   GCM = eval(sprintf("%s.nc.Attributes(j).Value ;", SIM{1})) ;
   j = eval(sprintf("find(strcmp({%s.nc.Attributes.Name}, \"model_id\")) ;", SIM{1})) ;
   RCM = eval(sprintf("%s.nc.Attributes(j).Value ;", SIM{1})) ;
   smdl = strsplit(mdl, "."){2} ;
   htit = title(sprintf("%s", mdl), "fontsize", 20) ;
   pos = get(htit, "position") ;
   ht = text(1960, pos(2) - 0.05, sprintf("GCM: %s\nRCM: %s", GCM, RCM), "fontsize", 14) ;

   hgsave(sprintf("nc/paper/%s.%s.%s.sim.og", GCM, RCM, mdl)) ;
   print(sprintf("nc/paper/%s.%s.%s.sim.svg", GCM, RCM, mdl)) ;
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

hgsave(sprintf("nc/paper/Shallow.sim.og")) ;
print(sprintf("nc/paper/Shallow.sim.svg")) ;
