%% usage: s = read_dwd (fin)
%%
%%
function s = read_dwd (fin)

   global isoctave LON LAT

   if isoctave(), pkg load io ; end

   jD = 5 ; ja = 7 ; jx = 10 ; je = 9 ; jd = 5 ;
   Jx = 5 : 11 ;
   
   MONS = 4:8 ;
   HRS = 11:21 ;

   D = dlmread(fin) ;
   D = D(2:end,:) ;

   if ~issorted(D(:,2))
      [t, Is] = unique(D(:,2), 'sorted') ;
      D = D(Is,:) ;
   endif

   lon = D(:,3) ; lat = D(:,4) ;
   I = lookup(LON, lon) == 1 & lookup(LAT, lat) == 1 ;
   D(I,Jx) = NaN ;
   
   t = D(:,2) ; d = D(:,jd) ;
   t = datenum(num2str(t, '%d'), 'yyyymmddHHMM') ;
   t = t - d ./ 48 ; # center of event

   id0 = datevec(t(1)) ; id0 = [id0(1) 1 1] ;
   id1 = datevec(t(end)) ; id1 = [id1(1) 12 31] ;
   tf = (datenum(id0):1/24:datenum(id1))' ;
   id = datevec(tf) ; id = id(:,1:4) ;
   x = nan(rows(id), 7) ;
   
   idx = lookup(tf, t) ;
   x(idx,:) = D(:,Jx) ;

   [idy y] = dayavg(id, x, 0, @(x) nanmax(x, [])) ;

   s.id = datevec(t)(:,1:5) ;
   s.lon = D(:,3) ; s.lat = D(:,4) ;
   
%%   I = ismember(idy(:,2), MONS) & ismember(idy(:,4), HRS) ;
   I = ismember(idy(:,2), MONS) ;

   s.id = idy(I,:) ;
   s.x = y(I) ;

   s.p0 = sum(s.x < 0) / rows(s.x) ;

endfunction
