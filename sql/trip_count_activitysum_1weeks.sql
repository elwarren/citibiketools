-- Trips       TotalSecs   TotalMins 
-- ----------  ----------  ----------
-- 2           1358        22        
-- NOTE: date does not support '-4 weeks', seems it only works for days and months
.headers on
.mode columns
select count(*) Trips
     , sum(durationSeconds) TotalSecs
     , sum(durationSeconds)/60 TotalMins
     , sum(durationSeconds)/60/60 TotalHours
  from trips 
 where abs(strftime('%Y%W', startTimestamp, 'unixepoch', 'localtime')) > abs(strftime('%Y%W', 'now', 'localtime')) - 1;
