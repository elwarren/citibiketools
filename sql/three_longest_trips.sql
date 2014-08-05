-- three shortest trips
select endTimestamp, startTimestamp, endTimestamp - startTimestamp, durationMins 
  from trips 
 where startStationId != endStationId 
 order by 3 desc limit 3;