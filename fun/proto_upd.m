## usage: [fss fsn fsd] = proto_upd (BLD = true, ptr, pdd, proto)
##
## update proto files
function [fss fsn fsd] = proto_upd (BLD = false, ptr, pdd, proto)

   if exist(sfile = sprintf("models/%s/solver.tpl", proto), "file") == 2
      ss = fileread(sfile) ;
   else
      ss = fileread("models/solver.tpl") ;
   endif
   
   sn1 = fileread("models/data.tpl") ;
   sn2 = fileread(sprintf("models/%s/net.tpl", proto)) ;
   sn3 = fileread("models/loss.tpl") ;

   sd1 = fileread(sprintf("models/inp.tpl", proto)) ;
   sd2 = fileread(sprintf("models/loss_deploy.tpl", proto)) ;
   
   sn = strcat(sn1, sn2, sn3) ;
   sd = strcat(sd1, sn2, sd2) ;

   fss = sprintf("models/%s/%s_solver.prototxt", proto, pdd.name) ;
   fsn = sprintf("models/%s/%s.prototxt", proto, pdd.name) ;
   fsd = sprintf("models/%s/%s_deploy.prototxt", proto, pdd.name) ;

   if BLD | ~isnewer(fss, sprintf("models/%s/solver.tpl", proto))
      print_str(ptr, pdd, proto, ss, fss) ;
   endif
   if BLD | ~isnewer(fsn, sprintf("models/%s/net.tpl", proto))
      print_str(ptr, pdd, proto, sn, fsn) ;
   endif
   if BLD | ~isnewer(fsd, sprintf("models/%s/data.tpl", proto))
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
   str = strrep(str, "CHANNEL_tpl", num2str(size(ptr.x, 2)));
   str = strrep(str, "WIDTH_tpl", num2str(size(ptr.x, 3)));
   str = strrep(str, "HEIGHT_tpl", num2str(size(ptr.x, 4)));

   fid  = fopen(ofile, "wt") ;
   fprintf(fid, "%s", str) ;
   fclose(fid) ;
   printf("--> %s\n", ofile) ;

endfunction
