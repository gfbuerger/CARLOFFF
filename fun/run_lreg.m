## usage: [res ptr1] = run_lreg (ptr, pdd, PCA, TRC, SKL = {"GSS" "HSS"}, varargin)
##
## calibrate and apply caffe logistic optimization
function [res ptr1] = run_lreg (ptr, pdd, PCA, TRC, SKL = {"GSS" "HSS"}, varargin)

   global PENALIZED
   pkg load statistics
   source(tilde_expand("~/oct/nc/penalized/install_penalized.m"))

   Lfun = @(beta, x) beta(1) + x * beta(2:end) ;

   for PHS = {"CAL" "VAL"}
      PHS = PHS{:} ;
      eval(sprintf("ptr.%s = sdate(ptr.id, ptr.Y%s) ;", PHS, PHS)) ;
      eval(sprintf("pdd.%s = sdate(pdd.id, ptr.Y%s) ;", PHS, PHS)) ;
   endfor
   
   X = ptr.x ;
   N = size(X) ;

   if ndims(X) > 2

      X = reshape(X, N(1), N(2), prod(N(3:end))) ;
      PC = [] ;
      for j = 1 : size(X, 2)
	 X(:,j,:) = (X(:,j,:) - nanmean(X(:,j,:)(:))) ./ nanstd(X(:,j,:)(:)) ;
	 x = squeeze(X(ptr.CAL,j,:)) ;

	 if isnewer(efile = sprintf("data/eof.%s.ob", ptr.var{j}), "data/atm.ob")
	    printf("<-- %s\n", efile) ;
	    load(efile)
	 else
	    switch class(PCA)
	       case "char"
		  [~, E] = pca(x) ;
	       case {"function_handle" "double"}
		  E = gpca(x, PCA) ;
	       otherwise
		  E = eye(columns(x)) ;
	    endswitch
	    printf("--> %s\n", efile) ;
	    save(efile, "E") ;
	 endif

	 PC = [PC, nanmult(X(:,j,:), E(:,1:PCA))] ;
      endfor

   else

      PC = X ;

   endif

   if PCA > size(PC, 2)
      error(sprintf("PCA = %d > %d = size(PC, 2)", PCA, size(PC, 2))) ;
   endif
   
   for PHS = {"CAL" "VAL"}

      PHS = PHS{:} ;

      x = PC(ptr.(PHS),:) ;

      c = unique(pdd.c(pdd.(PHS))) ;
      y = ismember(pdd.c(pdd.(PHS)), c(end)) ;

      if strcmp(PHS, "CAL")

	 if PENALIZED

	    model = glm_logistic(y,x) ;
	    fit = penalized(model, @p_lasso, varargin{:}) ;
	    AIC = goodness_of_fit("aic", fit) ;
	    BIC = goodness_of_fit("bic", fit, model) ;
	    CV = cv_penalized(model, @p_lasso, "folds", 5, varargin{:}) ;
	    switch TRC
	       case "AIC"
		  [~, jLasso] = min(AIC) ;
	       case "BIC"
		  [~, jLasso] = min(BIC) ;
	       case "CVE"
		  [~, jLasso] = min(CV.cve) ;
	       case "PCA/2"
		  jLasso = find(sum(fit.beta(2:end,:) ~= 0, 1) >= PCA / 2)(1) ;
	       otherwise
		  jLasso = size(fit.beta, 2) ;
	    endswitch

	    beta = fit.beta(:,jLasso) ;
	    ILasso = fit.beta(2:end,jLasso) ~= 0 ; # check where sum(fit.beta ~= 0, 1) gets saturated
	    printf("Lasso: using %d predictors\n", sum(ILasso)) ;

	 else

	    XX = x ;
	    yy = double(ismember(pdd.c(pdd.(PHS)), c(end))) ;
	    I = all(~isnan([XX yy]), 2) ;
	    XX = XX(I,:) ; yy = yy(I,:) ;
##	    save -mat /tmp/data.mat XX yy

	    pkg load optim
	    modelfun = @(beta, x) 1 ./ (1 + exp(-Lfun(beta, x))) ;
	    beta0 = zeros(columns(XX)+1, 1) ;
	    opt = optimset("Display", "iter") ;
	    beta = nlinfit (XX, yy, modelfun, beta0, opt) ;
	    ILasso = true(1, columns(E)) ;
	    
	 endif
	 
      endif
      
      if PENALIZED & 0
	 clf ;
	 ax(1) = subplot(3, 2, [1 3]) ;
	 plot_penalized(fit) ;
	 ax(2) = subplot(3, 2, [5]) ;
	 semilogx(fit.lambda, sum(fit.beta(2:end,:) ~= 0, 1)) ;
	 ax(3) = subplot(3, 2, 2) ;
	 semilogx(fit.lambda, AIC) ;
	 xlabel({"\\lambda"}) ; ylabel({"AIC"}) ;
	 ax(4) = subplot(3, 2, 4) ;
	 semilogx(fit.lambda, BIC) ;
	 xlabel({"\\lambda"}) ; ylabel({"BIC"}) ;
	 ax(5) = subplot(3, 2, 6) ;
	 semilogx(CV.lambda', CV.cve) ;
	 xlabel({"\\lambda"}) ; ylabel({"CVE"}) ;
	 set(ax(2:5), "xdir", "reverse") ;
	 set(ax, "xlim", xlim(ax(1))) ;
	 
	 bar(fit.beta(2:end,end)) ;
	 xlabel("potential coefficients") ; ylabel("{\\beta}") ;

      endif

      prob.(PHS) = logistic_cdf(Lfun(beta, x)) ;
      prob.(PHS) = [1 - prob.(PHS) prob.(PHS)] ;

      ce.(PHS) = crossentropy(pdd.c(pdd.(PHS)), prob.(PHS)) ;

      for s = SKL
	 s = s{:} ;
	 [thx fval] = fminsearch(@(th) -MoC(s, pdd.c(pdd.(PHS)), prob.(PHS)(:,end) > th), 0.1) ;
	 th.(s).(PHS) = thx ;
	 skl.(s).(PHS) = -fval ;
      endfor
      
   endfor

   res = struct("beta", beta, "prob", prob, "th", th, "skl", skl) ;

   ptr1 = ptr ;
   ptr1.x = PC ;
   
endfunction


## usage: res = F (beta, X)
##
##
function res = F (beta, X)

   res = logistic_cdf(beta(1) + X * beta(2:end)) ;

   res = max(0, res) ;
   res = min(1, res) ;
   
endfunction

function [J, grad] = costFunction(theta, X, y)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
%
% Note: grad should have the same dimensions as theta
%

sigmoid = @(x) 1 ./ (1 + exp(-x)) ;
h = sigmoid(X*theta);
% J = (1/m)*sum(-y .* log(h) - (1 - y) .* log(1-h));
J = (1/m)*(-y'* log(h) - (1 - y)'* log(1-h));
grad = (1/m)*X'*(h - y);

% =============================================================

end
