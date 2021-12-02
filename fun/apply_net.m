## usage: prob = apply_net (x, net, I=[])
##
## apply ptr to net for PHS
function prob = apply_net (x, net, I=[])

   Data = flipdim(x) ;
   N = size(Data) ;
   if length(N) < 3
      N = [1 1 N] ;
      Data = reshape(Data, N) ;
   endif
   
   if isempty(I) I = true(N(end), 1) ; endif

   prob = nan(sum(I), 2) ; ii = 0 ;
   for i = find(I)'
      data = Data(:,:,:,i) ;
      phat = net.forward({data}) ;
      prob(++ii,:) = phat{1}(1:2) ;
   endfor

endfunction
