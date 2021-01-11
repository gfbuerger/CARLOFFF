function [y, m, d, hh, mm, ss] = cal2date (j, cal)

   ## usage:  [y, m, d, hh, mm, ss] = cal2date (j, cal)
   ##
   ## calculate date sequence from d using calendar cal

   j = j(:) ;

   if (nargin < 2), cal = "gregorian" ; endif 

   if (strfind(cal, "gregorian") || strcmp(cal, "standard") || strcmp(cal, "days")) # FIXME: "days" should not be here
      [y m d hh mm ss] = datevec(j) ;
      return ;
   endif

   if strcmp(cal, "360_day") || strfind(cal, "360") # some calendars are inaccurate
      per = 360 ;
      mon = repmat(30, 1, 12) ;
   else
      per = 365 ;
      mon = [31 28 31 30 31 30 31 31 30 31 30 31] ;
   endif
   cmon = cumsum([0 mon(1:11)]) ;

   y = floor(j / per) + 1 ;
   y(y <= 0) = y(y <= 0) - 1 ;
   d = mod(j, per) + 1 ;
   m = sum(repmat(cmon, rows(j), 1) < repmat(floor(d), 1, 12), 2) ;
   hh = d - cmon(m)' ;
   d = floor(hh) ;
   hh = (hh - d) * 24 ;

   ## from datevec
   fracd = j - floor (j);
   tmps = abs (eps*86400*j);
   tmps(tmps == 0) = 1;
   srnd = 2 .^ floor (- log2 (tmps));
   ss = round (86400 * fracd .* srnd) ./ srnd;
   hh = floor (ss / 3600);
   ss = ss - 3600 * hh;
   mm = floor (ss / 60);
   ss = ss - 60 * mm;

endfunction
