-- just day of week based on morning trips
select strftime('%w', startTimestamp, 'unixepoch', 'localtime') dayofweek
     , count(*) trips
  from trips 
 where cast(strftime('%H', startTimestamp, 'unixepoch', 'localtime') as integer) between 6 and 12 
 group by 1 
 order by 1;