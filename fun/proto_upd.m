## usage: [fss fsn fsd] = proto_upd (BLD = true, ptr, pdd, proto, Dd)
##
## update proto files
function [fss fsn fsd] = proto_upd (BLD = false, ptr, pdd, proto, Dd)

   global REG NH RES

   if exist(wss = sprintf("models/%s/solver.tpl", proto), "file") == 2
      ss = fileread(wss) ;
   else
      ss = fileread(wss = "models/solver.tpl") ;
   endif
   ss = [ss "net: \"DATA_tpl/PROTO_tpl.PDD_tpl.prototxt\"\n"] ;
   ss = [ss "snapshot_prefix: \"DATA_tpl/PROTO_tpl.PDD_tpl\"\n"] ;
   
   if exist(wsn1 = sprintf("models/%s/data.tpl", proto), "file") == 2
      sn1 = fileread(wsn1) ;
   else
      sn1 = fileread(wsn1 = "models/data.tpl") ;
   endif
   if exist(wsn2 = sprintf("models/%s/net.tpl", proto), "file") == 2
      sn2 = fileread(wsn2) ;
   else
      sn2 = fileread(wsn2 = "models/net.tpl") ;
   endif
   if exist(wsn3 = sprintf("models/%s/loss.tpl", proto), "file")
      sn3 = fileread(wsn3) ;
   else
      sn3 = fileread(wsn3 = "models/loss.tpl") ;
   endif

   sd1 = fileread(sprintf("models/inp.tpl", proto)) ;
   sd2 = fileread(sprintf("models/deploy.tpl", proto)) ;
   
   sn = strcat(sn1, sn2, sn3) ;
   sd = strcat(sd1, sn2, sd2) ;

   fss = sprintf("%s/%s.%s_solver.prototxt", Dd, proto, pdd.name) ;
   fsn = sprintf("%s/%s.%s.prototxt", Dd, proto, pdd.name) ;
   fsd = sprintf("%s/%s.%s.%s_deploy.prototxt", Dd, proto, ptr.ind, pdd.name) ;

   if ~isnewer(fss, wss)
      print_str(ptr, pdd, proto, Dd, ss, fss) ;
   endif
   if ~isnewer(fsn, wsn1, wsn2, wsn3)
      print_str(ptr, pdd, proto, Dd, sn, fsn) ;
   endif
   if ~isnewer(fsd, wsn1, wsn2)
      print_str(ptr, pdd, proto, Dd, sd, fsd) ;
   endif

endfunction


## usage: print_str (ptr, pdd, proto, Dd, str, ofile)
##
## print suitable string to ofile
function print_str (ptr, pdd, proto, Dd, str, ofile)

   global REG NH RES

   N = size(ptr.img) ;
   if length(N) < 3
      N = [N 1 1] ;
   endif

   NHs = sprintf("%02d", NH);

   str = strrep(str, "PROTO_tpl", proto);
   str = strrep(str, "REG_tpl", REG);
   str = strrep(str, "NH_tpl", NHs);
   str = strrep(str, "DATA_tpl", Dd);
   str = strrep(str, "PDD_tpl", pdd.name);
   str = strrep(str, "CHANNEL_tpl", num2str(N(2)));
   str = strrep(str, "WIDTH_tpl", num2str(N(3)));
   str = strrep(str, "HEIGHT_tpl", num2str(N(4)));

   fid  = fopen(ofile, "wt") ;
   fprintf(fid, "%s", str) ;
   fclose(fid) ;
   printf("--> %s\n", ofile) ;

endfunction
