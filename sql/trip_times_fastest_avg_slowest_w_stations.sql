-- startLabel       endLabel         trips       FASTEST     AVERAGE     SLOWEST
-- ---------------  ---------------  ----------  ----------  ----------  ----------
-- W 26 St & 8 Ave  9 Ave & W 18 St  3           229         256         276
-- W 29 St & 9 Ave  W 16 St & The H  3           359         423         500
-- W 41 St & 8 Ave  9 Ave & W 18 St  3           318         352         377
-- 8 Ave & W 31 St  9 Ave & W 18 St  14          279         321         375
-- W 29 St & 9 Ave  9 Ave & W 18 St  16          207         281         439
-- W 16 St & The H  W 29 St & 9 Ave  17          267         473         1107
.headers on
.mode column
select sa.label startLabel
     , sb.label endLabel
     , count(*) trips
     , min(t.durationSeconds) FASTEST
     , cast(avg(t.durationSeconds) as int) AVERAGE
     , max(t.durationSeconds) SLOWEST 
  from trips t left join distance d on t.startStationId = d.startStationId and t.endStationId = d.endStationId
               left join stations sa on t.startStationId = sa.id
               left join stations sb on t.endStationId = sb.id
 where t.startStationId != t.endStationId 
 group by t.startStationId
     , t.endStationId 
having count(*) > 1 
 order by 3, 1, 2;
