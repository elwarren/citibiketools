-- Date        TimeBeg     TimeEnd     Secs        distance    IdBeg       IdEnd       StationBeg       StationEnd       FASTEST     AVERAGE     SLOWEST     Trips
-- ----------  ----------  ----------  ----------  ----------  ----------  ----------  ---------------  ---------------  ----------  ----------  ----------  ----------
-- 2014-09-04  10:27:42    10:32:57    315         0.8 mi      521         434         8 Ave & W 31 St  9 Ave & W 18 St  279         321         375         14
-- 2014-09-04  19:16:10    19:23:07    417         1.1 mi      212         512         W 16 St & The H  W 29 St & 9 Ave  267         473         1107        17
--
-- Example of an open trip
-- Date        TimeBeg     TimeEnd     Secs        distance    IdBeg       IdEnd       StationBeg       StationEnd       FASTEST     AVERAGE     SLOWEST     Trips
-- ----------  ----------  ----------  ----------  ----------  ----------  ----------  ---------------  ---------------  ----------  ----------  ----------  ----------
-- 2014-09-08  10:40:40    10:47:31    411         1.0 mi      379         434         W 31 St & 7 Ave  9 Ave & W 18 St  323         367         411         2
-- 2014-09-08  18:33:40                0                       212         Station Id  W 16 St & The H                   0           0           0           1
.headers on
.mode column
select date(t.startTimestamp, 'unixepoch', 'localtime') Date
     , time(t.startTimestamp, 'unixepoch', 'localtime') TimeBeg
     , time(t.endTimestamp, 'unixepoch', 'localtime') TimeEnd
     , t.durationSeconds Secs
     , d.distance
     , t.startStationId IdBeg
     , cast(t.endStationId as int) IdEnd
     , sa.label StationBeg
     , sb.label StationEnd
     , tmm.fastest
     , tmm.average
     , tmm.slowest
     , tmm.total Trips
  from trips t left join distance d on t.startStationId = d.startStationId and t.endStationId = d.endStationId
               left join stations sa on t.startStationId = sa.id 
               left join stations sb on t.endStationId = sb.id
               left join ( select fas.startStationId, fas.endStationId
                                , min(fas.durationSeconds) FASTEST
                                , cast(avg(fas.durationSeconds) as int) AVERAGE
                                , max(fas.durationSeconds) SLOWEST 
                                , count(*) TOTAL
                             from trips fas
                            group by fas.startStationId, fas.endStationId 
                         ) tmm on t.startStationId = tmm.startStationId and t.endStationId = tmm.endStationId 
 where date(t.startTimestamp, 'unixepoch', 'localtime') = date('now', 'localtime')
 order by 1 asc, 2 asc;
