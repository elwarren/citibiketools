-- top 3 trips with different start and end stations
select startStationId, endStationId, count(*) from trips where startStationId != endStationId group by startStationId, endStationId order by 3 desc limit 3;
