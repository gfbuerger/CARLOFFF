## usage: [iout, lout] = oversmpl (i, l, IMB)
##
## oversample i, l using IMB
function [iout, lout] = oversmpl (i, l, IMB)

   [iout lout] = deal(i, l) ;

   if isempty(IMB) || isequal(IMB, "NONE") || isequal(IMB, 0)
      return ;
   endif

   N = size(i) ;

   if size(l, 2) == 1
      I = c2l(l) ;
   else
      I = l > 0 ;
   endif

   if strcmp(IMB, "SMOTE") && 0 # knnsearch not installed
      printf("oversampling using SMOTE\n") ;
      if Lnan = (exist("knnsearch", "file") ~= 2), pkg load nan ; endif
      options.Class = l(:,end) ;
      k = max(ceil(rows(I)./sum(I))) ;
      [iout lout] = smote(i, [], k, options) ;
      iout = reshape(iout, [], num2cell(N){2:end}) ;
      if Lnan, pkg unload nan ; endif
      return ;
   endif

   if ~isnumeric(IMB)
      error("IMB incorrectly specified") ;
   endif

   ## minority class
   [~, j] = min(sum(I)) ;
   I = I(:,j) ;

   if (q = sum(I) / length(I)) >= IMB
      return
   endif

   printf("oversampling with: %.0f%% (< IMB = %.0f%%)\n", 100*q, 100*IMB) ;

   n = sum(~I) - sum(I) ;

   ## generate new samples
   fI = find(I) ;
   newI = fI(randi(length(fI), n, 1)) ;
   notI = find(~I) ;

   idx.type = "()" ;
   idx.subs = repmat({":"}, 1, ndims(iout)) ;
   idx.subs{1} = fI ;
   iout1 = subsref(iout, idx) ;
   idx.subs{1} = newI ;
   iout2 = subsref(iout, idx) ;
   idx.subs{1} = notI ;
   iout3 = subsref(iout, idx) ;
   iout = cat(1, iout1, iout2, iout3) ;

   ldx.type = "()" ;
   ldx.subs = repmat({":"}, 1, ndims(lout)) ;
   ldx.subs{1} = fI ;
   lout1 = subsref(lout, ldx) ;
   ldx.subs{1} = newI ;
   lout2 = subsref(lout, ldx) ;
   ldx.subs{1} = notI ;
   lout3 = subsref(lout, ldx) ;
   lout = cat(1, lout1, lout2, lout3) ;

   ## re-order index
   if 0
      N = size(iout) ;
      Ir = randperm(N(1)) ;
      idx.subs{1} = ldx.subs{1} = Ir ;
      iout = subref(iout, idx) ;
      lout = subref(lout, ldx) ;
   else
      N = size(iout) ;
      iout = reshape(iout, [N(1)/2 2 N(2:end)]) ;
      iout = permute(iout, [2 1 3:length(N)+1]) ;
      iout = reshape(iout, N) ;
      N = size(lout) ;
      lout = reshape(lout, [N(1)/2 2 N(2:end)]) ;
      lout = permute(lout, [2 1 3:length(N)+1]) ;
      lout = reshape(lout, N) ;
   endif

endfunction
