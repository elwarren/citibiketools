-- count trips by day of week
select strftime('%w', startTimestamp, 'unixepoch', 'localtime') dayofweek
     , count(*) trips
  from trips 
 group by 1 
 order by 1;