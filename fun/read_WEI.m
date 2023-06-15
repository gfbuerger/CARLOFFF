%% usage: s = read_WEI (fin)
%%
%% read (x)WEI
function s = read_WEI (fin)

   global isoctave MON REG PFX CNVDUR

   if isoctave(), pkg load io ; end

   dlon = 9 ; dlat = 8 ;
   Jx = [3 2 4 5] ;
   
   fid = fopen(fin, "rt") ;
   str = fgetl(fid) ;
   s.vars = strsplit(str, ",")(Jx) ;
   fclose(fid) ;
   
   D = real(dlmread(fin))(2:end,:) ;
   Icnv = (D(:,4) <= CNVDUR) ;
   D = D(Icnv,:) ;

   lon = D(:,dlon) ; lat = D(:,dlat) ;
   [LON LAT] = geo2ll(REG.geo) ;

   I = lookup(LON, lon) == 1 & lookup(LAT, lat) == 1 ;
   D = D(I,:) ;
   
   t1 = datenum(num2str(D(:,6), '%d'), 'yyyymmddHHMM') ;
   t2 = datenum(num2str(D(:,7), '%d'), 'yyyymmddHHMM') ;
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
   s.reg = PFX ;
   
endfunction
