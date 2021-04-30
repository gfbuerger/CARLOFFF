function res = sdate (id, varargin)

   %% select years from an index series
   %%
   %% usage:  res = sdate(id, varargin)

   id0 = varargin{1} ;
   if (nargin == 3)
      id1 = varargin{1} ;
      id2 = varargin{2} ;
   elseif (size(id0, 1) > 1)
      id1 = id0(1,:) ; id2 = id0(2,:) ;
   else
      id1 = id0 ;
      id2 = id0 ;
   end 

   if (size(id, 2) == 1)
      id = [id ones(rows(id), 2)] ;
   end
   if (size(id, 2) == 2)
      id = [id 15*ones(rows(id), 1)] ;
   end

   if (size(id1, 2) == 1)
      id1 = [id1 1 1 0 0 0] ;
   elseif (size(id1, 2) == 2)
      id1 = [id1 1 0 0 0] ;
   elseif (size(id1, 2) == 3)
      id1 = [id1 0 0 0] ;
   end

   if (size(id2, 2) == 1)
      id2 = [id2 12 31 23 59 59] ;
   elseif (size(id2, 2) == 2)
      id2 = [id2 31 23 59 59] ;
   elseif (size(id2, 2) == 3)
      id2 = [id2 23 59 59] ;
   end

   if (isempty(id) || any(isnan([id1(:); id2(:)])))
      res = all(id, 2) ;
   else
      if datenum(id1(1:3)) < datenum(id(1,1:3))
	 cid = num2cell(id(1,1:3)) ;
	 cid1 = num2cell(id1) ;
	 warning('xds:xds', 'incompatible dates: [%04d %02d %02d] < [%04d %02d %02d]\n', cid1{1:3}, cid{:}) ;
      end
      if datenum(id(end,1:3)) < datenum(id2(1:3))	 
	 cid = num2cell(id(end,1:3)) ;
	 cid2 = num2cell(id2) ;
	 warning('xds:xds', 'incompatible dates: [%04d %02d %02d] < [%04d %02d %02d]\n', cid{:}, cid2{1:3})
      end
      res = date_cmp(id1, id) & date_cmp(id, id2) ;
   end

end
