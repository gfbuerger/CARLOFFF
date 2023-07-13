## usage: varargout = errfun (S, varargin)
##
##
function varargout = errfun (S, varargin)

   warning(S.identifier, S.message) ;
   varargout = mat2cell(nan(1, nargout)) ;

endfunction
