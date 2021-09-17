## usage: [idy y] = selmon (id, x, rec=1)
##
## select specific months
function [idy y] = selmon (id, x, rec=1)

   global MON

   if isempty(MON) MON = 1:12 ; endif
   
   N = size(x) ;
   
   idx.type = "()" ;
   idx.subs = repmat({":"}, 1, length(N)) ;
   
   I = ismember(id(:,2), MON) ;

   idy = id(I,:) ;
   
   idx.subs{rec} = I ;
   y = subsref(x, idx) ;

endfunction
