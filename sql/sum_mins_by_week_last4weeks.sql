-- 30|15|96
-- 31|12|65
-- 32|17|139
-- 33|1|5
select strftime('%W', startTimestamp, 'unixepoch', 'localtime') woy
     , count(*) tripCount, abs(sum(durationSeconds)/60) sumMins
  from trips 
 where abs(strftime('%Y%W', startTimestamp, 'unixepoch', 'localtime')) > abs(strftime('%Y%W', 'now', 'localtime')) - 4
 group by 1
 order by 1;
