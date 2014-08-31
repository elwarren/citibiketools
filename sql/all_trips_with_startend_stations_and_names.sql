-- all trips with start and end station names
select t.id, sa.label, sb.label, t.startStationId, t.endStationId
     , datetime(startTimestamp, 'unixepoch', 'localtime')
     , datetime(endTimestamp, 'unixepoch', 'localtime') 
  from trips t, stations sa, stations sb 
 where t.startStationId = sa.id 
   and t.endStationId = sb.id 
 order by t.id;
