## usage: ofile = upd_solver (file, name)
##
## replace max_iter in solver
function ofile = upd_solver (file, name)

   ofile = file ;
   
   [Dd Dn De] = fileparts(file) ;
   Dn = strsplit(Dn, ".") ;
   proto = Dn{1} ; area = strsplit(Dd, "/"){2} ;

   sfile = sprintf("%s/%s.%s_solver.prototxt", Dd, proto, name) ;
   str = fileread(sfile) ;
   Jnl = strfind(str, "\n") ;
   j = strfind(str, "max_iter: ") + 10 ;
   k = Jnl(Jnl > j)(1) - 1 ;
   str = [str(1:j) num2str(2 * sscanf(str(j:k), "%d")) str(k+1:end)] ;

   sfile = sprintf("%s/%s.%s_solver_upd.prototxt", Dd, proto, name) ;

   printf("--> %s\n", sfile) ;
   fputs(fid = fopen(sfile, "wt"), str) ;
   fclose(fid) ;

endfunction
