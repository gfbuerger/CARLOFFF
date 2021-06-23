cd ~/carlofff

addpath ~/oct/nc/RegEM

load cin.mat

[X, M, C, Xerr, B, peff, kavlr, kmisr, iptrn] = regem(x(I,:)) ;

save cin.mat ;
