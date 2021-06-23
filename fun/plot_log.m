

## usage: plot_log (lfile, loss = "loss", pse = 5, plog = 0)
##
##
function plot_log (lfile, loss = "loss", pse = 5, plog = 0)

   Ipat = sprintf(" Iteration [0-9]+, Testing net") ;
   lpat = sprintf("Test net output #[0-9]+: %s = ", loss) ;

   mtime = 0 ;
   clf ;
   axes("ygrid", "on") ;
   
   while stat(lfile).mtime > mtime

      mtime = stat(lfile).mtime ;

      fid = fopen(lfile, "rt") ;
      s = fscanf(fid, "%c") ;
      s = strsplit(s, "\n") ;

      [S, E, TE, M, T, NM, SP] = regexp(s, Ipat) ;
      I = cellfun(@(c) ~isempty(c), S) ;
      Iter = cellfun(@(c) str2num(strsplit(c{:}, " "){3}), M(I))' ;

      [S, E, TE, M, T, NM, SP] = regexp(s, lpat) ;
      I = cellfun(@(c) ~isempty(c), S) ;
      x = cellfun(@(c) str2num(strsplit(c{2}, " "){1}), SP(I))' ;

      fclose(fid) ;

      n = min(numel(Iter), numel(x)) ;
      if plog set(gca, "yscale", "log") ; endif
      h = line(Iter(1:n), x(1:n), "linestyle", "-", "color", "black") ;
      ylabel(loss) ;
      pause(pse) ;
      if plog set(gca, "yscale", "linear") ; endif
      ##      drawnow ;

      pause(pse) ;
##      delete(h) ;
      
   endwhile

   
endfunction
