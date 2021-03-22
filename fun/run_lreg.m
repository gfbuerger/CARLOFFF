## usage: res = run_lreg (ptr, pdd, PCA, SKL = {"GSS" "HSS"}, varargin)
##
## calibrate and apply caffe logistic optimization
function res = run_lreg (ptr, pdd, PCA, SKL = {"GSS" "HSS"}, varargin)

   pkg load statistics
   source(tilde_expand("~/oct/nc/penalized/install_penalized.m"))

   X = ptr.x ;
   N = size(X) ;
   X = reshape(X, N(1), N(2), prod(N(3:end))) ;
   for j = 1 : size(X, 2)
      X(:,j,:) = (X(:,j,:) - nanmean(X(:,j,:)(:))) ./ nanstd(X(:,j,:)(:)) ;
   endfor
   X = reshape(X, N(1), prod(N(2:end))) ;
   
   for PHS = {"CAL" "VAL"}

      PHS = PHS{:} ;
      eval(sprintf("ptr.%s = sdate(ptr.id, ptr.Y%s) ;", PHS, PHS)) ;
      eval(sprintf("pdd.%s = sdate(pdd.id, ptr.Y%s) ;", PHS, PHS)) ;

      x = X(ptr.I & ptr.(PHS),:) ;

      if strcmp(PHS, "CAL")
	 switch class(PCA)
	    case "char"
	       [~, E] = pca(x) ;
	    case {"function_handle" "double"}
	       E = gpca(x, PCA) ;
	    otherwise
	       E = eye(columns(x)) ;
	 endswitch
      endif

      x = x * E ;
      
      c = unique(pdd.c(pdd.I & pdd.(PHS))) ;
      y = ismember(pdd.c(pdd.I & pdd.(PHS)), c(end)) ;

      model = glm_logistic(y,x) ;
      if strcmp(PHS, "CAL")
	 fit = penalized(model, @p_lasso, varargin{:}) ;
	 I = fit.beta(2:end,40) ~= 0 ; # check where sum(fit.beta ~= 0, 1) gets saturated
	 XX = X(ptr.I,:) * E(:,I) ;
	 yy = ismember(pdd.c(pdd.I), c(end)) ;
	 save -mat data.mat XX yy
      endif
      
      if 0
	 plot_penalized(fit) ;
	 AIC = goodness_of_fit("aic", fit) ;
	 semilogx(fit.lambda, AIC) ;
	 xlabel({"\\lambda"}) ; ylabel({"AIC"}) ;
	 BIC = goodness_of_fit("bic", fit, model) ;
	 semilogx(fit.lambda, BIC) ;
	 xlabel({"\\lambda"}) ; ylabel({"BIC"}) ;

	 cv = cv_penalized(model, @p_lasso, "folds", 5, varargin{:}) ;
	 plot_cv_penalized(cv) ;

	 bar(fit.beta(2:end,end)) ;
	 xlabel("potential coefficients") ; ylabel("{\\beta}") ;

      endif

      beta = fit.beta(:,end) ;
      f = beta(1) + x * beta(2:end) ;

      prob.(PHS) = logistic_cdf(f) ;
      prob.(PHS) = [1 - prob.(PHS) prob.(PHS)] ;

      ce.(PHS) = crossentropy(pdd.c(pdd.I & pdd.(PHS)), prob.(PHS)) ;

      for s = SKL
	 s = s{:} ;
	 [thx fval] = fminsearch(@(th) -MoC(s, pdd.c(pdd.I & pdd.(PHS)), prob.(PHS)(:,end) > th), 0.1) ;
	 th.(s).(PHS) = thx ;
	 skl.(s).(PHS) = -fval ;
      endfor
      
   endfor

   res = struct("beta", beta, "prob", prob, "th", th, "skl", skl) ;

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
