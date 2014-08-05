-- compare my recorded ride time to the 1e100 google racer estimate
select t.startStationId, t.endStationId, time(startTimestamp, 'unixepoch', 'localtime'), d.durationSec, t.durationSeconds, time(t.endTimestamp, 'unixepoch', 'localtime'), d.distance
  from trips t, distance d
 where t.startStationId == d.startStationId
   and t.endStationId == d.endStationId
   and date(t.startTimestamp, 'unixepoch', 'localtime') == '2014-08-04'
 order by t.startTimestamp desc;
-- 212|512|19:43:17|443|704|19:55:01|1.1 mi
-- 442|225|09:59:49|461|468|10:07:37|1.3 mi
