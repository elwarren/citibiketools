-- three shortest trips
select endTimestamp, startTimestamp, endTimestamp - startTimestamp, durationMins 
  from trips 
 where startStationId != endStationId 
 order by 3 asc limit 3;