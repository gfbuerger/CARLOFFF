## usage: [lon, lat] = geo2ll (geo)
##
##
function [lon, lat] = geo2ll (geo)

   lon = cell2mat(cellfun(@(r) r(1,:), geo, "UniformOutput", false))(:) ;
   lon = [min(lon) max(lon)] ;
   lat = cell2mat(cellfun(@(r) r(2,:), geo, "UniformOutput", false))(:) ;
   lat = [min(lat) max(lat)] ;

endfunction
