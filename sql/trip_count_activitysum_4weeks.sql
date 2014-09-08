-- Trips       TotalSecs   TotalMins 
-- ----------  ----------  ----------
-- 45          18414       306       
-- NOTE: date does not support '-4 weeks', seems it only works for days and months
.headers on
.mode columns
select count(*) Trips
     , sum(durationSeconds) TotalSecs
     , sum(durationSeconds)/60 TotalMins
  from trips 
 where abs(strftime('%Y%W', startTimestamp, 'unixepoch', 'localtime')) > abs(strftime('%Y%W', 'now', 'localtime')) - 4;
