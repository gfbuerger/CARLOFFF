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

   fI = find(I) ;
   prob = arrayfun(@(i) net.forward({Data(:,:,:,fI(i))}){1}(1:2), 1 : sum(I), "UniformOutput", false) ;
   
endfunction
