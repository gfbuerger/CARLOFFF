## usage: val = table_pick (file, key)
##
## pick val = key from table file
function val = table_pick (file, key)

   fid = fopen(file, "rt") ;
   C = textscan(fid, "%s: %s\n", "commentstyle", "#", "Delimiter", " :") ;
   fclose(fid) ;

   k = find(strcmp(C{1}, key)) ;
   val = C{2}{k} ;
   
endfunction
