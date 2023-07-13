## usage: fmod (file, x)
##
## save x to file, preserving timestamp
function fmod (file, x)

   xn = inputname(2) ;
   eval(sprintf("%s = x ;", xn)) ;

   t = stat(file).mtime ;
   t = strftime("%Y%m%d%H%M", localtime(t)) ;

   printf("%s --> %s\n", xn, file) ;
   save(file, xn) ;
   system(sprintf("touch -t %s %s", t, file)) ;

endfunction
