-- all trips with start and end station names
.headers on
.mode column
select t.id
     , sa.label startStation, sb.label endStation
     , t.startStationId startId, t.endStationId endId
     , date(startTimestamp, 'unixepoch', 'localtime') Date
     , time(startTimestamp, 'unixepoch', 'localtime') startTime
     , time(endTimestamp, 'unixepoch', 'localtime') endTime
  from trips t, stations sa, stations sb 
 where t.startStationId = sa.id 
   and t.endStationId = sb.id 
 order by t.id;