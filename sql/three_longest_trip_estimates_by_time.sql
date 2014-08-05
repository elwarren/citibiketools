-- three longest trip estimates based on duration
-- 315|512|5.3 mi|8514|29 mins|1711|East River Bikeway, New York, NY 10005, USA|332 West 29th Street, New York, NY 10001, USA
-- 356|434|3.8 mi|6089|21 mins|1283|31 Willett Street, New York, NY 10002, USA|110-112 9th Avenue, New York, NY 10011, USA
-- 309|512|3.3 mi|5267|20 mins|1215|162 West Street, New York, NY 10007, USA|332 West 29th Street, New York, NY 10001, USA
select * from distance order by durationSec desc limit 3;
