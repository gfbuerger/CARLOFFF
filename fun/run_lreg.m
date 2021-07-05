## usage: [res ptr1] = run_lreg (ptr, pdd, PCA, TRC="AIC", SKL = {"GSS" "HSS"}, varargin)
##
## calibrate and apply caffe logistic optimization
function [res ptr1] = run_lreg (ptr, pdd, PCA, TRC="CVE", SKL = {"GSS" "HSS"}, varargin)

   global PENALIZED REG NH
   pkg load statistics
   if strcmp(class(PCA), "char") ; pkg load tisean ; endif
   source(tilde_expand("~/oct/nc/penalized/install_penalized.m"))

   Lfun = @(beta, x) beta(1) + x * beta(2:end) ;

   for PHS = {"CAL" "VAL"}
      PHS = PHS{:} ;
      eval(sprintf("ptr.%s = sdate(ptr.id, ptr.Y%s) ;", PHS, PHS)) ;
      eval(sprintf("pdd.%s = sdate(pdd.id, ptr.Y%s) ;", PHS, PHS)) ;
   endfor
   
   X = ptr.x ;
   N = size(X) ;
   prob.id = ptr.id ;
   prob.x = nan(N(1), 2) ;

   if ndims(X) > 2

      X = reshape(X, N(1), N(2), prod(N(3:end))) ;
      PC = [] ;
      for j = 1 : size(X, 2)
	 X(:,j,:) = (X(:,j,:) - nanmean(X(:,j,:)(:))) ./ nanstd(X(:,j,:)(:)) ;
	 x = squeeze(X(ptr.CAL,j,:)) ;

	 if isnewer(efile = sprintf("data/eof.%s.%02d.ob", ptr.vars{j}, NH), "data/atm.ob")
	    load(efile)
	    printf("<-- %s [%d]\n", efile, columns(E)) ;
	 else
	    switch class(PCA)
	       case "char"
		  [ev, E] = pca(x) ;
	       case {"function_handle" "double"}
		  E = gpca(x, PCA) ;
	       otherwise
		  E = eye(columns(x)) ;
	    endswitch
	    printf("[%d] --> %s\n", columns(E), efile) ;
	    save(efile, "E") ;
	 endif

	 PC = [PC, nanmult(X(:,j,:), E)] ;
      endfor

      if ~isempty(PCA) && PCA > size(PC, 2)
	 warning(sprintf("PCA = %d > %d = size(PC, 2)\n", PCA, size(PC, 2))) ;
      endif

   else

      PC = X ;
      PCA = N(2) ;
      
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
##	    plot_penalized(fit) ;
##	    title("LASSO logistic regression") ;
##	    print("nc/LASSO_lreg.png") ;
	    AIC = goodness_of_fit("aic", fit) ;
	    BIC = goodness_of_fit("bic", fit, model) ;
	    CV = fit.CV = cv_penalized(model, @p_lasso, "folds", 5, varargin{:}) ;
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
	    fit.jLasso = jLasso ;

	    beta = fit.beta(:,jLasso) ;
	    ILasso = beta(2:end) ~= 0 ; # check where sum(beta ~= 0, 1) gets saturated
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
	    
	 endif
	 
      endif
      
      w = logistic_cdf(Lfun(beta, x)) ;
      prob.x(ptr.(PHS),:) = [1 - w w] ;

      ce.(PHS) = crossentropy(pdd.c(pdd.(PHS)), prob.x(ptr.(PHS),:)) ;

      [th.(PHS) skl.(PHS)] = skl_est(prob.x(ptr.(PHS),end), pdd.c(pdd.(PHS)), SKL) ;
      
   endfor

   res = struct("fit", fit, "prob", prob, "th", th, "skl", skl) ;

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
