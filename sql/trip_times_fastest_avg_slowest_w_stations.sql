-- startStationId  endStationId  label                    label            count(*)    FASTEST     AVERAGE     SLOWEST   
-- --------------  ------------  -----------------------  ---------------  ----------  ----------  ----------  ----------
-- 212             512           W 16 St & The High Line  W 29 St & 9 Ave  15          267         483         1107      
-- 477             434           W 41 St & 8 Ave          9 Ave & W 18 St  3           318         352         377       
-- 494             434           W 26 St & 8 Ave          9 Ave & W 18 St  3           229         256         276       
-- 512             212           W 29 St & 9 Ave          W 16 St & The H  3           359         423         500       
-- 512             434           W 29 St & 9 Ave          9 Ave & W 18 St  14          207         286         439       
-- 521             434           8 Ave & W 31 St          9 Ave & W 18 St  8           285         326         375       

select sa.label
     , sb.label
     , count(*)
     , min(durationSeconds) FASTEST
     , cast(avg(durationSeconds) as int) AVERAGE
     , max(durationSeconds) SLOWEST 
  from trips t
     , stations sa
     , stations sb
 where startStationId != endStationId 
   and t.startStationId = sa.id
   and t.endStationId = sb.id
 group by startStationId, endStationId 
having count(*) > 1 
 order by 3, 1, 2;
