## usage: init_rnd (arg)
##
## init RNG
function init_rnd (arg)

   rfile = "rand_init.ot" ;
   
   if nargin > 0 ||  exist(rfile, "file") ~= 2
      rnd = rand ("state") ;
      save(rfile, "-text", "rnd") ;
   else
      load(rfile) ;
      rand ("state", rnd) ;
   endif

endfunction
