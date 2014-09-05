--       Date = 2014-09-04
--    TimeBeg = 10:27:42
--    TimeEnd = 10:32:57
--       Secs = 315
--   distance = 0.8 mi
--      IdBeg = 521
--      IdEnd = 434
-- StationBeg = 8 Ave & W 31 St
-- StationEnd = 9 Ave & W 18 St
--    FASTEST = 279
--    AVERAGE = 321
--    SLOWEST = 375
--      Trips = 14

--       Date = 2014-09-04
--    TimeBeg = 19:16:10
--    TimeEnd = 19:23:07
--       Secs = 417
--   distance = 1.1 mi
--      IdBeg = 212
--      IdEnd = 512
-- StationBeg = W 16 St & The High Line
-- StationEnd = W 29 St & 9 Ave
--    FASTEST = 267
--    AVERAGE = 473
--    SLOWEST = 1107
--      Trips = 17

.headers on
.mode line
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
  from trips t
     , distance d
     , stations sa
     , stations sb
     , ( select fas.startStationId, fas.endStationId
              , min(fas.durationSeconds) FASTEST
              , cast(avg(fas.durationSeconds) as int) AVERAGE
              , max(fas.durationSeconds) SLOWEST 
              , count(*) TOTAL
             from trips fas
          group by fas.startStationId, fas.endStationId 
       ) tmm
 where t.startStationId = sa.id
   and t.endStationId = sb.id
   and t.startStationId = d.startStationId 
   and t.endStationId = d.endStationId 
   and t.startStationId = tmm.startStationId 
   and t.endStationId = tmm.endStationId 
   and date(t.startTimestamp, 'unixepoch', 'localtime') == date('now', 'localtime')
 order by 1, 2, 3;
