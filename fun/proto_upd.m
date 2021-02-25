## usage: [fss fsn fsd] = proto_upd (ptr, pdd, proto)
##
## update proto files
function [fss fsn fsd] = proto_upd (ptr, pdd, proto)

   ss = fileread("solver/solver.tpl") ;
   
   sn1 = fileread("nets/data.tpl") ;
   sn2 = fileread(["nets/" proto ".tpl"]) ;
   sn3 = fileread("nets/loss.tpl") ;

   sd1 = fileread("nets/inp.tpl") ;
   sd2 = fileread("nets/loss_deploy.tpl") ;
   
   sn = strcat(sn1, sn2, sn3) ;
   sd = strcat(sd1, sn2, sd2) ; ;

   fss = sprintf("solver/%s.%s_solver.prototxt", proto, pdd.name) ;
   fsn = sprintf("nets/%s.%s.prototxt", proto, pdd.name) ;
   fsd = sprintf("nets/%s.%s_deploy.prototxt", proto, pdd.name) ;

   if ~isnewer(fss, "solver/solver.tpl")
      print_str(ptr, pdd, proto, ss, fss) ;
   endif
   if ~isnewer(fsn, glob("nets/*.tpl"){:})
      print_str(ptr, pdd, proto, sn, fsn) ;
   endif
   if ~isnewer(fsd, glob("nets/*.tpl"){:})
      print_str(ptr, pdd, proto, sd, fsd) ;
   endif

endfunction


## usage: print_str (ptr, pdd, proto, str, ofile)
##
## print suitable string to ofile
function print_str (ptr, pdd, proto, str, ofile)

   global REG

   str = strrep(str, "PROTO_tpl", proto);
   str = strrep(str, "REG_tpl", REG);
   str = strrep(str, "PDD_tpl", pdd.name);
   str = strrep(str, "WIDTH_tpl", num2str(size(ptr.x, 2)));
   str = strrep(str, "HEIGHT_tpl", num2str(size(ptr.x, 3)));

   fid  = fopen(ofile, "wt") ;
   fprintf(fid, "%s", str) ;
   fclose(fid) ;
   printf("--> %s\n", ofile) ;

endfunction
