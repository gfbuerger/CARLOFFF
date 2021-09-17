## usage: s = read_sim (d, svar, sim, lon, lat)
##
## read svar from simulations sim from directory d
function s = read_sim (d, svar, sim, lon, lat)

   global MON
   pkg load netcdf

   s.id = s.x = [] ;
   for ncf = glob(sprintf("%s/%s*%s*.nc", d, svar, sim))'

      printf("<-- %s\n", ncf = ncf{:}) ;

      rlon = ncread(ncf, "rlon") ;
      rlat = ncread(ncf, "rlat") ;
      xlon = ncread(ncf, "lon") ;
      xlat = ncread(ncf, "lat") ;
      t = ncread(ncf, "time") ;
      id = nctime(ncf) ;
      x = ncread(ncf, svar) ;
      
      [id x] = selmon(id, x, 3) ;

      y = ll2rot (x, xlon, xlat, lon, lat) ;

      s.id = cat(1, s.id, id) ;
      s.x = cat(1, s.x, y) ;
      s.name = svar ;

   endfor

endfunction
