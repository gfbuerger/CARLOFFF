function res = date2cal (id, cal)

   ## usage:  res = date2cal (id, cal)
   ##
   ## calculate days since date, using calendar cal

   [nr nc] = size(id) ;

   idc = cell(1, nc) ;
   [idc] = deal(mat2cell(id, nr, ones(nc,1))) ;
   [y m d] = deal(idc{1:3}) ; 

   if nc > 3
      hh = idc{4} ;
      if nc > 4
	 mm = idc{5} ;
	 if nc > 5
	    ss = idc{6} ;
	 else
	    ss = 0(ones(rows(id), 1)) ;
	 endif
      else
	 mm = 0(ones(rows(id), 1)) ;
	 ss = 0(ones(rows(id), 1)) ;
      endif
   else
      hh = 0(ones(rows(id), 1)) ;
      mm = 0(ones(rows(id), 1)) ;
      ss = 0(ones(rows(id), 1)) ;
   endif

   if (nargin < 2), cal = "gregorian" ; endif 

   if (strcmpi(cal, "gregorian") || strcmpi(cal, "standard") || strcmpi(cal, "days")) # FIXME: "days" should not be here
      res = datenum(y, m, d, hh, mm, ss) ;
      return ;
   endif 

   if strcmp(cal, "360_day") || strfind(cal, "360")
      per = 360 ;
      mon = repmat(30, 1, 12) ;
   else
      per = 365 ;
      mon = [31 28 31 30 31 30 31 31 30 31 30 31] ;
   endif 
   cmon = cumsum([0 mon(1:11)]) ;

   y(y == -1) = 0 ;
   res = (y-1) * per + cmon(m)' + d - 1 + hh/24 ;

endfunction
