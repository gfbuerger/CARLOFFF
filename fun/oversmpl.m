## usage: [iout, lout] = oversmpl (i, l, IMB)
##
## oversample i, l using IMB
function [iout, lout] = oversmpl (i, l, IMB)

   [iout lout] = deal(i, l) ;

   if isempty(IMB) || strcmpi("IMB", "NONE")
      return ;
   endif

   printf("oversampling with: %s\n", IMB) ;
   
   N = size(i) ;

   if size(l, 2) == 1
      I = c2l(l) ;
   else
      I = l > 0 ;
   endif
   
   if strcmp(IMB, "SMOTE") && 0 # knnsearch not installed
      if Lnan = (exist("knnsearch", "file") ~= 2), pkg load nan ; endif
      options.Class = l(:,end) ;
      k = max(ceil(rows(I)./sum(I))) ;
      [iout lout] = smote(i, [], k, options) ;
      iout = reshape(iout, [], num2cell(N){2:end}) ;
      if Lnan, pkg unload nan ; endif
      return ;
   endif

   [~, j] = min(sum(I)) ;
   I = I(:,j) ;

   n = sum(~I) - sum(I) ;
   if n == 0 return ; endif

   ## create n new cases of I and append
   fI = randi(sum(I), n, 1) ;
   fI = [find(I) ; find(I)(fI)] ;

   fnI = find(~I) ;

   ## concatenate cases
   idx.type = "()" ; idx.subs = repmat({":"}, 1, ndims(i)) ;
   idx.subs{1} = fnI ; inI = subsref(i, idx) ;
   idx.subs{1} = fI ; iI = subsref(i, idx) ;
   iout = [inI ; iI] ;
   lout = [l(fnI,:) ; l(fI,:)] ;

   ## shuffle result
   iout = iout(randperm(size(iout, 1)),:) ;
   lout = lout(randperm(size(lout, 1)),:) ;
   
endfunction
