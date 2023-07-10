## usage: res = Shallow (ptr, pdd, PCA, TRC="CVE", mdl, SKL={"GSS" "HSS"}, varargin)
##
## calibrate and apply Shallow models
function res = Shallow (ptr, pdd, PCA, TRC="CVE", mdl, SKL={"GSS" "HSS"}, varargin)

   global GREG REG NH IMB MAXX
   if strcmp(class(PCA), "char") ; pkg load tisean ; endif
   init_mdl(mdl) ;	 

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

	 if strcmp(ptr.vars{j}, "prc") ptr.vars{j} = "cp" ; endif
	 if strcmp(ptr.vars{j}, "prw") ptr.vars{j} = "tcw" ; endif

	 if isequal(PCA, {})

	    E = eye(size(X, 3)) ;

	 else

	    efile = sprintf("data/%s.%02d/eof.%s.ob", REG, NH, ptr.vars{j}) ;
	    if ~Lcv || isnewer(efile, sprintf("data/%s.%02d/%s.%s.ob", REG, NH, ptr.ind, pdd.lname))
	       load(efile) ;
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

      if strcmp(phs, "CAL")  th = [] ; endif

      if Lcv
	 x = PC(ptr.(phs),:) ;
	 c = unique(pdd.c(pdd.(phs))) ;
	 y = ismember(pdd.c(pdd.(phs)), c(end)) ;
      else
	 x = PC ;	 
      endif

      if Lcv && strcmp(phs, "CAL")

	 ## oversampling
	 [xx yy] = oversmpl(x, y, IMB) ;

	 ## remove missing data
	 I = all(~isnan([xx yy]), 2) ;
	 xx = xx(I,:) ; yy = yy(I,:) ;

	 tic ;

	 switch mdl

	    case "lasso"

	       model = glm_logistic(yy,xx) ;
	       fit = penalized(model, @p_lasso, varargin{:}) ;
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
	       fit.model = @(par, x) logicdf(Lfun(par, x), 0, 1) ;
	       printf("Lasso: using %d predictors\n", sum(ILasso)) ;

	    case "nnet"

	       Pr = [min(xx) ; max(xx)]' ;
	       SS = [7 3 1] ; # based on some tests
	       Net = arrayfun(@(i) newff(Pr, SS, {"tansig","logsig","purelin"}, "trainlm", "learngdm", "mse"), 1:20) ;
	       for i = 1 : length(Net)
		  Net(i).trainParam.show = NaN ;
		  Net(i).trainParam.goal = 0 ;
		  if size(xx, 2) > MAXX
		     warning("trivial solution for xx(:,2) = %d\n", size(xx, 2)) ;
		     Net(i).trainParam.epochs = 1 ;
		  endif
	       endfor

	       fit.par = parfun(@(net) train(net, xx', yy'), Net) ;
	       fit.model = @(par, x) clprob(@sim, par, x, [0 1]) ;
	       printf("NNET: using %d predictors\n", columns(xx)) ;

	    case "tree"

	       trainParamsEnsemble = m5pparamsensemble(200) ;
	       trainParamsEnsemble.getOOBContrib = false ;
	       fit.par = m5pbuild_new(xx, yy, [], [], trainParamsEnsemble) ;
	       fit.model = @(par, x) clprob(par, x, unique(pdd.c(:))') ;

	    case "rf"

	       D = prdataset(xx, double(yy)) ;
	       fit.par = rfLearning(D, 200) ;
	       fit.model = @(par, x) rfPredict(x, par)(:,end) ;

	    otherwise

	       modelfun = @(beta, x) 1 ./ (1 + exp(-Lfun(beta, x))) ;
	       beta0 = zeros(columns(xx)+1, 1) ;
	       opt = optimset("MaxIter", 200, "TolFun", 1e-8) ;
	       if size(xx, 2) > MAXX
		  warning("trivial solution for xx(:,2) = %d\n", size(xx, 2)) ;
	       endif
	       [fit.par resid cvg outp] = nonlin_curvefit(modelfun, beta0, xx, yy, opt) ;
	       fit.model = @(beta, x) modelfun(beta, x) ;

	 endswitch
	 
	 fprintf('Execution time: %0.2f hours\n', toc/(60*60));

	 if 0
	    plot_fit (mdl, fit)
	    hgsave(sprintf("nc/%s.%02d/%s.og", REG, NH, mdl)) ;
	    print(sprintf("nc/%s.%02d/%s.svg", REG, NH, mdl)) ;
   	 endif

      endif

      if Lcv
	 w = feval(fit.model, fit.par, x) ;
	 prob.x(ptr.(phs),:) = [1 - w w] ;
	 eskl.(phs) = [] ;
	 if strcmp(mdl, "tree")
	    w = m5ppredict_new(fit.par, x) ;
	    u = unique(pdd.c(:))' ;
	    J = cell2mat(arrayfun(@(j) nthargout(2, @min, abs(w(:,j) - u), [], 2), 1 : size(w, 2), "UniformOutput", false)) ;
	    w = u(J) ;
	    eskl.(phs) = arrayfun(@(j) MoC("ETS", pdd.c(pdd.(phs)), w(:,j)), 1 : size(w, 2)) ;
	 endif
      else
	 w = feval(pdd.fit.model, pdd.fit.par, x, pdd.fit.uc) ;
	 res = [1 - w w] ;
	 return ;
      endif

      ce.(phs) = crossentropy(pdd.c(pdd.(phs)), prob.x(ptr.(phs),:)) ;

      [skl.(phs) th] = skl_est(prob.x(ptr.(phs),end), pdd.c(pdd.(phs)), SKL, th) ;
      
   endfor

   res = struct("fit", fit, "prob", prob, "th", th, "skl", skl, "crossentropy", ce, "eskl", eskl) ;

endfunction


## usage: res = F (beta, X)
##
##
function res = F (beta, X)

   res = logicdf(beta(1) + X * beta(2:end), 0, 1) ;

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
	 pkg load nnet parallel
      case "tree"
	 addpath ~/oct/nc/M5PrimeLab ~/oct/nc/M5PrimeLab/private ;
      case "rf"
	 addpath ~/oct/nc/prtools ~/oct/nc/bagging-boosting-random-forests/random-forests ;
      otherwise
	 pkg load optim
   endswitch
   
endfunction
