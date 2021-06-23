function [E PC ev lmb D] = gpca(x, trunc, lNaN=true)

   ## usage:  [E PC ev lmb D] = gpca(x [,trunc [,lNaN]])
   ## 
   ## Performs a principal component analysis of x
   ## x ....... data vector
   ## trunc.... requested cum EV of retained PCs
   ## E   ..... principal component patterns (EOFs)
   ## PC....... principal components
   ## ev........explained variances of the PCs.
   ## lmb.......eigenvalues
   ## D.........singular values
   ## lNaN......how to deal with NaNs
   
   ## Author:  GB
   ## Description:  Principal Component Analysis

   if (ndims(x) > 2)
      error("gpca: too many dimensions.\n")
   endif 

   if ischar(trunc) && strcmp(trunc, "none")
      E = eye(ns) ; PC = x ;
      return ;
   endif

   [nt ns] = size(x);
   np = min(ns, nt) ;

   if isnumeric(trunc) && trunc >= 1
      np = round(trunc) ;
   endif
   
   x(isnan(x)) = 0 ;

   if lNaN
      PC = nan(rows(x), np) ;
      J = any(isfinite(x), 1) ;
      I = any(isfinite(x), 2) ;
      x = x(I,J) ;
      if 1 | np > 20 # octave bug
	 [wPC, D, E] = svd(x) ;
      else
	 [wPC, D, E] = svds(x, np) ;
	 D = real(D) ;
	 [~, is] = sort(diag(D)) ;
	 wPC = wPC(:,is) ; D = D(is,is) ; E = E(:,is) ;
      endif
      PC(I,:) = wPC(:,1:np) ;
      E = E(:,1:np) ;
      D = D(1:np,1:np) ;
   else
      J = all(isfinite(x)) ;
      if 1 | np > 20 # octave bug
	 if exist(sfile = "data/svd.mat", "file") == 2
	    clear x ;
	    load(sfile) ;
	 else
	    [PC, D, E] = svd(x, np) ;
	    save(sfile, "PC", "D", "E") ;
	 endif
      else
	 [PC, D, E] = svds(x, np) ;
	 D = real(D) ;
	 [~, is] = sort(diag(D)) ;
	 wPC = wPC(:,is) ; D = D(is,is) ; E = E(:,is) ;
      endif
   endif
   d = diag(D) ;
   [~, is] = sort(d, "descend") ;
   PC = PC(:,is) ;
   D = diag(d(is)) ;
   E = E(:,is) ;
#  printf("gpca: using %d EOFs\n", length(J)) ;

   lmb = diag(D).'.^2 / (nt-1) ;

   if ischar(trunc) trunc = str2func(trunc) ; endif
   if isempty(trunc) trunc = @nEOF ; endif
   if isa(trunc, "function_handle")
      np = feval(trunc, lmb) ;
   elseif 0 < trunc && trunc < 1
      I = lmb/sum(lmb) > eps ;
      PC = PC(:,I) ; lmb = lmb(I) ; E = E(:,I) ;
      np = find(cumsum(lmb)/sum(lmb) >= trunc)(1) ;
   else
      np = round(trunc) ;
   endif
   ev = 100 * lmb / sum(lmb) ;

   E = E(:,1:np) ;
   PC = PC(:,1:np) ;
   D = D(1:np,1:np) ;

   w = nan(ns, np) ;
   w(J,:) = E ;
   E = w ;

   PC = PC * D ;

endfunction


function n = levfit (x)
	 
   ## usage: n = levfit (x)
   ## 
   ## fit best linear line from end

   x = log(x(:)) ; N = length(x) ; n0 = 3 ;

   wrn = warning ;
   warning("off", "Octave:divide-by-zero") ;
   for k=1:N-n0
      u = (k:N)' ; v = x(u) ;
##      [P(k,:), S{k}] = polyfit (u, v, 1) ;
##      R(k) = S{k}.normr / S{k}.df ;
      [~, ~, ~, ~, STATS(k,:)] = regress (v, [ones(rows(u), 1) u]) ;
   endfor
   warning(wrn) ;

   n = find(STATS(:,4) < 0.1 * mean(STATS(:,4)))(1) ;

##   if N > n0 && any(I = diff(R) > 0)
##      n = find(I)(1) ;
##   else
##      n = N ;
##   endif
##   n = N - find(R == min(R)) ;

endfunction

function n = brkstk (x)
	 
	 ## usage: n = brkstk (x)
	 ## 
	 ## PCA truncation using broken stick

	 [pred_evals,nvect] = brokestk(length(x), sum(x), x) ;

	 n = find(x > pred_evals)(end) ;

endfunction


function [pred_evals,nvect] = brokestk(nvars,totvar,evals)
% BROKESTK: Predicts the eigenvalues from a principal component analysis of 
%           random data based on the null broken-stick model of Frontier (1976).  
%           If a vector of eigenvalues is supplied, the function returns the 
%           number of 'significant' eigenvalues.  See Jackson (1993).
%
%     [pred_evals,nvect] = brokestk(nvars,{totvar},{evals})
%
%           nvars =   number of variables in analysis.
%           totvar =  optional total variance, if the PCA is based on a 
%                       covariance matrix.
%           evals =   optional vector of observed eigenvalues.
%           -------------------------------------------------------------------
%           pred_evals = col vector of predicted eigenvalues from null model.
%           nvect =   number of 'significant' eigenvalues, if evals is passed.
%

% Frontier, S.  1976.  Etude de la decroissance des valeurs propres dans une 
%   analyze en composantes principales: comparison avec le modele de baton 
%   brise.  J. Exp. Mar. Biol. Ecol. 25:67-75.
% Jackson, D.A.  1993.  Stopping rules in principal components analysis: a 
%   comparison of heuristial and statistical approaches.  Ecology 74:2204-2214.

% RE Strauss, 12/7/99


  if (nargin < 2) totvar = []; endif;
  if (nargin < 3) evals = []; endif;

  if (~isempty(evals))
    if (length(evals)~=nvars)
      error('  BROKESTK: requires full set of observed eigenvalues');
    endif;
  endif;

  pred_evals = zeros(nvars,1);
  nvect = [];

  for i = 1:nvars                         % Predicted eigenvalues from broken-stick model
    pred_evals(i) = sum(1./(i:nvars));
  endfor;

  if (~isempty(totvar))                   % Adjust by total variance
    pred_evals = totvar .* pred_evals ./ nvars;
  endif;

  if (~isempty(evals))                    % Number of significant eigenvalues
    b = (evals > pred_evals);
    i = min(find(~b));
    nvect = length(1:(i-1));
  endif;

  return;

endfunction


## usage: k = nEOF (lmb)
##
## North rule of thumb
function k = nEOF (lmb)
   n = length(lmb) ;
   if any(J = (abs(diff(lmb)) < sqrt(2/n))) ;
      k = find(J)(1) ;
   else
      k = n ;
   endif
endfunction
