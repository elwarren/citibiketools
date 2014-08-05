-- top 3 trips with different start and end stations, including station names
select t.startStationId, sa.label, t.endStationId, sb.label, count(*)
  from trips t
     , stations sa
     , stations sb
 where t.startStationId != t.endStationId 
   and t.startStationId = sa.id
   and t.endStationId = sb.id
 group by t.startStationId, t.endStationId 
 order by 5 desc limit 3;