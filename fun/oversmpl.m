## usage: [iout, lout] = oversmpl (i, l, IMB)
##
## oversample i, l using IMB
function [iout, lout] = oversmpl (i, l, IMB)

   if isempty(IMB) || strcmpi(IMB, "NONE")
      [iout lout] = deal(i, l) ;
      return ;
   endif
   
   N = size(i) ;
   
   lu = unique(l) ;
   I = l == lu' ;

   if strcmp(IMB, "SMOTE")
      if Lnan = (exist("knnsearch", "file") ~= 2), pkg load nan ; endif
      options.Class = l ;
      k = max(ceil(rows(I)./sum(I))) ;
      [iout lout] = smote(i, [], k, options) ;
      iout = reshape(iout, [], num2cell(N){2:end}) ;
      if Lnan, pkg unload nan ; endif
      return ;
   endif

   [~, j] = min(sum(I)) ;
   I = I(:,j) ;

   if (n = floor(sum(~I) / sum(I))) > 1
      printf("oversampling with: %s\n", IMB) ;
   endif

   fI = repmat(find(I), n, 1) ;
   fI = fI(randperm(length(fI))) ;
   fnI = find(~I) ;
   fnI = fnI(randperm(length(fnI))) ;

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
