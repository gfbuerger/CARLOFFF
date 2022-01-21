%% usage: s = read_klamex (fin)
%%
%%
function s = read_klamex (fin)

   global isoctave LON LAT MON REG

   if isoctave(), pkg load io ; end

   dlon = 62 ; dlat = 63 ;
   Jx = 23 : 29 ;
   
   MONS = 5:8 ;
   HRS = 12:23 ;

   fid = fopen(fin, "rt") ;
   str = fgetl(fid) ;
   s.vars = strsplit(str, ",")(Jx) ;
   fclose(fid) ;
   
   D = dlmread(fin) ;
   D = D(2:end,:) ;

   lon = D(:,dlon) ; lat = D(:,dlat) ;
   I = lookup(LON, lon) == 1 & lookup(LAT, lat) == 1 ;
   D = D(I,:) ;
   
   t1 = datenum(num2str(D(:,5), '%d'), 'yyyymmddHHMM') ;
   t2 = datenum(num2str(D(:,6), '%d'), 'yyyymmddHHMM') ;
   d = t2 - t1 ; t = (t1 + t2) / 2 ;

   if ~issorted(t)
      [~, Is] = sort(t) ;
      D = D(Is,:) ;
   endif

   id = datevec(t) ;
   II = ismember(id(:,2), MON) ;

   s.id = id(II,1:4) ;
   s.x = D(II,Jx) ;
   s.lon = D(II,dlon) ; s.lat = D(II,dlat) ;
   s.reg = REG ;
   
endfunction
