function res = isnewer (file1, varargin)

   ## usage:  res = isnewer (file1, varargin)
   ##
   ## check if file1 is newer than files in varargin

   tick = 0 ;
   if ~exist(file1, "file")
      res = false ;
      return ;
   else
      res = true ;
   endif

   for i = 1:nargin-1
      res = res && all(birth(file1) > birth(varargin{i}) + tick)  ;
   endfor

endfunction


function res = birth (file)

   ## usage:  res = birth (file)
   ##
   ## determine age of file (newest in case of directory)

   if exist(file, "file") == 0
      if strncmp(file, "http", 4)
	 res = 0 ;
      else
	 res = Inf ;
      endif
      return ;
   endif

   if isfolder(file)

      if strcmp(file(end), ".")
	 res = -Inf ;
	 return ;
      endif

      D = readdir(file)(3:end) ;

      if isempty(D)
##	 res = time ;
	 res = stat(file).mtime ;
      else
	 res = max(cellfun(@(a) birth(fullfile(file, a)), D)) ;
	 res = max(res, stat(file).mtime) ;
      endif
      ##res = 0 ;
      ##for f = glob([file "/*"])'
      ##	 if islink(f{:}), continue ; endif
      ##	 res = max(res, birth(f{:})) ;
      ##endfor

   else

      res = stat(file).mtime ;

   endif

endfunction
