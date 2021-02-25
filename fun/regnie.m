## usage: pdd = regnie (rfile)
##
## read DWD REGNIE
function pdd = regnie (rfile)

   global LON LAT REG
   xth = 20 ;

   nr = 971 ; nc = 611 ;
   xdelta = 1/60 ; ydelta = 1/120 ;
   lon =  6 - 10 * xdelta + (0:nc-1) * xdelta ;
   lat = 55 + 10 * ydelta - (0:nr-1) * ydelta ;
   Ilon = LON(1) <= lon & lon <= LON(2) ;
   Ilat = LAT(1) <= lat & lat <= LAT(2) ;
   lon = lon(Ilon) ; lat = lat(Ilat) ;

   ##[lon, lat] = meshgrid(lon, lat) ;
   ##I = LON(1) <= lon & lon <= LON(2) & LAT(1) <= lat & lat <= LAT(2) ;

   mkdir(tt = tempname) ;
   mkdir("data/regnie") ;
   t0 = datenum(2001,1,1) ; t1 = datenum(2019,12,31) ; n = t1 - t0 + 1 ;
   id = datevec(t0:t1)(:,1:3) ;
   c = false(n, 1) ;

   hw = waitbar(0) ;
   i = 0 ;
   for y = 2001 : 2019

      if exist(ofile = sprintf("data/regnie/%s.%4d.ob", REG, y), "file") == 2
	 load(ofile) ; continue ;
      endif

      tfile = sprintf("%s/ra%4dm.tar", rfile, y) ;
      lfile = sprintf("%s/tarfile", tt) ;
      while web("opendata.dwd.dd")
	 pause(10) ;
      endwhile
      urlwrite(tfile, lfile)
      gzfiles = unpack(lfile, tt, "tar") ;
      delete(lfile) ;

      for gf = gzfiles'

	 f = unpack(sprintf("%s/%s", tt, gf{:}), tt, "gz") ;
	 
	 fid = fopen(f{:}, "rt") ;
	 s = textscan(fid, "%s", "Delimiter", "", "Whitespace", "") ;
	 fclose(fid) ;
	 s = cellfun(@(c) str2num(reshape(c, [], nc)')', s{:}(1:end-1), "UniformOutput", false) ;
	 s = cell2mat(s) ;

	 s = s(Ilat,Ilon) ;
	 s(s == -999) = NaN ;
	 s = s / 10 ;

	 if 0
	    imagesc(lon, lat, s)
	    set(gca, "ydir", "normal") ;
	    xlabel("Lon") ; ylabel("Lat") ;
	    colorbar ;
	 endif
	 
	 i++ ;
	 x(i) = max(s(:)) ;

	 delete(f{:}) ;
	 waitbar(i/n, hw) ;
	 printf("--> %s\n", f{:}) ;

      endfor

      printf("--> %s\n", ofile) ;
      save(ofile, "x", "i") ;

   endfor

   II = ismember(id(:,2), 4:8) ;

   pdd.id = id(II,:) ;
   pdd.x = x(II)' ;

endfunction
