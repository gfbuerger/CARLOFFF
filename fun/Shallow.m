## usage: res = Shallow (ptr, pdd, PCA, TRC="CVE", mdl, SKL={"GSS" "HSS"}, varargin)
##
## calibrate and apply Shallow models
function res = Shallow (ptr, pdd, PCA, TRC="CVE", mdl, SKL={"GSS" "HSS"}, varargin)

   global PFX NH IMB
   if strcmp(class(PCA), "char") ; pkg load tisean ; endif
   init_mdl(mdl) ;	 

   Lfun = @(beta, x) beta(1,:) + x * beta(2:end,:) ;

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
   prob.x = nan(N(1), size(pdd.c, 2)) ;

   if ndims(X) > 2

      X = reshape(X, N(1), N(2), prod(N(3:end))) ;
      PC = [] ;
      for j = 1 : size(X, 2)

	 if strcmp(ptr.vars{j}, "prc") ptr.vars{j} = "cp" ; endif
	 if strcmp(ptr.vars{j}, "prw") ptr.vars{j} = "tcw" ; endif

	 if isequal(PCA, {})

	    E = eye(size(X, 3)) ;

	 else

	    ptfile = sprintf("data/%s.%02d/%s.%s.ob", PFX, NH, ptr.ind, pdd.lname) ;
	    if isnewer(efile = sprintf("data/%s.%02d/eof.%s.ob", PFX, NH, ptr.vars{j}), ptfile) || ~Lcv 
	       load(efile)
	       printf("<-- %s [%d]\n", efile, columns(E)) ;
	    else
	       x = squeeze(X(ptr.CAL,j,:)) ;
	       switch class(PCA)
		  case "char"
		     [ev, E] = pca(x) ;
		  case {"function_handle" "double"}
		     E = gpca(x, PCA) ;
	       endswitch
	       printf("[%d] --> %s\n", columns(E), efile) ;
	       save(efile, "E") ;
	    endif
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
	 c = unique(pdd.c(pdd.(phs),:)) ;
	 y = pdd.c(pdd.(phs),:) ;
	 if numel(c) < 3
	    y = ismember(y, c(end)) ;
	 endif
      else
	 x = PC ;	 
      endif
      
      if Lcv && strcmp(phs, "CAL")

	 ## oversampling
	 [xx yy] = oversmpl(x, y, IMB) ;

	 ## remove missing data
	 I = all(~isnan([xx yy]), 2) ;
	 xx = xx(I,:) ; yy = yy(I,:) ;

	 switch mdl

	    case "lasso"

	       model = glm_multinomial(yy, xx) ;
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
	       fit.par = reshape(fit.beta(:,jLasso), size(fit.beta, 1)/size(yy, 2), size(yy, 2), []) ;
	       fit.model = @(par, x) softmax(logistic_cdf(Lfun(par, x))) ;
	       printf("Lasso: using %d predictors\n", sum(ILasso)) ;

	    case "nnet"

	       Pr = [min(xx) ; max(xx)]' ;
	       SS = [7 3 1] ; # based on some tests
	       Net = newff(Pr, SS, {"tansig","logsig","purelin"}, "trainlm", "learngdm", "mse") ;
	       Net.trainParam.show = NaN ;
	       Net.trainParam.goal = 0 ;
	       Net.trainParam.epochs = 100 ;
	       Net.trainParam.mu_max = 1e12 ;
	       fit.par = train(Net, xx', yy') ;
	       fit.model = @(net, x) sim(net, x')' ;
	       printf("NNET: using %d predictors\n", columns(xx)) ;
	       
	    case "tree"

	       yc = arrayfun(@(i) nthargout(2, @max, yy(i,:), [], 2), 1 : size(yy, 1))' ;
	       trainParamsEnsemble = m5pparamsensemble(50) ;
	       trainParamsEnsemble.getOOBContrib = false ;
	       fit.par = m5pbuild_new(xx, yc, [], [], trainParamsEnsemble) ;
	       if trainParamsEnsemble.numTrees > 1
		  fit.model = @(par, x) mean(cell2mat(cellfun(@(p) m5ppredict(p, x), par, "UniformOutput", false)'), 2) ;
	       else
		  fit.model = @(par, x) m5ppredict(par, x) ;
	       endif

	    otherwise

	       modelfun = @(beta, x) 1 ./ (1 + exp(-Lfun(beta, x))) ;
	       beta0 = zeros(columns(xx)+1, 1) ;
	       opt = optimset("Display", "iter") ;

	       fit.par = nlinfit (xx, yy, modelfun, beta0, opt) ;
##	       F = @(beta) sumsq(modelfun(beta,xx) - yy) ;
##	       [fit.par resid cvg outp] = nonlin_residmin(F, beta0, opt) ;
##	       [fit.par resid cvg outp] = nonlin_curvefit(modelfun, beta0, xx, yy, opt) ;

	       fit.model = @(beta, x) modelfun(beta, x) ;
	       
	 endswitch
	 
      endif

      if Lcv
	 prob.x(ptr.(phs),:) = feval(fit.model, fit.par, x) ;
      else
	 res = feval(pdd.fit.model, pdd.fit.par, x) ;
	 return ;
      endif

      c = arrayfun(@(i) nthargout(2, @max, pdd.c(i,:), [], 2), find(pdd.(phs))) ;
      ce.(phs) = crossentropy(softmax(pdd.c(pdd.(phs),:)), prob.x(ptr.(phs),:)) ;
      [th.(phs) skl.(phs)] = skl_est(prob.x(ptr.(phs),:), c, SKL) ;
      
   endfor

   res = struct("fit", fit, "prob", prob, "th", th, "skl", skl, "crossentropy", ce) ;

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


## usage: init_mdl (mdl)
##
## initialize model
function init_mdl (mdl)

   switch mdl
      case "lasso"
	 source(tilde_expand("~/oct/nc/penalized/install_penalized.m"))
      case "nnet"
	 pkg load nnet
      case "tree"
	 addpath ~/oct/nc/M5PrimeLab ;
      otherwise
	 pkg load optim
   endswitch
   
endfunction
