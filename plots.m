reset(0) ;
set(0, "defaultfigureunits", "normalized", "defaultfigurepapertype", "A4") ;
set(0, "defaultfigurepaperunits", "normalized", "defaultfigurepaperpositionmode", "auto") ;
set(0, "defaultfigureposition", [0.7 0.7 0.3 0.3]) ;
set(0, "defaultaxesgridalpha", 0.3)

set(0, "defaultaxesfontname", "Liberation Sans", "defaultaxesfontsize", 14) ;
set(0, "defaulttextfontname", "Linux Biolinum", "defaulttextfontsize", 14, "defaultlinelinewidth", 2) ;


addpath ~/oct/nc/maxdistcolor
col = maxdistcolor(rows(S) + length(NET), @(m) sRGB_to_OSAUCS (m, true, true)) ;

## Shallow
figure(1) ; sz = 70 ;
clf ; hold on ;
for jMDL = 1 : rows(S)
   hgS(jMDL) = scatter(S(jMDL,1), S(jMDL,2), sz, col(jMDL,:), "filled", "s") ;
endfor
hS = legend(hgS, upper(MDL), "box", "off", "location", "northeast") ;

figure(2) ;
clf ; hold on ;
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
   load(mfile) ;
   I = skl(:,1) > 0.1 ;
   hg = hggroup() ;
   scatter(skl(I,1), skl(I,2), 5, col(jPLT,:), "o", "filled", "parent", hg) ;
   hgD(jNET) = scatter(mean(skl(I,1)), mean(skl(I,2)), sz, col(jPLT,:), "d", "filled", "parent", hg) ;
endfor
xlabel("ETS") ; ylabel("crossentropy") ;
legend(hgD(JNET), NET(JNET), "box", "off", "location", "southwest") ;
h = copyobj(hS, gcf) ;
set(findall(h, "type", "axes"), "xcolor", "none", "ycolor", "none") ;

print("nc/paper/skl_scatter.svg") ;


## cases
## June 2013
clf ;
D1 = [2013, 5, 15 ; 2013, 6, 15] ; d1 = [2013 5 30] ;
plot_case(shallow.prob, pdd, D1, d1) ;
set(findall("-property", "fontname"), "fontname", "Linux Biolinum", "fontsize", 24) ;
print(sprintf("nc/%s.%02d/2013-06.png", REG, NH)) ;

for jVAR = 1 : numel(ptr.vars)
   clf ;
   ds = datestr(datenum(d1), "yyyy-mm-dd") ;
   I = sdate(ptr.id, d1) ;
   xm = zscore(squeeze(ptr.x(:,jVAR,:,:))) ;
   xm = squeeze(xm(I,:,:)) ;
   imagesc(ptr.lon, ptr.lat, xm') ;
   set(gca, "ydir", "normal", "clim", [-3 3]) ;
   ##title(sprintf("normalized %s for %s", toupper(ptr.vars{jVAR}), ds)) ;
   hc = colorbar ;
   colormap(redblue)
   xlabel("longitude") ; ylabel("latitude") ;
   
   hold on
   hb = borders("germany", "color", "black") ;

   set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
   set(findall("type", "axes"), "fontsize", 14) ;
   set(findall("type", "text"), "fontsize", 22) ;
   hgsave(sprintf("nc/%s.2013-06.og", ptr.vars{jVAR})) ;
   print(sprintf("nc/%s.2013-06.png", ptr.vars{jVAR})) ;
endfor

## July 2014
D1 = [2014 7 15 ; 2014 8 15] ; d1 = [2014 7 28] ;
plot_case(ptr, pdd, shallow.prob, D1, d1, jVAR) ;

## May 2016
D1 = [2016, 5, 15 ; 2016, 6, 15] ; d1 = [2016 5 29] ;
plot_case(ptr, pdd, shallow.prob, D1, d1, jVAR) ;

plot_case(shallow.prob, pdd, D1, d1) ;
set(findall("-property", "fontname"), "fontname", "Linux Biolinum", "fontsize", 24) ;
print(sprintf("nc/%s.%02d/2016-05.png", REG, NH)) ;

clf ; jVAR = 1 ;
ds = datestr(datenum(d1), "yyyy-mm-dd") ;

I = sdate(ptr.id, d1) ;
xm = zscore(squeeze(ptr.x(:,jVAR,:,:))) ;
xm = squeeze(xm(I,:,:)) ;
imagesc(ptr.lon, ptr.lat, xm') ;
set(gca, "ydir", "normal", "clim", [-3 3]) ;
##title(sprintf("normalized %s for %s", toupper(ptr.vars{jVAR}), ds)) ;
hc = colorbar ;
colormap(redblue)
xlabel("longitude") ; ylabel("latitude") ;
##   set(get(hc, "Title"), "string", "[%]") ;
   
hold on
hb = borders("germany", "color", "black") ;

set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
set(findall("type", "axes"), "fontsize", 14) ;
set(findall("type", "text"), "fontsize", 22) ;
hgsave(sprintf("nc/%s.2016-05.og", ptr.vars{jVAR})) ;
print(sprintf("nc/%s.2016-05.png", ptr.vars{jVAR})) ;


clf ;
I = sdate(pdd.id, d1) ;
w = pdd.x(I,1,:,:) ;
xm = squeeze(any(w > pdd.q, 1)) ;
imagesc(pdd.lon-0.125, pdd.lat-0.125, xm') ;
xticks(pdd.lon) ; yticks(pdd.lat) ; 
set(gca, "ydir", "normal") ;
colormap(flip(gray(5)))
title(sprintf("%s > 0 for %s", toupper(pdd.vars{1}), ds)) ;
set(gca, "xtick", [], "ytick", [], "xticklabel", [], "yticklabel", [])
##xlabel("longitude") ; ylabel("latitude") ;
   
hold on
hb = borders("germany", "color", "black") ;

set(findall("-property", "fontname"), "fontname", "Linux Biolinum", "fontsize", 30) ;
hgsave(sprintf("nc/%s.%02d/%s.2016-05.og", REG, NH, pdd.vars{1})) ;
print(sprintf("nc/%s.%02d/%s.2016-05.png", REG, NH, pdd.vars{1})) ;
##}


addpath ~/oct/mmap

borders germany

[Y X] = meshgrid(ptr.lat, ptr.lon) ;
%create the list of text
string = mat2cell(num2str([1:10*10]'),ones(10*10,1));
%display the background
imagesc(I)
hold on
%insert the labels
text(Y(:)-.5,X(:)+.25,string,'HorizontalAlignment','left')
%calculte the grid lines
grid = .5:1:10.5;
grid1 = [grid;grid];
grid2 = repmat([.5;10.5],1,length(grid))
%plot the grid lines
plot(grid1,grid2,'k')
plot(grid2,grid1,'k')





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
