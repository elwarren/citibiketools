-- compare my recorded ride time to the 1e100 google racer estimate
-- 212|512|19:43:17|443|704|19:55:01|1.1 mi
-- 442|225|09:59:49|461|468|10:07:37|1.3 mi
select sa.label StationStart
     , sb.label StationEnd
     , date(startTimestamp, 'unixepoch', 'localtime') Date
     , time(startTimestamp, 'unixepoch', 'localtime') TimeStart
     , time(t.endTimestamp, 'unixepoch', 'localtime') TimeFinish
     , t.durationSeconds MyTime, d.durationSec RacerTime
     , d.durationSec - t.durationSeconds diff
     , d.distance
  from trips t, distance d, stations sa, stations sb
 where t.startStationId == d.startStationId
   and t.endStationId == d.endStationId
   and t.startStationId = sa.id
   and t.endStationId = sb.id
--   and date(t.startTimestamp, 'unixepoch', 'localtime') = date('now')
 order by t.id desc
 limit 3;