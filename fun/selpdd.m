## usage: pdd = selpdd (PDD, LON, LAT, ID, Q0, s)
##
## select predictands
function pdd = selpdd (PDD, LON, LAT, ID, Q0, s)

   global MON
   
   switch PDD
      case {"cape" "cp"}
	 pdd = ptr2pdd(s, LON, LAT, Q0) ;
      case "regnie"
	 R0 = 10 ; # from climate explorer
	 rfile = "https://opendata.dwd.de/climate_environment/CDC/grids_germany/daily/regnie" ;
	 pdd = regnie(rfile, 2001, 2020, R0) ;
	 x0 = quantile(pdd.x, Q0) ;
	 pdd.x(pdd.x <= x0,:) = NaN ;
      case "RR"
	 pdd = read_dwd("nc/StaedteDWD/klamex_with_coords.csv") ;
	 ##      pdd.x = pdd.x(:,3) ; # use RRmean
	 ##      pdd.x = pdd.x(:,5) ; # use Eta
	 ##      pdd.x = pdd.x(:,6) ; # use RRmax
      case "CatRaRE"
	 pdd = read_klamex("nc/StaedteDWD/CatRaRE_2001_2020_W3_Eta_v2021_01.csv") ;
	 ##      pdd.x = pdd.x(:,3) ; # use RRmean
	 ##      pdd.x = pdd.x(:,5) ; # use Eta
	 ##      pdd.x = pdd.x(:,6) ; # use RRmax
   endswitch

   pdd.name = PDD ;
   pdd = togrid(pdd, s.lon, s.lat) ;
   pdd = unifid(pdd, ID, MON) ;

   ## plot pdd statistics
   if 0
      for jVAR = JVAR
	 plot_pdd(pdd, jVAR) ;
      endfor
   endif
   pdd.x(isinf(pdd.x)) = 0 ;
   if 0
      plot_hrs(pdd) ;
   endif

endfunction
