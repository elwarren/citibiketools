-- count trips by day of month
-- 01|4
-- 31|2
select strftime('%d', startTimestamp, 'unixepoch', 'localtime') dayofmonth
     , count(*) trips
  from trips
 group by 1 
 order by 1;
