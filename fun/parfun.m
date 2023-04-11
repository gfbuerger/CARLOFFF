function varargout = parfun (varargin)

   ## usage:  varargout = parfun (varargin)
   ##
   ## wrapper for parfun

   dbs = dbstack ;

   global NCPU PARLOOP VERBOSE

   ncpu = NCPU ;

   c = cell(1, nargout) ;
   if isnumeric(w = varargin{1})
      ncpu = w ;
      varargin = varargin(2:end) ;
   endif
   fun = varargin{1} ; sfun = func2str(fun) ;
   if iscell(varargin{2})
      pfun = "cellfun" ;
   else
      pfun = "arrayfun" ;
   endif

   if isempty(ncpu) || ncpu < 2
      if !isempty(j = find(strcmpi(varargin, "verboselevel")))
	 varargin = [varargin(1:j-1) varargin(j+2:end)] ;
      endif
      if VERBOSE
	 printf("cellfun: ncpu = %d: ", ncpu) ;
	 printf("< %s", sfun) ;
	 arrayfun(@(a) printf("< %s", a.name), dbs) ;
	 printf("\n") ;
      endif
      [c{:}] = feval(pfun, varargin{:}, "ErrorHandler", @errfun) ;
   else
      if PARLOOP
	 for j=1:length(varargin{2})
	    printf("looping: %s < %s (%d): %s)\n", dbs(2).name, dbs(1).name, j, sfun) ;
	    clear C ;
	    for k = 2:nargin
	       if ischar(varargin{k}), break ; endif
	       C{k-1} = varargin{k}{j} ;
	    endfor
	    w = cell(1, nargout) ;
      	    [w{:}] = feval(fun, C{:}) ;
	    for k = 1:nargout
	       c{k}{j,1} = w{k} ;
	    endfor
	 endfor
      else
	 if any(strcmp({dbs(2:end).name}, "parfun"))
	    if !isempty(j = find(strcmpi(varargin, "verboselevel")))
	       varargin = [varargin(1:j-1) varargin(j+2:end)] ;
	    endif
	    if VERBOSE
	       printf("%s: ", pfun) ;
	       printf("< %s", sfun) ;
	       arrayfun(@(a) printf(" < %s", a.name), dbs) ;
	       printf("\n") ;
	    endif
	    [c{:}] = feval(pfun, varargin{:}, "ErrorHandler", @errfun) ;
	 else
	    if min(numel(varargin{2}), nproc) > 1
	       pkg load parallel
	       varargin = [ncpu, varargin] ;
	       pfun = ["par" pfun] ;
	    endif
	    if VERBOSE
	       printf("%s: ", pfun) ;
	       printf("< %s", sfun) ;
	       arrayfun(@(a) printf(" < %s", a.name), dbs) ;
	       printf("\n") ;
	    endif
	    [c{:}] = feval(pfun, varargin{:}, "ErrorHandler", @errfun) ;
	 endif
      endif
   endif

   varargout = c ;

endfunction
