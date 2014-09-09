-- most recent trip, with start and end station names
--           id = 14865853
-- startStation = 8 Ave & W 31 St
--   endStation = 9 Ave & W 18 St
--      startId = 521
--        endId = 434
--       isOpen = 0
--   isOpenCalc = 0
--         Date = 2014-09-09
--    startTime = 10:45:13
--      endTime = 10:49:41
--      nowTime = 18:05:07
--  tillNowSecs = 26394
--  tillNowMins = 439
-- tillNowHours = 7
-- 
-- NOTE: the replace line is to detect open trips with endStationId=='Station Id - null : null'
--       when cast to int it becomes 0 and there are no zero stations, so declare open trip
--       if it is normal integer station id then no match and trip is declared closed
--           id = 14839068
-- startStation = W 16 St & The High Line
--   endStation =
--      startId = 212
--        endId = Station Id - null : null
--       isOpen = 1
--   isOpenCalc = 1
--         Date = 2014-09-08
--    startTime = 18:33:40
--      endTime =
--          now = 1410279978
--  tillNowSecs = 64358
--  tillNowMins = 1072
-- tillNowHours = 17
.headers on
.mode line
select t.id
     , sa.label startStation
     , sb.label endStation
     , t.startStationId startId
     , t.endStationId endId
     , t.isOpen isOpen
     , replace(0, cast(t.endStationId as int), 1) isOpenCalc
     , date(startTimestamp, 'unixepoch', 'localtime') Date
     , time(startTimestamp, 'unixepoch', 'localtime') startTime
     , time(endTimestamp, 'unixepoch', 'localtime') endTime
     , time('now', 'localtime') nowTime
     , cast(strftime("%s", CURRENT_TIMESTAMP) as int) - startTimestamp tillNowSecs
     , cast((cast(strftime("%s", CURRENT_TIMESTAMP) as int) - startTimestamp) / 60 as int) tillNowMins
     , cast((cast(strftime("%s", CURRENT_TIMESTAMP) as int) - startTimestamp) / 60 / 60 as int) tillNowHours
  from trips t left join stations sa on t.startStationId = sa.id
               left join stations sb on t.endStationId = sb.id
 order by t.id desc
 limit 1;