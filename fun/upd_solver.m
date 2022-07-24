## usage: ofile = upd_solver (file, ind, name)
##
## replace max_iter in solver
function ofile = upd_solver (file, ind, name)

   ofile = file ;

   if isempty(SOLV = getenv("SOLV")) return ; endif

   [Dd Dn De] = fileparts(file) ;
   Dn = strsplit(Dn, ".") ;
   proto = Dn{1} ; area = strsplit(Dd, "/"){3} ;

   sfile = sprintf("%s/%s.%s.%s_solver.prototxt", Dd, proto, ind, name) ;
   str = fileread(sfile) ;
   Jnl = strfind(str, "\n") ;
   j = strfind(str, "max_iter: ") + 9 ;
   k = Jnl(Jnl > j)(1) - 1 ;
   str = [str(1:j) num2str(2 * sscanf(str(j:k), "%d")) str(k+1:end)] ;

   sfile = sprintf("%s/%s.%s.%s_solver_upd.prototxt", Dd, proto, ind, name) ;
   printf("--> %s\n", sfile) ;
   fputs(fid = fopen(sfile, "wt"), str) ;
   fclose(fid) ;

endfunction
