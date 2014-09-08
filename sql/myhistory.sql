-- match my private trip history to anonymous public trip history based on timestamp
-- tripDuration  durationSeconds  startStationId  endStationId  startTime            startDatetime        stopTime             bikeId      userType    birthYear   gender      tripId    
-- ------------  ---------------  --------------  ------------  -------------------  -------------------  -------------------  ----------  ----------  ----------  ----------  ----------
-- 439           439              512             434           2014-05-15 11:04:07  2014-05-15 11:04:07  2014-05-15 11:11:26  17530       Subscriber  1976        1           10076869  
-- 261           261              512             434           2014-05-20 10:28:34  2014-05-20 10:28:34  2014-05-20 10:32:55  19304       Subscriber  1976        1           10254155  
-- 1255          1255             309             512           2014-05-26 15:11:21  2014-05-26 15:11:21  2014-05-26 15:32:16  20819       Subscriber  1976        1           10467135  
-- sqlite> 
.headers on
.mode columns
select h.tripDuration
     , t.durationSeconds
     , h.startStationId
     , h.endStationId
     , h.startTime
     , datetime(t.startTimestamp, 'unixepoch', 'localtime') startDatetime
     , h.stopTime
     , h.bikeId
     , h.userType
     , h.birthYear
     , h.gender
     , t.id tripId
  from history h
     , trips t 
 where h.startStationId = t.startStationId 
   -- and h.endStationId = t.endStationId 
   -- and h.birthYear = 1976 
   and h.startTime = datetime(t.startTimestamp, 'unixepoch', 'localtime');