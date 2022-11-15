## usage: v = agg (u, nh, fun=@nanmean)
##
## aggregate u to time resolution nh hours
function v = agg (u, nh, fun=@nanmean)

   v = u ;

   nd = length(unique(u.id(:,4))) ;
   nq = nh * nd / 24 ;

   if nq == 1 return ; endif

   N = size(u.x) ;

   if rem(N(1), nq) ~= 0
      error("length %d not divisible by %d\n", N, nq) ;
   endif
   
   v.id = reshape(v.id, nq, N(1)/nq, []) ;
   v.id = squeeze(v.id(1,:,1:4)) ;
   v.x = reshape(v.x, [nq N(1)/nq N(2:end)]) ;

   v.x = squeeze(feval(fun, v.x, [], 1)) ;
   v.x = reshape(v.x, [N(1)/nq N(2:end)]) ;
   
endfunction
