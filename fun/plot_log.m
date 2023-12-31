## usage: varargout = plot_log (h, lfile, loss = "loss", gap = 1, pse = 10, plog = 0)
##
##
function varargout = plot_log (h, lfile = "/tmp/caffe.INFO", loss = "loss", gap = 1, pse = 10, plog = 0)

   phase = {"Train" "Test"} ;
   
   mtime = 0 ;

   if exist(lfile, "file") ~= 2 error("no such file: %s\n", lfile) ; endif
   
   if isempty(h)
      clf ;
      h = gca ;
   endif
   set(h, "ygrid", "on", "NextPlot", "add", "ColorOrder", [0.3 0.3 0.7 ; 0.3 0.7 0.3]) ;
   
   while stat(lfile).mtime > mtime

      mtime = stat(lfile).mtime ;

      fid = fopen(lfile, "rt") ;
      sf = fscanf(fid, "%c") ;
      fclose(fid) ;
      s = strsplit(sf, "\n") ;
      [S, E, TE, M, T, NM, SP] = regexp(s, "I.* solver.cpp.*(Iteration|output #0|output #1)") ;
      I = cellfun(@(c) ~isempty(c), S) ;
      s = s(I) ;
      
      hp = [] ;
      phase = {"Train" "Test"} ; sh_phs = [1 -2] ;
      for jphs = 1 : length(phase)

	 phs = phase{jphs} ;

	 lpat = sprintf("%s net output #[0-9]+: %s = ", phs, loss) ;
	 [S, E, TE, M, T, NM, SP] = regexp(s, lpat) ;
	 I = cellfun(@(c) ~isempty(c), S) ;
	 x = cellfun(@(c) str2num(strsplit(c{2}, " "){1}), SP(I))' ;
	 [S, E, TE, M, T, NM, SP] = regexp(s(find(I)+sh_phs(jphs)), " [0-9]+") ;
	 Iter = cellfun(@(c) str2num(c{3}), M)' ;

	 if isempty(Iter) || isempty(x) || all(Iter .* x == 0, 1)
	    warning("no input\n") ;
	    varargout{1} = nan(1, 3) ;
	    return ;
	 endif
	 
	 n = min(numel(Iter), numel(x)) ;
	 if plog set(h, "yscale", "log") ; endif
	 II = gap <= Iter ;
	 c = 10^(ceil(log10(Iter(II)(end)))-1) ;
	 hp = [hp plot(1/c * Iter(II), x(II))] ;
	 xlabel(sprintf("iterations (x%d)", c)) ; ylabel(loss) ;
	 set(h, "ygrid", "on") ;
	 
      endfor
      if numel(get(h, "children")) < 2
	 mtime = 0 ;
	 continue ;
      endif
      hp = [hp legend(phase, "box", "off", "location", "southwest")] ;
      
      if plog set(h, "yscale", "log", "yminorgrid", "on") ; endif

      pause(pse) ;
      
   endwhile

   set(hp(1), "linewidth", 1) ; set(hp(2), "linewidth", 2) ;

   if nargout > 0
      varargout{1} = hp ;
   endif
   
endfunction
