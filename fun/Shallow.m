## usage: res = Shallow (ptr, pdd, PCA, TRC="AIC", SKL={"GSS" "HSS"}, varargin)
##
## calibrate and apply Shallow models
function res = Shallow (ptr, pdd, PCA, TRC="CVE", SKL={"GSS" "HSS"}, varargin)

   global MODE REG NH IMB
   if strcmp(class(PCA), "char") ; pkg load tisean ; endif

   Lfun = @(beta, x) beta(1) + x * beta(2:end) ;

   if Lcv = ~isfield(pdd, "fit")
      for phs = {"CAL" "VAL"}
	 phs = phs{:} ;
	 eval(sprintf("ptr.%s = sdate(ptr.id, ptr.Y%s) ;", phs, phs)) ;
	 eval(sprintf("pdd.%s = sdate(pdd.id, ptr.Y%s) ;", phs, phs)) ;
      endfor
   endif
   
   X = ptr.x ;
   N = size(X) ;
   prob.id = ptr.id ;
   prob.x = nan(N(1), 2) ;

   if ndims(X) > 2

      X = reshape(X, N(1), N(2), prod(N(3:end))) ;
      PC = [] ;
      for j = 1 : size(X, 2)
	 X(:,j,:) = (X(:,j,:) - nanmean(X(:,j,:)(:))) ./ nanstd(X(:,j,:)(:)) ;

	 if strcmp(ptr.vars{j}, "prc") ptr.vars{j} = "cp" ; endif
	 if isnewer(efile = sprintf("data/%s.%02d/eof.%s.ob", REG, NH, ptr.vars{j}), "data/atm.ob")
	    load(efile)
	    printf("<-- %s [%d]\n", efile, columns(E)) ;
	 else
	    x = squeeze(X(ptr.CAL,j,:)) ;
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

   for phs = {"CAL" "VAL"}

      phs = phs{:} ;

      if Lcv
	 x = PC(ptr.(phs),:) ;
	 c = unique(pdd.c(pdd.(phs))) ;
	 y = ismember(pdd.c(pdd.(phs)), c(end)) ;
      else
	 x = PC ;	 
      endif
      
      if Lcv && strcmp(phs, "CAL")

	 switch IMB
	    case "SMOTE"
	       printf("imbalance handling using: %s\n", IMB) ;
	       [xx yy] = smote(x, y) ;
	    case ""
	    otherwise
	       printf("imbalance handling using: %s\n", IMB) ;
	       [xx yy] = oversmpl(x, y) ;
	 endswitch
	 
	 switch MODE

	    case "lasso"

	       source(tilde_expand("~/oct/nc/penalized/install_penalized.m"))
	       model = glm_logistic(yy,xx) ;
	       fit = penalized(model, @p_lasso, varargin{:}) ;
	       if 0
		  plot_penalized(fit) ;
		  title("LASSO logistic regression") ;
		  print("nc/LASSO_lreg.png") ;
	       endif
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

	       ILasso = fit.beta(2:end,jLasso) ~= 0 ; # check where sum(beta ~= 0, 1) gets saturated
	       fit.par = fit.beta(:,jLasso) ;
	       fit.model = @(par, x) logistic_cdf(Lfun(par, x)) ;
	       printf("Lasso: using %d predictors\n", sum(ILasso)) ;

	    case "nnet"

	       I = all(~isnan([xx yy]), 2) ;
	       xx = xx(I,:) ; yy = yy(I,:) ;

	       pkg load nnet
	       Pr = [min(xx) ; max(xx)]' ;
	       if ~isempty(varargin)
		  SS = varargin{1} ;
	       else
		  SS = [7 3 1] ; # based on some tests
	       endif
	       Net = newff(Pr, SS, {"tansig","logsig","purelin"}, "trainlm", "learngdm", "mse") ;
##	       Net.trainParam.show = Inf ;
	       Net.trainParam.goal = 0 ;
	       Net.trainParam.epochs = 100 ;
	       Net.trainParam.mu_max = 1e12 ;
	       fit.par = train(Net, xx', yy') ;
	       fit.model = @(net, x) sim(net, x')' ;
	       printf("NNET: using %d predictors\n", columns(xx)) ;
	       
	    case "tree"

	       I = all(~isnan([xx yy]), 2) ;
	       xx = xx(I,:) ; yy = yy(I,:) ;

	       addpath ~/oct/nc/M5PrimeLab ;
	       trainParamsEnsemble = m5pparamsensemble(50) ;
	       trainParamsEnsemble.getOOBContrib = false ;
	       fit.par = m5pbuild(xx, yy, [], [], trainParamsEnsemble) ;
	       if trainParamsEnsemble.numTrees > 1
		  fit.model = @(par, x) mean(cell2mat(cellfun(@(p) m5ppredict(p, x), par, "UniformOutput", false)'), 2) ;
	       else
		  fit.model = @(par, x) m5ppredict(par, x) ;
	       endif

	    otherwise

	       I = all(~isnan([xx yy]), 2) ;
	       xx = xx(I,:) ; yy = yy(I,:) ;

	       pkg load optim
	       modelfun = @(beta, x) 1 ./ (1 + exp(-Lfun(beta, x))) ;
	       beta0 = zeros(columns(xx)+1, 1) ;
	       opt = optimset("Display", "iter") ;
	       fit.par = nlinfit (xx, yy, modelfun, beta0, opt) ;
	       fit.model = @(beta, x) modelfun(beta, x) ;
	       
	 endswitch
	 
      endif

      if Lcv
	 w = feval(fit.model, fit.par, x) ;
	 prob.x(ptr.(phs),:) = [1 - w w] ;
      else
	 w = feval(pdd.fit.model, pdd.fit.par, x) ;
	 res = [1 - w w] ;
	 return ;
      endif

      ce.(phs) = crossentropy(pdd.c(pdd.(phs)), prob.x(ptr.(phs),:)) ;

      [th.(phs) skl.(phs)] = skl_est(prob.x(ptr.(phs),end), pdd.c(pdd.(phs)), SKL) ;
      
   endfor

   res = struct("fit", fit, "prob", prob, "th", th, "skl", skl) ;

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
