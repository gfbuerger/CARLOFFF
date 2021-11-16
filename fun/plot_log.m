## usage: varargout = plot_log (lfile, loss = "loss", iter0 = 0, pse = 10, plog = 0)
##
##
function varargout = plot_log (lfile, loss = "loss", iter0 = 0, pse = 10, plog = 0)

   global COL

   phase = {"Train" "Test"} ;
   
   mtime = 0 ;
   clf ;
   set(gca, "ygrid", "on", "NextPlot", "add", "colororder", [0 1 0 ; 0 0 1]) ;
   
   while stat(lfile).mtime > mtime

      mtime = stat(lfile).mtime ;

      h = [] ;
      for phs = phase

	 phs = phs{:} ;
	 
	 fid = fopen(lfile, "rt") ;
	 s = fscanf(fid, "%c") ;
	 s = strsplit(s, "\n") ;

	 if strcmp(phs, "Train")
	    Ipat = sprintf(" Iteration [0-9]+.*, loss") ;
	 else
	    Ipat = sprintf(" Iteration [0-9]+.*, Testing") ;
	 endif
	 
	 [S, E, TE, M, T, NM, SP] = regexp(s, Ipat) ;
	 I = cellfun(@(c) ~isempty(c), S) ;
	 Iter = cellfun(@(c) str2num(strsplit(c{:}, " "){3}), M(I))' ;

	 lpat = sprintf("%s net output #[0-9]+: %s = ", phs, loss) ;
	 [S, E, TE, M, T, NM, SP] = regexp(s, lpat) ;
	 I = cellfun(@(c) ~isempty(c), S) ;
	 x = cellfun(@(c) str2num(strsplit(c{2}, " "){1}), SP(I))' ;

	 fclose(fid) ;

	 n = min(numel(Iter), numel(x)) ;
	 if plog set(gca, "yscale", "log") ; endif
	 h = [h plot(iter0 + Iter(1:n), x(1:n), "linestyle", "-", "linewidth", 1)] ;
	 xlabel("iterations") ; ylabel(loss) ;
	 set(gca, "ygrid", "on") ;
	 
      endfor
      legend(phase, "box", "off") ;
      
      if plog set(gca, "yscale", "log", "yminorgrid", "on") ; endif

      pause(pse) ;
      
   endwhile

   if nargout > 0
      varargout{1} = h ;
   endif
   
endfunction
