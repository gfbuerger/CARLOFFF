## usage: v = agg (u, nh, fun)
##
## aggregate u to time resolution nh hours
function v = agg (u, nh, fun=@nanmean)

   v = u ;

   if nh == 1 return ; endif

   N = size(u.x) ;

   if rem(N, nh) ~= 0
      error("length %d not divisible by %d\n", N, nh) ;
   endif
   
   v.id = reshape(v.id, nh, N(1)/nh, []) ;
   v.id = squeeze(v.id(1,:,1:4)) ;
   v.x = reshape(v.x, [nh N(1)/nh N(2:end)]) ;

   v.x = squeeze(feval(fun, v.x, 1)) ;
   v.x = reshape(v.x, [N(1)/nh N(2:end)]) ;
   
endfunction
