## usage: SVAR = trl_atm (tfile, JVAR)
##
## translate atmospheric variables
function SVAR = trl_atm (tfile, JVAR)

   fid = fopen(tfile, "rt") ;
   t = textscan(fid, "%s,%s", "Delimiter", ",") ;
   fclose(fid) ;

   SVAR = t{2}'(JVAR) ;
   
endfunction
