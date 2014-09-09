-- most recent trip, with start and end station names
-- TODO trying to detect open trips with endStationId=='Station Id - null : null' need to test with open trip data
.headers on
.mode line
select t.id
     , sa.label startStation
     , sb.label endStation
     , t.startStationId startId
     , t.endStationId endId
     , t.isOpen isOpen
     -- , replace(0, cast('Station Id - null : null' as int), 1) isOpenCalc
     , replace(0, cast(endStationId as int), 1) isOpenCalc
     , date(startTimestamp, 'unixepoch', 'localtime') Date
     , time(startTimestamp, 'unixepoch', 'localtime') startTime
     , time(endTimestamp, 'unixepoch', 'localtime') endTime
     , cast(strftime("%s", CURRENT_TIMESTAMP) as int) now
     , cast(strftime("%s", CURRENT_TIMESTAMP) as int) - startTimestamp tillNowSecs
     , cast((cast(strftime("%s", CURRENT_TIMESTAMP) as int) - startTimestamp) / 60 as int) tillNowMins
     , cast((cast(strftime("%s", CURRENT_TIMESTAMP) as int) - startTimestamp) / 60 / 60 as int) tillNowHours
  from trips t left join stations sa on t.startStationId = sa.id
               left join stations sb on t.endStationId = sb.id
 order by t.id desc
 limit 1;