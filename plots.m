
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
figure(1, "position", [0.7 0.7 0.45 0.3]) ; sz = 70 ;
clf ; clear SKL ;
subplot(1, 2, 1) ; hold on ;
## without EOFs
JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.R%s.%s.ot", REG, NH, ind, pdd.name))
SKL(:,1) = S(:,1) ;
JVAR = [2 4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.R%s.%s.ot", REG, NH, ind, pdd.name))
SKL(:,2) = S(:,1) ;
## with EOFs
JVAR = [4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ind, pdd.name))
SKL(:,3) = S(:,1) ;
JVAR = [2 4 10] ; ind = sprintf("%d", ind2log(JVAR, numel(VAR))) ;
load(sprintf("nc/%s.%02d/skl.Shallow.%s.%s.ot", REG, NH, ind, pdd.name))
SKL(:,4) = S(:,1) ;

sn = min(SKL(:)) ; sx = max(SKL(:)) ;
plot([sn sx], [sn sx], "k--") ;
axis square ;
for jMDL = 1 : rows(S)
   hg(jMDL) = scatter(SKL(jMDL,2), SKL(jMDL,1), sz, col(jMDL,:), "", "s", "linewidth", 1.5) ;
   hgE(jMDL) = scatter(SKL(jMDL,4), SKL(jMDL,3), sz, col(jMDL,:), "filled", "s") ;
endfor
xlabel("ETS with cape") ; ylabel("ETS without cape") ;
hlE = legend(hgE, upper(MDL), "box", "off", "location", "northwest") ;
xl = xlim() ;

## Deep
subplot(1, 2, 2) ; hold on ;
jPLT = 0 ;
for jNET = 1 : rows(S)
   jPLT++ ;
   hgS(jPLT) = scatter(S(jNET,1), S(jNET,2), sz, col(jPLT,:), "filled", "s") ;
endfor

JNET = false(length(NET), 1) ;
for jNET = 1 : length(NET)
   jPLT++ ;
   net = NET{jNET} ;

   mfile = sprintf("nc/%s.%02d/skl.%s.%s.%s.ot", REG, NH, net, ptr.ind, pdd.name) ;
   if ~(JNET(jNET) = exist(mfile) == 2) continue ; endif
   printf("<-- %s\n", mfile) ;
   load(mfile) ;
   I = skl(:,1) > 0.1 ;
   hg = hggroup() ;
   scatter(skl(I,1), skl(I,2), 5, col(jPLT,:), "o", "filled", "parent", hg) ;
   hgD(jNET) = scatter(mean(skl(I,1)), mean(skl(I,2)), sz, col(jPLT,:), "d", "filled", "parent", hg) ;
endfor
xlim(xl) ;
xlabel("ETS (with cape)") ; ylabel("crossentropy (with cape)") ;
legend(hgD(JNET), NET(JNET), "box", "off", "location", "southwest") ;
h = copyobj(hlE, gcf) ;
set(findall(h, "type", "axes"), "xcolor", "none", "ycolor", "none") ;
set(h, "position", [0.85 0.65 0.10 0.24])

print("nc/paper/skl_scatter.svg") ;



### plots
alpha = 0.05 ;
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
qEta = sum(any(any(pdd.x(:,1,:,:) > 0, 3), 4)) / rows(pdd.x) ;
printf("average rate Eta > 0: %7.0f%%\n", 100*qEta) ;
scatter(datenum(pdd.id(I,:)), nanmean(nanmean(pdd.x(I,1,:,:), 3), 4), 60, "k", "filled") ; axis tight
set(gca, "ytick", [0 0.01 0.02])
xlabel("") ; ylabel("Eta") ;
datetick("mmm") ;
hgsave(sprintf("nc/plots/Eta.og")) ;
print(sprintf("nc/plots/Eta.svg")) ;

COL = [0 0 0 ; 0.8 0.2 0.2 ; 0.2 0.8 0.2 ; 0.2 0.2 0.8]([1 4 2],:) ;
for mdl = {"shallow" "nnet"}
   mdl = mdl{:} ;
   clf ; hold on ; clear h ; j = 0 ;
   h(++j) = plot([1951 2100], [qEta qEta], "color", COL(1,:), "linewidth", 2, "linestyle", "--") ;
   for sim = SIM
      eval(sprintf("sim = %s ;", sim{:})) ; j++ ;
      eval(sprintf("[s.id s.x] = annstat(sim.id, sim.%s.prob, @nanmean) ;", mdl)) ;
      scatter(s.id(:,1), s.x(:,2), 20, 0.8*COL(j,:), "filled") ; axis tight
      [B, BINT, R, RINT, STATS] = regress(s.x(:,2), [ones(rows(s.x),1) s.id(:,1)]) ;
      stats(j,:) = STATS ;
      yf = [ones(rows(s.x),1) s.id(:,1)] * B ;
      h(j) = plot(s.id(:,1), yf, "color", COL(j,:), "linewidth", 5) ;
##      h(j) = plot(s.id(:,1), smooth(s.x(:,2), 1), "color", COL(j,:), "linewidth", 5) ;
      xlabel("year") ; ylabel(sprintf("prob (WS {\\geq 3})", 0.3)) ;
   endfor
   if stats(3,3) < alpha
      text(2040, 0.4, "p<0.05", "color", COL(3,:)) ;
   endif
   ##   set(gca, "ygrid", "on") ;
   ylim([0.1 0.4]) ;
   if strcmp(mdl, "shallow")
      loc = "northwest" ;
   else
      loc = "southeast" ;
   endif
   legend(h, {"CLIM" NSIM{:}}, "box", "off", "location", loc) ;
   hgsave(sprintf("nc/plots/%s.sim.og", mdl)) ;
   print(sprintf("nc/plots/%s.sim.png", mdl)) ;
endfor
