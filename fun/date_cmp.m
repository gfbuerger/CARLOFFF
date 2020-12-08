function res = date_cmp (id1, id2)

   %% usage:  res = date_cmp (id1, id2)
   %%
   %% compare two dates ('res = id1 <= id2')

   res = (datenum(id1(:,1:3)) <= datenum(id2(:,1:3))) ;

end
