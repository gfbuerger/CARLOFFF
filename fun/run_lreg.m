## usage: prob = run_lreg (cape, RR, CAL, VAL, C, L)
##
## calibrate and apply caffe logistic optimization
function prob = run_lreg (cape, RR, CAL, VAL, C = 1, L = 100)

   pkg load statistics
   
   for PHS = {"CAL" "VAL"}
      PHS = PHS{:} ;
      eval(sprintf("cape.%s = sdate(cape.id(cape.I,:), %s) ;", PHS, PHS)) ;
      eval(sprintf("RR.%s = sdate(RR.id(RR.I,:), %s) ;", PHS, PHS)) ;
   endfor

   PHS = "CAL" ;

   X = permute(cape.x(:,:,cape.(PHS)), [3 1 2]) ;
   X = reshape(X, size(X, 1), []) ;
##   [EIGVAL, EIGVEC, TS] = pca(X) ;
   [E X ev lmb] = gpca(X, "levfit") ;
   y = RR.c(RR.(PHS)) ;
   c = unique(y) ;
   
   F = @(beta) exp(X * beta) ./ (1 + exp(X * beta)) ;

   n = size(X, 1) ;
   q = sum(y == c(2)) / sum(y <= c(2)) ;
   ## preliminary (TBD: deal with NaNs)
   cost = @(theta) nanmean((F(theta(1:end-1)) > theta(end)) * C + (y == c(2)) .* (F(theta(1:end-1)) <= theta(end)) * L) ;

   theta0 = [ones(size(X, 2), 1) ; 0.5] ;
   opt = optimset("Display", "off") ;
   [theta fval flag out] = fminsearch(cost, theta0, opt) ;
   
endfunction
