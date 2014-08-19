-- label            label            count(*)    FASTEST     diffFtoA    AVERAGE     diffStoA    SLOWEST     diffFtoS  
-- ---------------  ---------------  ----------  ----------  ----------  ----------  ----------  ----------  ----------
-- W 26 St & 8 Ave  9 Ave & W 18 St  3           229         27          256         20          276         47        
-- W 29 St & 9 Ave  W 16 St & The H  3           359         64          423         77          500         141       
-- W 41 St & 8 Ave  9 Ave & W 18 St  3           318         34          352         25          377         59        
-- 8 Ave & W 31 St  9 Ave & W 18 St  8           285         41          326         49          375         90        
-- W 29 St & 9 Ave  9 Ave & W 18 St  14          207         79          286         153         439         232       
-- W 16 St & The H  W 29 St & 9 Ave  15          267         216         483         624         1107        840       
-- startStationId int, endStationId int, distance text, distanceMeters int, duration text, durationSec int, startStationAddr text, endStationAddr text);

select sa.label
     , sb.label
     , count(*)
     , d.distance
     , min(durationSeconds) FASTEST
     , cast(avg(durationSeconds) as int) -  min(durationSeconds) diffFtoA
     , cast(avg(durationSeconds) as int) AVERAGE
     , max(durationSeconds) - cast(avg(durationSeconds) as int) diffStoA
     , max(durationSeconds) SLOWEST 
     , max(durationSeconds) - min(durationSeconds) diffFtoS 
  from trips t
     , distance d
     , stations sa
     , stations sb
 where startStationId != endStationId 
   and t.startStationId = sa.id
   and t.endStationId = sb.id
 group by startStationId, endStationId 
having count(*) > 1 
 order by 3, 1, 2;
