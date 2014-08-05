-- three longest trip estimates from penn station by distance
select * from distance where startStationId is 521 order by distanceMeters desc limit 3;
