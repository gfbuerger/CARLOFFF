function pmkdir (varargin)

   ## usage:  pmkdir (D)
   ##
   ## make directory with parents

   for v=varargin
      D = v{:} ;
      sd = "" ;
      for d=strsplit(D, "/")
	 sd = [sd d{:} "/"] ;
	 if exist(sd, "dir") ~= 7
	    printf("--> %s\n", sd) ;
	    mkdir(sd) ;
	 endif
      endfor 
   endfor 

endfunction
