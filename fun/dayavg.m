function [idy, y] = dayavg(idx, x, mode, fun=@nanmean)

   ## usage:  [idy, y] = dayavg (idx, x, mode, fun=@nanmean)
   ## 
   ## calculate daily averages, mode=24 indicating 24h belongs to day

   global PAR

   if ~isfield(PAR, "rec") PAR.rec = 1 ; endif

   PAR.idx.type = "()" ;
   PAR.idx.subs = repmat({":"}, 1, columns(x)) ;
   
   pkg load statistics
   
   wrn = warning("query", "Octave:divide-by-zero").state ;
   warning("off", "Octave:divide-by-zero") ;

   if columns(idx) < 4
      idx(:,4) = zeros(rows(idx), 1) ;
   endif
   
   u = unique(idx(:,4)) ;

   if (nargin < 3 || mode == 0)
      h = min(u) ;
   else
      h = sort(u)(floor(length(u)/2)+1) ;
   endif

   if columns(idx) < 4
      [idy, y] = deal(idx, x) ;
      return
   endif

   N = size(x) ;
   Iy = repmat({":"}, 1, length(N)) ;
   
   if true || numel(u) < 20

      lb = find(idx(:,4) == h) ;
      ub = shift(find(idx(:,4) == h) - 1, -1) ; ub(end) = rows(idx) ;

      N(PAR.rec) = rows(lb) ;
      y = nan(N) ;
      for j=1:rows(lb)
	 Iy{PAR.rec} = j ;
	 idy(j,:) = idx(lb(j),:) ;
	 PAR.idx.subs{PAR.rec} = lb(j):ub(j) ;
	 y(Iy{:}) = feval(fun, subsref(x, PAR.idx), PAR.rec) ;
      endfor
      idy(:,4) = 12 ;

   else

      N(PAR.rec) = length(rdu) ;
      y = nan(N) ;
      rd = datenum(idx(:,1:3)) ;
      delta = diff(rdu = unique(rd)) ;
      for d = 1:length(rdu)
	 Iy{PAR.rec} = d ;
	 I = find(rd == rdu(d)) ;
	 PAR.idx.subs{PAR.rec} = I ;
	 idy(d,:) = idx(I(1),1:3) ;
	 y(Iy{:}) = feval(fun, subsref(x, PAR.idx), PAR.rec) ;
      endfor

   endif

   warning(wrn, "Octave:divide-by-zero") ;

endfunction
