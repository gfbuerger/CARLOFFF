## usage: y = arr2img (x, res = [])
##
## resize x to new resolution res
function y = arr2img (x, res = [])

   if isempty(res)
      y = x ;
      return ;
   endif

   pkg load image
   
   N = size(x) ;
   N1 = prod(N(1:end-2)) ;
   x = reshape(x, [N1 N(end-1) N(end)]) ;

   y = parfun(@(i) imresize(squeeze(x(i,:,:)), res)(:), 1:N1, "UniformOutput", false) ;

   y = cell2mat(y)' ;
   y = reshape(y, [N(1:end-2) res]) ; 
   
endfunction
