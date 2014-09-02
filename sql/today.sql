
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
         having count(*) > 1 
       ) tmm
    where date('now') = date(t.startTimestamp, 'unixepoch', 'localtime')
   and t.startStationId = sa.id
   and t.endStationId = sb.id
   and t.startStationId = d.startStationId 
   and t.endStationId = d.endStationId 
   and t.startStationId = tmm.startStationId 
   and t.endStationId = tmm.endStationId 
 order by 3, 1, 2;
