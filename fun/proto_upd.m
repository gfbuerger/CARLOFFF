## usage: [fss fsn fsd] = proto_upd (BLD = true, ptr, pdd, proto)
##
## update proto files
function [fss fsn fsd] = proto_upd (BLD = false, ptr, pdd, proto)

   if exist(ss = sprintf("models/%s/solver.tpl", proto), "file") == 2
      ss = fileread(ss) ;
   else
      ss = fileread("models/solver.tpl") ;
   endif
   
   sn1 = fileread("models/data.tpl") ;
   if exist(sn2 = sprintf("models/%s/net.tpl", proto), "file") == 2
      sn2 = fileread(sn2) ;
   else
      sn2 = fileread("models/net.tpl") ;
   endif
   if exist(sn3 = sprintf("models/%s/loss.tpl", proto), "file")
      sn3 = fileread(sn3) ;
   else
      sn3 = fileread("models/loss.tpl") ;
   endif

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
   if true | ~isnewer(fsn, sprintf("models/%s/net.tpl", proto))  # FIXME
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

   N = size(ptr.x) ;
   if length(N) < 3
      N = [N 1 1] ;
   endif

   str = strrep(str, "PROTO_tpl", proto);
   str = strrep(str, "REG_tpl", REG);
   str = strrep(str, "PDD_tpl", pdd.name);
   str = strrep(str, "CHANNEL_tpl", num2str(N(2)));
   str = strrep(str, "WIDTH_tpl", num2str(N(3)));
   str = strrep(str, "HEIGHT_tpl", num2str(N(4)));

   fid  = fopen(ofile, "wt") ;
   fprintf(fid, "%s", str) ;
   fclose(fid) ;
   printf("--> %s\n", ofile) ;

endfunction
