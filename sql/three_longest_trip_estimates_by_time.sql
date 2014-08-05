-- three longest trip estimates from penn station by time
select * from distance where startStationId is 521 order by durationSec desc limit 3;
