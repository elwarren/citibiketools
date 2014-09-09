-- compare my recorded ride time to the 1e100 google racer estimate
-- StationStart             StationEnd       Date        TimeStart   TimeFinish  MyTime      RacerTime   diff        distance
-- -----------------------  ---------------  ----------  ----------  ----------  ----------  ----------  ----------  ----------
-- W 16 St & The High Line  W 29 St & 9 Ave  2014-09-04  19:16:10    19:23:07    417         443         26          1.1 mi
-- 8 Ave & W 31 St          9 Ave & W 18 St  2014-09-04  10:27:42    10:32:57    315         318         3           0.8 mi
-- W 29 St & 9 Ave          9 Ave & W 18 St  2014-09-03  10:31:32    10:35:41    249         202         -47         0.6 mi.headers on
.mode columns
.headers on
select sa.label StationStart
     , sb.label StationEnd
     , date(startTimestamp, 'unixepoch', 'localtime') Date
     , time(startTimestamp, 'unixepoch', 'localtime') TimeStart
     , time(t.endTimestamp, 'unixepoch', 'localtime') TimeFinish
     , t.durationSeconds MyTime
     , d.durationSec RacerTime
     , d.durationSec - t.durationSeconds diff
     , d.distance
  from trips t left join distance d on t.startStationId = d.startStationId and t.endStationId = d.endStationId
               left join stations sa on t.startStationId = sa.id 
               left join stations sb on t.endStationId = sb.id
--  where date(t.startTimestamp, 'unixepoch', 'localtime') = date('now', 'localtime')
 order by t.id desc
 limit 3;