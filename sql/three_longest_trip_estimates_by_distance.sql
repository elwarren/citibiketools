-- three longest trip estimates based on distance
-- 315|512|5.3 mi|8514|29 mins|1711|East River Bikeway, New York, NY 10005, USA|332 West 29th Street, New York, NY 10001, USA
-- 356|434|3.8 mi|6089|21 mins|1283|31 Willett Street, New York, NY 10002, USA|110-112 9th Avenue, New York, NY 10011, USA
-- 327|514|3.4 mi|5551|17 mins|1004|6 River Terrace, New York, NY 10282, USA|Hudson River Greenway, New York, NY 10018, USA
select * from distance order by distanceMeters desc limit 3;
