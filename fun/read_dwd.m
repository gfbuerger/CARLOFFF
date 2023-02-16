%% usage: s = read_dwd (fin)
%%
%%
function s = read_dwd (fin)

   global isoctave GLON GLAT MON

   if isoctave(), pkg load io ; end

   jD = 5 ; ja = 7 ; jx = 10 ; je = 9 ; jd = 5 ;
   Jx = 5 : 11 ;
   
   MONS = 5:8 ;
   HRS = 12:23 ;

   fid = fopen(fin, "rt") ;
   lbl = fgetl(fid) ;
   fclose(fid) ;
   lbl = strsplit(lbl, ";") ;
   
   D = dlmread(fin) ;
   D = D(2:end,:) ;

   lon = D(:,3) ; lat = D(:,4) ;
   I = lookup(GLON, lon) == 1 & lookup(GLAT, lat) == 1 ;
   D = D(I,:) ;
   
   t = D(:,2) ; d = D(:,jd) ;
   t = datenum(num2str(t, '%d'), 'yyyymmddHHMM') ;
   t = t - (d ./ 24) / 2 ; # center of event

   if ~issorted(t)
      if strcmp(version()(1), "5")
	 [t, Is] = unique(t) ;
      else
	 [t, Is] = unique(t, 'sorted') ;
      endif
      D = D(Is,:) ;
   endif

   id = datevec(t) ;
   II = ismember(id(:,2), MON) ;

   s.id = id(II,1:4) ;
   s.x = D(II,Jx) ;
   s.lon = D(II,3) ; s.lat = D(II,4) ;
   s.vars = lbl(Jx) ;
   
   return ;
   
   id0 = datevec(t(1)) ; id0 = [id0(1) 1 1 0] ;
   id1 = datevec(t(end)) ; id1 = [id1(1) 12 31 23 59 59] ;
   tf = (datenum(id0):1/24:datenum(id1))' ;
   id = datevec(tf) ; id = id(:,1:4) ;
   x = nan(rows(id), 7) ;
   
   idx = lookup(tf, t) ;
   x(idx,:) = D(:,Jx) ;

##   [idy y] = dayavg(id, x, 0, @(x) nanmax(x, [])) ;
   x = reshape(x, 24, [], columns(x)) ;
   x = squeeze(nanmean(x, 1)) ;
   id = id(ismember(id(:,4), [0 6 12 18]),:) ;
   [idy y] = deal(id, x) ;

   s.lon = D(:,3) ; s.lat = D(:,4) ;
   
%%   I = ismember(idy(:,2), MONS) & ismember(idy(:,4), HRS) ;
   I = ismember(idy(:,2), MONS) ;

   s.id = idy(I,1:4) ;
   s.x = y(I,:) ;

   s.p0 = sum(s.x < 0) ./ rows(s.x) ;

endfunction
