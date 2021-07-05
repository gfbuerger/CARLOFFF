
cape.z = zscore(cape.x, [], 1) ;

i0 = find(all(cape.id(:,1:4) == [2014 7 28 0], 2)) ;
i1 = find(all(cape.id(:,1:4) == [2014 7 29 18], 2)) ;

clf ; ii = 0 ;
for i = i0 : i1

   ii++ ;
   ax(ii) = subplot(2, 4, ii) ;

   imagesc(cape.lon, cape.lat, squeeze(cape.z(i,:,:))') ;
   title(sprintf("%d-%d-%d:%d", cape.id(i,:))) ;
endfor
colormap(redblue)
set(ax, "ydir", "normal", "clim", [-3 3]) ;
set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
set(findall("type", "axes"), "fontsize", 18) ;
set(findall("type", "text"), "fontsize", 22) ;
hgsave(sprintf("nc/cape.2014-07.og")) ;
print(sprintf("nc/cape.2014-07.png")) ;

figure
imagesc(cape.lon, cape.lat, squeeze(nanmean(cape.z(i0:i0+3,:,:))') ;
colormap(redblue)
set(ax, "ydir", "normal", "clim", [-3 3]) ;
set(findall("-property", "fontname"), "fontname", "Linux Biolinum") ;
set(findall("type", "axes"), "fontsize", 18) ;
set(findall("type", "text"), "fontsize", 22) ;
