-- BAM-028869-WL:CitiBike lindsey$ sqlite3 data/citibike.sqlite3 < citibiketools/sql/today.sql
-- Date        TimeBeg     TimeEnd     Secs        distance    IdBeg       IdEnd       StationBeg       StationEnd       FASTEST     AVERAGE     SLOWEST     Trips
-- ----------  ----------  ----------  ----------  ----------  ----------  ----------  ---------------  ---------------  ----------  ----------  ----------  ----------
-- 2014-09-04  10:27:42    10:32:57    315         0.8 mi      521         434         8 Ave & W 31 St  9 Ave & W 18 St  279         321         375         14
-- 2014-09-04  19:16:10    19:23:07    417         1.1 mi      212         512         W 16 St & The H  W 29 St & 9 Ave  267         473         1107        17
.headers on
.mode column
select date(t.startTimestamp, 'unixepoch', 'localtime') Date
     , time(t.startTimestamp, 'unixepoch', 'localtime') TimeBeg
     , time(t.endTimestamp, 'unixepoch', 'localtime') TimeEnd
     , t.durationSeconds Secs
     , d.distance
     , t.startStationId IdBeg
     , t.endStationId IdEnd
     , sa.label StationBeg
     , sb.label StationEnd
     , tmm.fastest
     , tmm.average
     , tmm.slowest
     , tmm.total Trips
  from trips t left join distance d on t.startStationId = d.startStationId and t.endStationId = d.endStationId
               left join stations sa on t.startStationId = sa.id 
               left join stations sb on t.endStationId = sb.id
     , ( select fas.startStationId, fas.endStationId
              , min(fas.durationSeconds) FASTEST
              , cast(avg(fas.durationSeconds) as int) AVERAGE
              , max(fas.durationSeconds) SLOWEST 
              , count(*) TOTAL
           from trips fas
          group by fas.startStationId, fas.endStationId 
       ) tmm
 where t.startStationId = tmm.startStationId 
   and t.endStationId = tmm.endStationId 
   and date(t.startTimestamp, 'unixepoch', 'localtime') = date('now', 'localtime')
 order by 1 asc, 2 asc;
