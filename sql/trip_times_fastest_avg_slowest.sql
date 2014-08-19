-- startStationId  endStationId  count(*)    FASTEST     AVERAGE     SLOWEST   
-- --------------  ------------  ----------  ----------  ----------  ----------
-- 212             512           15          267         483         1107      
-- 477             434           3           318         352         377       
-- 494             434           3           229         256         276       
-- 512             212           3           359         423         500       
-- 512             434           14          207         286         439       
-- 521             434           8           285         326         375       


select startStationId, endStationId
     , count(*)
     , min(durationSeconds) FASTEST
     , cast(avg(durationSeconds) as int) AVERAGE
     , max(durationSeconds) SLOWEST 
  from trips 
 where startStationId != endStationId 
 group by startStationId, endStationId 
having count(*) > 1 
 order by 1, 2, 3;
