-- 2013-10-18|1
-- 2013-10-19|2
-- ...
-- 2014-08-18|1
select strftime('%Y-%m-%d', startTimestamp, 'unixepoch', 'localtime') dayofmonth, count(*) from trips group by 1 order by 1;