-- only round trips on same day with same start and end station
-- ride from home to work, then work to home, start and stop at station 512
select date(ta.startTimestamp, 'unixepoch', 'localtime') Date
     , sa.label
     -- , sb.label
     -- , t.startStationId, t.endStationId
     , time(ta.startTimestamp, 'unixepoch', 'localtime') begTime
     , time(tb.endTimestamp, 'unixepoch', 'localtime') endTime
     , (tb.endTimestamp - ta.startTimestamp ) / 60 / 60 hours
  from trips ta, trips tb, stations sa, stations sb 
 where ta.startStationId = tb.endStationId
   and ta.startStationId = sa.id 
   and tb.endStationId = sb.id 
   and date(ta.startTimestamp, 'unixepoch', 'localtime') == date(tb.endTimestamp, 'unixepoch', 'localtime') 
 order by 1;
