## usage: SVAR = trl_atm (tfile, jSIM, JVAR)
##
## translate atmospheric variables
function SVAR = trl_atm (tfile, jSIM, JVAR)

   fid = fopen(tfile, "rt") ;
   t = textscan(fid, "%s,%s", "Delimiter", ",") ;
   fclose(fid) ;

   SVAR = t{jSIM}'(JVAR) ;
   
endfunction
