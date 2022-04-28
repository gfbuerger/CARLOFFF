## usage: varargout = plot_log (h, lfile, loss = "loss", iter0 = 0, pse = 10, plog = 0)
##
##
function varargout = plot_log (h, lfile, loss = "loss", iter0 = 0, pse = 10, plog = 0)

   global COL

   phase = {"Train" "Test"} ;
   
   mtime = 0 ;
   if isempty(h)
      clf ;
      h = gca ;
   endif
   set(h, "ygrid", "on", "NextPlot", "add", "colororder", COL) ;
   
   while stat(lfile).mtime > mtime

      mtime = stat(lfile).mtime ;

      fid = fopen(lfile, "rt") ;
      sf = fscanf(fid, "%c") ;
      fclose(fid) ;
      s = strsplit(sf, "\n") ;
      [S, E, TE, M, T, NM, SP] = regexp(s, " solver.cpp") ;
      I = cellfun(@(c) ~isempty(c), S) ;
      s = s(I) ;
      
      hp = [] ;
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
	 if strcmp(phs, "Train")
	    Iter = Iter(1:end-1) ;
	 endif
	 
	 lpat = sprintf("%s net output #[0-9]+: %s = ", phs, loss) ;
	 [S, E, TE, M, T, NM, SP] = regexp(s, lpat) ;
	 I = cellfun(@(c) ~isempty(c), S) ;
	 x = cellfun(@(c) str2num(strsplit(c{2}, " "){1}), SP(I))' ;

	 n = min(numel(Iter), numel(x)) ;
	 if plog set(h, "yscale", "log") ; endif
	 hp = [hp plot(iter0 + Iter, x, "linestyle", "-", "linewidth", 1)] ;
	 xlabel("iterations") ; ylabel(loss) ;
	 set(h, "ygrid", "on") ;
	 
      endfor
      if numel(get(h, "children")) < 2
	 mtime = 0 ;
	 continue ;
      endif
      legend(phase, "box", "off", "location", "northeast") ;
      
      if plog set(h, "yscale", "log", "yminorgrid", "on") ; endif

      pause(pse) ;
      
   endwhile

   set(hp(1), "linewidth", 1) ; set(hp(2), "linewidth", 3) ;

   if nargout > 0
      varargout{1} = hp ;
   endif
   
endfunction
