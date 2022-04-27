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

      fid = fopen(lfile, "rt") ;
      sf = fscanf(fid, "%c") ;
      fclose(fid) ;
      net = strsplit(lfile, "/"){6} ;
      sf = strsplit(sf, sprintf("name: \"%s\"", net)) ;
      s = strsplit(sf{3}, "\n") ;

      h = [] ;
      for phs = phase

	 phs = phs{:} ;
	 
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

	 n = min(numel(Iter), numel(x)) ;
	 if plog set(gca, "yscale", "log") ; endif
	 h = [h plot(iter0 + Iter(2:n), x(2:n), "linestyle", "-", "linewidth", 1)] ;
	 xlabel("iterations") ; ylabel(loss) ;
	 set(gca, "ygrid", "on") ;
	 
      endfor
      if numel(get(gca, "children")) < 2
	 mtime = 0 ;
	 continue ;
      endif
      legend(phase, "box", "off") ;
      
      if plog set(gca, "yscale", "log", "yminorgrid", "on") ; endif

      pause(pse) ;
      
   endwhile

   if nargout > 0
      varargout{1} = h ;
   endif
   
endfunction
