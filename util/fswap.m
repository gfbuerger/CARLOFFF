## usage: fswap (ifile)
##
## swap ifile and ofile (preserve timestamp)
function fswap (ifile)

   ofile = [ifile(1:end-1) "b"] ;

   if exist(ifile, "file") ~= 2 return ; endif
   
   printf("<-- %s\n", ifile) ;
   w = load(ifile) ;
   t = stat(ifile).mtime ;
   t = strftime("%Y%m%d%H%M", localtime(t)) ;

   fld = fieldnames(w){:} ;
   eval(sprintf("%s = w.%s ;", fld, fld)) ;

   printf("--> %s\n", ofile) ;
   save(ofile, fld) ;
   system(sprintf("touch -t %s %s", t, ofile)) ;

   delete(ifile) ;

endfunction
