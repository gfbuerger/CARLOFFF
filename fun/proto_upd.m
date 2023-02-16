## usage: [solver deploy] = proto_upd (BLD = true, ptr, pdd, proto, Dd)
##
## update proto files
function [solver deploy] = proto_upd (BLD = false, ptr, pdd, proto, Dd)

   ## solver
   if exist(wSolver = sprintf("models/%s/solver.tpl", proto), "file") == 2
      Solver = fileread(wSolver) ;
   else
      Solver = fileread(wSolver = "models/solver.tpl") ;
   endif
   Solver = [Solver "net: \"DATA_tpl/PROTO_tpl.IND_tpl.PDD_tpl.prototxt\"\n"] ;
   Solver = [Solver "snapshot_prefix: \"DATA_tpl/PROTO_tpl.IND_tpl.PDD_tpl\"\n"] ;

   ## Data
   if exist(wData = sprintf("models/%s/data.tpl", proto), "file") == 2
      Data = fileread(wData) ;
   else
      Data = fileread(wData = "models/data.tpl") ;
   endif
   ## net
   if exist(wNet = sprintf("models/%s/net.tpl", proto), "file") == 2
      Net = fileread(wNet) ;
   else
      Net = fileread(wNet = "models/net.tpl") ;
   endif
   ## loss
   if exist(wLoss = sprintf("models/%s/loss.tpl", proto), "file")
      Loss = fileread(wLoss) ;
   else
      Loss = fileread(wLoss = "models/loss.tpl") ;
   endif

   Proto = strcat(Data, Net, Loss) ;

   ## deploy
   if exist(wDeploy = sprintf("models/%s/deploy.tpl", proto), "file") == 2
      Deploy = fileread(wDeploy) ;
   else
      Inp = fileread(sprintf("models/inp.tpl", proto)) ;
      Prob = fileread(sprintf("models/prob.tpl", proto)) ;
      Deploy = strcat(Inp, Net, Prob) ;
   endif

   solver = sprintf("%s/%s.%s.%s_solver.prototxt", Dd, proto, ptr.ind, pdd.lname) ;
   if isnewer(Lossv = strrep(solver, "solver", "solver_upd"), solver)
      solver = Lossv ;
   endif
   net = sprintf("%s/%s.%s.%s.prototxt", Dd, proto, ptr.ind, pdd.lname) ;
   deploy = sprintf("%s/%s.%s.%s_deploy.prototxt", Dd, proto, ptr.ind, pdd.lname) ;

   if ~isnewer(solver, wSolver)
      print_str(ptr, pdd, proto, Dd, Solver, solver) ;
   endif
   if ~isnewer(net, wData, wNet, wLoss)
      print_str(ptr, pdd, proto, Dd, Proto, net) ;
   endif
   if ~isnewer(deploy, wData, wNet, wDeploy)
      print_str(ptr, pdd, proto, Dd, Deploy, deploy) ;
   endif

endfunction


## usage: print_str (ptr, pdd, proto, Dd, str, ofile)
##
## print suitable string to ofile
function print_str (ptr, pdd, proto, Dd, str, ofile)

   global PFX NH

   N = size(ptr.img) ;
   if length(N) < 3
      N = [N 1 1] ;
   endif

   NHs = sprintf("%02d", NH);

   str = strrep(str, "PROTO_tpl", proto);
   str = strrep(str, "IND_tpl", ptr.ind);
   str = strrep(str, "PFX_tpl", PFX);
   str = strrep(str, "NH_tpl", NHs);
   str = strrep(str, "DATA_tpl", Dd);
   str = strrep(str, "PDD_tpl", pdd.lname);
   str = strrep(str, "CHANNEL_tpl", num2str(N(2)));
   str = strrep(str, "WIDTH_tpl", num2str(N(3)));
   str = strrep(str, "HEIGHT_tpl", num2str(N(4)));

   fid  = fopen(ofile, "wt") ;
   fprintf(fid, "%s", str) ;
   fclose(fid) ;
   printf("--> %s\n", ofile) ;

endfunction
