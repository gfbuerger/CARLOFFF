## usage: [iout, lout] = oversmpl (i, l, IMB)
##
## oversample i, l using IMB
function [iout, lout] = oversmpl (i, l, IMB)

   printf("oversampling with: %s\n", IMB) ;

   if isempty(IMB)
      [iout lout] = deal(i, l) ;
      return ;
   endif
   
   N = size(i) ;
   
   lu = unique(l) ;
   I = l == lu' ;

   if strcmp(IMB, "SMOTE")
      if Lnan = (exist("knnsearch", "file") ~= 2), pkg load nan ; endif
      options.Class = l ;
      ii = reshape(i, N(1), []) ;
      [iout lout] = smote(ii, rows(I)./sum(I), 5, options) ;
      iout = reshape(iout, [], num2cell(N){2:end}) ;
      if Lnan, pkg unload nan ; endif
      return ;
   endif

   [~, j] = min(sum(I)) ;
   I = I(:,j) ;

   n = floor(sum(~I) / sum(I)) ;
   fI = repmat(find(I), n, 1) ;
   fnI = find(~I) ;

   fnI = fnI(randperm(length(fnI))) ;
   fI = fI(randperm(length(fI))) ;

   lout = [l(fnI) ; l(fI)] ;
   iout = [i(fnI,:,:,:) ; i(fI,:,:,:)] ;

   k = floor(length(lout) / 2) ;
   
   lout = reshape(lout(1:2*k), k, 2) ;
   iout = reshape(iout(1:2*k,:,:,:), [k 2 N(2:end)]) ;

   lout = permute(lout, [2 1]) ;
   iout = permute(iout, [2 1 3 4 5]) ;

   lout = reshape(lout, 2*k, 1) ;
   iout = reshape(iout, [2*k, N(2:end)]) ;
   
endfunction
