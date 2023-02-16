## usage: pdd = regnie (rfile, Y0, Y1, R0)
##
## read DWD REGNIE
function pdd = regnie (rfile, Y0, Y1, R0)

   global REG MON

   nr = 971 ; nc = 611 ;
   xdelta = 1/60 ; ydelta = 1/120 ;
   lon =  6 - 10 * xdelta + (0:nc-1) * xdelta ;
   lat = 55 + 10 * ydelta - (0:nr-1) * ydelta ;
   [lon lat] = meshgrid(lon, lat) ;
   glon = [REG.geo{1}(1) REG.geo{2}(1)] ; glat = [REG.geo{1}(2) REG.geo{3}(4)] ;
   I = glon(1) <= lon & lon <= glon(2) & glat(2) <= lat & lat <= glat(1) ;
   
   mkdir(tt = tempname) ;
   mkdir("data/regnie") ;
   t0 = datenum(Y0,1,1) ; t1 = datenum(Y1,12,31) ; n = t1 - t0 + 1 ;
   id = datevec(t0:t1)(:,1:3) ;
   c = false(n, 1) ;

   i = 0 ; pdd.id = pdd.lon = pdd.lat = pdd.x = [] ;
   for y = Y0 : Y1

      if isnewer(ofile = sprintf("data/regnie/%s.%4d.ob", REG, y), "fun/regnie.m")

	 printf("<-- %s\n", ofile) ;
	 load(ofile) ;

      else
	 
	 tfile = sprintf("%s/ra%4dm.tar", rfile, y) ;
	 lfile = sprintf("%s/tarfile", tt) ;
	 while web("opendata.dwd.de")
	    pause(10) ;
	 endwhile
	 urlwrite(tfile, lfile)
	 gzfiles = unpack(lfile, tt, "tar") ;
	 delete(lfile) ;

	 x = [] ;
	 for gf = gzfiles'

	    if ~ismember(str2num(gf{:}(5:6)), MON) continue ; endif
	    
	    f = unpack(sprintf("%s/%s", tt, gf{:}), tt, "gz") ;
	    
	    printf("<-- %s\n", f{:}) ;
	    fid = fopen(f{:}, "rt") ;
	    s = textscan(fid, "%s", "Delimiter", "", "Whitespace", "") ;
	    fclose(fid) ;
	    s = cellfun(@(c) str2num(reshape(c, [], nc)')', s{:}(1:nr), "UniformOutput", false) ;
	    s = cell2mat(s) ;

	    s(s == -999) = NaN ;
	    s = s / 10 ;

	    if 0
	       imagesc(lon, lat, s)
	       set(gca, "ydir", "normal") ;
	       xlabel("Lon") ; ylabel("Lat") ;
	       colorbar ;
	    endif
	    
	    i++ ;
	    II = I & s > R0 ;
	    if any(II(:))
	       wid = repmat(id(i,:), sum(II(:)), 1) ;
	       x = [x ; wid lon(II) lat(II) s(II)] ;
	    endif
	    
	    delete(f{:}) ;

	 endfor
	 printf("--> %s\n", ofile) ;
	 save(ofile, "x", "i") ;

      endif
      
      pdd.id = [pdd.id ; x(:,1:3)] ;
      pdd.lon = [pdd.lon ; x(:,4)] ;
      pdd.lat = [pdd.lat ; x(:,5)] ;
      pdd.x = [pdd.x ; x(:,6)] ;

   endfor

endfunction
