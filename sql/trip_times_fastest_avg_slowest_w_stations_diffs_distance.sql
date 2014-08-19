-- label            label            count(*)    distance    FASTEST     diffFtoA    AVERAGE     diffStoA    SLOWEST     diffFtoS  
-- ---------------  ---------------  ----------  ----------  ----------  ----------  ----------  ----------  ----------  ----------
-- W 26 St & 8 Ave  9 Ave & W 18 St  3           0.9 mi      229         27          256         20          276         47        
-- W 29 St & 9 Ave  W 16 St & The H  3           0.9 mi      359         64          423         77          500         141       
-- W 41 St & 8 Ave  9 Ave & W 18 St  3           1.3 mi      318         34          352         25          377         59        
-- 8 Ave & W 31 St  9 Ave & W 18 St  8           0.8 mi      285         41          326         49          375         90        
-- W 29 St & 9 Ave  9 Ave & W 18 St  14          0.6 mi      207         79          286         153         439         232       
-- W 16 St & The H  W 29 St & 9 Ave  15          1.1 mi      267         216         483         624         1107        840       

select sa.label
     , sb.label
     , count(*)
     , d.distance
     , min(t.durationSeconds) FASTEST
     , cast(avg(t.durationSeconds) as int) -  min(t.durationSeconds) diffFtoA
     , cast(avg(t.durationSeconds) as int) AVERAGE
     , max(t.durationSeconds) - cast(avg(t.durationSeconds) as int) diffStoA
     , max(t.durationSeconds) SLOWEST 
     , max(t.durationSeconds) - min(t.durationSeconds) diffFtoS 
  from trips t
     , distance d
     , stations sa
     , stations sb
 where t.startStationId != t.endStationId 
   and t.startStationId = sa.id
   and t.endStationId = sb.id
   and t.startStationId = d.startStationId 
   and t.endStationId = d.endStationId 
 group by t.startStationId, t.endStationId 
having count(*) > 1 
 order by 3, 1, 2;