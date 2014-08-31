-- highlight which days of week you rode
-- over the last four weeks
-- with total minutes of weekly ride time
--
-- http://www.sqlite.org/lang_datefunc.html
-- MTWTFSS
-- 1h 27m
-- 0h 46m
-- 1h 56m
-- Calendar-star-white 0h 10m
-- %d		day of month: 00
-- %f		fractional seconds: SS.SSS
-- %H		hour: 00-24
-- %j		day of year: 001-366
-- %J		Julian day number
-- %m		month: 01-12
-- %M		minute: 00-59
-- %s		seconds since 1970-01-01
-- %S		seconds: 00-59
-- %w		day of week 0-6 with Sunday==0
-- %Y-%W		week of year: 00-53
-- %Y		year: 0000-9999
-- %%		%
--
-- woy         mon         tue         wed         thu         fri         sat         sun         minsPerWeek
-- ----------  ----------  ----------  ----------  ----------  ----------  ----------  ----------  ----------
-- 30          1           2           2           2           2           6                       36        
-- 31          2           2           2           2           3                       1           33        
-- 32          2           1           1           2           1           10                      46        
-- 33          1                                                                                   5         
--                                                           

.headers on
.mode column
select woy, max(mon) mon, max(tue) tue, max(wed) wed, max(thu) thu, max(fri) fri, max(sat) sat, max(sun) sun, sum(durationSeconds)/60 minsPerWeek
  from (
select strftime('%Y-%W', startTimestamp, 'unixepoch', 'localtime') woy
	 , count(*) mon
	 , null tue
	 , null wed
	 , null thu
	 , null fri
	 , null sat
	 , null sun
	 , sum(durationSeconds) durationSeconds
  from trips 
 where abs(strftime('%w', startTimestamp, 'unixepoch', 'localtime')) = 1
 group by 1
 union
select strftime('%Y-%W', startTimestamp, 'unixepoch', 'localtime') woy
	 , null mon
	 , count(*) tue
	 , null wed
	 , null thu
	 , null fri
	 , null sat
	 , null sun
	 , sum(durationSeconds) durationSeconds
  from trips 
 where abs(strftime('%w', startTimestamp, 'unixepoch', 'localtime')) = 2
 group by 1
 union
 select strftime('%Y-%W', startTimestamp, 'unixepoch', 'localtime') woy
	 , null mon
	 , null tue
	 , count(*) wed
	 , null thu
	 , null fri
	 , null sat
	 , null sun
	 , sum(durationSeconds) durationSeconds
  from trips 
 where abs(strftime('%w', startTimestamp, 'unixepoch', 'localtime')) = 3
 group by 1
 union
 select strftime('%Y-%W', startTimestamp, 'unixepoch', 'localtime') woy
	 , null mon
	 , null tue
	 , null wed
	 , count(*) thu
	 , null fri
	 , null sat
	 , null sun
	 , sum(durationSeconds) durationSeconds
  from trips 
 where abs(strftime('%w', startTimestamp, 'unixepoch', 'localtime')) = 4
 group by 1
 union
 select strftime('%Y-%W', startTimestamp, 'unixepoch', 'localtime') woy
	 , null mon
	 , null tue
	 , null wed
	 , null thu
	 , count(*) fri
	 , null sat
	 , null sun
	 , sum(durationSeconds) durationSeconds
  from trips 
 where abs(strftime('%w', startTimestamp, 'unixepoch', 'localtime')) = 5
 group by 1
 union
 select strftime('%Y-%W', startTimestamp, 'unixepoch', 'localtime') woy
	 , null mon
	 , null tue
	 , null wed
	 , null thu
	 , null fri
	 , count(*) sat
	 , null sun
	 , sum(durationSeconds) durationSeconds
  from trips 
 where abs(strftime('%w', startTimestamp, 'unixepoch', 'localtime')) = 6
 group by 1
 union
 select strftime('%Y-%W', startTimestamp, 'unixepoch', 'localtime') woy
	 , null mon
	 , null tue
	 , null wed
	 , null thu
	 , null fri
	 , null sat
	 , count(*) sun
	 , sum(durationSeconds) durationSeconds
  from trips 
 where abs(strftime('%w', startTimestamp, 'unixepoch', 'localtime')) = 0
 group by 1
 ) 
group by 1
order by 1;
