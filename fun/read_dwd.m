%% usage: s = read_dwd (fin)
%%
%%
function s = read_dwd (fin)

   global isoctave

   if isoctave(), pkg load io ; end

   LATS = [] ;
   MONS = 4:8 ;
   HRS = 11:21 ;

   [NUMARR, TXTARR, RAWARR] = xlsread (fin) ;

   dt = parfun(@(a) datestr(datenum(num2str(a), 'yyyymmddHHMM')), NUMARR(:,5), 'UniformOutput', false) ;
   id = datevec(char(dt)) ; id(:,5) = 0 ; t = datenum(id) ;
   [t, Is] = unique(t, 'sorted') ;
   dt = dt(Is) ; NUMARR = NUMARR(Is,:) ;

   tf = (floor(t(1)):1/24:ceil(t(end)))' ;

   [~, I, If] = intersect(t, tf) ;

   id = datevec(tf) ; id = id(:,1:4) ;
   x = zeros(length(tf), 1) ;
   x(If) = NUMARR(:,10) ;

   [idy y] = dayavg(id, x, 0, @(x) nanmax(x, [])) ;
   
%%   I = ismember(idy(:,2), MONS) & ismember(idy(:,4), HRS) ;
   I = ismember(idy(:,2), MONS) ;

   s.id = idy(I,:) ;
   s.x = y(I) ;

   return ;
   
%%   idy = cellfun(@(a) strptime(a, '%d-%b-%Y %T').mon, dt, 'UniformOutput', ~false) ;
%%   idh = cellfun(@(a) strptime(a, '%d-%b-%Y %T').hour, dt, 'UniformOutput', ~false) ;
%%   idm = cellfun(@(a) strptime(a, '%d-%b-%Y %T').min, dt, 'UniformOutput', ~false) ;

%%   hist(idy, 1:12)
%%   [hn hx] = hist(idh, 1:24) ; hn(24) = hn(1) = hn(1)/2 ;
%%   bar(hx, hn) ;
%%   hist(idm)

endfunction
