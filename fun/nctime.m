## usage: id = nctime (ncf, wcal)
##
## convert netcdf date to id
function id = nctime (ncf, wcal = "Gregorian")

   ntime = double(ncread(ncf, "time")) ;
	 
   j = find(strcmp({ncinfo(ncf).Variables.Name}, "time")) ;
   k = find(strcmp({ncinfo(ncf).Variables(j).Attributes.Name}, "units")) ;
   v = ncinfo(ncf).Variables(j).Attributes(k).Value ;

   [~, ~, ~, dstr] = regexpi(v, "\(day\|hour\)s* since .*") ;
   dstr = dstr{:} ;
   if isempty(dstr)
      error("xds:xds", "nctime: could not determine time coordinate") ;
   endif

   wstr = strsplit(dstr, " ", STRIP_EMPTY=true) ;
   if strncmpi(wstr(1){:}, "hour", 4)
      if ntime(1) == 1 # UGLY, to avoid 'orphan' hours at end of month
	 ntime = ntime - 1 ;
      endif
      wq = 24 ;
   else
      wq = 1 ;
   endif

   clear id
   if strcmp(wstr(2){:}, "since")
      d0 = [sscanf(wstr(3){:}, "%d-%d-%d"); 0]' ;
      if isempty(strfind(wstr(3){:}, "T"))
	 d0 = [sscanf(wstr(3){:}, "%d-%d-%d"); 0]' ;
      else
	 d0 = sscanf(wstr(3){:}, "%d-%d-%dT%d")' ;
      endif
      if (strcmp(wcal, "gregorian") || strcmp(wcal, "standard")) && date_cmp(d0(1:3), [1582 10 14])
	 jd = ntime/wq - 2 ;
      else
	 jd = ntime/wq ;
      endif
      j0 = date2cal(d0, wcal) ;
      [id(:,1), id(:,2), id(:,3), id(:,4)] = cal2date(j0 + jd, wcal) ;
##      fix for 2-dim time
      N = size(jd) ;
      [id(:,1), id(:,2), id(:,3), id(:,4)] = cal2date(j0 + jd(:), wcal) ;
      id = squeeze(reshape(id, [N 4])) ;
   else
      id = dat(ntime) ;
      id = id(:,1:4) ;		# we do use hours
   endif
   
endfunction
