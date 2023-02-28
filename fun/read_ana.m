## usage: retval = read_ana (geo, NH, svar=[])
##
## read ERA5 data
function retval = read_ana (geo, NH, svar=[])

   pkg load netcdf

   [LON LAT] = geo2ll(geo) ;

   F = glob("data/ind/*.nc")' ;
   lon = ncread(F{1}, "longitude") ;
   lat = ncread(F{1}, "latitude") ;
   if (Llat = lat(1) > lat(end)) lat = flip(lat) ; endif
   JLON = LON(1) <= lon & lon <= LON(2) ;
   JLAT = LAT(1) <= lat & lat <= LAT(2) ;

   for j = 1 : length(F)

      nc = ncinfo(F{j}) ;
      k = find(cellfun(@(c) length(c), {nc.Variables.Size}) > 1) ;
      VAR(j) = v = {nc.Variables.Name}(k) ;
      if ~isempty(svar) && ~strcmp(v, svar) continue ; endif
      LVAR{j} = nc.Variables(k).Attributes(6).Value ;
      x = squeeze(ncread(F{j}, v{:})) ;
      if strcmp(VAR{j}, "cin")
	 x(isnan(x(:))) = 1000 ;
      endif
      x = permute(x, [3 1 2]) ; # all data are N x W x H
      if Llat x = flip(x, 3) ; endif
      id = nctime(F{j}) ;
      [id x] = selmon(id, x) ;
      eval(sprintf("retval.%s.nc = ncinfo(F{j}) ;", v{:})) ;
      eval(sprintf("retval.%s.id = id ;", v{:})) ;
      eval(sprintf("retval.%s.x = x(:,JLON,JLAT) ;", v{:})) ;
      eval(sprintf("retval.%s.lon = lon(JLON) ;", v{:})) ;
      eval(sprintf("retval.%s.lat = lat(JLAT) ;", v{:})) ;
      eval(sprintf("retval.%s.name = VAR{j} ;", v{:})) ;

      ## aggregate
      eval(sprintf("retval.%s = agg(retval.%s, NH) ;", v{:}, v{:})) ;

   endfor

   if ~isempty(svar) && ~strcmp(v, svar)
      eval(sprintf("retval = retval.%s ;", svar)) ;
   endif

endfunction
